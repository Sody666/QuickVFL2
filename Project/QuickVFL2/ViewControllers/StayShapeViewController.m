//
//  StayShapeViewController.m
//  QuickVFL2
//
//  Created by 苏第 on 17/11/8.
//  Copyright © 2017年 Quick. All rights reserved.
//

#import "StayShapeViewController.h"

@interface StayShapeViewController ()
@property (nonatomic, weak) UILabel* label1;
@property (nonatomic, weak) UILabel* label2;
@property (nonatomic, weak) UITextField* textField1;
@property (nonatomic, weak) UITextField* textField2;
@end

@implementation StayShapeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Keep View in Good Shape";
    
    self.textField1.placeholder = @"Keep inputing text for label 1";
    self.textField2.placeholder = @"Keep inputing text for label 2";
    
    self.textField1.borderStyle = UITextBorderStyleRoundedRect;
    self.textField2.borderStyle = UITextBorderStyleRoundedRect;
    
    self.label1.backgroundColor = [UIColor orangeColor];
    self.label2.backgroundColor = [UIColor orangeColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onTextChangedForTextField:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.textField1];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onTextChangedForTextField:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.textField2];
    
    
    UILabel* hardLabel = [self.layoutResult viewNamed:@"labelHard1_"];
    hardLabel.text = @"Lasting Text";
    hardLabel.backgroundColor = [UIColor grayColor];
    
    
    hardLabel = [self.layoutResult viewNamed:@"labelHard2_"];
    hardLabel.text = @"Lasting Text";
    hardLabel.backgroundColor = [UIColor grayColor];
}

-(QLayoutResult*)layout{
    return [QLayoutManager layoutForFileName:@"StayShapeViewController.json"
                                    entrance:self.view
                                      holder:self];
}

-(void)onTextChangedForTextField:(NSNotification*)notification{
    UITextField* sender = notification.object;
    if(sender == self.textField1){
        self.label1.text = sender.text;
    } else{
        self.label2.text = sender.text;
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
