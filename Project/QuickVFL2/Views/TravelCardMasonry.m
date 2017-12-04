//
//  TravelCardMasonry.m
//  QuickVFL2
//
//  Created by NickJackson on 2017/12/4.
//  Copyright © 2017年 Quick. All rights reserved.
//

#import "TravelCardMasonry.h"
#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"

@implementation TravelCardMasonry

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.backgroundColor = [UIColor colorWithRed:234./255 green:234./255 blue:234./255 alpha:1];
    
    UILabel *title1Label = [UILabel new];
    title1Label.numberOfLines = 0;
    title1Label.font = [UIFont systemFontOfSize:18.];
    
    UILabel *title2Label = [UILabel new];
    title2Label.numberOfLines = 0;
    title2Label.font = [UIFont systemFontOfSize:12.];
    
    UILabel *title3Label = [UILabel new];
    title3Label.font = [UIFont systemFontOfSize:10.];
    
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"image1.jpeg"];
    
    UILabel *title4Label = [UILabel new];
    title4Label.textAlignment = NSTextAlignmentRight;
    title4Label.font = [UIFont systemFontOfSize:10.];
    
    title1Label.text = @"北京石景山万达广场和颐酒店只要409元！";
    title2Label.text = @"高档型.公主坟、五棵松、石景山游乐园地区";
    title3Label.text = @"北京.精选酒店";
    
    UIView* wrapper = [UIView new];
    [wrapper addSubview:title4Label];
    title4Label.text = @"10000 阅读";
    
    [self addSubview:title1Label];
    [self addSubview:title2Label];
    [self addSubview:title3Label];
    [self addSubview:wrapper];
    [self addSubview:imageView];
    
    [title1Label makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(8);
        make.right.equalTo(imageView.mas_left).offset(-8);
    }];
    [title2Label makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(title1Label);
        make.top.equalTo(title1Label.mas_bottom).offset(8);
        make.right.equalTo(title1Label);
    }];
    [title3Label makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(title1Label);
        make.right.equalTo(title1Label);
        make.top.greaterThanOrEqualTo(title2Label.mas_bottom).offset(8);
        make.bottom.equalTo(-8);
    }];
    
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(title1Label.mas_width).multipliedBy(0.8);
        make.height.equalTo(imageView.mas_width).multipliedBy(0.6);
        make.top.equalTo(8);
        make.right.equalTo(-8);
        
    }];
    [wrapper makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imageView);
        make.left.equalTo(imageView);
        make.bottom.equalTo(-8);
        make.top.greaterThanOrEqualTo(imageView.mas_bottom).offset(8);
    }];
    
    [title4Label makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(0);
        make.left.greaterThanOrEqualTo(0);
    }];
}

@end
