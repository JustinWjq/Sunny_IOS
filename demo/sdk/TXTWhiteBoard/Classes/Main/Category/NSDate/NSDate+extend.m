//
//  NSDate+extend.m
//  TextCustomServiceDemo
//
//  Created by lidashuang on 2017/3/15.
//  Copyright © 2017年 lidashuang. All rights reserved.
//

#import "NSDate+extend.h"

@implementation NSDate (extend)

- (BOOL)isSameMin:(NSDate *)date
{
    BOOL bRet = NO;
    
    if (bRet) {
        
        double timezoneFix = [NSTimeZone localTimeZone].secondsFromGMT;
        bRet = MinForTimeInterval([self timeIntervalSinceReferenceDate] + timezoneFix) ==
               MinForTimeInterval([date timeIntervalSinceReferenceDate] + timezoneFix);
    }
    
    return bRet;
}

- (BOOL)isSameHour:(NSDate *)date
{
    BOOL bRet = NO;
    
    if (date) {
        
        double timezoneFix = [NSTimeZone localTimeZone].secondsFromGMT;
        bRet = HourForTimeInterval([self timeIntervalSinceReferenceDate] + timezoneFix) ==
               HourForTimeInterval([date timeIntervalSinceReferenceDate] + timezoneFix);
    }
    
    return bRet;
}

- (BOOL)isSameDay:(NSDate *)date
{
    BOOL bRef = NO;
    
    if (date) {
        
        double timezoneFix = [NSTimeZone localTimeZone].secondsFromGMT;
        bRef = DayForTimeInterval([self timeIntervalSinceReferenceDate] + timezoneFix) ==
               DayForTimeInterval([date timeIntervalSinceReferenceDate] + timezoneFix);
    }
    
    return bRef;
}

- (BOOL)isToMin{
    return [self isSameMin:[NSDate date]];
}

- (BOOL)isToHour{
    return [self isSameHour:[NSDate date]];
}

- (BOOL)isToday{
    return [self isSameDay:[NSDate date]];
}


- (NSString *)getUTCFormateDate:(NSDate *)newsDate
{
    
    NSString *dateContent;
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today=[[NSDate alloc] init];
    NSDate *yearsterDay =  [[NSDate alloc] initWithTimeIntervalSinceNow:-secondsPerDay];
    NSDate *qianToday =  [[NSDate alloc] initWithTimeIntervalSinceNow:-2*secondsPerDay];
    //假设这是你要比较的date：NSDate *yourDate = ……
    //日历
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:newsDate];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:yearsterDay];
    NSDateComponents* comp3 = [calendar components:unitFlags fromDate:qianToday];
    NSDateComponents* comp4 = [calendar components:unitFlags fromDate:today];
    if ( comp1.year == comp2.year && comp1.month == comp2.month && comp1.day == comp2.day) {
        dateContent = @"昨天";
    }
    else if (comp1.year == comp3.year && comp1.month == comp3.month && comp1.day == comp3.day)
    {
        dateContent = @"前天";
    }
    else if (comp1.year == comp4.year && comp1.month == comp4.month && comp1.day == comp4.day)
    {
        dateContent = @"今天";
    }
    else
    {
        //返回0说明该日期不是今天、昨天、前天
        dateContent = @"0";
    }
    return dateContent;
}



#pragma mark - 时间戳字符串转换时间格式字符串
+(NSString*)getTimeStampToDStringValue:(NSString*)timeStr{
    
    return [self getTimeStampToDStringValue:timeStr format:nil area:nil];
}
+(NSString*)getTimeStampToDStringValue:(NSString*)timeStr format:(NSString*)format {
    
    return [self getTimeStampToDStringValue:timeStr format:format area:nil];
}
+(NSString*)getTimeStampToDStringValue:(NSString*)timeStr area:(NSString*)area{
    
    return [self getTimeStampToDStringValue:timeStr format:nil area:area];
}

+(NSString*)getTimeStampToDStringValue:(NSString*)timeStr format:(NSString*)format area:(NSString*)area{
    
    NSDateFormatter *formatter = [self getNSDateFormatter:format area:area];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:[timeStr doubleValue]/1000.0];
    NSString*datestr =[formatter stringFromDate: detaildate];
    return datestr;
}


