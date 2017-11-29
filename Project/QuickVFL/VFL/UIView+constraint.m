//
//  UIView+constraint.m
//  Quick VFL
//
//  Created by Sou Dai on 16/9/21.
//  Copyright © 2016 Sou Dai. All rights reserved.
//

#import "UIView+constraint.h"
#import <objc/runtime.h>
#import "NSLayoutConstraint+vfl.h"

#define kQConstraintAlignTop          @"top"
#define kQConstraintAlignBottom       @"bottom"
#define kQConstraintAlignLeft         @"left"
#define kQConstraintAlignRight        @"right"
#define kQConstraintAlignCenterX      @"centerX"
#define kQConstraintAlignCenterY      @"centerY"

static const void *VerticalVisibilityKey = &VerticalVisibilityKey;
static const void *HorizontalVisibilityKey = &HorizontalVisibilityKey;

BOOL enableVFLDebug = NO;

@implementation UIView(constraint)
#define SHARED_EXPRESSION(expression) do {\
    static dispatch_once_t onceToken; \
    static NSRegularExpression* sharedExpression; \
    dispatch_once(&onceToken, ^{ \
        NSError* error = nil;\
        sharedExpression = [[NSRegularExpression alloc] initWithPattern:expression \
                                                                options:NSRegularExpressionCaseInsensitive \
                                                                  error:&error]; \
        if(error){\
            NSLog(@"Error while initialize regular expression: %@", error);\
        }\
    });\
    return sharedExpression; \
} while(0)

+(NSRegularExpression*)sharedTrimCommentExpression {
    SHARED_EXPRESSION(@"(/\\*([^*]|\n|(\\*+([^/]|\n)))*\\*+/)");
}

+(NSRegularExpression*)sharedAlignParserExpression {
    SHARED_EXPRESSION(@"(\\{[^}]*\\})");
}

#pragma mark private methods
-(NSLayoutFormatOptions) _q_parseConstraintOptionsByText:(NSString*)text{
    NSLayoutFormatOptions result = 0;
    
    if ([text rangeOfString:kQConstraintAlignTop].location != NSNotFound) {
        result |= NSLayoutFormatAlignAllTop;
    }
    
    if ([text rangeOfString:kQConstraintAlignBottom].location != NSNotFound) {
        result |= NSLayoutFormatAlignAllBottom;
    }
    
    if ([text rangeOfString:kQConstraintAlignLeft].location != NSNotFound) {
        result |= NSLayoutFormatAlignAllLeft;
    }
    
    if ([text rangeOfString:kQConstraintAlignRight].location != NSNotFound) {
        result |= NSLayoutFormatAlignAllRight;
    }
    
    if ([text rangeOfString:kQConstraintAlignCenterX].location != NSNotFound) {
        result |= NSLayoutFormatAlignAllCenterX;
    }
    
    if ([text rangeOfString:kQConstraintAlignCenterY].location != NSNotFound) {
        result |= NSLayoutFormatAlignAllCenterY;
    }
    
    return result;
}

-(NSString*)_q_trimCommentFromText:(NSString*)text{
    if(text.length == 0){
        return text;
    }
    
    return [[UIView sharedTrimCommentExpression] stringByReplacingMatchesInString:text
                                                options:NSMatchingWithTransparentBounds
                                                  range:NSMakeRange(0, text.length)
                                           withTemplate:@""];
}

-(NSArray*)_q_parseVFL:(NSString*)VFLText involvedViews:(NSDictionary*)views{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    // remove comments
    NSString* trimmedVFLText = [self _q_trimCommentFromText: VFLText];
    if(trimmedVFLText.length == 0){
        return result;
    }
    
    NSArray* lines = [trimmedVFLText componentsSeparatedByString:@";"];
    NSCharacterSet* emptySet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    NSString* singleLineContraint = nil;
    NSString* constraintText = nil;
    NSDictionary* involvedViews = nil;
    NSLayoutFormatOptions alignOption = 0;
    NSRange matchRange;
    for (NSString* line in lines) {
        singleLineContraint = nil;
        constraintText = nil;
        involvedViews = nil;
        alignOption = 0;
        
        // remove white space
        singleLineContraint = [line stringByTrimmingCharactersInSet:emptySet];
        
        if(singleLineContraint.length == 0){
            continue;
        }
        
        // parsing align options
        
        matchRange = [[UIView sharedAlignParserExpression] firstMatchInString:singleLineContraint
                                                                      options:NSMatchingReportCompletion
                                                                        range:NSMakeRange(0, singleLineContraint.length)].range;
        
        if(matchRange.location == NSNotFound || matchRange.length == 0){
            constraintText = singleLineContraint;
        } else {
            // trim align text
            constraintText = [[UIView sharedAlignParserExpression] stringByReplacingMatchesInString:singleLineContraint
                                                                                                 options:NSMatchingReportCompletion
                                                                                                   range:NSMakeRange(0, singleLineContraint.length)
                                                                                            withTemplate:@""];
            constraintText = [constraintText stringByTrimmingCharactersInSet:emptySet];
            
            alignOption = [self _q_parseConstraintOptionsByText:[singleLineContraint substringWithRange:matchRange]];
            
            involvedViews = [self _q_involedViewsInVFLText:constraintText totalViews:views];
            [self _q_processCenterForViews:involvedViews
                                   options:alignOption];
            // remove center x and center y option
            alignOption &= (~(NSLayoutFormatAlignAllCenterX|NSLayoutFormatAlignAllCenterY));
        }
        
        NSArray* parsedConstraints = [NSLayoutConstraint
                                      constraintsWithVisualFormat:constraintText
                                      options:alignOption
                                      metrics:nil
                                      views:views];
        
        if(enableVFLDebug){
            for (NSLayoutConstraint* constraint in parsedConstraints) {
                constraint.q_vfl = constraintText;
                
                constraint.q_firstItemName = [views allKeysForObject:constraint.firstItem].firstObject;
                constraint.q_secondItemName = [views allKeysForObject:constraint.secondItem].firstObject;
            }
        }
        
        [result addObjectsFromArray:parsedConstraints];
    }
    
    return result;
}

