//
//  BWLimitTextView.h
//  BW_LimitInputNumbers
//
//  Created by liucai on 2018/12/8.
//  Copyright © 2018年 XiongBenWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BWTextView;

@protocol BWTextViewDelegate<NSObject>
@optional;
- (void)bwTextViewDidChanged:(UITextView *)textView;

- (BOOL)bwTextView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

- (BOOL)bwTextViewShouldBeginEditing:(UITextView *)textView;

- (BOOL)bwTextViewShouldEndEditing:(UITextView *)textView;

- (void)bwTextViewDidBeginEditing:(UITextView *)textView;

- (void)bwTextViewDidEndEditing:(UITextView *)textView;

@end

@interface BWTextView : UITextView

@property (nonatomic, assign) NSInteger tvLimitNumber;//最大输入字数

@property (nonatomic, assign, getter=isForbidSystemEmoji) BOOL shouldForbidSystemEmoji;//是否禁止系统表情输入

@property (nonatomic, assign) BOOL returnKeyDone;//return键点击效果是否完成输入

@property (nonatomic, weak) id<BWTextViewDelegate> tvDelegate;//自定义代理方法

@end
