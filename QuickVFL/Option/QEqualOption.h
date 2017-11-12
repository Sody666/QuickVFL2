//
//  QEqualOption.h
//  LibSourceUser
//
//  Created by 苏第 on 17/11/8.
//  Copyright © 2017年 Su Di. All rights reserved.
//

#import "QOption.h"
#import <UIKit/UIKit.h>

@class UIView;
@interface QEqualOption : QOption
@property (nonatomic, strong) NSString* targetViewName;
@property (nonatomic, assign) float multiplier;
@property (nonatomic, assign) NSLayoutAttribute firstAttribute;
@property (nonatomic, assign) NSLayoutAttribute secondAttribute;
+(void)equalView:(UIView*)aView
    forAttrubute:(NSLayoutAttribute)firstAttribute
     toOtherView:(UIView*)otherView
    forAttrubute:(NSLayoutAttribute)secondAttribute
      multiplier:(float)multiplier;
@end
