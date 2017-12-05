//
//  AnimationViewController.m
//  QuickVFL2
//
//  Created by 苏第 on 2017/12/5.
//  Copyright © 2017年 Quick. All rights reserved.
//

#import "AnimationViewController.h"

@interface AnimationViewController ()
@property (nonatomic, weak) UIView* imageWrapper;
@property (nonatomic, weak) UIScrollView* scrollView;
@property (nonatomic, weak) UIImageView* imageView;
@property (nonatomic, weak) NSLayoutConstraint* constraintPickerControl;
@property (nonatomic, weak) UIDatePicker* datePicker_;
@property (nonatomic, weak) UIView* viewMask;
@end

@implementation AnimationViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"Animation Demo";
    
    self.imageView.image = [UIImage imageNamed:@"image1.jpeg"];
    [self.scrollView q_refreshContentView];
}

-(QLayoutResult*)layout{
    return [QLayoutManager layoutForFileName:@"AnimationViewController.json"
                                    entrance:self.view
                                      holder:self];
}

-(void)controlPickerVisibity:(BOOL)visible{
    [UIView animateWithDuration:0.4 animations:^{
        if(visible){
            self.constraintPickerControl.constant = -1 * self.datePicker_.superview.frame.size.height;
            self.viewMask.alpha = 1;
            self.viewMask.userInteractionEnabled = YES;
        } else {
            self.constraintPickerControl.constant = 0;
            self.viewMask.alpha = 0;
            self.viewMask.userInteractionEnabled = NO;
        }
        
        [self.view layoutIfNeeded];
    }];
}

-(void)onButtonClicked{
    BOOL hidden = [self.imageWrapper q_visibleVertically:YES];
    [UIView animateWithDuration:0.6 animations:^{
        [self.imageWrapper q_setVisibility:!hidden isVertically:YES];
        
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.scrollView q_refreshContentView];
    }];
}

-(void)onDatePickerButtonClicked{
    [self controlPickerVisibity:YES];
}

-(void)onMaskTapped{
    [self controlPickerVisibity:NO];
}

-(void)onDoneButtonClicked{
    // other job should be done here.
    [self controlPickerVisibity:NO];
}
@end
