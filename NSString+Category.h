//
//  NSString+Category.h
//  BW_LimitInputNumbers
//
//  Created by liucai on 2018/9/25.
//  Copyright © 2018年 XiongBenWang. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  检测&获取 字符串中字符长度
 */
@interface NSString (Category)

/**
 *  获取字符串中字符长度
 */
- (NSInteger)getStringLengthOfBytes;

/**
 *  截取指定长度的字符串
 */
- (NSString *)subBytesOfStringToIndex:(NSInteger)index;

@end
