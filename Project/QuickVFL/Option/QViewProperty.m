//
//  QViewProperty.m
//  LibSourceUser
//
//  Created by 苏第 on 17/11/7.
//  Copyright © 2017年 Su Di. All rights reserved.
//

#import "QViewProperty.h"
#import "QParseException.h"
#import <UIKit/UIKit.h>
#import "QStayShapedOption.h"
#import "QAlignOption.h"
#import "QEqualOption.h"
#import "QLayoutManager.h"

@interface QViewProperty()
@property (nonatomic, strong) NSMutableArray* arrayStayShapeOptions;
@property (nonatomic, strong) NSMutableArray* arrayEqualOptions;
@property (nonatomic, strong) NSMutableArray* arrayAlighOptions;
@end

@implementation QViewProperty
-(BOOL) isViewContainer {
    return self.subviewsProperty.count > 0 || self.scrollOrientation != QOrientationNone;
}

-(BOOL) isScrollEnabled {
    return self.scrollOrientation != QOrientationNone;
}

-(id)init{
    self = [super init];
    if (self) {
        self.scrollOrientation = QOrientationNone;
        self.arrayAlighOptions = [[NSMutableArray alloc] init];
    }
    
    return self;
}

+(id)propertyWithViewName:(NSString*)viewName class:(Class)targetClass{
    QViewProperty* result = [[self alloc] init];
    
    result.name = viewName;
    result.viewClass = targetClass;
    
    return result;
}

-(void)parseOptionKey:(NSString*)key value:(id)value{
    if(key.length == 0){
        return;
    } else if([key isEqualToString:QVIEW_OPTION_LAYOUT]){
        self.VFLText = value;
    } else if([key isEqualToString:QVIEW_OPTION_SCROLL_HORIZONTAL]){
        self.scrollOrientation = QOrientationHorizontal;
        self.scrollViewName = value;
    } else if([key isEqualToString:QVIEW_OPTION_SCROLL_VERTICAL]){
        self.scrollOrientation = QOrientationVertical;
        self.scrollViewName = value;
    } else if([key isEqualToString:QVIEW_OPTION_CLASS_NAME]){
        self.viewClass = [QLayoutManager parseClassName:value];
    } else if([key isEqualToString:QVIEW_OPTION_STAY_WHEN_STRETCHED] ||
              [key isEqualToString:QVIEW_OPTION_STAY_WHEN_COMPRESSED]){
        if(!_arrayStayShapeOptions){
            _arrayStayShapeOptions = [[NSMutableArray alloc] init];
        }
        
        [_arrayStayShapeOptions addObject:[QStayShapedOption optionWithKey:key value:value]];
    } else if([key isEqualToString:QVIEW_OPTION_EQUAL_WIDTH] ||
              [key isEqualToString:QVIEW_OPTION_EQUAL_HEIGHT]){
        if(!_arrayEqualOptions){
            _arrayEqualOptions = [[NSMutableArray alloc] init];
        }
        
        [_arrayEqualOptions addObject:[QEqualOption optionWithKey:key value:value]];
    } else if([key isEqualToString:QVIEW_OPTION_VIEW_DATA]){
        self.viewData = value;
    } else if([key hasSuffix:@"Align"]){
        if(!_arrayAlighOptions){
            _arrayAlighOptions = [[NSMutableArray alloc] init];
        }
        
        [_arrayAlighOptions addObject:[QAlignOption optionWithKey:key value:value]];
    } else {
        NSString* reason = [NSString stringWithFormat:@"Unknown option with key %@ and value %@", key, value];
        @throw [QParseException exceptionWithReason:reason];
    }
}
@end
