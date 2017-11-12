//
//  QLayoutManager.h
//  LibSourceUser
//
//  Created by 苏第 on 17/11/5.
//  Copyright © 2017年 Su Di. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class QLayoutResult;

@interface QLayoutManager : NSObject

+(QLayoutResult*) layoutForFilePath:(NSString*)filePath
                           entrance:(UIView*)entrance
                             holder:(id)holder;

+(QLayoutResult*) layoutForFileName:(NSString*)fileName
                           entrance:(UIView*)entrance
                             holder:(id)holder;

+(QLayoutResult*) layoutForContent:(NSString*)content
                          entrance:(UIView*)entrance
                            holder:(id)holder;

+(Class)parseClassName:(NSString*)className;
@end
