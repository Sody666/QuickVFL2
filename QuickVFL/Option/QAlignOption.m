//
//  QAlignOption.m
//  QuickVFL2
//
//  Created by 苏第 on 17/11/9.
//  Copyright © 2017年 Quick. All rights reserved.
//

#import "QAlignOption.h"
#import "QViewProperty.h"
#import "QParseException.h"

@implementation QAlignOption
+(id)optionWithKey:(NSString *)key value:(NSString *)value{
    QAlignOption* option = [super optionWithKey:key value:value];
    NSArray* groups = [value componentsSeparatedByString:@";"];
    NSMutableArray* viewGroups = [[NSMutableArray alloc] init];
    for (NSString* group in groups) {
        [viewGroups addObject:[group componentsSeparatedByString:@","]];
    }
    option.viewNames = viewGroups;
    
    if([QVIEW_OPTION_TOP_ALIGN isEqualToString:key]){
        option.attribute = NSLayoutAttributeTop;
    } else if([QVIEW_OPTION_BOTTOM_ALIGN isEqualToString:key]){
        option.attribute = NSLayoutAttributeBottom;
    } else if([QVIEW_OPTION_LEFT_ALIGN isEqualToString:key]){
        option.attribute = NSLayoutAttributeLeft;
    } else if([QVIEW_OPTION_RIGHT_ALIGN isEqualToString:key]){
        option.attribute = NSLayoutAttributeRight;
    } else if([QVIEW_OPTION_CENTER_X_ALIGN isEqualToString:key]){
        option.attribute = NSLayoutAttributeCenterX;
    } else if([QVIEW_OPTION_CENTER_Y_ALIGN isEqualToString:key]){
        option.attribute = NSLayoutAttributeCenterY;
    } else{
        NSString* reason = [NSString stringWithFormat:@"Unknown align type %@", key];
        @throw [QParseException exceptionWithReason:reason];
    }
    
    return option;
}

+(void)alignViews:(NSArray*)views
     forAttribute:(NSLayoutAttribute)attribute
         entrance:(UIView*)entrance{
    if(views.count < 2){
        return;
    }
    
    UIView* firstItem = views.firstObject;
    NSLayoutConstraint* constraint;
    for (int i=1; i<views.count; i++) {
        constraint = [NSLayoutConstraint constraintWithItem:firstItem
                                                  attribute:attribute
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:[views objectAtIndex:i]
                                                  attribute:attribute
                                                 multiplier:1
                                                   constant:0];
        [entrance addConstraint:constraint];
    }
}

+(void)alignViews:(NSDictionary*)views
      withOptions:(NSArray*)options
     withEntrance:(UIView*)entrance{
    NSMutableArray* targetViews;
    UIView* targetView;
    targetViews = [[NSMutableArray alloc] init];
    for (QAlignOption* option in options) {
        for(NSArray* group in option.viewNames){
            [targetViews removeAllObjects];
            for (NSString* name in group) {
                targetView = [views objectForKey:name];
                if(targetView == nil){
                    NSString* reason = [NSString stringWithFormat:@"Uknown view named %@", name];
                    @throw [QParseException exceptionWithReason:reason];
                }
                [targetViews addObject:targetView];
            }
            
            if(option.attribute == NSLayoutAttributeCenterX || option.attribute == NSLayoutAttributeCenterY) {
                [targetViews insertObject:entrance atIndex:0];
            }
            
            [self alignViews:targetViews forAttribute:option.attribute entrance:entrance];
        }
    }
}
@end
