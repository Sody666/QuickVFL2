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
@property (nonatomic, weak) UIImageView* imageViewRotate;
@property (nonatomic, weak) UIDatePicker* datePicker_;
@property (nonatomic, weak) UIView* viewMask;
@property (nonatomic, weak) UIButton* confirmButtonShadow;
@property (nonatomic, weak) UILabel* labelDelete;
@property (nonatomic, weak) UIView* informationWrapper_;
@end

@implementation AnimationViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"Animation Demo";
    
    self.imageView.image = [UIImage imageNamed:@"image1.jpeg"];
    self.imageViewRotate.image = [UIImage imageNamed:@"image1.jpeg"];
    
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
            self.datePicker_.superview.transform = CGAffineTransformMakeTranslation(0, -1 * self.datePicker_.superview.frame.size.height);
            self.viewMask.alpha = 1;
            self.viewMask.userInteractionEnabled = YES;
        } else {
            self.datePicker_.superview.transform = CGAffineTransformIdentity;
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

-(void)onRotateButtonClicked:(UIButton*)sender {
    CABasicAnimation* animation = [CABasicAnimation new];
    animation.keyPath = @"transform.rotation.z";
    animation.toValue = @(M_PI*2);
    animation.duration = 3;
    
    animation.repeatCount = INFINITY;
    animation.fillMode = kCAFillModeForwards;
    [self.imageViewRotate.layer addAnimation:animation forKey:@"rotate"];
    sender.enabled = NO;
}

-(void)toggleDeleteState{
    static BOOL deleting = NO;
    [UIView animateWithDuration:0.4 animations:^{
        if(deleting == NO){
            self.informationWrapper_.transform = CGAffineTransformMakeTranslation(-1*self.confirmButtonShadow.frame.size.width, 0);
            self.labelDelete.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
        }else{
            self.informationWrapper_.transform = CGAffineTransformIdentity;
            self.labelDelete.transform = CGAffineTransformIdentity;
        }
        
        deleting = !deleting;
    } completion:^(BOOL finished) {
        if(finished){
            self.confirmButtonShadow.userInteractionEnabled = deleting;
        }
    }];
}

-(void)onDeleteConfirm{
    // do delete job here.
    [self toggleDeleteState];
}

-(void)onDelete{
    [self toggleDeleteState];
}
@end
