//
//  QLayoutResult.h
//  LibSourceUser
//
//  Created by 苏第 on 17/11/5.
//  Copyright © 2017年 Su Di. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QLayoutResult : NSObject
@property (nonatomic, strong) NSDictionary* createdViews;
/**
 *  Get the unmapped view with name.
 **/
-(id)viewNamed:(NSString*)name;
@end
