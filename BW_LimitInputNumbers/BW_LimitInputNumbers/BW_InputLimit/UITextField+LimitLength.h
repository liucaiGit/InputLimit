//
//  UITextField+LimitLength.h
//  BW_LimitInputNumbers
//
//  Created by liucai on 2018/9/25.
//  Copyright © 2018年 XiongBenWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (LimitLength)

@property (nonatomic, copy) NSNumber *maxLength;//最大输入字数（优先）

@property (nonatomic, copy) NSNumber *maxCharLength;//最大输入字符长度

@end
