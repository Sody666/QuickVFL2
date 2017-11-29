//
//  QException.h
//  LibSourceUser
//
//  Created by 苏第 on 17/11/8.
//  Copyright © 2017年 Su Di. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QException : NSException
+(nonnull id)exceptionWithReason:(nonnull NSString*)reason;
+(nonnull id)exceptionWithReason:(nonnull NSString*)reason userInfo:(nullable NSDictionary*)userInfo;
+(nonnull NSString*)exceptionName;

+(void)throwExceptionWithUserInfo:(nullable NSDictionary*)userInfo
                           reason:(nonnull NSString *)format, ...;

+(void)throwExceptionForReason:(nonnull NSString *)format, ...;
@end
