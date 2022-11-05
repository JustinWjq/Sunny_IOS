//
//  NSString+extend.h
//  ChinaBus
//
//  Created by 李大双 on 2018/8/16.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (extend)

+(CGSize) boundingRectWithSize:(NSString*) txt Font:(UIFont*) font Size:(CGSize) size;

//身份证号
+ (BOOL)CheckIsIdentityCard: (NSString *)identityCard;
// 获取URL中的参数
+ (NSMutableDictionary *)getURLParameters:(NSString *)urlStr;

//传入参数与url，拼接为一个带参数的url
+(NSString *)connectUrlParams:(NSMutableDictionary *)params url:(NSString *) urlLink;
//中间四位星号
+ (NSString *)machPhoneNumWithAster:(NSString *)phoneNum;
//判断是否为手机号
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
//判断字符串是否同时包含子母和数字
+ (BOOL)containBothCharacterAndNumWith:(NSString *)str;
//去非法字符
- (NSString *)xm_trim;
- (NSString *)xm_trimAll;
- (NSString *)xm_convertReturn;

-(NSString *)fineNumFromeStr;

+(NSString *)AES128Encrypt:(NSString *)str key:(NSString *)key;

+ (NSString *)stringToMD5:(NSString *)str;

+ (NSString *)newsShowTime:(SInt64)time;
- (instancetype)initWithDateFormat:(nullable NSString *)dateFormat;
@end
