//
//  UIScrollView+constraint.m
//  QuickVFL
//
//  Created by Sou Dai on 16/9/21.
//  Copyright © 2016 Sou Dai. All rights reserved.
//

#import "UIScrollView+constraint.h"
#import "UIView+constraint.h"
#import <objc/runtime.h>

static const void *ControlConstraint = &ControlConstraint;
static const void *UIScrollViewContentViewKey = &UIScrollViewContentViewKey;
static const void *OrientationKey = &OrientationKey;

@implementation UIScrollView(constraint)
#pragma mark content getter and setter
-(NSLayoutConstraint*)controlConstraint{
    return objc_getAssociatedObject(self, ControlConstraint);
}

-(void)setControlConstraint:(NSLayoutConstraint*)constraint{
    objc_setAssociatedObject(self, ControlConstraint, constraint, OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark content view getter and setter
-(UIView*)q_contentView{
    return objc_getAssociatedObject(self, UIScrollViewContentViewKey);
}

-(void)setQ_contentView:(UIView*)view{
    objc_setAssociatedObject(self, UIScrollViewContentViewKey, view, OBJC_ASSOCIATION_ASSIGN);
}

-(QScrollOrientation)orientation{
    NSNumber* value = objc_getAssociatedObject(self, OrientationKey);
    return value.unsignedIntegerValue;
}

-(void)setOrientation:(QScrollOrientation)orientation{
    NSNumber* value = [NSNumber numberWithUnsignedInteger:orientation];
    objc_setAssociatedObject(self, OrientationKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark public methods
-(UIView*)q_prepareContentViewForOrientation:(QScrollOrientation)orientation{
    UIView* viewSystemContent = QVIEW(self, UIView);
    UIView* viewUserContent = QVIEW(viewSystemContent, UIView);
    
    self.orientation = orientation;
    
    NSLayoutConstraint* maxLimit;
    if(orientation == QScrollOrientationVertical){
        maxLimit = [NSLayoutConstraint constraintWithItem:viewSystemContent attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
        self.controlConstraint = [self q_addConstraintsByText:@"V:[viewSystemContent(1@750)];"
                                           involvedViews:NSDictionaryOfVariableBindings(viewSystemContent)][0];
    } else {
        maxLimit = [NSLayoutConstraint constraintWithItem:viewSystemContent attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
        self.controlConstraint = [self q_addConstraintsByText:@"H:[viewSystemContent(1@750)];"
                                           involvedViews:NSDictionaryOfVariableBindings(viewSystemContent)][0];
    }
    
    maxLimit.priority = UILayoutPriorityRequired;
    [self addConstraint:maxLimit];
    
    NSString* widthLimit = (orientation == QScrollOrientationVertical ? @"-0-|" : @"");
    NSString* heightLimit = (orientation == QScrollOrientationHorizontal ? @"-0-|" : @"");
    
    NSString* layout = [ NSString stringWithFormat:@"   \
        H:|[viewSystemContent]|;                        \
        V:|[viewSystemContent]|;                        \
        H:|[viewUserContent]%@;                         \
        V:|[viewUserContent]%@;                         \
    ", widthLimit, heightLimit];
    
    
    [self q_addConstraintsByText:layout
                                involvedViews:NSDictionaryOfVariableBindings(viewUserContent, viewSystemContent)];
    
    self.q_contentView = viewUserContent;
    return viewUserContent;
}

-(void)q_refreshContentView{
    [self.q_contentView setNeedsLayout];
    [self.q_contentView layoutIfNeeded];
    
    if(self.orientation == QScrollOrientationVertical){
        self.controlConstraint.constant = MAX(self.q_contentView.frame.size.height, self.frame.size.height);
    } else {
        self.controlConstraint.constant = MAX(self.q_contentView.frame.size.width, self.frame.size.width);
    }

    [self setNeedsLayout];
}
@end
