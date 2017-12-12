//
//  RootTableViewCell.m
//  QuickVFL2
//
//  Created by 苏第 on 17/11/10.
//  Copyright © 2017年 Quick. All rights reserved.
//

#import "RootTableViewCell.h"

@interface RootTableViewCell(){
    NSIndexPath* _indexPath;
}
@end

@implementation RootTableViewCell
+(NSString*)nameOfIndexPath:(NSIndexPath*)indexPath{
    return [NSString stringWithFormat:@"%d-%d", (int)indexPath.section, (int)indexPath.row];
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.layoutResult = [self layout];
    }
    
    return self;
}

-(QLayoutResult*)layout{
    QLayoutResult* result = [QLayoutManager layoutForFileName:@"RootTableViewCell.json"
                                    entrance:self.contentView
                                      holder:self];
    
    _viewTotalWrapper = [result viewNamed:@"viewTotalWrapper_"];
    
    return result;
}
-(CGFloat)cellHeight{
    return self.viewTotalWrapper.frame.size.height;
}

-(void)fillData:(id)data{
}

-(void)setIndexPath:(NSIndexPath*)path{
    _indexPath = path;
}

-(NSString*)indexPath{
    if(_indexPath){
        return [RootTableViewCell nameOfIndexPath:_indexPath];
    } else {
        return nil;
    }
}
@end