#pragma mark - 时间字符串转换时间格式
+(NSDate*)getStringToDateValue:(NSString*)timeStr{
    
    return [self getStringToDateValue:timeStr format:nil area:nil];
}
+(NSDate*)getStringToDateValue:(NSString*)timeStr format:(NSString*)format {
    
    return [self getStringToDateValue:timeStr format:format area:nil];
}
+(NSDate*)getStringToDateValue:(NSString*)timeStr area:(NSString*)area{
    
    return [self getStringToDateValue:timeStr format:nil area:area];
}
+(NSDate*)getStringToDateValue:(NSString*)timeStr format:(NSString*)format area:(NSString*)area{
    
    NSDateFormatter *formatter = [self getNSDateFormatter:format area:area];
    NSDate* date = [formatter dateFromString:timeStr];
    return date;
}




+(NSString*)geDStringToTimeStampValue:(NSDate*)date{
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    return timeSp;
}





+ (NSDate *)getInternetDate

{
    NSString *urlString = @"http://m.baidu.com";
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    // 实例化NSMutableURLRequest，并进行参数配置
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: urlString]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval: 2];
    [request setHTTPShouldHandleCookies:FALSE];
    [request setHTTPMethod:@"GET"];
    NSError *error = nil;
    NSHTTPURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request
                          returningResponse:&response error:&error];
    // 处理返回的数据
    //    NSString *strReturn = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    if (error) {
        //return [NSDate date];
        NSDate *netDate = [NSDate date];
        NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        NSInteger interval = [zone secondsFromGMTForDate: netDate];
        NSDate *localeDate = [netDate  dateByAddingTimeInterval: interval];
        return localeDate;
    }
    NSLog(@"response is %@",response);
    NSString *date = [[response allHeaderFields] objectForKey:@"Date"];
    date = [date substringFromIndex:5];
    date = [date substringToIndex:[date length]-4];
    NSDateFormatter *dMatter = [[NSDateFormatter alloc] init];
    dMatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    // @"06 Jan 2017 06:37:20"
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dMatter setTimeZone:timeZone];
    [dMatter setDateFormat:@"dd MM yyyy HH:mm:ss"];
    NSDate *netDate = [[dMatter dateFromString:date] dateByAddingTimeInterval:60*60*8];
    
    NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSInteger interval = [zone secondsFromGMTForDate: netDate];
    NSDate *localeDate = [netDate  dateByAddingTimeInterval: interval];
    return localeDate;
    
}

/**
 * 开始到结束的时间差
 */
+ (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    NSDateFormatter *date = [self getNSDateFormatter];
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [date dateFromString:endTime];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    return [NSString stringWithFormat:@"%f",value];
}

#pragma mark - 日期转换时间字符串
+(NSString*)getDateToString:(NSDate*)date{
    
    return [self getDateToString:date format:nil area:nil];
}

+(NSString*)getDateToString:(NSDate*)date format:(NSString*)format{
    
    return [self getDateToString:date format:format area:nil];
}

+(NSString*)getDateToString:(NSDate*)date area:(NSString*)area{
    
    return [self getDateToString:date format:nil area:area];
}
+(NSString*)getDateToString:(NSDate*)date format:(NSString*)format area:(NSString*)area{
    
    NSDateFormatter *formatter =  [self getNSDateFormatter:format area:area];
    NSString *newtimeStr = [formatter stringFromDate:date];
    return newtimeStr;
}



//时间区域转换
+(NSDate*)aa:(NSDate*)date {
    
    return [self aa:date format:nil];
}
+(NSDate*)aa:(NSDate*)date format:(NSString*)format{
    if(format==nil){
        format = @"Asia/Shanghai";
    }
    NSTimeZone *zone = [NSTimeZone timeZoneWithName:format];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *newDate = [date  dateByAddingTimeInterval: interval];
    return newDate;
}


+(NSDateFormatter*)getNSDateFormatter{
    return  [self getNSDateFormatter:nil area:nil];
}
+(NSDateFormatter*)getNSDateFormatter:(NSString*)format area:(NSString*)area{
    
    if(format==nil){
        format = @"YYYY-MM-dd HH-mm-ss";
    }
    if(area==nil){
        area = @"Asia/Shanghai";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:area];
    [formatter setTimeZone:timeZone];
    return  formatter;
}



@end
