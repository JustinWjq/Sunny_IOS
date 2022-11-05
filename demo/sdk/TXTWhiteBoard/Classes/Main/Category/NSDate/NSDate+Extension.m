//
//  NSDate+Extension.m
//  Weibo11
//
//  Created by JYJ on 15/12/12.
//  Copyright © 2015年 itheima. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

- (NSString *)ff_dateDescription {
    
    // 1. 获取当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 2. 判断是否是今天
    if ([calendar isDateInToday:self]) {
        
        NSInteger interval = ABS((NSInteger)[self timeIntervalSinceNow]);

        if (interval < 60) {
            return @"刚刚";
        }
        interval /= 60;
        if (interval < 60) {
            return [NSString stringWithFormat:@"%zd 分钟前", interval];
        }
        
        return [NSString stringWithFormat:@"%zd 小时前", interval / 60];
    }
    
    // 3. 昨天
    NSMutableString *formatString = [NSMutableString stringWithString:@" HH:mm"];
    if ([calendar isDateInYesterday:self]) {
        [formatString insertString:@"昨天" atIndex:0];
    } else {
        [formatString insertString:@"MM-dd" atIndex:0];
        
        // 4. 是否当年
        NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:self toDate:[NSDate date] options:0];

        if (components.year != 0) {
            [formatString insertString:@"yyyy-" atIndex:0];
        }
    }

    // 5. 转换格式字符串
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [NSLocale localeWithLocaleIdentifier:@"en"];
    fmt.dateFormat = formatString;
    
    return [fmt stringFromDate:self];
}

/**
 *  是否为今年
 */
- (BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return nowCmps.year == selfCmps.year;
}

/**
 * 是否是明天
 */
- (BOOL)isTomorrow {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    // 获得只有年月日的时间
    NSString *nowString = [fmt stringFromDate:[NSDate date]];
    NSDate *nowDate = [fmt dateFromString:nowString];
    
    NSString *selfString = [fmt stringFromDate:self];
    NSDate *selfDate = [fmt dateFromString:selfString];
    
    // 比较
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    
    NSDateComponents *cmps = [calendar components:unit fromDate:selfDate toDate:nowDate options:0];
    
    return cmps.year == 0
    && cmps.month == 0
    && cmps.day == -1;
}

- (NSDateComponents *)deltaWithNow
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unit fromDate:self toDate:[NSDate date] options:0];
}

- (NSDateComponents *)deltaFrom:(NSDate *)from
{
    // 日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 比较时间
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    return [calendar components:unit fromDate:from toDate:self options:0];
}


+(long) gk_now;
{
    return (long)[[NSDate date] timeIntervalSince1970];
}

+(long long) gk_now64;
{
    return (long long)([[NSDate date] timeIntervalSince1970] * 1000);
}

static NSDateFormatter *DefaultFormatterYMDHMSSS = nil;//YYYY-MM-dd HH:mm:ss.SSS
static NSDateFormatter *DefaultFormatterYMDHMS = nil;//YYYY-MM-dd HH:mm:ss
static NSDateFormatter *DefaultFormatterYMDHM = nil;//YYYY-MM-dd HH:mm
static NSDateFormatter *DefaultFormatterYMD = nil;//YYYY-MM-dd
static NSDateFormatter *DefaultFormatterMDHM = nil;//MM-dd HH:mm
static NSDateFormatter *DefaultFormatterMD = nil;//MM/dd
static NSDateFormatter *DefaultFormatterM_D = nil;//MM-dd
static NSDateFormatter *DefaultFormatterHM = nil;//HH:mm

+ (NSDateFormatter *)formatterWithFormat:(NSString *)format{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:format];
    return formatter;
}

+ (void)initialize{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DefaultFormatterYMDHMSSS = [self formatterWithFormat:@"YYYY-MM-dd HH:mm:ss.SSS"];
        DefaultFormatterYMDHMS = [self formatterWithFormat:@"YYYY-MM-dd HH:mm:ss"];
        DefaultFormatterYMDHM = [self formatterWithFormat:@"YYYY-MM-dd HH:mm"];
        DefaultFormatterYMD = [self formatterWithFormat:@"YYYY-MM-dd"];
        DefaultFormatterMDHM = [self formatterWithFormat:@"MM-dd HH:mm"];
        DefaultFormatterMD = [self formatterWithFormat:@"MM/dd"];
        DefaultFormatterM_D = [self formatterWithFormat:@"MM-dd"];
        DefaultFormatterHM = [self formatterWithFormat:@"HH:mm"];
    });
}

