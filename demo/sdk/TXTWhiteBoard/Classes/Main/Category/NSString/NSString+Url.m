//
//  NSString+Url.m
//  KDIOSApp
//
//  Created by appleMac on 16/4/25.
//  Copyright © 2016年 KDIOSApp. All rights reserved.
//

#import "NSString+Url.h"

@implementation NSString (Url)

+ (BOOL)judgeString:(NSString *)str
{
    if (str && ![str isKindOfClass:[NSNull class]] && [str isKindOfClass:[NSString class]] && str.length && ![str isEqualToString:@""]) {
        return YES;
    }else{
        return NO;
    }
}

/*
 URL 字符串 里面可能包含某些字符，比如‘$‘ ‘&’ ‘？’...等，这些字符在 URL 语法中是具有特殊语法含义的，
 比如 URL ：http://www.baidu.com/s?wd=%BD%AA%C3%C8%D1%BF&rsv_bp=0&rsv_spt=3&inputT=3512
 中 的 & 起到分割作用 等等，如果 你提供的URL 本身就含有 这些字符，就需要把这些字符 转化为 “%+ASCII” 形式，以免造成冲突
 */
+ (NSString *)urlEscape:(NSString *)unencodedString {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (CFStringRef)unencodedString,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                 kCFStringEncodingUTF8));
}

// 把传入的参数按照get的方式打包到url后面。
+ (NSString *)addQueryStringToUrl:(NSString *)url params:(NSDictionary *)params
{
    if (nil == url) {
        return @"";
    }
#ifdef  DEBUG
    //    NSString *localStr = [self getlocalURLTitle:url];
    //    NSString *updateStr = [self getlocalURLTitle:[[ConfigManage sharedConfig] getURLStringWithAliasName:@"getIndex"]];
    //    if (!localStr) {
    //
    //    } else if (![localStr isEqualToString:updateStr] && [url rangeOfString:@"config"].length < 1) {
    //        url = [url substringFromIndex:localStr.length];
    //        url = [updateStr stringByAppendingString:url];
    //    }
#endif
    
    NSMutableString *urlWithQuerystring = [[NSMutableString alloc] initWithString:url];
    
    
    
    // Convert the params into a query string
    if (params) {
        for(id key in params) {
            NSString *sKey = [key description];
            NSString *sVal = [[params objectForKey:key] description];
            //是否有？，必须处理这个
            if ([urlWithQuerystring rangeOfString:@"?"].location==NSNotFound) {
                [urlWithQuerystring appendFormat:@"?%@=%@", [NSString urlEscape:sKey], [NSString urlEscape:sVal]];
            } else {
                [urlWithQuerystring appendFormat:@"&%@=%@", [NSString urlEscape:sKey], [NSString urlEscape:sVal]];
            }
        }
    }
    
    return urlWithQuerystring;
}

+ (NSString *)getSessionDomin:(NSString *)tempStr
{
    if ([tempStr rangeOfString:@"pre-api.koudailc.com"].length > 1) {
        return @".koudailc.com";
    }
    if ([tempStr rangeOfString:@"api.koudailc.com"].length > 1) {
        return @".koudailc.com";
    }
    if ([NSURL URLWithString:tempStr].host) {
        return [NSURL URLWithString:tempStr].host;
    }
    return @"";
}

//进行urlEncode编码
- (NSString *)TXTURLEncodedString
{
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                                    (CFStringRef)self,
                                                                                                    (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                                                                    NULL,
                                                                                                    kCFStringEncodingUTF8));
    return encodedString;
}

//可能返回的数据中带转义字符 需要替换掉
- (NSString *)clearString:(NSString *)jsonString
{
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\v" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\f" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\b" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\a" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\e" withString:@""];
    return jsonString;
}
@end
