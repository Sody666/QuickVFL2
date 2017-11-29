//
//  HomeViewController.m
//  QuickVFL2
//
//  Created by 苏第 on 17/11/8.
//  Copyright © 2017年 Quick. All rights reserved.
//

#import "HomeViewController.h"
#import "VCInformationCell.h"
#import "StayShapeViewController.h"
#import "VisibleViewController.h"
#import "ScrollViewController.h"
#import "ComplexScrollViewController.h"
#import "AlignViewController.h"
#import "NewsViewController.h"
#import "CustomizedViewController.h"
#import "EqualViewController.h"
#import "PerformanceViewController.h"

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView* tableViewContent;
@property (nonatomic, strong) NSArray* arrayViewControllerClasses;
@property (nonatomic, strong) NSArray* arrayTitles;
@property (nonatomic, strong) NSArray* arrayDescriptions;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Home";
    self.tableViewContent.dataSource = self;
    self.tableViewContent.delegate = self;
    self.tableViewContent.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableViewContent registerClass:[VCInformationCell class] forCellReuseIdentifier:@"vcinfo"];
    
    [self setupData];
    [self.tableViewContent reloadData];
}

-(QLayoutResult*)layout{
    return [QLayoutManager layoutForFileName:@"HomeViewController.json"
                                    entrance:self.view
                                      holder:self];
}

-(void)setupData{
    self.arrayViewControllerClasses = @[
                                        [VisibleViewController class],
                                        [StayShapeViewController class],
                                        [ScrollViewController class],
                                        [ComplexScrollViewController class],
                                        [AlignViewController class],
                                        [CustomizedViewController class],
                                        [NewsViewController class],
                                        [EqualViewController class],
                                        [PerformanceViewController class],
                                        ];
    self.arrayTitles = @[
                         @"Visible Control Demo",
                         @"Stay Shape Demo",
                         @"Auto Scrolled Demo",
                         @"Auto scrolled Demo2",
                         @"Align Demo",
                         @"Use customzed view Demo",
                         @"News List Demo",
                         @"Equal Dimension Demo",
                         @"Performance comparing"
                         ];
    
    self.arrayDescriptions = @[
                               @"Make view visible and invisible",
                               @"Make view keep shape when space is more or less",
                               @"Wrap all the view with scroll view automatically",
                               @"Wrap content in subviews",
                               @"Align Widgets in all the way",
                               @"Use a customzied view in layout file",
                               @"A list of news",
                               @"Equal dimension to another view's",
                               @"Comparing 3 ways of layouting"
                               ];
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayViewControllerClasses.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VCInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"vcinfo"];
    
    [cell setupTitle:self.arrayTitles[indexPath.row]
         description:self.arrayDescriptions[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Class vcClass = [self.arrayViewControllerClasses objectAtIndex:indexPath.row];
    UIViewController* controller = [[vcClass alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
