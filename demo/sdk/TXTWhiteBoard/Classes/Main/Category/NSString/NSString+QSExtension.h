//
//  NSString+YLExtension.h
//  BXInsurenceBroker
//
//  Created by JYJ on 16/2/23.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (QSExtension)

/**
 * 判断字段是否包含空格
 */
- (BOOL)validateContainsSpace;


/**
 *  返回字符串所占用的尺寸
 *
 *  @param font    字体
 *  @param maxSize 最大尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;


/**
 *手机号码验证 MODIFIED BY HELENSONG
 */
- (BOOL)isValidateMobile;

/**
 *  将数字转换成xx万
 */
+ (NSString *)stringWithMoneyAmountInChinese:(double)amount;

/**
 * 沙盒路径
 */
- (NSString *)cl_document;


// 隐藏信息
- (NSString *)hideInformation;
/**
 * 隐藏手机号
 */
- (NSString *)newHidePhoneInformation;
/// 隐藏名字
- (NSString *)hideNameInfoWithLastName:(NSString *)lastName;
/// 隐藏名字
- (NSString *)newHideNameInfo;

// 检查字符串是否包含emoji表情
- (BOOL)containsEmoji;

- (NSString *)valueExchangeChines:(NSString *)value;

//数字逗号分隔
+ (NSString *)countNumAndChangeformat:(NSString *)num;


/**
 * 返回json字符串
 */
+ (NSString *)objectToJsonString:(id)object;
/**
* 返回json字符串
*/
+ (NSString *)convertDictToString:(id)dict;

// 获取文字宽高
+ (CGSize)stringSizeWithWidthString:(NSString *)string withWidthLimit:(CGFloat)width withFont:(UIFont *)font;

// 搜索数据对应的路径
+ (NSString *)pathWithDocumentName:(NSString *)documentName;

/**
 * 获取当前语言code
 */
+ (NSString *)getCurrentLocaleLanguageCode;


/// 是否含有中文
+ (BOOL)isChinese:(NSString *)str;
/// 是否为空，或者全是空格
+ (BOOL)isEmpty:(NSString *)str;

@end
