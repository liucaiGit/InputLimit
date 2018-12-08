//
//  UITextView+LimitLength.m
//  BW_LimitInputNumbers
//
//  Created by liucai on 2018/9/25.
//  Copyright © 2018年 XiongBenWang. All rights reserved.
//

#import "UITextView+LimitLength.h"
#import <objc/runtime.h>
#import "NSString+Category.h"

static const void *textViewMaxLength = &textViewMaxLength;

static const void *textViewMaxCharLength = &textViewMaxCharLength;

@implementation UITextView (LimitLength)
- (void)setMaxCharLength:(NSNumber *)maxCharLength {
    objc_setAssociatedObject(self, textViewMaxCharLength, maxCharLength, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [self addTextCharDidChagedNotification];
}

- (NSNumber *)maxCharLength {
    return objc_getAssociatedObject(self, textViewMaxCharLength);
}

- (void)setMaxLength:(NSNumber *)maxLength {
    objc_setAssociatedObject(self, textViewMaxLength, maxLength, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [self addTexDidChangedNotification];
}

- (NSNumber *)maxLength {
    return objc_getAssociatedObject(self, textViewMaxLength);
}

//增加输入字符的监听
- (void)addTexDidChangedNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged) name:UITextViewTextDidChangeNotification object:nil];
}

//增加字符个数的监听
- (void)addTextCharDidChagedNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextCharDidChanged) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)textFieldDidChanged {
    if (self.maxLength.integerValue <= 0) return;
    NSString *textString = self.text;
    //获取当前键盘输入模式
    NSString *keyboardLanguage = [[self textInputMode] primaryLanguage];
    if ([keyboardLanguage isEqualToString:@"zh-Hans"]) {
        //简体中文模式输入
        UITextRange *range = [self markedTextRange];
        UITextPosition *start = range.start;
        UITextPosition*end = range.end;
        NSInteger selectLength = [self offsetFromPosition:start toPosition:end];
        NSInteger contentLength = self.text.length - selectLength;
        if (contentLength > self.maxLength.integerValue) {
            self.text = [self.text substringToIndex:self.maxLength.integerValue];
        }
    } else {
        if (self.text.length > self.maxLength.integerValue) {
            self.text = [textString substringToIndex:self.maxLength.integerValue];
        }
    }
}

- (void)textFieldTextCharDidChanged {
    if (self.maxCharLength.integerValue <= 0 || self.maxLength.integerValue > 0) return;
    NSString *textString = self.text;
    //获取当前键盘输入模式
    NSString *keyboardLanguage = [[self textInputMode] primaryLanguage];
    if ([keyboardLanguage isEqualToString:@"zh-Hans"]) {
        //简体中文输入模式下获取高亮部分
        //判断markedTextRange是不是为Nil，如果为Nil的话就说明你现在没有未选中的字符，
        //可以计算文字长度。否则此时计算出来的字符长度可能不正确
        UITextRange *markedRange = [self markedTextRange];
        UITextPosition *position = [self positionFromPosition:markedRange.start offset:0];
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if ([textString getStringLengthOfBytes] > self.maxCharLength.integerValue) {
                self.text = [textString subBytesOfStringToIndex:self.maxCharLength.integerValue];
            }
        }
    } else {
        if ([textString getStringLengthOfBytes] > self.maxCharLength.integerValue) {
            self.text = [textString subBytesOfStringToIndex:self.maxCharLength.integerValue];
        }
    }
}

@end
