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
@end

@implementation VisibleViewController

-(QLayoutResult*)layout{
    return [QLayoutManager layoutForFileName:@"VisibleViewController.json"
                                    entrance:self.view
                                      holder:self];
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
