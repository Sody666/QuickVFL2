//
//  RootTableViewCell.h
//  QuickVFL2
//
//  Created by 苏第 on 17/11/10.
//  Copyright © 2017年 Quick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootTableViewCell : UITableViewCell

@property (nonatomic, strong) QLayoutResult* layoutResult;
-(QLayoutResult*)layout;
-(void)fillData:(id)data;
@end
