//
//  QViewProperty.h
//  LibSourceUser
//
//  Created by 苏第 on 17/11/7.
//  Copyright © 2017年 Su Di. All rights reserved.
//

#import <Foundation/Foundation.h>


#define QVIEW_OPTION_LAYOUT                 @":layout"
#define QVIEW_OPTION_SCROLL_VERTICAL        @":scrollV"
#define QVIEW_OPTION_SCROLL_HORIZONTAL      @":scrollH"
#define QVIEW_OPTION_CLASS_NAME             @":className"
#define QVIEW_OPTION_STAY_WHEN_COMPRESSED   @":stayWhenCompressed"
#define QVIEW_OPTION_STAY_WHEN_STRETCHED    @":stayWhenStretched"
#define QVIEW_OPTION_EQUAL_WIDTH            @":widthEqual"
#define QVIEW_OPTION_EQUAL_HEIGHT           @":heightEqual"
#define QVIEW_OPTION_TOP_ALIGN              @":topAlign"
#define QVIEW_OPTION_BOTTOM_ALIGN           @":bottomAlign"
#define QVIEW_OPTION_LEFT_ALIGN             @":leftAlign"
#define QVIEW_OPTION_RIGHT_ALIGN            @":rightAlign"
#define QVIEW_OPTION_CENTER_X_ALIGN         @":centerXAlign"
#define QVIEW_OPTION_CENTER_Y_ALIGN         @":centerYAlign"

typedef NS_ENUM(NSUInteger, QOrientationOption) {
    QOrientationNone        = 1 << 0,
    QOrientationVertical    = 1 << 1,
    QOrientationHorizontal  = 1 << 2,
};

@class UIView;
@class QStayShapedOption;
@class QEqualOption;
@interface QViewProperty : NSObject
+(id)propertyWithViewName:(NSString*)viewName class:(Class)targetClass;

/**
 *  Valid when is view container.
 **/
@property (nonatomic, strong) NSArray* subviewsProperty;

/**
 *  Name of the view tagged.
 **/
@property (nonatomic, strong) NSString* name;

/**
 *  Valid when is view container.
 **/
@property (nonatomic, assign) QOrientationOption scrollOrientation;

/**
 *  the scroll view when scroll option enabled
 **/
@property (nonatomic, weak) UIView* scrollViewShadow;

/**
 *  the scroll view name when scroll option enabled
 **/
@property (nonatomic, strong) NSString* scrollViewName;

/**
 *  Class of the current view.
 **/
@property (nonatomic, strong) Class viewClass;

@property (nonatomic, strong, readonly) NSArray* arrayStayShapeOptions;
@property (nonatomic, strong, readonly) NSArray* arrayEqualOptions;
@property (nonatomic, strong, readonly) NSArray* arrayAlighOptions;
/**
 *  Constraints for this view.
 **/
@property (nonatomic, strong) NSString* VFLText;

@property (nonatomic, readonly) BOOL isViewContainer;

@property (nonatomic, readonly) BOOL isScrollEnabled;



-(void)parseOptionKey:(NSString*)key value:(NSString*)value;
@end
