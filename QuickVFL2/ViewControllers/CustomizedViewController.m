//
//  CustomizedViewController.m
//  QuickVFL2
//
//  Created by 苏第 on 17/11/11.
//  Copyright © 2017年 Quick. All rights reserved.
//

#import "CustomizedViewController.h"
#import "PortraitView.h"

@interface CustomizedViewController ()
@property (nonatomic, weak) PortraitView* portaitView;
@property (nonatomic, weak) UIScrollView* scrollView;
@end

@implementation CustomizedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Use a Customized View";
    
    [self.portaitView setupImage:[UIImage imageNamed:@"image1.jpeg"] title:@"海绵宝宝"];
    
    [self.scrollView q_refreshContentView];
}

-(QLayoutResult*)layout{
    return [QLayoutManager layoutForFileName:@"CustomizedViewController.json"
                                    entrance:self.view
                                      holder:self];
}

@end
