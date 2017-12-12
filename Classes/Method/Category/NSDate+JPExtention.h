//
//  NSDate+JPExtention.h
//  JiePos
//
//  Created by Jason_LJ on 2017/4/19.
//  Copyright © 2017年 Jason. All rights reserved.
//

/***
 3、iOS-NSDateFormatter 格式说明：
 
 G: 公元时代，例如AD公元
 yy: 年的后2位
 yyyy: 完整年
 MM: 月，显示为1-12
 MMM: 月，显示为英文月份简写,如 Jan
 MMMM: 月，显示为英文月份全称，如 Janualy
 dd: 日，2位数表示，如02
 d: 日，1-2位显示，如 2
 EEE: 简写星期几，如Sun
 EEEE: 全写星期几，如Sunday
 aa: 上下午，AM/PM
 H: 时，24小时制，0-23
 K：时，12小时制，0-11
 m: 分，1-2位
 mm: 分，2位
 s: 秒，1-2位
 ss: 秒，2位
 S: 毫秒
 
 常用日期结构：
 yyyy-MM-dd HH:mm:ss.SSS
 yyyy-MM-dd HH:mm:ss
 yyyy-MM-dd
 MM dd yyyy
 ***/
#import <Foundation/Foundation.h>

#define JP_MINUTE	60
#define JP_HOUR		3600
#define JP_DAY		86400
#define JP_WEEK		604800
#define JP_YEAR		31556926

struct JPTimeInterval{
    int day;      //天
    int hour;     //小时
    int min;      //分钟
    int second;   //秒
    int hms;   //百毫秒
} ;

/*! 时间间隔
 */
typedef struct JPTimeInterval JPTimeInterval;

struct JPDateInformation {
    NSInteger day;
    NSInteger month;
    NSInteger year;
    
    NSInteger weekday;
    
    NSInteger minute;
    NSInteger hour;
    NSInteger second;
};

typedef struct JPDateInformation JPDateInformation;
@interface NSDate (JPExtention)
/**
 获取当地当前时间
 */
+ (NSDate *)getLocalTime;
//  获取最近30天日期
+ (NSArray *)getLastDaysWithFormat:(NSString *)format;
//  今天的日期   2017/04/19
+ (NSString *)getToday;
+ (NSDate *)getLastMonth;
+ (NSDate *)getYesterday;
//昨天的日期
+ (NSString *)getYesterdayDate;
//获取最近几个月
+ (NSMutableArray *)getNearMonthWithNum:(NSInteger)num;
//获取今天是星期几
-(NSInteger)dayOfWeek;
//获取每月有多少天
-(NSInteger)monthOfDay;
//本周开始时间
-(NSDate*)beginningOfWeek;
//本周结束时间
- (NSDate *)endOfWeek;
//日期添加几天
-(NSDate*)dateByAddingDays:(NSInteger)day;
//日期格式化
- (NSString *)stringWithFormat:(NSString *)format;
//字符串转换成时间
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;
- (NSDate*)dateWithFormater:(NSString*)format;

//时间戳转成NSDate
+ (NSString*)timeStringFromInterval:(NSTimeInterval)timeInterval;

//时间转换成字符串
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)string;
//日期转化成民国时间
-(NSString*)dateToTW:(NSString *)string;
- (JPDateInformation) dateInformation;
- (JPDateInformation) dateInformationWithTimeZone:(NSTimeZone*)tz;
+ (NSDate*) dateFromDateInformation:(JPDateInformation)info;
+ (NSDate*) dateFromDateInformation:(JPDateInformation)info timeZone:(NSTimeZone*)tz;
+ (NSString*) dateInformationDescriptionWithInformation:(JPDateInformation)info;
/***时间大小的比较
 @return: 左边的时间大于date返回YES，否则返回NO
 ***/
-(BOOL)compareToDate:(NSDate*)date;

/*! 转换以秒为单位的时间间隔值为VSTimeInterval时间间隔结构
 * \param interval 以秒为单位的时间间隔值
 * \returns VSTimeInterval时间间隔结构
 */
+ (JPTimeInterval)convertTimeInterval:(NSTimeInterval)interval;

// add by zt 20150105
// Comparing dates
- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate;
- (BOOL) isToday;
- (BOOL) isTomorrow;
- (BOOL) isYesterday;
- (BOOL) isSameWeekAsDate: (NSDate *) aDate;
- (BOOL) isThisWeek;
- (BOOL) isNextWeek;
- (BOOL) isLastWeek;
- (BOOL) isSameMonthAsDate: (NSDate *) aDate;
- (BOOL) isThisMonth;
- (BOOL) isSameYearAsDate: (NSDate *) aDate;
- (BOOL) isThisYear;
- (BOOL) isNextYear;
- (BOOL) isLastYear;
- (BOOL) isEarlierThanDate: (NSDate *) aDate;
- (BOOL) isLaterThanDate: (NSDate *) aDate;
- (BOOL) isInFuture;
- (BOOL) isInPast;
@end
