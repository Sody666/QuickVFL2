//
//  QException.m
//  LibSourceUser
//
//  Created by 苏第 on 17/11/8.
//  Copyright © 2017年 Su Di. All rights reserved.
//

#import "QException.h"

@implementation QException
+(nonnull id)exceptionWithReason:(nonnull NSString*)reason{
    return [self exceptionWithReason:reason userInfo:nil];
}

+(nonnull id)exceptionWithReason:(nonnull NSString*)reason userInfo:(nullable NSDictionary*)userInfo{
    return [super exceptionWithName:[self exceptionName] reason:reason userInfo:userInfo];
}

+(NSString*)exceptionName{
    return @"Quick VFL Framework";
}
@end
