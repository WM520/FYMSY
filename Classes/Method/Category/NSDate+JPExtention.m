//
//  NSDate+JPExtention.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/19.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "NSDate+JPExtention.h"
#define DATE_COMPONENTS (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfMonth |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]

@implementation NSDate (JPExtention)
/**
 获取当地当前时间
 */
+ (NSDate *)getLocalTime {
    NSDate *date = [NSDate date]; // 获得时间对象
    NSTimeZone *zone = [NSTimeZone systemTimeZone]; // 获得系统的时区
    NSTimeInterval time = [zone secondsFromGMTForDate:date];// 以秒为单位返回当前时间与系统格林尼治时间的差
    return [date dateByAddingTimeInterval:time];// 然后把差的时间加上,就是当前系统准确的时间
}

//  获取最近30天日期
+ (NSArray *)getLastDaysWithFormat:(NSString *)format {
    NSMutableArray *dates = [NSMutableArray array];
    long long startTime = [[NSDate date] timeIntervalSince1970] - (30 * 24 * 60 * 60), //开始时间
    endTime = [[NSDate date] timeIntervalSince1970] - (24 * 60 * 60),//结束时间
    dayTime = 24*60*60,
    time = startTime - startTime % dayTime;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    
    while (time < endTime) {
        NSString *showOldDate = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
        [dates addObject:showOldDate];
        time += dayTime;
    }
    return dates;
}

+ (NSString *)getToday {
    return [self stringFromDate:[NSDate date] withFormat:@"yyyy/M/dd"];
}

+ (NSDate *)getLastMonth {
    return [NSDate dateWithTimeIntervalSinceNow:- (31 * 24 * 60 * 60)];
}

+ (NSDate *)getYesterday {
    return [NSDate dateWithTimeIntervalSinceNow:- (24 * 60 * 60)];
}

//昨天的日期
+ (NSString *)getYesterdayDate
{
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:- (24 * 60 * 60)];
    return [self stringFromDate:yesterday withFormat:@"yyyy/M/dd"];
}

//获取最近几个月
+ (NSMutableArray *)getNearMonthWithNum:(NSInteger)num
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    //获取当前秒
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeInterval time1970 = [now timeIntervalSince1970];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[NSDate date]];
    
    NSUInteger numberOfDaysInMonths = range.length;
    
    for (NSInteger i = 0; i < num; i ++)
    {
        //格式化时间
        NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:time1970 - (86400 * numberOfDaysInMonths * i)];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy年MM月"];
        [formatter stringFromDate:dateTime];
        
        //得到近6个月时间
        NSString *string = [NSString stringWithFormat:@"%@",dateTime];
        NSString *monthStr = [string substringWithRange:NSMakeRange(0, 7)];
        [arr addObject:monthStr];
    }
    return arr;
}
//获取今天是星期几
-(NSInteger)dayOfWeek {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *offsetComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                                     fromDate:self];
    NSInteger y=[offsetComponents year];
    NSInteger m=[offsetComponents month];
    NSInteger d=[offsetComponents day];
    static int t[] = {0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4};
    y -= m < 3;
    
    NSInteger result=(y + y/4 - y/100 + y/400 + t[m-1] + d) % 7;
    if (result==0) {
        result=7;
    }
    return result;
}
//获取每月有多少天
-(NSInteger)monthOfDay{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *offsetComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                                     fromDate:self];
    NSInteger y=[offsetComponents year];
    NSInteger m=[offsetComponents month];
    if (m==2) {
        if (y%4==0&&(y%100!=0||y%400==0)) {
            return 29;
        }
        return 28;
    }
    if (m==4||m==6||m==9||m==11) {
        return 30;
    }
    return 31;
}
//本周开始时间
-(NSDate*)beginningOfWeek{
    NSInteger weekday=[self dayOfWeek];
    return  [self dateByAddingDays:(weekday-1)*-1];
}
//本周结束时间
- (NSDate *)endOfWeek{
    NSInteger weekday=[self dayOfWeek];
    if (weekday==7) {
        return self;
    }
    return [self dateByAddingDays:7-weekday];
}
//日期添加几天
-(NSDate*)dateByAddingDays:(NSInteger)days{
    NSDateComponents *c = [[NSDateComponents alloc] init];
    c.day = days;
    
    NSDate *resultDate=[[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0];
    
    return resultDate;
    //return [[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0];
    /***
     NSTimeInterval interval = 24 * 60 * 60;//表示一天
     return  [self dateByAddingTimeInterval:day*interval];
     ***/
}
//日期格式化
- (NSString *)stringWithFormat:(NSString *)format {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:format];
    NSString *timestamp_str = [outputFormatter stringFromDate:self];
    return timestamp_str;
}
//字符串转换成时间
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];
    NSDate *date = [inputFormatter dateFromString:string];
    return date;
}

