//
//  AutoConfig.m
//  QuickVFL2
//
//  Created by 苏第 on 17/11/15.
//  Copyright © 2017年 Quick. All rights reserved.
//

#import "QAutoConfig.h"
#import "QLayoutException.h"


@interface UIView()
// category api
// Declare these two selector for later use.
// Will not implement it.
-(BOOL)_q_configWithKey:(NSString*)key value:(id)value;
-(BOOL)q_configWithKey:(NSString*)key value:(id)value;

// subclass api
-(BOOL)QConfigWithKey:(NSString *)key value:(id)value;
@end

#define QVIEW_BG_COLOR @"backgroundColor"
#define QVIEW_ALPHA @"alpha"
@implementation UIView(AutoConfig)
-(void)q_configureWithData:(NSDictionary*)configData{
    if(configData == nil || configData.count < 1){
        return;
    }
    
    BOOL respondViewCommon = [self respondsToSelector:@selector(_commonViewConfigWithKey:value:)];
    BOOL respondExtendCommon = [self respondsToSelector:@selector(_q_configWithKey:value:)];
    BOOL respondExtendCustomize = [self respondsToSelector:@selector(q_configWithKey:value:)];
    BOOL respondSubclass = [self respondsToSelector:@selector(QConfigWithKey:value:)];
    
    for (NSString* key in configData.allKeys) {
        if((respondSubclass && [self QConfigWithKey:key value:[configData objectForKey:key]]) ||
           (respondExtendCustomize && [self q_configWithKey:key value:[configData objectForKey:key]]) ||
           (respondExtendCommon && [self _q_configWithKey:key value:[configData objectForKey:key]]) ||
           (respondViewCommon && [self _commonViewConfigWithKey:key value:[configData objectForKey:key]])){
            continue;
        }
        
        NSString* reason = [NSString stringWithFormat:@"Config key %@ is not handled for class %@", key, NSStringFromClass(self.class)];
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

-(BOOL)_commonViewConfigWithKey:(NSString*)key value:(id)value{
    if([QVIEW_BG_COLOR isEqualToString:key]){
        self.backgroundColor = [self _q_parseColorString:value];
    } else if([QVIEW_ALPHA isEqualToString:key]){
        self.alpha = [value floatValue];
    } else {
        return NO;
    }
    
    return YES;
}
@end

#define QLABEL_TEXT             @"text"
#define QLABEL_NUMBER_OF_LINES  @"numberOfLines"
#define QLABEL_TEXT_COLOR       @"textColor"
#define QLABEL_FONT_SIZE        @"fontSize"
#define QLABEL_TEXT_ALIGN       @"textAlignment"

@implementation UILabel(AutoConfig)
-(BOOL)_q_configWithKey:(NSString*)key value:(id)value{
    if([QLABEL_TEXT isEqualToString:key]){
        self.text = value;
    } else if([QLABEL_NUMBER_OF_LINES isEqualToString:key]){
        self.numberOfLines = [value integerValue];
    } else if([QLABEL_TEXT_COLOR isEqualToString:key]){
        self.textColor = [self _q_parseColorString:value];
    } else if([QLABEL_FONT_SIZE isEqualToString:key]){
        self.font = [self.font fontWithSize:[value floatValue]];
    } else if([QLABEL_TEXT_ALIGN isEqualToString:key]){
        self.textAlignment = [value integerValue];
    } else {
        return NO;
    }
    
    return YES;
}
@end

#define QBUTTON_TITLE  @"text"
#define QBUTTON_TITLE_COLOR  @"textColor"
@implementation UIButton(AutoConfig)

-(BOOL)_q_configWithKey:(NSString*)key value:(id)value{
    if([QBUTTON_TITLE isEqualToString:key]){
        [self setTitle:value forState:UIControlStateNormal];
        [self setTitle:value forState:UIControlStateSelected];
        [self setTitle:value forState:UIControlStateDisabled];
    } else if([QBUTTON_TITLE_COLOR isEqualToString:key]){
        UIColor* titleColor = [self _q_parseColorString:value];
        [self setTitleColor:titleColor forState:UIControlStateNormal];
        [self setTitleColor:titleColor forState:UIControlStateSelected];
        [self setTitleColor:titleColor forState:UIControlStateDisabled];
    } else {
        return NO;
    }
    
    return YES;
}
@end

#define QTEXTFIELD_PLACE_HOLDER     @"placeHolder"
#define QTEXTFIELD_TEXT             @"text"
#define QTEXTFIELD_TEXT_COLOR       @"textColor"
#define QTEXTFIELD_FONT_SIZE        @"fontSize"
@implementation UITextField(AutoConfig)

-(BOOL)_q_configWithKey:(NSString*)key value:(id)value{
    if([QTEXTFIELD_PLACE_HOLDER isEqualToString:key]){
        self.placeholder = value;
    } else if([QTEXTFIELD_TEXT isEqualToString:key]){
        self.text = value;
    } else if([QTEXTFIELD_TEXT_COLOR isEqualToString:key]){
        self.textColor = [self _q_parseColorString:value];
    } else if([QLABEL_FONT_SIZE isEqualToString:key]){
        self.font = [self.font fontWithSize:[value floatValue]];
    } else {
        return NO;
    }
    
    return YES;
}

@end