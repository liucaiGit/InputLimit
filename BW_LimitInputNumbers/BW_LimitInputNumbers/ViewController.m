//
//  ViewController.m
//  BW_LimitInputNumbers
//
//  Created by liucai on 2018/9/25.
//  Copyright © 2018年 XiongBenWang. All rights reserved.
//

#import "ViewController.h"
#import "UITextView+Placeholder.h"
#import "BWTextView.h"
#import "BWTextField.h"

NSInteger maxTFNum = 30;

NSInteger maxTVNum = 30;

@interface ViewController ()<BWTextFieldDelegate,BWTextViewDelegate>

@property (nonatomic, strong) BWTextField *textField;//输入框

@property (nonatomic, strong) BWTextView *textView;//textView

@property (nonatomic, strong) UILabel *textFieldDescL;//

@property (nonatomic, strong) UILabel *textViewDescL;//

@property (nonatomic, strong) UILabel *showTFNumL;

@property (nonatomic, strong) UILabel *showTVNumL;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:229 / 255.f green:229 / 255.f blue:229 / 255.f alpha:1];
    //initUI
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - InitUI

- (void)initUI {
    [self.view addSubview:self.textFieldDescL];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.showTFNumL];
    
    [self.view addSubview:self.textViewDescL];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.showTVNumL];
}

# pragma mark - < BWTextFieldDelegate >

- (BOOL)bwTextFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (void)bwTextFieldDidBeginEditing:(UITextField *)textField {
    
}

- (BOOL)bwTextFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (void)bwTextFieldDidEndEditing:(UITextField *)textField {
    
}

- (BOOL)bwTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

- (BOOL)bwTextFieldShouldClear:(UITextField *)textField {
    return YES;
}

- (BOOL)bwTextFieldShouldReturn:(UITextField *)textField {
    return YES;
}

- (void)bwTextFieldDidChanged:(UITextField *)textField {
    //此处获取的是准确实时的输入内容 可用于剩余输入数量的提示
    NSInteger tfTextLenth = textField.text.length;
    self.showTFNumL.text = [NSString stringWithFormat:@"%li/%li",tfTextLenth,maxTFNum];
}


# pragma mark - < BWTextViewDelegate >

- (void)bwTextViewDidChanged:(UITextView *)textView {
    //此处获取的是准确实时的输入内容  可用于剩余输入数量的提示
    NSInteger tvTextLength = textView.text.length;
    self.showTVNumL.text = [NSString stringWithFormat:@"%li/%li",tvTextLength,maxTVNum];
}

- (BOOL)bwTextView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return YES;
}

- (void)bwTextViewDidEndEditing:(UITextView *)textView {
    
}

- (BOOL)bwTextViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}

- (void)bwTextViewDidBeginEditing:(UITextView *)textView {
    
}

- (BOOL)bwTextViewShouldEndEditing:(UITextView *)textView {
    return YES;
}

#pragma mark - Lazy load

- (BWTextField *)textField {
    if (!_textField) {
        _textField = [[BWTextField alloc] init];
        _textField.frame = CGRectMake(30.f, CGRectGetMaxY(self.textFieldDescL.frame) + 10, self.view.frame.size.width * 2.0 / 3, 100.f);
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.font = [UIFont systemFontOfSize:16];
        _textField.placeholder = @"这里是UITextField";
        _textField.tfDelegate = self;
        _textField.tfLimitNumber = maxTFNum;
        _textField.shouldForbidSystemEmoji = YES;
        _textField.returnKeyDone = YES;
    }
    return _textField;
}

- (BWTextView *)textView {
    if (!_textView) {
        _textView = [[BWTextView alloc] init];
        _textView.frame = CGRectMake(30.f, CGRectGetMaxY(self.textViewDescL.frame) + 10, self.view.frame.size.width * 2.0 / 3, 100);
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.showsVerticalScrollIndicator = YES;
        _textView.placeholder = @"这里是UITextView";
        _textView.tvDelegate = self;
        _textView.tvLimitNumber = maxTVNum;
        _textView.returnKeyDone = YES;
        _textView.shouldForbidSystemEmoji = YES;
    }
    return _textView;
}

- (UILabel *)textFieldDescL {
    if (!_textFieldDescL) {
        _textFieldDescL = [[UILabel alloc] initWithFrame:CGRectMake(12, 80.f, self.view.frame.size.width - 24, 30)];
        _textFieldDescL.textColor = [UIColor blackColor];
        _textFieldDescL.font = [UIFont systemFontOfSize:15];
        _textFieldDescL.text = @"这里是TextField";
    }
    return _textFieldDescL;
}

- (UILabel *)textViewDescL {
    if (!_textViewDescL) {
        _textViewDescL = [[UILabel alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(self.textField.frame) + 20, self.textFieldDescL.frame.size.width, 30)];
        _textViewDescL.textColor = [UIColor blackColor];
        _textViewDescL.font = [UIFont systemFontOfSize:15];
        _textViewDescL.text = @"这里是TextView";
    }
    return _textViewDescL;
}

- (UILabel *)showTFNumL {
    if (!_showTFNumL) {
        _showTFNumL = [[UILabel alloc] init];
        _showTFNumL.frame = CGRectMake(CGRectGetMaxX(self.textField.frame) + 10, CGRectGetMaxY(self.textField.frame) - 30, 60, 30);
        _showTFNumL.font = [UIFont systemFontOfSize:15];
        _showTFNumL.text = [NSString stringWithFormat:@"0/%li",maxTFNum];
    }
    return _showTFNumL;
}

- (UILabel *)showTVNumL {
    if (!_showTVNumL) {
        _showTVNumL = [[UILabel alloc] init];
        _showTVNumL.frame = CGRectMake(CGRectGetMaxX(self.textView.frame) + 10, CGRectGetMaxY(self.textView.frame) - 30, 60, 30);
        _showTVNumL.font = [UIFont systemFontOfSize:15];
        _showTVNumL.text = [NSString stringWithFormat:@"0/%li",maxTVNum];
    }
    return _showTVNumL;
}

@end
