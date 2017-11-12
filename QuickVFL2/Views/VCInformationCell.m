//
//  VCInformationCell.m
//  QuickVFL2
//
//  Created by 苏第 on 17/11/8.
//  Copyright © 2017年 Quick. All rights reserved.
//

#import "VCInformationCell.h"

@interface VCInformationCell()
@property (nonatomic, weak) UILabel* labelTitle;
@property (nonatomic, weak) UILabel* labelDescription;
@end

@implementation VCInformationCell

-(void)setupWidget{
    [QLayoutManager layoutForFileName:@"VCInformationCell.json"
                             entrance:self.contentView
                               holder:self];
    
    self.labelDescription.numberOfLines = 2;
    self.labelTitle.font = [UIFont systemFontOfSize:24];
    self.labelDescription.font = [UIFont systemFontOfSize:16];
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setupWidget];
    }
    
    return self;
}

-(id)init{
    self=[super init];
    if (self) {
        [self setupWidget];
    }
    
    return self;
}

-(void)setupTitle:(NSString*)title description:(NSString*)description{
    self.labelTitle.text = title;
    self.labelDescription.text = description;
}
@end
