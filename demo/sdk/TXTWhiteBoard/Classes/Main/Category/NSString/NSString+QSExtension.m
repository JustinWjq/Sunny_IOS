//
//  NSString+QSExtension.m
//  BXInsurenceBroker
//
//  Created by JYJ on 16/2/23.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import "NSString+QSExtension.h"

@implementation NSString (QSExtension)

- (BOOL)validateContainsSpace {
    return [self rangeOfString:@" "].location == NSNotFound;
}


- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

/*手机号码验证 MODIFIED BY HELENSONG*/
- (BOOL)isValidateMobile {
    //手机号以13, 15, 17, 18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(16[0-9])|(17[0-9])|(18[0,0-9])|(19[0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:self];
}

+ (NSString *)stringWithMoneyAmountInChinese:(double)amount {
    if (amount < 10000) {
        return [NSString stringWithFormat:@"%g", amount];
    } else {
        // 在百位四舍五入，比如12356变成124
        amount = round(amount / 100.0);
        amount = amount / 100;
        return [NSString stringWithFormat:@"%g万", amount];
    }
}

- (NSString *)cl_document {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


/**
 * 隐藏手机号
 */
- (NSString *)hideInformation {
    static const NSInteger kVisibleLength = 4;
    if (self.length <= kVisibleLength) {
        return self;
    }
    NSInteger length = self.length - kVisibleLength * 2 + 1;
    NSMutableString *result = [self mutableCopy];
    for (NSInteger i = 0; i < length; i++) {
        [result replaceCharactersInRange:NSMakeRange(i + kVisibleLength - 1, 1) withString:@"*"];
    }
    return result;
}

/**
 * 隐藏手机号
 */
- (NSString *)newHidePhoneInformation {
    if (self.length <= 9) {
        return self;
    }
    NSMutableString *result = [self mutableCopy];
    [result replaceCharactersInRange:NSMakeRange(3, 6) withString:@"******"];
    return result;
}

/// 隐藏名字
- (NSString *)hideNameInfoWithLastName:(NSString *)lastName {
    NSInteger nameLength = self.length - lastName.length;
    NSString *newName = lastName;
    for (int i=0; i<nameLength; i++) {
        newName = [NSString stringWithFormat:@"%@*", newName];
    }
    return newName;
}

/// 隐藏名字
- (NSString *)newHideNameInfo {
    NSString *name = self;
    for (int i=0; i<name.length - 1; i++) {
        name = [name stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
    }
    return name;
}

// 检查字符串是否包含emoji
- (BOOL)containsEmoji
{
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
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
                            }];
    return returnValue;
}

- (NSString *)valueExchangeChines:(NSString *)value {
//    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
//    nf.numberStyle = kCFNumberFormatterRoundHalfDown;
//    NSString *str = [nf stringFromNumber:[NSNumber numberWithString:value]];
//    return str;
    NSString  *str = nil;
    if ([value isEqualToString:@"0"]) {
        str = @"零";
    } else if ([value isEqualToString:@"1"]) {
        str = @"一";
    } else if ([value isEqualToString:@"2"]) {
        str = @"二";
    } else if ([value isEqualToString:@"3"]) {
        str = @"三";
    } else if ([value isEqualToString:@"4"]) {
        str = @"四";
    } else if ([value isEqualToString:@"5"]) {
        str = @"五";
    } else if ([value isEqualToString:@"6"]) {
        str = @"六";
    } else if ([value isEqualToString:@"7"]) {
        str = @"七";
    } else if ([value isEqualToString:@"8"]) {
        str = @"八";
    } else if ([value isEqualToString:@"9"]) {
        str = @"九";
    } else if ([value isEqualToString:@"10"]) {
        str = @"十";
    }
    return str;
}

//数字逗号分隔
+ (NSString *)countNumAndChangeformat:(NSString *)num{
    int count = 0;
    long long int a = num.longLongValue;
    while (a != 0){
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:num];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    return newstring;
}


/**
 * 返回json字符串
 */
+ (NSString *)objectToJsonString:(id)object {
    NSString *jsonString = [[NSString alloc]init];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    
    if (!jsonData) {
        jsonString = @"";
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

+ (NSString *)convertDictToString:(id)dict {
    NSError *error;

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];

    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    } else {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }

    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};

    // 去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

+ (CGSize)stringSizeWithWidthString:(NSString *)string withWidthLimit:(CGFloat)width withFont:(UIFont *)font {
  CGSize maxSize = CGSizeMake(width, 2000);
//  UIFont *font =[UIFont systemFontOfSize:18];
  NSMutableParagraphStyle *paragraphStyle= [[NSMutableParagraphStyle alloc] init];
  CGSize realSize = [string boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
  return realSize;
}


// 搜索数据对应的路径
+ (NSString *)pathWithDocumentName:(NSString *)documentName {
    // 获取沙盒路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    // 拼接文件夹
    NSString *path = [documentDirectory stringByAppendingPathComponent:documentName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 判断文件夹是否存在
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

/**
 * 获取当前语言code
 */
+ (NSString *)getCurrentLocaleLanguageCode {
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLocaleLanguageCode = @"";
    if (languages.count > 0) {
         currentLocaleLanguageCode = languages.firstObject;
         if ([currentLocaleLanguageCode hasPrefix:@"en"]) {
             currentLocaleLanguageCode = @"en";
         } else if ([currentLocaleLanguageCode hasPrefix:@"zh"]) {
             currentLocaleLanguageCode = @"zh";
         } else {
             currentLocaleLanguageCode = @"zh";
         }
    } else {
        currentLocaleLanguageCode = @"zh";
    }
    return currentLocaleLanguageCode;
}

+ (BOOL)isChinese:(NSString *)str {
    for (int i=0; i< [str length];i++) {
        int a = [str characterAtIndex:i];
        if  (a > 0x4e00 && a < 0x9fff) {
            return YES;
        }
    }
    return NO;
}


+ (BOOL)isEmpty:(NSString *)str {
    if (!str) {
        return YES;
    } else {
        //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        if ([trimedString length] == 0) {
            return YES;
        } else {
            return NO;
        }
    }
}


@end
