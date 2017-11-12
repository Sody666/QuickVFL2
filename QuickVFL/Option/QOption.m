//
//  QOption.m
//  QuickVFL2
//
//  Created by 苏第 on 17/11/9.
//  Copyright © 2017年 Quick. All rights reserved.
//

#import "QOption.h"
#import "QParseException.h"

@implementation QOption
+(QOption*)optionWithKey:(NSString*)key value:(NSString*)value{
    if(key.length == 0 || value.length == 0){
        @throw [QParseException exceptionWithReason:@"Both key and value must be valid."];
    }
    
    return [[self alloc] init];
}
@end
