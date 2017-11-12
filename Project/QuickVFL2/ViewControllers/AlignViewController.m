//
//  AlignViewController.m
//  QuickVFL2
//
//  Created by 苏第 on 17/11/9.
//  Copyright © 2017年 Quick. All rights reserved.
//

#import "AlignViewController.h"

@interface AlignViewController ()
@property (nonatomic, weak) UIScrollView* scrollViewContent;
@end

@implementation AlignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Alignment Demo";
    
    UIView* view = [self.layoutResult viewNamed:@"part1_"];
    view.backgroundColor = [UIColor lightGrayColor];
    
    UILabel* label = [self.layoutResult viewNamed:@"labelTitle1_"];
    label.text = @"Horizontal Alignment";
    label.backgroundColor = [UIColor orangeColor];
    
    label = [self.layoutResult viewNamed:@"left1_"];
    label.text = @"Left";
    label.backgroundColor = [UIColor redColor];
    
    label = [self.layoutResult viewNamed:@"middle1_"];
    label.text = @"Center X";
    label.backgroundColor = [UIColor greenColor];
    
    label = [self.layoutResult viewNamed:@"right1_"];
    label.text = @"Right";
    label.backgroundColor = [UIColor blueColor];
    
    
    // part 2
    view = [self.layoutResult viewNamed:@"part2_"];
    view.backgroundColor = [UIColor lightGrayColor];
    
    label = [self.layoutResult viewNamed:@"labelTitle2_"];
    label.text = @"Vertical Alignment";
    label.backgroundColor = [UIColor orangeColor];
    
    label = [self.layoutResult viewNamed:@"top2_"];
    label.text = @"Top";
    label.backgroundColor = [UIColor redColor];
    
    label = [self.layoutResult viewNamed:@"middle2_"];
    label.text = @"Center Y";
    label.backgroundColor = [UIColor greenColor];
    
    label = [self.layoutResult viewNamed:@"bottom2_"];
    label.text = @"Bottom";
    label.backgroundColor = [UIColor blueColor];
    
    
    // part 3
    view = [self.layoutResult viewNamed:@"part3_"];
    view.backgroundColor = [UIColor lightGrayColor];
    
    label = [self.layoutResult viewNamed:@"labelTitle3_"];
    label.text = @"VFL center";
    label.backgroundColor = [UIColor orangeColor];
    
    label = [self.layoutResult viewNamed:@"label31_"];
    label.text = @"Text A";
    label.backgroundColor = [UIColor redColor];
    
    label = [self.layoutResult viewNamed:@"label32_"];
    label.text = @"Short Text B";
    label.backgroundColor = [UIColor greenColor];
    
    label = [self.layoutResult viewNamed:@"label33_"];
    label.text = @"Another Short Text C";
    label.backgroundColor = [UIColor blueColor];
    
    [self.scrollViewContent q_refreshContentView];
}

-(QLayoutResult*)layout{
    return [QLayoutManager layoutForFileName:@"AlignViewController.json"
                                    entrance:self.view
                                      holder:self];
}

@end
