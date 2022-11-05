//
//  NSDate+extend.h
//  TextCustomServiceDemo
//
//  Created by lidashuang on 2017/3/15.
//  Copyright © 2017年 lidashuang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SecPerDay                                   86400.0
#define SecPerHour                                  3600.0
#define MinPerHour                                  60.0
#define SecPerMin                                   MinPerHour
#define DayForTimeInterval(_time)                   floor((_time) / SecPerDay)
#define HourForTimeInterval(_time)                  floor((_time) / SecPerHour)
#define MinForTimeInterval(_time)                   floor((_time) / SecPerMin)

@interface NSDate (extend)

/**
 比较两个时间是否为同一分钟内

 @param date 比较的时间
 @return 返回布尔值
 */
- (BOOL)isSameMin:(NSDate *)date;


/**
  比较两个时间是否为同一小时

 @param date 比较的时间
 @return 返回布尔值
 */
- (BOOL)isSameHour:(NSDate *)date;


/**
  比较两个时间是否为同一天

 @param date  比较的时间
 @return 返回布尔值
 */
- (BOOL)isSameDay:(NSDate *)date;


/**
 时间是否为当前分钟

 @return 返回布尔值
 */
- (BOOL)isToMin;


/**
 时间是否为当前小时

 @return 返回布尔值
 */
- (BOOL)isToHour;


/**
 时间是否为今天

 @return 返回布尔值
 */
- (BOOL)isToday;

- (NSString *)getUTCFormateDate:(NSDate *)newsDate;


/**
 时间戳转换日期格式字符串
 @parms timeStr  时间戳字符串
 @return 日期字符串
 */
+(NSString*)getTimeStampToDStringValue:(NSString*)timeStr;
/**
 时间戳转换日期格式字符串
 @parms timeStr  时间戳字符串
 @parms format  日期格式
 @return 日期字符串
 */
+(NSString*)getTimeStampToDStringValue:(NSString*)timeStr format:(NSString*)format;
/**
 时间戳转换日期格式字符串
 @parms timeStr  时间戳字符串
 @parms area  区域
 @return 日期字符串
 */
+(NSString*)getTimeStampToDStringValue:(NSString*)timeStr area:(NSString*)area;
/**
 时间戳转换日期格式字符串
 @parms timeStr  时间戳字符串
 @parms format  日期格式
 @parms area  区域
 @return 日期字符串
 */
+(NSString*)getTimeStampToDStringValue:(NSString*)timeStr format:(NSString*)format area:(NSString*)area;




/**
 日期字符串转换日期格式
 @parms timeStr  日期字符串
 @return 日期
 */
+(NSDate*)getStringToDateValue:(NSString*)timeStr;
/**
 日期字符串转换日期格式
 @parms timeStr  日期字符串
 @parms format  日期格式
 @return 日期
 */
+(NSDate*)getStringToDateValue:(NSString*)timeStr format:(NSString*)format;
/**
 日期字符串转换日期格式
 @parms timeStr  日期字符串
 @parms area  区域
 @return 日期
 */
+(NSDate*)getStringToDateValue:(NSString*)timeStr area:(NSString*)area;
/**
 日期字符串转换日期格式
 @parms timeStr  日期字符串
 @parms format  日期格式
 @parms area  区域
 @return 日期
 */
+(NSDate*)getStringToDateValue:(NSString*)timeStr format:(NSString*)format area:(NSString*)area;

/**
 日期字符串转换时间戳字符串
 
 @param date 日期
 @return 时间戳
 */
+(NSString*)geDStringToTimeStampValue:(NSDate*)date;


//时间区域转换
+(NSDate*)aa:(NSDate*)date;
+(NSDate*)aa:(NSDate*)date format:(NSString*)format;

//日期转字符串
+(NSString*)getDateToString:(NSDate*)date;
+(NSString*)getDateToString:(NSDate*)date format:(NSString*)format;
+(NSString*)getDateToString:(NSDate*)date area:(NSString*)area;
+(NSString*)getDateToString:(NSDate*)date format:(NSString*)format area:(NSString*)area;

@end
