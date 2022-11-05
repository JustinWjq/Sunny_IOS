//
//  NSString+EsayEncrypt.h
//  QSTaxi
//
//  Created by 高明亮 on 2019/11/29.
//  Copyright © 2019 gaomingliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (EsayEncrypt)
//奇偶互换
- (NSString *)stringWithOddEvenExchange;
//首部分交换
- (NSString *)stringWithFrontExchange:(NSUInteger)length ;
//首尾互换
- (NSString *)stringWithFrontAndBackExchange:(NSUInteger)length;//length不能超过字符串长度的一半
//定长插值
- (NSString *)stringWithAddChars:(char *)chars stepLength:(NSUInteger)stepLength;//每次从数组chars里循环取值插入
//MD5加密
- (NSString *)MD5;

@end


