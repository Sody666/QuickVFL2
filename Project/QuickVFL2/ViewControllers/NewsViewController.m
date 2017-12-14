//
//  NewsViewController.m
//  QuickVFL2
//
//  Created by 苏第 on 17/11/10.
//  Copyright © 2017年 Quick. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsACell.h"
#import "NewsBCell.h"
#import "NewsModel.h"

@interface NewsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView* tableViewContent;
@property (nonatomic, strong) NSArray* arrrayNews;
@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"News List";
    
    self.tableViewContent.delegate = self;
    self.tableViewContent.dataSource = self;
    self.tableViewContent.estimatedRowHeight = 80.;
    self.tableViewContent.rowHeight = UITableViewAutomaticDimension;
    [self.tableViewContent registerClass:[NewsACell class] forCellReuseIdentifier:@"3"];
    [self.tableViewContent registerClass:[NewsBCell class] forCellReuseIdentifier:@"1"];
    
    [self setupData];
    [self.tableViewContent reloadData];
    self.tableViewContent.tableFooterView = [[UIView alloc] init];
}

-(QLayoutResult*)layout{
    return [QLayoutManager layoutForFileName:@"NewsViewController.json"
                                    entrance:self.view
                                      holder:self];
}

#pragma mark - table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrrayNews.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsModel* news = [self.arrrayNews objectAtIndex:indexPath.row];
    
    NSString* key;
    if(news.images.count >=3){
        key = @"3";
    } else {
        key = @"1";
    }
    
    RootTableViewCell*  cell = [tableView dequeueReusableCellWithIdentifier:key];
    [cell fillData:news];
    
    return cell;
}

