//
//  QViewProperty.h
//  LibSourceUser
//
//  Created by 苏第 on 17/11/7.
//  Copyright © 2017年 Su Di. All rights reserved.
//

#import <Foundation/Foundation.h>

// the vfl defination of current view
#define QVIEW_OPTION_LAYOUT                 @":layout"
// wrap current view with scroll view vertically
#define QVIEW_OPTION_SCROLL_VERTICAL        @":scrollV"
// wrap current view with scroll view horizontal
#define QVIEW_OPTION_SCROLL_HORIZONTAL      @":scrollH"
// class name of current view
#define QVIEW_OPTION_CLASS_NAME             @":className"
// priority and orientation to stay unchanged when space is not enough
#define QVIEW_OPTION_STAY_WHEN_COMPRESSED   @":stayWhenCompressed"
// priority and orientation to stay unchanged when space is more than needed
#define QVIEW_OPTION_STAY_WHEN_STRETCHED    @":stayWhenStretched"
// data for the view
#define QVIEW_OPTION_VIEW_DATA              @":viewData"
// equal current view's width to some body
// equal 0.6 height of widget => ":widthEqual":"widget@0.6@h"
// equal width of widget =>":widthEqual":"widget"
// equal height of widget =>":widthEqual":"widget@1.0@h"
#define QVIEW_OPTION_EQUAL_WIDTH            @":widthEqual"
// equal current view's height to some body
#define QVIEW_OPTION_EQUAL_HEIGHT           @":heightEqual"
// align to top.
// seperate groups with ; and members with ,
// each group must have more than one members
// first member will be aligned to.
// top align a, b, c as a group and x, y, z as another group
// => ":topAligh":"a,b,c;x,y,z"
#define QVIEW_OPTION_TOP_ALIGN              @":topAlign"
#define QVIEW_OPTION_BOTTOM_ALIGN           @":bottomAlign"
#define QVIEW_OPTION_LEFT_ALIGN             @":leftAlign"
#define QVIEW_OPTION_RIGHT_ALIGN            @":rightAlign"
// align to center horizontally.
// each group must have at least one member
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

@property (nonatomic, strong) id viewData;

-(void)parseOptionKey:(NSString*)key value:(NSString*)value;
@end
