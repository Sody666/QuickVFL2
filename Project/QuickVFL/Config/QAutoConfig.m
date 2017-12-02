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
-(BOOL)_q_configWithKey:(NSString*)key value:(id)value holder:(id)holder;
-(BOOL)q_configWithKey:(NSString*)key value:(id)value holder:(id)holder;

// subclass api
-(BOOL)QConfigWithKey:(NSString *)key value:(id)value holder:(id)holder;
@end

#define QVIEW_BG_COLOR @"backgroundColor"
#define QVIEW_ALPHA @"alpha"
#define QVIEW_TAG   @"tag"
#define QVIEW_INTERACTION @"enableInteraction"
#define QVIEW_CLIP_SUBVIEWS @"clipSubviews"
#define QVIEW_TINT_COLOR @"tintColor"
#define QVIEW_TINT_ADJUST_MODE @"tintAdjustMode"
#define QVIEW_CONTENT_MODE      @"contentMode"

#define QATTR_TEXT @"text"
#define QATTR_CLEAR @"clear"

#define QATTR_FONTSIZE @"fontSize"
#define QATTR_FOREGROUNDCOLOR  @"foregroundColor"
#define QATTR_BACKGROUNDCOLOR  @"backgroundColor"
#define QATTR_LIGATURE  @"ligature"
#define QATTR_KERN  @"kern"
#define QATTR_STRIKE  @"strike"
#define QATTR_STRIKECOLOR  @"strikeColor"
#define QATTR_UNDERLINE     @"underline"
#define QATTR_UNDERLINECOLOR @"underlineColor"
#define QATTR_STROKE  @"stroke"
#define QATTR_STROKECOLOR  @"strokeColor"
//#define QATTR_SHADOW  @"shadow"
//#define QATTR_TEXTEFFECT  @"textEffect"
#define QATTR_BASELINEOFFSET  @"baselineOffset"
#define QATTR_OBLIQUENESS  @"obliqueness"
#define QATTR_EXPANSION  @"expansion"
//#define QATTR_WRITINGDIRECTION  @"writingDirection"
//#define QATTR_VERTICALGLYPHFORM  @"verticalGlyphForm"
//#define QATTR_LINK  @"link"

@implementation UIView(AutoConfig)
-(void)q_configureWithData:(NSDictionary*)configData holder:(id)holder{
    if(configData == nil || configData.count < 1){
        return;
    }
    
    BOOL respondViewCommon = [self respondsToSelector:@selector(_commonViewConfigWithKey:value:holder:)];
    BOOL respondExtendCommon = [self respondsToSelector:@selector(_q_configWithKey:value:holder:)];
    BOOL respondExtendCustomize = [self respondsToSelector:@selector(q_configWithKey:value:holder:)];
    BOOL respondSubclass = [self respondsToSelector:@selector(QConfigWithKey:value:holder:)];
    
    for (NSString* key in configData.allKeys) {
        if((respondSubclass && [self QConfigWithKey:key value:[configData objectForKey:key] holder:holder]) ||
           (respondExtendCustomize && [self q_configWithKey:key value:[configData objectForKey:key] holder:holder]) ||
           (respondExtendCommon && [self _q_configWithKey:key value:[configData objectForKey:key] holder:holder]) ||
           (respondViewCommon && [self _commonViewConfigWithKey:key value:[configData objectForKey:key] holder:holder])){
            continue;
        }
        
        [QLayoutException throwExceptionForReason:@"Config key %@ is not handled for class %@",
                                                    key, NSStringFromClass(self.class)];
    }
}

