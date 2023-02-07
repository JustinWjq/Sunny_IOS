//
//  NSString+Emoji.h
//  黑马微博
//
//  Created by MJ Lee on 14/7/12.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Emoji)
/**
 *  将十六进制的编码转为emoji字符
 */
+ (NSString *)emojiWithIntCode:(int)intCode;

/**
 *  将十六进制的编码转为emoji字符
 */
+ (NSString *)emojiWithStringCode:(NSString *)stringCode;

///普通字符串转换为十六进制的。
+ (NSString *)hexStringFromString:(NSString *)string;
/**
 *  是否为emoji字符
 */
- (BOOL)isEmoji;



//截取字符前多少位，处理emoji表情问题
////🐒🐒🐒🐒 + 截取3 = 🐒🐒🐒
+ (NSString *)subStringWithEmoji:(NSString *)emojiString
                     limitLength:(NSInteger)limitLength;

+ (NSString *)subStrWithStr:(NSString *)str fromIndex:(NSInteger)index;
@end
