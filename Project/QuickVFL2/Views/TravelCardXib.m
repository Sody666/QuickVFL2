//
//  TravelCardXib.m
//  QuickVFL2
//
//  Created by 苏第 on 17/11/28.
//  Copyright © 2017年 Quick. All rights reserved.
//

#import "TravelCardXib.h"

@interface TravelCardXib()
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelSubtitle;
@property (weak, nonatomic) IBOutlet UILabel *labelSource;
@property (weak, nonatomic) IBOutlet UILabel *labelReadCount;
@property (weak, nonatomic) IBOutlet UIView *viewReadCounterWrapper;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewTitle;

@end


@implementation TravelCardXib

+(id)instance{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"TravelCardXib" owner:nil options:nil];
    return [nibView objectAtIndex:0];
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
        self.labelReadCount.text = [NSString stringWithFormat:@"%d 阅读", (int)count];
    }
}
@end