-(NSDate*)dateWithFormater:(NSString*)format{
    NSString *string = [self stringWithFormat:format];
    
    return [NSDate dateFromString:string withFormat:format];
}

+ (NSString*)timeStringFromInterval:(NSTimeInterval)timeInterval
{
    long hours  = (long)timeInterval / 60l;
    long mins   = ((long)timeInterval / 60l) % 60l;
    long secs   = (long)timeInterval % 60l;
    long hunds  = (long)(timeInterval * 100.0) % 100l;
    
    NSString *timeStr = [NSString stringWithFormat:@"%02ld:%02ld:%02ld.%02ld", hours, mins, secs, hunds];
    
    return timeStr;
}

//时间转换成字符串
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format {
    return [date stringWithFormat:format];
}
//日期转化成民国时间
-(NSString*)dateToTW:(NSString *)string{
    NSString *str=[self stringWithFormat:string];
    int y=[[str substringWithRange:NSMakeRange(0, 4)] intValue];
    return [NSString stringWithFormat:@"%d%@",y-1911,[str stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:@""]];
}
- (JPDateInformation) dateInformationWithTimeZone:(NSTimeZone*)tz{
    
    
    JPDateInformation info;
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setTimeZone:tz];
    NSDateComponents *comp = [gregorian components:(NSCalendarUnitMonth | NSCalendarUnitMinute | NSCalendarUnitYear |
                                                    NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitSecond)
                                          fromDate:self];
    info.day = [comp day];
    info.month = [comp month];
    info.year = [comp year];
    
    info.hour = [comp hour];
    info.minute = [comp minute];
    info.second = [comp second];
    
    info.weekday = [comp weekday];
    
    
    return info;
    
}
- (JPDateInformation) dateInformation{
    
    JPDateInformation info;
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp = [gregorian components:(NSCalendarUnitMonth | NSCalendarUnitMinute | NSCalendarUnitYear |
                                                    NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitSecond)
                                          fromDate:self];
    info.day = [comp day];
    info.month = [comp month];
    info.year = [comp year];
    
    info.hour = [comp hour];
    info.minute = [comp minute];
    info.second = [comp second];
    
    info.weekday = [comp weekday];
    
    
    return info;
}
+ (NSDate*) dateFromDateInformation:(JPDateInformation)info timeZone:(NSTimeZone*)tz{
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setTimeZone:tz];
    NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:[NSDate date]];
    
    [comp setDay:info.day];
    [comp setMonth:info.month];
    [comp setYear:info.year];
    [comp setHour:info.hour];
    [comp setMinute:info.minute];
    [comp setSecond:info.second];
    [comp setTimeZone:tz];
    
    return [gregorian dateFromComponents:comp];
}
+ (NSDate*) dateFromDateInformation:(JPDateInformation)info{
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:[NSDate date]];
    
    [comp setDay:info.day];
    [comp setMonth:info.month];
    [comp setYear:info.year];
    [comp setHour:info.hour];
    [comp setMinute:info.minute];
    [comp setSecond:info.second];
    //[comp setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    return [gregorian dateFromComponents:comp];
}

