//
//  BWLimitTextView.m
//  BW_LimitInputNumbers
//
//  Created by liucai on 2018/12/8.
//  Copyright © 2018年 XiongBenWang. All rights reserved.
//

#import "BWTextView.h"

@interface BWTextView()<UITextViewDelegate>

@end

@implementation BWTextView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)setReturnKeyDone:(BOOL)returnKeyDone {
    if (returnKeyDone) {
        self.returnKeyType = UIReturnKeyDone;
    }
}

# pragma mark - < UITextViewDelegate >

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (self.tvDelegate && [self.tvDelegate respondsToSelector:@selector(bwTextViewShouldEndEditing:)]) {
        return [self.tvDelegate bwTextViewShouldEndEditing:textView];
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (self.tvDelegate && [self.tvDelegate respondsToSelector:@selector(bwTextViewShouldBeginEditing:)]) {
        return [self.tvDelegate bwTextViewShouldBeginEditing:textView];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (self.tvDelegate && [self.tvDelegate respondsToSelector:@selector(bwTextViewDidBeginEditing:)]) {
        [self.tvDelegate bwTextViewDidBeginEditing:textView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (self.tvDelegate && [self.tvDelegate respondsToSelector:@selector(bwTextViewDidEndEditing:)]) {
        [self.tvDelegate bwTextViewDidEndEditing:textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if (self.returnKeyDone) {
            [textView resignFirstResponder];
            return NO;
        }
    }
    //不支持发送系统表情
    if ([[textView textInputMode] primaryLanguage] == nil || [[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"]) {
        if (self.isForbidSystemEmoji) {
            return NO;
        }
    }
    //最大限制数量小于0 则不做限制数量限制
    if (self.tvLimitNumber <= 0) {
        return YES;
    }
    //获取高亮部分
    UITextRange *markedRange = [textView markedTextRange];
    UITextPosition *position = [textView positionFromPosition:markedRange.start offset:0];
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (markedRange && position) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:markedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:markedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        if (offsetRange.location < self.tvLimitNumber) {
            return YES;
        } else {
            return NO;
        }
    }
    return [self bwTextView:textView shouldChangeTextInRange:range replacementText:text];
}

- (void)textViewDidChange:(UITextView *)textView {
    //若限制数量小于等于0 则不对输入做限制
    if (self.tvLimitNumber <= 0) {
        //执行自定义代理方法
        [self textViewValueDidChanged:textView];
        return;
    }
    NSString *lang = [[[UITextInputMode activeInputModes] firstObject] primaryLanguage];//当前的输入模式
    //获取高亮部分
    UITextRange *range = [textView markedTextRange];
    UITextPosition *start = range.start;
    UITextPosition*end = range.end;
    NSInteger selectLength = [textView offsetFromPosition:start toPosition:end];
    //存在高亮则不计算高度
    if (range && selectLength) {
        return;
    }
    if ([lang isEqualToString:@"zh-Hans"]) {
        NSInteger contentLength = textView.text.length - selectLength;
        if (contentLength >= self.tvLimitNumber) {
            textView.text = [textView.text substringToIndex:self.tvLimitNumber];
            //文字数量超出最大限制数量
        }
    } else {
        if (textView.text.length >= self.tvLimitNumber) {
            textView.text = [textView.text substringToIndex:self.tvLimitNumber];
            //文字数量超出最大限制数量
        }
    }
    //执行自定义代理方法
    [self textViewValueDidChanged:textView];
}

# pragma mark - --

- (void)textViewValueDidChanged:(UITextView *)textView {
    if (self.tvDelegate && [self.tvDelegate respondsToSelector:@selector(bwTextViewDidChanged:)]) {
        [self.tvDelegate bwTextViewDidChanged:textView];
    }
}

- (BOOL)bwTextView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (self.tvDelegate && [self.tvDelegate respondsToSelector:@selector(bwTextView:shouldChangeTextInRange:replacementText:)]) {
        return [self.tvDelegate bwTextView:textView shouldChangeTextInRange:range replacementText:text];
    }
    return YES;
}

@end
