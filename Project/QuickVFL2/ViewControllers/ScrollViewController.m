//
//  ScrollViewController.m
//  QuickVFL2
//
//  Created by 苏第 on 17/11/9.
//  Copyright © 2017年 Quick. All rights reserved.
//

#import "ScrollViewController.h"

@interface ScrollViewController ()
@property (nonatomic, weak) UIScrollView* scrollViewContent;
@end

@implementation ScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Scroll-wrapped";
    
    UIImageView* imageView = [self.layoutResult viewNamed:@"imageView1_"];
    imageView.image = [UIImage imageNamed:@"image1.jpeg"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    imageView = [self.layoutResult viewNamed:@"imageView2_"];
    imageView.image = [UIImage imageNamed:@"image2.jpeg"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    imageView = [self.layoutResult viewNamed:@"imageView3_"];
    imageView.image = [UIImage imageNamed:@"image1.jpeg"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    imageView = [self.layoutResult viewNamed:@"imageView4_"];
    imageView.image = [UIImage imageNamed:@"image2.jpeg"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    [self.scrollViewContent q_refreshContentView];
}

-(QLayoutResult* )layout{
    return [QLayoutManager layoutForFileName:@"ScrollViewController.json"
                                    entrance:self.view
                                      holder:self];
}

@end