+ (NSString*) dateInformationDescriptionWithInformation:(JPDateInformation)info{
    return [NSString stringWithFormat:@"%ld %ld %ld %ld:%ld:%ld",(long)info.month,(long)info.day,(long)info.year,(long)info.hour,(long)info.minute,(long)info.second];
}
-(BOOL)compareToDate:(NSDate*)date{
    if ([self compare:date]==NSOrderedDescending) {
        return YES;
    }
    return NO;
}

+ (JPTimeInterval)convertTimeInterval:(NSTimeInterval)interval
{
    JPTimeInterval ti;
    ti.day = (int) interval / 86400;
    ti.hour = (int) (interval - 86400 * ti.day) / 3600;
    ti.min = (int) (interval - 86400 * ti.day - 3600 * ti.hour) / 60;
    ti.second = (int) (interval - 86400 * ti.day - 3600 * ti.hour - 60 * ti.min);
    ti.hms = (int) ((interval - 86400 * ti.day - 3600 * ti.hour - 60 * ti.min - ti.second)*10);
    return ti;
}

#pragma mark Comparing Dates

- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}

- (BOOL) isToday
{
    return [self isEqualToDateIgnoringTime:[NSDate date]];
}

- (BOOL) isTomorrow
{
    return [self isEqualToDateIgnoringTime:[NSDate dateTomorrow]];
}

- (BOOL) isYesterday
{
    return [self isEqualToDateIgnoringTime:[NSDate dateYesterday]];
}

// This hard codes the assumption that a week is 7 days
- (BOOL) isSameWeekAsDate: (NSDate *) aDate
{
    //TODO: update
    return YES;
    //    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    //    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
    //
    //    // Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
    //    if (components1.week != components2.week) return NO;
    //
    //    // Must have a time interval under 1 week. Thanks @aclark
    //    return (abs([self timeIntervalSinceDate:aDate]) < D_WEEK);
}

- (BOOL) isThisWeek
{
    return [self isSameWeekAsDate:[NSDate date]];
}

- (BOOL) isNextWeek
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + JP_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self isSameWeekAsDate:newDate];
}

- (BOOL) isLastWeek
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - JP_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self isSameWeekAsDate:newDate];
}

// Thanks, mspasov
- (BOOL) isSameMonthAsDate: (NSDate *) aDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:aDate];
    return ((components1.month == components2.month) &&
            (components1.year == components2.year));
}

- (BOOL) isThisMonth
{
    return [self isSameMonthAsDate:[NSDate date]];
}

- (BOOL) isSameYearAsDate: (NSDate *) aDate
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:aDate];
#pragma clang diagnostic pop
    return (components1.year == components2.year);
}

- (BOOL) isThisYear
{
    // Thanks, baspellis
    return [self isSameYearAsDate:[NSDate date]];
}

- (BOOL) isNextYear
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:[NSDate date]];
#pragma clang diagnostic pop
    return (components1.year == (components2.year + 1));
}

- (BOOL) isLastYear
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:[NSDate date]];
#pragma clang diagnostic pop
    return (components1.year == (components2.year - 1));
}

- (BOOL) isEarlierThanDate: (NSDate *) aDate
{
    return ([self compare:aDate] == NSOrderedAscending);
}

- (BOOL) isLaterThanDate: (NSDate *) aDate
{
    return ([self compare:aDate] == NSOrderedDescending);
}

// Thanks, markrickert
- (BOOL) isInFuture
{
    return ([self isLaterThanDate:[NSDate date]]);
}

// Thanks, markrickert
- (BOOL) isInPast
{
    return ([self isEarlierThanDate:[NSDate date]]);
}

+ (NSDate *) dateWithDaysFromNow: (NSInteger) days
{
    // Thanks, Jim Morrison
    return [[NSDate date] dateByAddingDays:days];
}

+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days
{
    // Thanks, Jim Morrison
    return [[NSDate date] dateBySubtractingDays:days];
}

+ (NSDate *) dateTomorrow
{
    return [NSDate dateWithDaysFromNow:1];
}

+ (NSDate *) dateYesterday
{
    return [NSDate dateWithDaysBeforeNow:1];
}

- (NSDate *) dateBySubtractingDays: (NSInteger) dDays
{
    return [self dateByAddingDays: (dDays * -1)];
}
@end
