//
//  QException.m
//  LibSourceUser
//
//  Created by 苏第 on 17/11/8.
//  Copyright © 2017年 Su Di. All rights reserved.
//

#import "QException.h"
#import "QLayoutManager.h"

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

+(void)throwExceptionWithUserInfo:(nullable NSDictionary*)userInfo
                           reason:(nonnull NSString *)format, ... NS_FORMAT_FUNCTION(2,3){
    if([QLayoutManager layoutMode] > QLayoutModeQuiet){
        return;
    }
    
    va_list args;
    va_start(args, format);
    NSString *reason = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    @throw [self exceptionWithReason:reason userInfo:userInfo];
}

+(void)throwExceptionForReason:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2) {
    if([QLayoutManager layoutMode] > QLayoutModeQuiet){
        return;
    }
    
    va_list args;
    va_start(args, format);
    NSString *reason = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    @throw [self exceptionWithReason:reason];
}
@end
