//
//  PerformanceViewController.m
//  QuickVFL2
//
//  Created by 苏第 on 17/11/28.
//  Copyright © 2017年 Quick. All rights reserved.
//

#import "PerformanceViewController.h"
#import "TravelCardVFL.h"
#import "TravelCardXib.h"

@interface PerformanceViewController ()
@property (nonatomic, weak) UILabel* labelResult;
@property (nonatomic, weak) UIScrollView* scrollView;
@property (nonatomic, weak) UIView* viewPlaceHolder;
@property (nonatomic, weak) TravelCardVFL* cardDemo;
@property (atomic, assign) BOOL working;

@property (nonatomic, strong) UIImage* titleImage;
@end

@implementation PerformanceViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.working = NO;
}

-(void)cleanPlayground{
    NSArray* views = self.viewPlaceHolder.subviews;
    for (UIView* view in views) {
        [view removeFromSuperview];
    }
}

-(QLayoutResult*)layout{
    QLayoutResult* result = [QLayoutManager layoutForFileName:@"PerformanceViewController.json"
                                                     entrance:self.view
                                                       holder:self];
    UIButton* button = [result viewNamed:@"buttonVFL_"];
    [button addTarget:self action:@selector(onVFLButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    button = [result viewNamed:@"buttonXIB_"];
    [button addTarget:self action:@selector(onXIBButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scrollView q_refreshContentView];
    
    
    self.titleImage = [UIImage imageNamed:@"image1.jpeg"];
    
    [self.cardDemo setupWithTitle:@"北京石景山万达广场和颐酒店只要409元！" subTitle:@"高档型.公主坟、五棵松、石景山游乐园地区" source:@"北京.精选酒店" readCount:10000 titleImage:self.titleImage];
    
    return result;
}

-(void)onVFLButtonClicked{
    if(self.working){
        return;
    }

    [self cleanPlayground];
    self.labelResult.text = @"Working...";
    [self.scrollView q_refreshContentView];
    
    self.working = YES;
    
    TravelCardVFL* card;
    TravelCardVFL* previousCard;
    NSDate* now = [NSDate date];
    for (int i=0; i< 1000; i++) {
        card = [[TravelCardVFL alloc] initWithFrame:self.viewPlaceHolder.bounds];
        [card setupWithTitle:@"北京石景山万达广场和颐酒店只要409元！" subTitle:@"高档型.公主坟、五棵松、石景山游乐园地区" source:@"北京.精选酒店" readCount:10000 titleImage:self.titleImage];
        [card setNeedsLayout];
        [card layoutIfNeeded];
        
        if(previousCard){
            [previousCard removeFromSuperview];
        }
        [self.viewPlaceHolder addSubview:card];
        
        previousCard = card;
    }
    
    NSDate* later = [NSDate date];
    
    NSTimeInterval interval = [later timeIntervalSinceDate:now];
    self.labelResult.text = [NSString stringWithFormat:@"QuickVFL took %.2f seconds to create 1000 cards.", interval];
    self.working = NO;
    
    [self.scrollView q_refreshContentView];
}

-(void)onXIBButtonClicked{
    if(self.working){
        return;
    }
    
    [self cleanPlayground];
    self.labelResult.text = @"Working...";
    [self.scrollView q_refreshContentView];
    
    self.working = YES;
    
    TravelCardXib* card;
    TravelCardXib* previousCard;
    NSDate* now = [NSDate date];
    for (int i=0; i< 1000; i++) {
        card = [TravelCardXib instance];
        card.frame = self.viewPlaceHolder.bounds;
        [card setupWithTitle:@"北京石景山万达广场和颐酒店只要409元！" subTitle:@"高档型.公主坟、五棵松、石景山游乐园地区" source:@"北京.精选酒店" readCount:10000 titleImage:self.titleImage];
        [card setNeedsLayout];
        [card layoutIfNeeded];
        
        if(previousCard){
            [previousCard removeFromSuperview];
        }
        [self.viewPlaceHolder addSubview:card];
        
        previousCard = card;
    }
    
    NSDate* later = [NSDate date];
    
    NSTimeInterval interval = [later timeIntervalSinceDate:now];
    self.labelResult.text = [NSString stringWithFormat:@"XIB took %.2f seconds to create 1000 cards.", interval];
    self.working = NO;
    
    [self.scrollView q_refreshContentView];
}

@end
