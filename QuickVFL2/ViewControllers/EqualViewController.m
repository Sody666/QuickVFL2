//
//  EqualViewController.m
//  QuickVFL2
//
//  Created by 苏第 on 17/11/12.
//  Copyright © 2017年 Quick. All rights reserved.
//

#import "EqualViewController.h"

@interface EqualViewController ()
@property (nonatomic, weak) UIScrollView* scrollView;
@end

@implementation EqualViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Equal Dimension";
    
    UIView* wrapper = [self.layoutResult viewNamed:@"container1_"];
    wrapper.backgroundColor = [UIColor lightGrayColor];
    
    UILabel* label = [self.layoutResult viewNamed:@"label1_"];
    label.backgroundColor = [UIColor orangeColor];
    label.numberOfLines = 0;
    label.text = @"1: 120x160";
    
    label = [self.layoutResult viewNamed:@"label2_"];
    label.backgroundColor = [UIColor orangeColor];
    label.numberOfLines = 0;
    label.text = @"2: 160x200";
    
    label = [self.layoutResult viewNamed:@"labelA_"];
    label.backgroundColor = [UIColor yellowColor];
    label.numberOfLines = 0;
    label.text = @"A: width=1's width, height=2's height";
    
    label = [self.layoutResult viewNamed:@"labelB_"];
    label.backgroundColor = [UIColor yellowColor];
    label.numberOfLines = 0;
    label.text = @"B: width=1's height * 0.6, height=2's height * 0.8";
    
    label = [self.layoutResult viewNamed:@"labelC_"];
    label.backgroundColor = [UIColor yellowColor];
    label.numberOfLines = 0;
    label.text = @"C: width=A's width * 2, height=B's height * 0.8";
    
    label = [self.layoutResult viewNamed:@"labelD_"];
    label.backgroundColor = [UIColor yellowColor];
    label.numberOfLines = 0;
    label.text = @"D: width=A's width * 2, height=self width * 0.3";
    
    [self.scrollView q_refreshContentView];
}

-(QLayoutResult*)layout{
    return [QLayoutManager layoutForFileName:@"EqualViewController.json"
                                    entrance:self.view
                                      holder:self];
}


@end
