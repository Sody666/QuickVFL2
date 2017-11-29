//
//  te.m
//  QuickVFL2
//
//  Created by 苏第 on 17/11/28.
//  Copyright © 2017年 Quick. All rights reserved.
//

#import "NSLayoutConstraint+vfl.h"
#import <objc/runtime.h>

static const void *firstItemKey = &firstItemKey;
static const void *secondItemKey = &secondItemKey;
static const void *vflKey = &vflKey;

extern BOOL enableVFLDebug;

@implementation NSLayoutConstraint(vfl)
#pragma mark - setters and getters

-(NSString*)q_firstItemName{
    NSString* name = objc_getAssociatedObject(self, firstItemKey);
    if(name.length > 0){
        return name;
    } else {
        return [NSString stringWithFormat:@"View-%p", self];;
    }
}

-(void)setQ_firstItemName:(NSString *)firstItemName{
    objc_setAssociatedObject(self, firstItemKey, firstItemName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString*)q_secondItemName{
    NSString* name = objc_getAssociatedObject(self, secondItemKey);
    
    if(name.length > 0){
        return name;
    } else {
        return [NSString stringWithFormat:@"View-%p", self];;
    }
}

-(void)setQ_secondItemName:(NSString *)secondItemName{
    objc_setAssociatedObject(self, secondItemKey, secondItemName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString*)q_vfl{
    return objc_getAssociatedObject(self, vflKey);
}

-(void)setQ_vfl:(NSString *)vfl{
    objc_setAssociatedObject(self, vflKey, vfl, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+(NSString*)_q_nameForConstraintAttribute:(NSLayoutAttribute)attribute{

    if (attribute <NSLayoutAttributeNotAnAttribute || attribute > NSLayoutAttributeCenterYWithinMargins) {
        attribute = NSLayoutAttributeNotAnAttribute;
    }
    
    NSArray* names =
    @[
        @"NotAnAttribute",
        @"Left",
        @"Right",
        @"Top",
        @"Bottom",
        @"Leading",
        @"Trailing",
        @"Width",
        @"Height",
        @"CenterX",
        @"CenterY",
        @"Baseline",
        @"FirstBaseline",
        @"LeftMargin",
        @"RightMargin",
        @"TopMargin",
        @"BottomMargin",
        @"LeadingMargin",
        @"TrailingMargin",
        @"CenterXWithinMargins",
        @"CenterYWithinMargins",
    ];
    
    return [names objectAtIndex:attribute];
}

+(NSString*)_q_nameForConstraintRelation:(NSLayoutRelation)relation{
    if(relation == NSLayoutRelationLessThanOrEqual){
        return @"LessThanOrEqual";
    } else if(relation == NSLayoutRelationGreaterThanOrEqual){
        return @"GreaterThanOrEqual";
    } else {
        return @"Equal";
    }
}

-(NSString*)description{
    if(enableVFLDebug){
        return [NSString stringWithFormat:@"%@ %@ %@ %@ %@. VFL: %@",
                self.q_firstItemName, [NSLayoutConstraint _q_nameForConstraintAttribute:self.firstAttribute],
                [NSLayoutConstraint _q_nameForConstraintRelation:self.relation],
                self.q_secondItemName, [NSLayoutConstraint _q_nameForConstraintAttribute:self.secondAttribute],
                self.q_vfl];
    } else{
        return [NSString stringWithFormat:@"%@ %@ %@ %@ %@.",
                self.q_firstItemName, [NSLayoutConstraint _q_nameForConstraintAttribute:self.firstAttribute],
                [NSLayoutConstraint _q_nameForConstraintRelation:self.relation],
                self.q_secondItemName, [NSLayoutConstraint _q_nameForConstraintAttribute:self.secondAttribute]];
    }
    
}
@end
