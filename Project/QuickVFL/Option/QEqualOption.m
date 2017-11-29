//
//  QEqualOption.m
//  LibSourceUser
//
//  Created by 苏第 on 17/11/8.
//  Copyright © 2017年 Su Di. All rights reserved.
//

#import "QEqualOption.h"
#import "QParseException.h"
#import "QViewProperty.h"
#import <UIKit/UIKit.h>

@implementation QEqualOption
// ":equalWidth":"aView@0.5@w"
+(id)optionWithKey:(NSString *)key value:(NSString *)value{
    QEqualOption* option = [super optionWithKey:key value:value];
    
    if([key isEqualToString:QVIEW_OPTION_EQUAL_WIDTH]){
        option.firstAttribute = NSLayoutAttributeWidth;
    } else {
        option.firstAttribute = NSLayoutAttributeHeight;
    }
    
    NSArray* splitValue = [value componentsSeparatedByString:@"@"];
    
    option.targetViewName = splitValue.firstObject;
    
    NSString* secondAttrubuteString = @"";
    NSString* multiplierString = @"1.";
    if(splitValue.count >= 3){
        secondAttrubuteString = splitValue[2];
    }
    
    if(splitValue.count >= 2){
        multiplierString = splitValue[1];
    }
    
    option.multiplier = [multiplierString floatValue];
    if(option.multiplier <= 0){
        [QParseException throwExceptionForReason:@"Multiplier value must be  greater than 0."];
        option.multiplier = 1;
    }
    
    if([@"w" isEqualToString:secondAttrubuteString]){
        option.secondAttribute = NSLayoutAttributeWidth;
    } else if([@"h" isEqualToString:secondAttrubuteString]){
        option.secondAttribute = NSLayoutAttributeHeight;
    } else if(secondAttrubuteString.length == 0){
        option.secondAttribute = option.firstAttribute;
    }
    
    
    return option;
}
+(UIView*)ancestorForView:(UIView*)aView theOtherViw:(UIView*)otherView{
    if(aView == nil || otherView == nil){
        return nil;
    }
    
    UIView* startView = aView;
    UIView* result = nil;
    while (startView != nil) {
        if([otherView isDescendantOfView:startView] || otherView == startView){
            result = startView;
            break;
        }else{
            startView = startView.superview;
        }
    }
    
    return result;
}

+(void)equalView:(UIView*)aView
    forAttrubute:(NSLayoutAttribute)firstAttribute
     toOtherView:(UIView*)otherView
    forAttrubute:(NSLayoutAttribute)secondAttribute
      multiplier:(float)multiplier{
    UIView* ancestor = [self ancestorForView:aView theOtherViw:otherView];
    if(ancestor == nil){
        [QParseException throwExceptionForReason:@"Equal option requires two views are in the same layout tree"];
        return;
    }
    
    if(aView == otherView && firstAttribute == secondAttribute){
        NSString* fact;
        if(firstAttribute == NSLayoutAttributeWidth){
            fact = @"Can't set width to width of self.";
        } else {
            fact = @"Can't set height to height of self.";
        }
        
        [QParseException throwExceptionForReason:fact];
        return;
    }
    
    NSLayoutConstraint* constraint = [NSLayoutConstraint constraintWithItem:aView
                                                                  attribute:firstAttribute
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:otherView
                                                                  attribute:secondAttribute
                                                                 multiplier:multiplier
                                                                   constant:0];
    [ancestor addConstraint:constraint];
}
@end
