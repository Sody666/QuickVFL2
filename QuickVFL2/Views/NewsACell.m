//
//  NewsACell.m
//  QuickVFL2
//
//  Created by 苏第 on 17/11/10.
//  Copyright © 2017年 Quick. All rights reserved.
//

#import "NewsACell.h"
#import "NewsModel.h"

@interface NewsACell()
@property (nonatomic, weak) UILabel* labelTitle;
@property (nonatomic, weak) UILabel* labelPostscript;
@property (nonatomic, weak) UIImageView* imageViewLeft;
@property (nonatomic, weak) UIImageView* imageViewMiddle;
@property (nonatomic, weak) UIImageView* imageViewRight;
@end

@implementation NewsACell
-(QLayoutResult*)layout{
    [super layout];
    
    QLayoutResult* result = [QLayoutManager layoutForFileName:@"NewsACell.json"
                                                     entrance:self.viewTotalWrapper
                                                       holder:self];
    UIButton* dislikeButton = [result viewNamed:@"buttonDislike_"];
    [dislikeButton setTitle:@"x" forState:UIControlStateNormal];
    [dislikeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.labelTitle.numberOfLines = 2;
    self.labelTitle.font = [UIFont systemFontOfSize:18];
    self.labelPostscript.font = [UIFont systemFontOfSize:12];
    
    return result;
}

-(void)fillData:(id)data{
    NewsModel* news = data;
    self.labelTitle.text = news.title;
    
    NSArray* images = news.images;
    self.imageViewLeft.image = images.count >=1 ? images[0] : nil;
    self.imageViewMiddle.image = images.count >=2 ? images[1] : nil;
    self.imageViewRight.image = images.count >=3 ? images[2] : nil;
    
    self.labelPostscript.text = news.postscript;
    
    [super fillData:data];
}
@end
