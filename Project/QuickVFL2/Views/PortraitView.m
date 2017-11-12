//
//  PortraitView.m
//  QuickVFL2
//
//  Created by 苏第 on 17/11/11.
//  Copyright © 2017年 Quick. All rights reserved.
//

#import "PortraitView.h"

@interface PortraitView()
@property (nonatomic, weak) UIImageView* imageViewContent;
@property (nonatomic, weak) UILabel* labelTitle;
@end
@implementation PortraitView

-(void)setupWidgets{
    [QLayoutManager layoutForFileName:@"PortraitView.json"
                             entrance:self
                               holder:self];
    
    self.labelTitle.textAlignment = NSTextAlignmentCenter;
}

-(id)init{
    self=[super init];
    if (self) {
        [self setupWidgets];
    }
    
    return self;
}

-(void)setupImage:(UIImage *)image title:(NSString *)title{
    self.imageViewContent.image = image;
    self.labelTitle.text = title;
}

@end
