//
//  RootTableViewCell.m
//  QuickVFL2
//
//  Created by 苏第 on 17/11/10.
//  Copyright © 2017年 Quick. All rights reserved.
//

#import "RootTableViewCell.h"

@interface RootTableViewCell()
@end

@implementation RootTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.layoutResult = [self layout];
    }
    
    return self;
}

-(QLayoutResult*)layout{
    return nil;
}

-(void)fillData:(id)data{
    
}
@end
