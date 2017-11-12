//
//  VisibleViewController.m
//  QuickVFL2
//
//  Created by 苏第 on 17/11/8.
//  Copyright © 2017年 Quick. All rights reserved.
//

#import "VisibleViewController.h"

@interface VisibleViewController ()
@property (nonatomic, weak) UIView* wrapper1;
@property (nonatomic, weak) UIView* wrapper2;
@property (nonatomic, weak) UIView* wrapper3;
@property (nonatomic, weak) UIButton* button1;
@property (nonatomic, weak) UIButton* button2;
@property (nonatomic, weak) UIButton* button3;

@property (nonatomic, weak) UILabel* label1_;
@end

@implementation VisibleViewController

-(QLayoutResult*)layout{
    return [QLayoutManager layoutForFileName:@"VisibleViewController.json"
                                    entrance:self.view
                                      holder:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel* label = self.label1_;
    label.text = @"Red Label";
    label.backgroundColor = [UIColor redColor];
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 10;
    
    label = [self.layoutResult viewNamed:@"label2_"];
    label.text = @"Green Label";
    label.backgroundColor = [UIColor greenColor];
    label.textColor = [UIColor whiteColor];
    
    label = [self.layoutResult viewNamed:@"label3_"];
    label.text = @"Blue Label";
    label.backgroundColor = [UIColor blueColor];
    label.textColor = [UIColor whiteColor];
    
    [self.button1 setTitle:@"Hide" forState:UIControlStateNormal];
    self.button1.backgroundColor = [UIColor redColor];
    [self.button1 addTarget:self
                     action:@selector(onButtonClicked:)
           forControlEvents:UIControlEventTouchUpInside];
    
    [self.button2 setTitle:@"Hide" forState:UIControlStateNormal];
    self.button2.backgroundColor = [UIColor greenColor];
    [self.button2 addTarget:self
                     action:@selector(onButtonClicked:)
           forControlEvents:UIControlEventTouchUpInside];
    
    [self.button3 setTitle:@"Hide" forState:UIControlStateNormal];
    self.button3.backgroundColor = [UIColor blueColor];
    [self.button3 addTarget:self
                     action:@selector(onButtonClicked:)
           forControlEvents:UIControlEventTouchUpInside];
}

-(void)onButtonClicked:(UIButton*)sender{
    UIView* wrapper;
    if(sender == self.button1){
        wrapper = self.wrapper1;
    } else if(sender == self.button2){
        wrapper = self.wrapper2;
    } else if(sender == self.button3){
        wrapper = self.wrapper3;
    }
    
    BOOL visible = [wrapper q_visibleVertically:YES];
    [wrapper q_setVisibility:!visible isVertically:YES];
    if([wrapper q_visibleVertically:YES]){
        [sender setTitle:@"Hide" forState:UIControlStateNormal];
    } else {
        [sender setTitle:@"Show" forState:UIControlStateNormal];
    }
}

@end
