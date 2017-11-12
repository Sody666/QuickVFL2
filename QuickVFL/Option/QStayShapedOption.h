//
//  QStayShapedOption.h
//  LibSourceUser
//
//  Created by 苏第 on 17/11/7.
//  Copyright © 2017年 Su Di. All rights reserved.
//

#import "QOption.h"
#import "QViewProperty.h"

@interface QStayShapedOption : QOption
@property (nonatomic, assign) QOrientationOption orientation;
@property (nonatomic, assign) NSUInteger priority;
@property (nonatomic, assign) BOOL isCompressed;
@end
