//
//  QStayShapedOption.m
//  LibSourceUser
//
//  Created by 苏第 on 17/11/7.
//  Copyright © 2017年 Su Di. All rights reserved.
//

#import "QStayShapedOption.h"
#import "QParseException.h"
#import <UIKit/UIKit.h>

@implementation QStayShapedOption
+(id)optionWithKey:(NSString *)key value:(NSString *)value{
    QStayShapedOption* option = [super optionWithKey:key value:value];
    
    option.isCompressed = [key isEqualToString:QVIEW_OPTION_STAY_WHEN_COMPRESSED];
    
    NSArray* splitValue = [value componentsSeparatedByString:@"@"];
    if (splitValue.count != 2) {
        @throw [QParseException exceptionWithReason:@"Stay shaped option value must be orientation@priority, H@751 for example."];
    }
    
    NSString* orientation = [[splitValue firstObject] lowercaseString];
    if ([orientation isEqualToString:@"v"] ) {
        option.orientation = QOrientationVertical;
    } else if ([orientation isEqualToString:@"h"] ) {
        option.orientation = QOrientationHorizontal;
    } else {
        NSString* reason = [NSString stringWithFormat:@"Unknown orientation value %@", orientation];
        @throw [QParseException exceptionWithReason:reason];
    }
    
    NSString* priority = splitValue[1];
    NSInteger priorityValue = [priority integerValue];
    if(priorityValue <= 0 || priorityValue > 1000){
        @throw [QParseException exceptionWithReason:@"Priority value must be between 0 and 1000"];
    }
    
    option.priority = priorityValue;
    
    return option;
}
@end
