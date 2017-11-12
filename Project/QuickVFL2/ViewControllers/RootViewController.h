//
//  RootViewController.h
//  QuickVFL2
//
//  Created by 苏第 on 17/11/9.
//  Copyright © 2017年 Quick. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QLayoutResult;
@interface RootViewController : UIViewController
/**
 *  Result of layout actions.
 **/
@property (nonatomic, readonly) QLayoutResult* layoutResult;

/**
 *  Routine action for layout.
 **/
-(QLayoutResult*)layout;
@end
