//
//  NSString+Category.m
//  BW_LimitInputNumbers
//
//  Created by liucai on 2018/9/25.
//  Copyright © 2018年 XiongBenWang. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (Category)

- (NSInteger)getStringLengthOfBytes {
    NSInteger lengthOfString = 0;
    for (int i = 0; i < self.length; i++) {
        //获取每个位置上的字符串
        NSString *subString = [self substringWithRange:NSMakeRange(i, 1)];
        //检测是否为中文或者中文符号--中文为两个字符长度 英文为一个字符长度
        if ([self validateChineseChar:subString]) {
            lengthOfString += 2;
        } else {
            lengthOfString += 1;
        }
    }
    return lengthOfString;
}

- (NSString *)subBytesOfStringToIndex:(NSInteger)index {
    NSInteger length = 0;//总长度
    NSInteger chineseLength = 0;//中文长度
    NSInteger charLength = 0;//字符长度
    //截取每个位置上的字符串
    for (int i = 0; i < self.length; i++) {
        NSString *subString = [self substringWithRange:NSMakeRange(i, 1)];
        if ([self validateChinese:subString]) {
            if (length + 2 > index) {
                return [self substringToIndex:(chineseLength + charLength)];
            }
            length += 2;
            chineseLength += 1;
        } else {
            if (length + 1 > index) {
                return [self substringToIndex:(chineseLength + charLength)];
            }
            length += 1;
            charLength += 1;
        }
    }
    return [self substringToIndex:index];
}

#pragma mark - Private Methods

/**
 *  检测中文或者中文符号
 */
- (BOOL)validateChineseChar:(NSString *)string
{
    NSString *nameRegEx = @"[\\u0391-\\uFFE5]";
    if (![string isMatchesRegularExp:nameRegEx]) {
        return NO;
    }
    return YES;
}

/**
 *  检测中文
 */
- (BOOL)validateChinese:(NSString*)string
{
    NSString *nameRegEx = @"[\u4e00-\u9fa5]";
    if (![string isMatchesRegularExp:nameRegEx]) {
        return NO;
    }
    return YES;
}

- (BOOL)isMatchesRegularExp:(NSString *)regex {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

@end
