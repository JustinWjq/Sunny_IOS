//
//  NSDate+Extension.h
//  Weibo11
//
//  Created by JYJ on 15/12/12.
//  Copyright © 2015年 itheima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSDate (Extension)

/// 日期描述字符串
///
/// 格式如下
///     -   刚刚(一分钟内)
///     -   X分钟前(一小时内)
///     -   X小时前(当天)
///     -   昨天 HH:mm(昨天)
///     -   MM-dd HH:mm(一年内)
///     -   yyyy-MM-dd HH:mm(更早期)
- (NSString *)ff_dateDescription;

/**
 *  是否为今年
 */
- (BOOL)isThisYear;

/**
 * 是否是明天
 */
- (BOOL)isTomorrow;

/**
 *  获得与当前时间的差距
 */
- (NSDateComponents *)deltaWithNow;
/**
 * 比较from和self的时间差值
 */
- (NSDateComponents *)deltaFrom:(NSDate *)from;


+(long ) gk_now;
+(long long) gk_now64;

-(NSString *) FORMAT_YMDHMS;
-(NSString *) FORMAT_YMD;


+ (NSString *)fullTimeString;

//标准：YYYY-MM-dd HH:mm
+(NSString *)custom_YMDHM:(long long) seconds;

//标准：MM-dd HH:mm
+(NSString *)custom_MDHM:(long long) seconds;

//标准：MM/dd
+(NSString *)custom_MD:(long long) seconds;

//标准：YYYY-MM-dd HH:mm:ss
+(NSString *)custom_YMDHMS:(long long) seconds;


//标准：YYYY-MM-dd
+(NSString *)custom_YMD:(long long) seconds;

+ (NSString *)recentlyTimeStringWithTimeline:(long long)timeline;
- (NSString *)recentlyTimeString;

//消息列表时间现实
+ (NSString *)listTimeStringWithTimeline:(long long)timeline;
- (NSString *)listTimeString;
//消息详情时间现实
+ (NSString *)detailTimeStringWithTimeline:(long long)timeline;
- (NSString *)detailTimeString;

// 根据NSDate获取星期几
- (NSString *)getDateAndWeek:(NSDate *)now;

@end
