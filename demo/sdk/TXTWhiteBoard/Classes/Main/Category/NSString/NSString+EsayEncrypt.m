//
//  NSString+EsayEncrypt.m
//  QSTaxi
//
//  Created by 高明亮 on 2019/11/29.
//  Copyright © 2019 gaomingliang. All rights reserved.
//

#import "NSString+EsayEncrypt.h"

#include <string.h>

#import <CommonCrypto/CommonDigest.h>

@implementation NSString (EsayEncrypt)
//奇偶互换
- (NSString *)stringWithOddEvenExchange {
    
    const char *constString = [self UTF8String];
    
    char *str = malloc(strlen(constString) + 1);
    strcpy(str, constString);
    
    long a = self.length - 1;
    
    for (long i = 0; i < a; i += 2) {
        char temp = *(str + i);
        *(str + i) = *(str + i + 1);
        *(str + i + 1) = temp;
    }
    NSString *changed = [NSString stringWithUTF8String:str];
    
    free(str);
    
    return changed;
}

//首部分交换

- (NSString *)stringWithFrontExchange:(NSUInteger)length {//length超过字符串的一半则返回空
    if (length > self.length / 2) {
        return nil;
    }
    
    NSRange front = NSMakeRange(0, length);
    NSRange back = NSMakeRange(length, length);
    
    NSString *frontStr = [self substringWithRange:front];
    NSString *backStr = [self substringWithRange:back];
    
    NSString *changed = [self stringByReplacingCharactersInRange:front withString:backStr];
    changed = [changed stringByReplacingCharactersInRange:back withString:frontStr];
    
    return changed;
    
}

//首尾互换
- (NSString *)stringWithFrontAndBackExchange:(NSUInteger)length { //length超过字符串的一半则返回空
    if (length > self.length / 2) {
        return nil;
    }
    NSRange front = NSMakeRange(0, length);
    NSRange back = NSMakeRange(self.length - length, length);
    
    NSString *frontStr = [self substringWithRange:front];
    NSString *backStr = [self substringWithRange:back];
    
    NSString *changed = [self stringByReplacingCharactersInRange:front withString:backStr];
    changed = [changed stringByReplacingCharactersInRange:back withString:frontStr];
    
    return changed;
}
//定长插值
- (NSString *)stringWithAddChars:(char *)chars stepLength:(NSUInteger)stepLength {
    const char *constString = [self UTF8String];
    
    NSUInteger maxlength = self.length + self.length / stepLength;
    
    char string[maxlength + 1]; //多个'\0'
    
    int sign = 0;
    int step = 0;
    for (int i = 0; i < self.length; i++) {
        if ((step + 1) % (stepLength + 1) == 0) {
            string[step++] = *(chars + (sign++ % strlen(chars)));
            i--;
        }else {
            string[step++] = *(constString + i);
        }
    }
    string[maxlength] = '\0';
    
    return [NSString stringWithUTF8String:string];
}
//MD5加密
- (NSString *)MD5 {
    const char *cStr = [self UTF8String];
    unsigned char digest[16];
    unsigned int x=(int)strlen(cStr) ;
    CC_MD5( cStr, x, digest );
    // This is the md5 call
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
}

@end
