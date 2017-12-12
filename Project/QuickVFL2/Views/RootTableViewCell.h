//
//  RootTableViewCell.h
//  QuickVFL2
//
//  Created by 苏第 on 17/11/10.
//  Copyright © 2017年 Quick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootTableViewCell : UITableViewCell
+(NSString*)nameOfIndexPath:(NSIndexPath*)indexPath;
@property (nonatomic, strong) QLayoutResult* layoutResult;
@property (nonatomic, weak, readonly) UIView* viewTotalWrapper;
@property (nonatomic, assign) BOOL dirty;
-(QLayoutResult*)layout;
-(CGFloat)cellHeight;
-(void)fillData:(id)data;
-(void)setIndexPath:(NSIndexPath*)indexPath;
-(NSString*)indexPath;
@end
