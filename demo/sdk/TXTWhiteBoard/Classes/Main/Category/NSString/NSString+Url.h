//
//  NSString+Url.h
//  KDIOSApp
//
//  Created by appleMac on 16/4/25.
//  Copyright © 2016年 KDIOSApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Url)

/*
 URL 字符串 里面可能包含某些字符，比如‘$‘ ‘&’ ‘？’...等，这些字符在 URL 语法中是具有特殊语法含义的，
 比如 URL ：http://www.baidu.com/s?wd=%BD%AA%C3%C8%D1%BF&rsv_bp=0&rsv_spt=3&inputT=3512
 中 的 & 起到分割作用 等等，如果 你提供的URL 本身就含有 这些字符，就需要把这些字符 转化为 “%+ASCII” 形式，以免造成冲突
 */
+ (NSString *)urlEscape:(NSString *)unencodedString;

/**
 *  判断url是不是有效的
 *
 *  @param str 要转换成url的string
 *
 *  @return 是否有效
 */
+ (BOOL)judgeString:(NSString *)str;

/**
 *  添加参数
 *
 *  @param url    url
 *  @param params 参数
 *
 *  @return 新的string
 */
+ (NSString *)addQueryStringToUrl:(NSString *)url params:(NSDictionary *)params;

/**
 *  获取url的host
 *
 *  @param tempStr url
 *
 *  @return host
 */
+ (NSString *)getSessionDomin:(NSString *)tempStr;

//进行urlEncode编码
- (NSString *)TXTURLEncodedString;

//过滤转义字符
- (NSString *)clearString:(NSString *)jsonString;


@end
