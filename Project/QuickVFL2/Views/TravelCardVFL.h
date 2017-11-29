//
//  TravelCard.h
//  QuickVFL2
//
//  Created by 苏第 on 17/11/28.
//  Copyright © 2017年 Quick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TravelCardVFL : UIView

-(void)setupWithTitle:(NSString*)title
             subTitle:(NSString*)subtitle
               source:(NSString*)source
            readCount:(NSUInteger)count
           titleImage:(UIImage*)titleImage;

@end