- (NSString *)FORMAT_YMDHMS
{
    return [DefaultFormatterYMDHMS stringFromDate:self];
}

- (NSString *)FORMAT_YMD
{
    NSString *newTimeStr=[DefaultFormatterYMD stringFromDate:self];
    return newTimeStr;
}

+ (NSString *)fullTimeString{
    NSString *newTimeStr=[DefaultFormatterYMDHMSSS stringFromDate:[NSDate date]];
    return newTimeStr;
}

+ (NSString *)custom_YMDHM:(long long) seconds
{
    if (seconds > 144913545800) {
        seconds /= 1000;
    }
    return [DefaultFormatterYMDHM stringFromDate:[NSDate dateWithTimeIntervalSince1970:seconds]];
}

+ (NSString *)custom_MDHM:(long long) seconds
{
    if (seconds > 144913545800) {
        seconds /= 1000;
    }
    return [DefaultFormatterMDHM stringFromDate:[NSDate dateWithTimeIntervalSince1970:seconds]];
}

+ (NSString *)custom_MD:(long long) seconds
{
    if (seconds > 144913545800) {
        seconds /= 1000;
    }
    return [DefaultFormatterM_D stringFromDate:[NSDate dateWithTimeIntervalSince1970:seconds]];
}

+ (NSString *)custom_YMDHMS:(long long) seconds
{
    if (seconds > 144913545800) {
        seconds /= 1000;
    }
    return [DefaultFormatterYMDHMS stringFromDate:[NSDate dateWithTimeIntervalSince1970:seconds]];
}

+ (NSString *)custom_YMD:(long long) seconds
{
    if (seconds > 144913545800) {
        seconds /= 1000;
    }
    return [DefaultFormatterYMD stringFromDate:[NSDate dateWithTimeIntervalSince1970:seconds]];
}

+ (NSString *)recentlyTimeStringWithTimeline:(long long)timeline{
    if (timeline > 144913545800) {
        timeline /= 1000;
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeline];
    return [date recentlyTimeString];
}

- (NSString *)recentlyTimeString{
    
    NSDate *date = self;
    NSDate *now = [NSDate new];
    NSTimeInterval delta = now.timeIntervalSince1970 - date.timeIntervalSince1970;
    if (delta < -60 * 10) { // 本地时间有问题
        return [DefaultFormatterYMD stringFromDate:date];
    } else if (delta < 60) { // 1分钟内
        return @"刚刚";
    } else if (delta < 60 * 60) { // 1小时内
        return [NSString stringWithFormat:@"%d分钟前", (int)(delta / 60.0)];
    } else if (date.isToday) {
        return [NSString stringWithFormat:@"%d小时前", (int)(delta / 60.0 / 60.0)];
    } else {
        return [DefaultFormatterM_D stringFromDate:date];
    }
    /*
     if (date.isYesterday) {
     return [formatterYesterday stringFromDate:date];
     } else if (date.year == now.year) {
     return [formatterSameYear stringFromDate:date];
     } else {
     return [formatterFullDate stringFromDate:date];
     }// */
}
+ (NSString *)listTimeStringWithTimeline:(long long)timeline{
    
    if (timeline > 144913545800) {
        timeline /= 1000;
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeline];
    return [date listTimeString];
}
- (NSString *)listTimeString{
    NSDate *date = self;
    if (date.isToday) {
        return [DefaultFormatterHM stringFromDate:date];
    }
    return [DefaultFormatterM_D stringFromDate:date];
}

+ (NSString *)detailTimeStringWithTimeline:(long long)timeline{
    
    if (timeline > 144913545800) {
        timeline /= 1000;
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeline];
    return [date detailTimeString];
}
- (NSString *)detailTimeString{
    NSDate *date = self;
    if (date.isToday) {
        return [DefaultFormatterHM stringFromDate:date];
    }
    return [DefaultFormatterMDHM stringFromDate:date];
}

/**
 *  获取时间
 *
 *  @return 返回需要的星期几
 */
- (NSString *)getDateAndWeek:(NSDate *)now {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //获取当前时间，日期
    //    NSDate *now = [NSDate date];
    NSInteger unitFlags = NSCalendarUnitWeekday;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:now];
    NSInteger week = [comps weekday];
    NSArray *arrWeek = [NSArray arrayWithObjects:@"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSString *weekString = [arrWeek objectAtIndex:week - 1];
    
    // 日期格式化
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:now];
    
    //最终输出时间
    NSString *outPutString = [NSString stringWithFormat:@"%@ %@",weekString, dateString];
    
    return outPutString;
}

@end
