//
//  NewsBCell.m
//  QuickVFL2
//
//  Created by 苏第 on 17/11/10.
//  Copyright © 2017年 Quick. All rights reserved.
//

#import "NewsBCell.h"
#import "NewsModel.h"

@interface NewsBCell()
@property (nonatomic, weak) UILabel* labelTitle;
@property (nonatomic, weak) UILabel* labelPostscript;
@property (nonatomic, weak) UIImageView* imageViewTitle;
@property (nonatomic, weak) UIView* totalWrapper;
@end

@implementation NewsBCell

-(QLayoutResult*)layout{
    [super layout];
    
    QLayoutResult* result = [QLayoutManager layoutForFileName:@"NewsBCell.json"
                                                     entrance:self.viewTotalWrapper
                                                       holder:self];
    
    UIButton* dislikeButton = [result viewNamed:@"buttonDislike_"];
    [dislikeButton setTitle:@"x" forState:UIControlStateNormal];
    [dislikeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.labelTitle.numberOfLines = 3;
    self.labelTitle.font = [UIFont systemFontOfSize:16];
    self.labelPostscript.font = [UIFont systemFontOfSize:12];
    
    return result;
}

-(void)fillData:(id)data{
    NewsModel* news = data;
    self.labelTitle.text = news.title;
    self.imageViewTitle.image = news.images.firstObject;
    self.labelPostscript.text = news.postscript;
    
    [super fillData:data];
}
@end
