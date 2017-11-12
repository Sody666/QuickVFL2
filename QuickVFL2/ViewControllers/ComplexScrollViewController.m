//
//  ComplexScrollViewController.m
//  QuickVFL2
//
//  Created by 苏第 on 17/11/9.
//  Copyright © 2017年 Quick. All rights reserved.
//

#import "ComplexScrollViewController.h"

@interface ComplexScrollViewController ()
@property (nonatomic, weak) UIScrollView* scrollViewV;
@property (nonatomic, weak) UIScrollView* scrollViewH;
@end

@implementation ComplexScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Complex Scroll";
    // Vertical part
    UIImageView* imageView = [self.layoutResult viewNamed:@"image1_"];
    imageView.image = [UIImage imageNamed:@"image1.jpeg"];
    
    imageView = [self.layoutResult viewNamed:@"image2_"];
    imageView.image = [UIImage imageNamed:@"image2.jpeg"];
    
    imageView = [self.layoutResult viewNamed:@"image3_"];
    imageView.image = [UIImage imageNamed:@"image1.jpeg"];
    
    imageView = [self.layoutResult viewNamed:@"image4_"];
    imageView.image = [UIImage imageNamed:@"image2.jpeg"];
    
    // horizontal part
    imageView = [self.layoutResult viewNamed:@"imageA_"];
    imageView.image = [UIImage imageNamed:@"image1.jpeg"];
    
    imageView = [self.layoutResult viewNamed:@"imageB_"];
    imageView.image = [UIImage imageNamed:@"image2.jpeg"];
    
    imageView = [self.layoutResult viewNamed:@"imageC_"];
    imageView.image = [UIImage imageNamed:@"image1.jpeg"];
    
    imageView = [self.layoutResult viewNamed:@"imageD_"];
    imageView.image = [UIImage imageNamed:@"image2.jpeg"];
    
    [self.scrollViewH q_refreshContentView];
    [self.scrollViewV q_refreshContentView];
}

-(QLayoutResult* )layout{
    return [QLayoutManager layoutForFileName:@"ComplexScrollViewController.json"
                                    entrance:self.view
                                      holder:self];
}

@end
