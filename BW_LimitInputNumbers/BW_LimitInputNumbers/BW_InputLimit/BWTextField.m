//
//  BWTextField.m
//  BW_LimitInputNumbers
//
//  Created by liucai on 2018/12/8.
//  Copyright © 2018年 XiongBenWang. All rights reserved.
//

#import "BWTextField.h"

@interface BWTextField()<UITextFieldDelegate>

@end

@implementation BWTextField

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)setTfLimitNumber:(NSInteger)tfLimitNumber {
    _tfLimitNumber = tfLimitNumber;
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged) name:UITextFieldTextDidChangeNotification object:nil];
}

# pragma mark - < UITextFieldDelegate >

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (self.tfDelegate && [self.tfDelegate respondsToSelector:@selector(bwTextFieldShouldBeginEditing:)]) {
        return [self.tfDelegate bwTextFieldShouldBeginEditing:textField];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.delegate && [self.tfDelegate respondsToSelector:@selector(bwTextFieldDidBeginEditing:)]) {
        [self.tfDelegate bwTextFieldDidBeginEditing:textField];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (self.tfDelegate && [self.tfDelegate respondsToSelector:@selector(bwTextFieldShouldEndEditing:)]) {
        return [self.tfDelegate bwTextFieldShouldEndEditing:textField];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.tfDelegate && [self.tfDelegate respondsToSelector:@selector(bwTextFieldDidEndEditing:)]) {
        [self.tfDelegate bwTextFieldDidEndEditing:textField];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        if (self.returnKeyDone) {
            [textField resignFirstResponder];
            return NO;
        }
    }
    //不支持发送系统表情
    if ([[textField textInputMode] primaryLanguage] == nil || [[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"]) {
        if (self.isForbidSystemEmoji) {
            return NO;
        }
    }
    //最大限制数量小于0 则不做限制数量限制
    if (self.tfLimitNumber <= 0) {
        return YES;
    }
    //获取高亮部分
    UITextRange *markedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:markedRange.start offset:0];
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (markedRange && position) {
        NSInteger startOffset = [textField offsetFromPosition:textField.beginningOfDocument toPosition:markedRange.start];
        NSInteger endOffset = [textField offsetFromPosition:textField.beginningOfDocument toPosition:markedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        if (offsetRange.location < self.tfLimitNumber) {
            return YES;
        } else {
            return NO;
        }
    }
    return [self bwTextField:textField shouldChangeCharactersInRange:range replacementString:string];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.returnKeyDone) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

# pragma mark - Notification

- (void)textFieldDidChanged {
    //若限制数量小于等于0 则不对输入做限制
    if (self.tfLimitNumber <= 0) {
        //执行自定义代理方法
        [self bwTextFieldDidChanged:self];
        return;
    }
    NSString *lang = [[[UITextInputMode activeInputModes] firstObject] primaryLanguage];//当前的输入模式
    //获取高亮部分
    UITextRange *range = [self markedTextRange];
    UITextPosition *start = range.start;
    UITextPosition*end = range.end;
    NSInteger selectLength = [self offsetFromPosition:start toPosition:end];
    //存在高亮则不计算高度
    if (range && selectLength) {
        return;
    }
    if ([lang isEqualToString:@"zh-Hans"]) {
        NSInteger contentLength = self.text.length - selectLength;
        if (contentLength >= self.tfLimitNumber) {
            self.text = [self.text substringToIndex:self.tfLimitNumber];
            //文字数量超出最大限制数量
        }
    } else {
        if (self.text.length >= self.tfLimitNumber) {
            self.text = [self.text substringToIndex:self.tfLimitNumber];
            //文字数量超出最大限制数量
        }
    }
    //执行自定义代理方法
    [self bwTextFieldDidChanged:self];
}

# pragma mark - --

- (BOOL)bwTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.tfDelegate && [self.tfDelegate respondsToSelector:@selector(bwTextField:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.tfDelegate bwTextField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    return YES;
}

- (void)bwTextFieldDidChanged:(UITextField *)textField {
    if (self.tfDelegate && [self.tfDelegate respondsToSelector:@selector(bwTextFieldDidChanged:)]) {
        [self.tfDelegate bwTextFieldDidChanged:textField];
    }
}

@end
