//
//  TravelCard.m
//  QuickVFL2
//
//  Created by 苏第 on 17/11/28.
//  Copyright © 2017年 Quick. All rights reserved.
//

#import "TravelCardVFL.h"

@interface TravelCardVFL()
@property (nonatomic, weak) UILabel* labelTitle;
@property (nonatomic, weak) UILabel* labelSubtitle;
@property (nonatomic, weak) UILabel* labelSource;
@property (nonatomic, weak) UILabel* labelReadCount;
@property (nonatomic, weak) UIImageView* imageViewTitle;
@property (nonatomic, weak) UIView* viewReadCounterWrapper;
@end

@implementation TravelCardVFL

-(void)layout{
    [QLayoutManager layoutForFileName:@"TravelCardVFL.json" entrance:self holder:self];
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self layout];
    }
    
    return self;
}

-(void)setupWithTitle:(NSString*)title
             subTitle:(NSString*)subtitle
               source:(NSString*)source
            readCount:(NSUInteger)count
           titleImage:(UIImage*)titleImage{
    self.labelTitle.text = title;
    self.labelSubtitle.text = subtitle;
    self.labelSource.text = source;
    self.imageViewTitle.image = titleImage;
    
    if(count < 100){
        [self.viewReadCounterWrapper q_setVisibility:NO isVertically:YES];
    } else {
        [self.viewReadCounterWrapper q_setVisibility:YES isVertically:YES];
        self.labelReadCount.text = [NSString stringWithFormat:@"%d 阅读", count];
    }
}
@end