-(UIColor*)_q_parseColorString:(NSString*)color{
    if(color.length == 0 || ![color hasPrefix:@"#"] || (color.length != 7 && color.length != 9)){
        [QLayoutException throwExceptionForReason:@"Illegal color format %@. Legal example: #FF123456 or #123456", color];
        
        // fall back to transparent color
        return [UIColor clearColor];
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

-(void)_q_parseAttributedStringKey:(NSString*)key value:(id)value inheritedAttributes:(NSMutableDictionary*)attributes{
    if([QATTR_TEXT isEqualToString:key] || [QATTR_CLEAR isEqualToString:key]){
        return;
    } else if ([QATTR_FONTSIZE isEqualToString:key]){
        [attributes setObject:[UIFont systemFontOfSize:[value floatValue]] forKey:NSFontAttributeName];
    } else if ([QATTR_FOREGROUNDCOLOR isEqualToString:key]){
        [attributes setObject:[self _q_parseColorString:value] forKey:NSForegroundColorAttributeName];
    } else if ([QATTR_BACKGROUNDCOLOR isEqualToString:key]){
        [attributes setObject:[self _q_parseColorString:value] forKey:NSBackgroundColorAttributeName];
    } else if ([QATTR_LIGATURE isEqualToString:key]){
        [attributes setObject:value forKey:NSLigatureAttributeName];
    } else if ([QATTR_KERN isEqualToString:key]){
        [attributes setObject:value forKey:NSKernAttributeName];
    } else if ([QATTR_STRIKE isEqualToString:key]){
        [attributes setObject:value forKey:NSStrikethroughStyleAttributeName];
    } else if ([QATTR_STRIKECOLOR isEqualToString:key]){
        [attributes setObject:[self _q_parseColorString:value] forKey:NSStrikethroughColorAttributeName];
    } else if ([QATTR_UNDERLINE isEqualToString:key]){
        [attributes setObject:value forKey:NSUnderlineStyleAttributeName];
    } else if ([QATTR_UNDERLINECOLOR isEqualToString:key]){
        [attributes setObject:[self _q_parseColorString:value] forKey:NSUnderlineColorAttributeName];
    } else if ([QATTR_STROKE isEqualToString:key]){
        [attributes setObject:value forKey:NSStrokeWidthAttributeName];
    } else if ([QATTR_STROKECOLOR isEqualToString:key]){
        [attributes setObject:[self _q_parseColorString:value] forKey:NSStrokeColorAttributeName];
    } else if ([QATTR_BASELINEOFFSET isEqualToString:key]){
        [attributes setObject:value forKey:NSBaselineOffsetAttributeName];
    } else if ([QATTR_OBLIQUENESS isEqualToString:key]){
        [attributes setObject:value forKey:NSObliquenessAttributeName];
    } else if ([QATTR_EXPANSION isEqualToString:key]){
        [attributes setObject:value forKey:NSExpansionAttributeName];
    } else {
        [QLayoutException throwExceptionForReason:@"Unsupported attributed key: %@", key];
    }
}

-(NSAttributedString*)_q_parseAttrubutedString:(NSArray*)segments{
    NSMutableAttributedString* result = [[NSMutableAttributedString alloc] init];
    
    if(![segments isKindOfClass:[NSArray class]] || segments.count == 0){
        [QLayoutException throwExceptionForReason:@"Bad format of attrubuted string."];
        return result;
    }
    
    NSString* text;
    NSNumber* clearTag;
    NSMutableDictionary* attributes = [[NSMutableDictionary alloc] init];
    for (NSDictionary* segment in segments) {
        clearTag = [segment objectForKey:QATTR_CLEAR];
        if(clearTag != nil && clearTag.boolValue){
            [attributes removeAllObjects];
        }
        text = [segment objectForKey:QATTR_TEXT];
        if(text.length == 0){
            continue;
        }
        
        for (NSString* key in segment.allKeys) {
            [self _q_parseAttributedStringKey:key
                                        value:[segment objectForKey:key]
                          inheritedAttributes:attributes];
        }
        
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:text attributes:attributes]];
    }
    
    return result;
}

-(BOOL)_commonViewConfigWithKey:(NSString*)key value:(id)value holder:(id)holder{
    if([QVIEW_BG_COLOR isEqualToString:key]){
        self.backgroundColor = [self _q_parseColorString:value];
    } else if([QVIEW_TINT_COLOR isEqualToString:key]){
        self.tintColor = [self _q_parseColorString:value];
    } else if([QVIEW_ALPHA isEqualToString:key]){
        self.alpha = [value floatValue];
    } else if([QVIEW_TAG isEqualToString:key]){
        self.tag = [value integerValue];
    } else if([QVIEW_INTERACTION isEqualToString:key]){
        self.userInteractionEnabled = [value boolValue];
    } else if([QVIEW_CLIP_SUBVIEWS isEqualToString:key]){
        self.clipsToBounds = [value boolValue];
    } else if([QVIEW_TINT_ADJUST_MODE isEqualToString:key]){
        self.tintAdjustmentMode = [value integerValue];
    } else if([QVIEW_CONTENT_MODE isEqualToString:key]){
        self.contentMode = [value integerValue];
    } else {
        return NO;
    }
    
    return YES;
}
@end

