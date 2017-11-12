//
//  QAlignOption.h
//  QuickVFL2
//
//  Created by 苏第 on 17/11/9.
//  Copyright © 2017年 Quick. All rights reserved.
//

#import "QOption.h"
#import <UIKit/UIKit.h>

@interface QAlignOption : QOption
@property (nonatomic, strong) NSArray* viewNames;
@property (nonatomic, assign) NSLayoutAttribute attribute;

+(void)alignViews:(NSDictionary*)views
      withOptions:(NSArray*)options
     withEntrance:(UIView*)entrance;
@end