#pragma mark - getter and setter
-(void)setupData{
    NSMutableArray* arrayNews = [[NSMutableArray alloc] init];
    NewsModel* news = [[NewsModel alloc] init];
    news.title = @"韩红不堪辱骂，一怒之下曝光了明星们捐款金额！这些明星瞬间尴尬";
    // Loading such images will block the main thread.
    // Never load images in this way in your real app.
    UIImage* image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://p3.pstatp.com/list/190x124/438b000345f9d1564ae5"]]];
    UIImage* image2 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://p3.pstatp.com/list/190x124/43900000ede2bc3ca7d4"]]];
    UIImage* image3 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://p1.pstatp.com/list/190x124/438c000135909c4ab4f3"]]];
    news.images = @[image1, image2, image3];
    news.postscript = @"我爱家乡 325评论 58分钟前";
    [arrayNews addObject:news];


    news = [[NewsModel alloc] init];
    news.title = @"章子怡说有20多位明星拒演《战狼2》，你知道这20多位明星都是谁吗？";
    image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://p9.pstatp.com/list/190x124/3f0400130d06d3bedd6e"]]];
    news.images = @[image1];
    news.postscript = @"悟空问答 1小时前";
    [arrayNews addObject:news];
    
    
    news = [[NewsModel alloc] init];
    news.title = @"史上最尴尬演唱会，他的到场只有7人，门票收入还不够买把吉他！";
    image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://p1.pstatp.com/list/190x124/436e0000e5b44630d931"]]];
    image2 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://p3.pstatp.com/list/190x124/436d0002359ba4ed1fdf"]]];
    image3 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://p1.pstatp.com/list/190x124/436c00023f319adf695d"]]];
    news.images = @[image1, image2, image3];
    news.postscript = @"水木清华小时光 503评论 1小时前";
    [arrayNews addObject:news];

    
    news = [[NewsModel alloc] init];
    news.title = @"就因为特朗普吃的这顿饭，韩国和日本现在正掐得热火朝天！";
    image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://p3.pstatp.com/list/190x124/438b00036e699972df4c"]]];
    news.images = @[image1];
    news.postscript = @"牛弹琴 27评论 2小时前";
    [arrayNews addObject:news];
    
    news = [[NewsModel alloc] init];
    news.title = @"大妈吃自助餐，一个人疯夹12盘虾，员工不敢吱声，老板亲自送走";
    image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://p3.pstatp.com/list/190x124/4383000099e76ea22d3e"]]];
    image2 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://p3.pstatp.com/list/190x124/438100020327afe06442"]]];
    image3 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://p3.pstatp.com/list/190x124/437f0002178c7609b93f"]]];
    news.images = @[image1, image2, image3];
    news.postscript = @"孟婆卖汤不卖药 评论 2小时前";
    [arrayNews addObject:news];
    
    
    news = [[NewsModel alloc] init];
    news.title = @"苹果“彻底发飙”: iPhone6双十一狂降，现已跌至“冰点价”！";
    image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://p1.pstatp.com/list/190x124/46c90000aa0eb642b66d"]]];
    news.images = @[image1];
    news.postscript = @"易说数码 151评论 2小时前";
    [arrayNews addObject:news];
    

    
    news = [[NewsModel alloc] init];
    news.title = @"他亲手击毙了卡扎菲，最终下场悲惨";
    image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://p1.pstatp.com/list/190x124/438e0002598f6adcf78c"]]];
    news.images = @[image1];
    news.postscript = @"云中史记 289评论 2小时前";
    [arrayNews addObject:news];
    
    news = [[NewsModel alloc] init];
    news.title = @"赵本山最火女徒弟丫蛋离婚，她的身世令人落泪";
    image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://p3.pstatp.com/list/190x124/439200043bb198b5ff30"]]];
    news.images = @[image1];
    news.postscript = @"细节攻 48评论 3小时前";
    [arrayNews addObject:news];
    ////////////////////////////////////////
    news = [[NewsModel alloc] init];
    news.title = @"章子怡说有20多位明星拒演《战狼2》，你知道这20多位明星都是谁吗？";
    image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://p9.pstatp.com/list/190x124/3f0400130d06d3bedd6e"]]];
    news.images = @[image1];
    news.postscript = @"悟空问答 1小时前";
    [arrayNews addObject:news];
    
    
    news = [[NewsModel alloc] init];
    news.title = @"史上最尴尬演唱会，他的到场只有7人，门票收入还不够买把吉他！";
    image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://p1.pstatp.com/list/190x124/436e0000e5b44630d931"]]];
    image2 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://p3.pstatp.com/list/190x124/436d0002359ba4ed1fdf"]]];
    image3 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://p1.pstatp.com/list/190x124/436c00023f319adf695d"]]];
    news.images = @[image1, image2, image3];
    news.postscript = @"水木清华小时光 503评论 1小时前";
    [arrayNews addObject:news];
    
    
    news = [[NewsModel alloc] init];
    news.title = @"就因为特朗普吃的这顿饭，韩国和日本现在正掐得热火朝天！";
    image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://p3.pstatp.com/list/190x124/438b00036e699972df4c"]]];
    news.images = @[image1];
    news.postscript = @"牛弹琴 27评论 2小时前";
    [arrayNews addObject:news];
    
    news = [[NewsModel alloc] init];
    news.title = @"大妈吃自助餐，一个人疯夹12盘虾，员工不敢吱声，老板亲自送走";
    image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://p3.pstatp.com/list/190x124/4383000099e76ea22d3e"]]];
    image2 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://p3.pstatp.com/list/190x124/438100020327afe06442"]]];
    image3 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://p3.pstatp.com/list/190x124/437f0002178c7609b93f"]]];
    news.images = @[image1, image2, image3];
    news.postscript = @"孟婆卖汤不卖药 评论 2小时前";
    [arrayNews addObject:news];
    
    
    news = [[NewsModel alloc] init];
    news.title = @"苹果“彻底发飙”: iPhone6双十一狂降，现已跌至“冰点价”！";
    image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://p1.pstatp.com/list/190x124/46c90000aa0eb642b66d"]]];
    news.images = @[image1];
    news.postscript = @"易说数码 151评论 2小时前";
    [arrayNews addObject:news];
    
    
    
    news = [[NewsModel alloc] init];
    news.title = @"他亲手击毙了卡扎菲，最终下场悲惨";
    image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://p1.pstatp.com/list/190x124/438e0002598f6adcf78c"]]];
    news.images = @[image1];
    news.postscript = @"云中史记 289评论 2小时前";
    [arrayNews addObject:news];
    
    news = [[NewsModel alloc] init];
    news.title = @"赵本山最火女徒弟丫蛋离婚，她的身世令人落泪";
    image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://p3.pstatp.com/list/190x124/439200043bb198b5ff30"]]];
    news.images = @[image1];
    news.postscript = @"细节攻 48评论 3小时前";
    [arrayNews addObject:news];
    ///////////////
    
    self.arrrayNews = arrayNews;
}
@end