#define QLABEL_TEXT             @"text"
#define QLABEL_ATTR_TEXT        @"attributedText"
#define QLABEL_NUMBER_OF_LINES  @"numberOfLines"
#define QLABEL_TEXT_COLOR       @"textColor"
#define QLABEL_FONT_SIZE        @"fontSize"
#define QLABEL_TEXT_ALIGN       @"textAlignment"
#define QLABEL_LINE_BREAK       @"lineBreak"
#define QLABEL_BASELINE_ADJUST  @"baselineAdjustment"

@implementation UILabel(AutoConfig)
-(BOOL)_q_configWithKey:(NSString*)key value:(id)value holder:(id)holder{
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
    } else if([QLABEL_LINE_BREAK isEqualToString:key]){
        self.lineBreakMode = [value integerValue];
    } else if([QLABEL_BASELINE_ADJUST isEqualToString:key]){
        self.baselineAdjustment = [value integerValue];
    } else if([QLABEL_ATTR_TEXT isEqualToString:key]){
        self.attributedText = [self _q_parseAttrubutedString:value];
    } else {
        return NO;
    }
    
    return YES;
}
@end

#define QBUTTON_TITLE       @"text"
#define QBUTTON_ATTR_TITLE  @"attributedText"
#define QBUTTON_TITLE_COLOR @"textColor"
#define QBUTTON_EVENT_TAP   @"tapEvent"
@implementation UIButton(AutoConfig)

-(BOOL)_q_configWithKey:(NSString*)key value:(id)value holder:(id)holder{
    if([QBUTTON_TITLE isEqualToString:key]){
        [self setTitle:value forState:UIControlStateNormal];
        [self setTitle:value forState:UIControlStateSelected];
        [self setTitle:value forState:UIControlStateDisabled];
    } else if([QBUTTON_ATTR_TITLE isEqualToString:key]){
        NSAttributedString* title = [self _q_parseAttrubutedString:value];
        [self setAttributedTitle:title forState:UIControlStateNormal];
        [self setAttributedTitle:title forState:UIControlStateSelected];
        [self setAttributedTitle:title forState:UIControlStateDisabled];
    } else if([QBUTTON_EVENT_TAP isEqualToString:key]){
        SEL eventSelector = NSSelectorFromString(value);
        if(![holder respondsToSelector:eventSelector]){
            [QLayoutException throwExceptionForReason:@"Holder doesn't respond to selector %@", value];
            return NO;
        }
        
        [self addTarget:holder action:eventSelector forControlEvents:UIControlEventTouchUpInside];
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
#define QTEXTFIELD_BORDER_STYLE     @"borderStyle"
#define QTEXTFIELD_SECURE_TEXT      @"secureText"
#define QTEXTFIELD_ADJUST_TO_FIT    @"adjustToFit"
#define QTEXTFIELD_MIN_FONT_SIZE    @"minFontSize"
@implementation UITextField(AutoConfig)

-(BOOL)_q_configWithKey:(NSString*)key value:(id)value holder:(id)holder{
    if([QTEXTFIELD_PLACE_HOLDER isEqualToString:key]){
        self.placeholder = value;
    } else if([QTEXTFIELD_TEXT isEqualToString:key]){
        self.text = value;
    } else if([QTEXTFIELD_TEXT_COLOR isEqualToString:key]){
        self.textColor = [self _q_parseColorString:value];
    } else if([QTEXTFIELD_FONT_SIZE isEqualToString:key]){
        self.font = [self.font fontWithSize:[value floatValue]];
    } else if([QTEXTFIELD_BORDER_STYLE isEqualToString:key]){
        self.borderStyle = [value integerValue];
    } else if([QTEXTFIELD_SECURE_TEXT isEqualToString:key]){
        self.secureTextEntry = [value boolValue];
    } else if([QTEXTFIELD_ADJUST_TO_FIT isEqualToString:key]){
        self.adjustsFontSizeToFitWidth = [value boolValue];
    } else if([QTEXTFIELD_MIN_FONT_SIZE isEqualToString:key]){
        self.minimumFontSize = [value floatValue];
    } else {
        return NO;
    }
    
    return YES;
}

@end