-(NSDictionary*)_q_involedViewsInVFLText:(NSString*)text totalViews:(NSDictionary*)totalViews{
    NSMutableDictionary* involvedViews = [[NSMutableDictionary alloc] init];
    for (NSString* viewName in totalViews.allKeys) {
        if([text containsString:viewName]){
            [involvedViews setValue:totalViews[viewName] forKey:viewName];
        }
    }
    
    return involvedViews;
}

-(void)_q_processCenterForViews:(NSDictionary*)involvedViews
                        options:(NSLayoutFormatOptions)options{
    NSLayoutAttribute parsedOption = 0;
    if (options & NSLayoutFormatAlignAllCenterX) {
        parsedOption = NSLayoutAttributeCenterX;
    } else if (options & NSLayoutFormatAlignAllCenterY) {
        parsedOption = NSLayoutAttributeCenterY;
    }
    
    if (parsedOption == 0) {
        return;
    }
    
    NSArray* viewNames = [involvedViews allKeys];
    NSLayoutConstraint* centerConstraint = nil;
    for(NSString* viewName in viewNames){
        UIView* view = [involvedViews objectForKey:viewName];
        centerConstraint = [NSLayoutConstraint constraintWithItem:view
                                                        attribute:parsedOption
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:view.superview
                                                        attribute:parsedOption
                                                       multiplier:1
                                                         constant:0];
        
        if(enableVFLDebug){
            centerConstraint.q_firstItemName = viewName;
            centerConstraint.q_secondItemName = [NSString stringWithFormat:@"%@'s super view", viewName];
        }
        
        [view.superview addConstraint:centerConstraint];
    }
}

-(NSLayoutConstraint*)_q_addHideConstraintVertically:(BOOL)isVertical{
    self.clipsToBounds = YES;
    NSLayoutAttribute attribute = isVertical? NSLayoutAttributeHeight:NSLayoutAttributeWidth;
    NSLayoutConstraint* constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:attribute
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:0
                                                                   constant:0];
    if(enableVFLDebug){
        NSString* name = @"HidingView";
        constraint.q_firstItemName = name;
        constraint.q_secondItemName = name;
    }
    
    constraint.priority = UILayoutPriorityRequired;
    
    [self addConstraint:constraint];
    return constraint;
}

#pragma mark visibility control setter and getter
-(NSLayoutConstraint*)verticalVisibilityConstraint{
    return objc_getAssociatedObject(self, VerticalVisibilityKey);
}

-(void)setVerticalVisibilityConstraint:(NSLayoutConstraint*)constraint{
    objc_setAssociatedObject(self, VerticalVisibilityKey, constraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSLayoutConstraint*)horizontalVisibilityConstraint{
    return objc_getAssociatedObject(self, HorizontalVisibilityKey);
}

-(void)setHorizontalVisibilityConstraint:(NSLayoutConstraint*)constraint{
    objc_setAssociatedObject(self, HorizontalVisibilityKey, constraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark public methods
+(id)q_autolayoutInstance{
    UIView* result = [[self alloc] init];
    result.translatesAutoresizingMaskIntoConstraints = NO;
    return result;
}

-(NSArray*)q_addConstraintsByText:(NSString*)text
                     involvedViews:(NSDictionary*)views{
    NSArray* constraints = [self _q_parseVFL:text involvedViews:views];

    [self addConstraints:constraints];
    
    return constraints;
}

-(id)q_addAutolayoutSubviewByClass:(Class)targetClass{
    // if the the target class is not a subclass of UIView,
    // do nothing.
    if (![targetClass isSubclassOfClass:[UIView class]]) {
        return nil;
    }
    
    UIView* result = [targetClass q_autolayoutInstance];
    [self addSubview:result];
    
    return result;
}

-(void)q_setVisibility:(BOOL)visible isVertically:(BOOL)vertically{
    NSLayoutConstraint* constraint;
    
    BOOL visibleCurrently = [self q_visibleVertically:vertically];
    
    if((visible && visibleCurrently) || (!visible && !visibleCurrently)){
        return;
    }
    
    if(vertically){
        constraint = self.verticalVisibilityConstraint;
        if(constraint == nil){
            constraint = [self _q_addHideConstraintVertically:YES];
            self.verticalVisibilityConstraint = constraint;
        }
    } else {
        constraint = self.horizontalVisibilityConstraint;
        if(constraint == nil){
            constraint = [self _q_addHideConstraintVertically:NO];
            self.horizontalVisibilityConstraint = constraint;
        }
    }
    
    constraint.active = !visible;
}

-(BOOL)q_visibleVertically:(BOOL)vertically{
    NSLayoutConstraint* constraint = vertically ? self.verticalVisibilityConstraint:self.horizontalVisibilityConstraint;
    if(constraint == nil){
        return YES;
    }
    
    return !constraint.active;
}
@end
