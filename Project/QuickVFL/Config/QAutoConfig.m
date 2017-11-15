//
//  AutoConfig.m
//  QuickVFL2
//
//  Created by 苏第 on 17/11/15.
//  Copyright © 2017年 Quick. All rights reserved.
//

#import "QAutoConfig.h"
#import "QLayoutException.h"

#define QVIEW_BG_COLOR @"backgroundColor"

@interface UIView()
// Declare these two selector for later use.
// Will not implement it.
-(BOOL)_q_configWithKey:(NSString*)key value:(id)value;
-(BOOL)q_configWithKey:(NSString*)key value:(id)value;
@end

@implementation UIView(AutoConfig)
-(void)q_configureWithData:(NSDictionary*)configData{
    if(configData == nil || configData.count < 1){
        return;
    }
    
    BOOL respondCommon = [self respondsToSelector:@selector(_q_configWithKey:value:)];
    BOOL respondExtend = [self respondsToSelector:@selector(q_configWithKey:value:)];
    
    if(!respondCommon && !respondExtend){
        return;
    }
    
    for (NSString* key in configData.allKeys) {
        if((respondCommon && [self _q_configWithKey:key value:[configData objectForKey:key]]) ||
           (respondExtend && [self q_configWithKey:key value:[configData objectForKey:key]])){
            continue;
        }
        
        NSString* reason = [NSString stringWithFormat:@"Key %@ is not handled for class %@", key, NSStringFromClass(self.class)];
        @throw [QLayoutException exceptionWithReason:reason];
    }
}

-(UIColor*)_q_parseColorString:(NSString*)color{
    if(color.length == 0 || ![color hasPrefix:@"#"] || (color.length != 7 && color.length != 9)){
        NSString* reason = [NSString stringWithFormat:@"Illegal color format %@. Legal example: #FF123456 or #123456", color];
        @throw [QLayoutException exceptionWithReason:reason];
    }
    
    NSString* alphaString = @"FF";
    NSString* colorString;
    if(color.length == 7){
        colorString = [color substringWithRange:NSMakeRange(1, 6)];
    } else {
        alphaString = [color substringWithRange:NSMakeRange(1, 2)];
        colorString = [color substringWithRange:NSMakeRange(3, 6)];
    }
    
    int alphaValue, colorValue;
    
    sscanf([alphaString cStringUsingEncoding:NSUTF8StringEncoding], "%x", &alphaValue);
    sscanf([colorString cStringUsingEncoding:NSUTF8StringEncoding], "%x", &colorValue);
    
    return [UIColor colorWithRed:((colorValue >> 16)&0xFF)/255.0
                           green:((colorValue >> 8)&0xFF)/255.0
                            blue:(colorValue&0xFF)/255.0
                           alpha:alphaValue/255.];
}
@end

#define QLABEL_TEXT             @"text"
#define QLABEL_NUMBER_OF_LINES  @"numberOfLines"
#define QLABEL_TEXT_COLOR       @"textColor"

@implementation UILabel(AutoConfig)
-(BOOL)_q_configWithKey:(NSString*)key value:(id)value{
    if([QLABEL_TEXT isEqualToString:key]){
        self.text = value;
    } else if([QLABEL_NUMBER_OF_LINES isEqualToString:key]){
        self.numberOfLines = [value integerValue];
    } else if([QLABEL_TEXT_COLOR isEqualToString:key]){
        self.textColor = [self _q_parseColorString:value];
    } else if([QVIEW_BG_COLOR isEqualToString:key]){
        self.backgroundColor = [self _q_parseColorString:value];
    } else {
        return NO;
    }
    
    return YES;
}
@end

#define QBUTTON_TITLE  @"title"
@implementation UIButton(AutoConfig)

-(BOOL)_q_configWithKey:(NSString*)key value:(id)value{
    if([QBUTTON_TITLE isEqualToString:key]){
        [self setTitle:value forState:UIControlStateNormal];
        [self setTitle:value forState:UIControlStateSelected];
        [self setTitle:value forState:UIControlStateDisabled];
    } else if([QVIEW_BG_COLOR isEqualToString:key]){
        self.backgroundColor = [self _q_parseColorString:value];
    } else {
        return NO;
    }
    
    return YES;
}
@end