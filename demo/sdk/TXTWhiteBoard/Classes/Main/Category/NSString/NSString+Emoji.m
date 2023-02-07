//
//  NSString+Emoji.m
//  黑马微博
//
//  Created by MJ Lee on 14/7/12.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "NSString+Emoji.h"
#define EmojiCodeToSymbol(c) ((((0x808080F0 | (c & 0x3F000) >> 4) | (c & 0xFC0) << 10) | (c & 0x1C0000) << 18) | (c & 0x3F) << 24)

@implementation NSString (Emoji)

+ (NSString *)emojiWithIntCode:(int)intCode {
    int symbol = EmojiCodeToSymbol(intCode);
    NSString *string = [[NSString alloc] initWithBytes:&symbol length:sizeof(symbol) encoding:NSUTF8StringEncoding];
    if (string == nil) { // 新版Emoji
        string = [NSString stringWithFormat:@"%C", (unichar)intCode];
    }
    return string;
}

+ (NSString *)emojiWithStringCode:(NSString *)stringCode
{
    char *charCode = (char *)stringCode.UTF8String;
    int intCode = strtol(charCode, NULL, 16);
    return [self emojiWithIntCode:intCode];
}

// 判断是否是 emoji表情
- (BOOL)isEmoji
{
     BOOL returnValue = NO;
         
     const unichar hs = [self characterAtIndex:0];
     // surrogate pair
     if (0xd800 <= hs && hs <= 0xdbff) {
         if (self.length > 1) {
             const unichar ls = [self characterAtIndex:1];
             const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
             if (0x1d000 <= uc && uc <= 0x1f77f) {
                 returnValue = YES;
             }
         }
     } else if (self.length > 1) {
         const unichar ls = [self characterAtIndex:1];
         if (ls == 0x20e3) {
             returnValue = YES;
         }
     } else {
         // non surrogate
         if (0x2100 <= hs && hs <= 0x27ff) {
             returnValue = YES;
         } else if (0x2B05 <= hs && hs <= 0x2b07) {
             returnValue = YES;
         } else if (0x2934 <= hs && hs <= 0x2935) {
             returnValue = YES;
         } else if (0x3297 <= hs && hs <= 0x3299) {
             returnValue = YES;
         } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
             returnValue = YES;
         }
     }
    
    return returnValue;
}

///普通字符串转换为十六进制的。
+ (NSString *)hexStringFromString:(NSString *)string {
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr = @"";
    for(int i=0; i<[myD length]; i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if ([newHexStr length] == 1) {
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        } else {
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
        }
    }
    return hexStr;
}



//截取字符前多少位，处理emoji表情问题
////🐒🐒🐒🐒 + 截取3 = 🐒🐒🐒
+ (NSString *)subStringWithEmoji:(NSString *)emojiString
                    limitLength:(NSInteger)limitLength {
    if (emojiString.length < limitLength) return emojiString;
    
    @autoreleasepool {
        NSString * subStr = emojiString;
        NSRange  range;
        NSInteger index = 0;
        for(int i=0; i< emojiString.length; i += range.length){
            range = [emojiString rangeOfComposedCharacterSequenceAtIndex:i];
            NSString * charrrr = [emojiString substringToIndex:range.location + range.length];
            index ++;
            if(index == limitLength){
                subStr = charrrr;
                break;
            }
        }
        return subStr;
    }
}

+ (NSString *)subStrWithStr:(NSString *)str fromIndex:(NSInteger)index {
    NSString *res = str;
    if (res.length > index) {
        NSRange rangIndex = [res rangeOfComposedCharacterSequenceAtIndex:index];
        res = [res substringFromIndex:(rangIndex.location)];
    }
    return res;
}
@end
