//
//  BWTextField.h
//  BW_LimitInputNumbers
//
//  Created by liucai on 2018/12/8.
//  Copyright © 2018年 XiongBenWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BWTextFieldDelegate<NSObject>

- (BOOL)bwTextFieldShouldBeginEditing:(UITextField *)textField;

- (void)bwTextFieldDidBeginEditing:(UITextField *)textField;

- (BOOL)bwTextFieldShouldEndEditing:(UITextField *)textField;

- (void)bwTextFieldDidEndEditing:(UITextField *)textField;

- (BOOL)bwTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

- (BOOL)bwTextFieldShouldClear:(UITextField *)textField;

- (BOOL)bwTextFieldShouldReturn:(UITextField *)textField;

- (void)bwTextFieldDidChanged:(UITextField *)textField;

@end

@interface BWTextField : UITextField

@property (nonatomic, assign) NSInteger tfLimitNumber;//最大输入字数

@property (nonatomic, assign, getter=isForbidSystemEmoji) BOOL shouldForbidSystemEmoji;//是否禁止系统表情输入

@property (nonatomic, assign) BOOL returnKeyDone;//return键点击效果是否完成输入

@property (nonatomic, weak) id<BWTextFieldDelegate> tfDelegate;//自定义代理

@end
