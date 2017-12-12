//
//  NSDate+KYSAddition.h
//  KYSKitDemo
//
//  Created by Liu Zhao on 16/2/23.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (KYSAddition)

#pragma mark - Component Properties

@property (nonatomic, readonly) NSInteger year; ///< Year component
@property (nonatomic, readonly) NSInteger month; ///< Month component (1~12)
@property (nonatomic, readonly) NSInteger day; ///< Day component (1~31)
@property (nonatomic, readonly) NSInteger hour; ///< Hour component (0~23)
@property (nonatomic, readonly) NSInteger minute; ///< Minute component (0~59)
@property (nonatomic, readonly) NSInteger second; ///< Second component (0~59)
@property (nonatomic, readonly) NSInteger nanosecond; ///< Nanosecond component
@property (nonatomic, readonly) NSInteger weekday; ///< Weekday component (1~7, first day is based on user setting)
@property (nonatomic, readonly) NSInteger weekdayOrdinal; ///< WeekdayOrdinal component
@property (nonatomic, readonly) NSInteger weekOfMonth; ///< WeekOfMonth component (1~5)
@property (nonatomic, readonly) NSInteger weekOfYear; ///< WeekOfYear component (1~53)
@property (nonatomic, readonly) NSInteger yearForWeekOfYear; ///< YearForWeekOfYear component
@property (nonatomic, readonly) NSInteger quarter; ///< Quarter component
@property (nonatomic, readonly) BOOL isLeapMonth; ///< whether the month is leap month
@property (nonatomic, readonly) BOOL isLeapYear; ///< whether the year is leap year


@property (nonatomic, readonly) BOOL isToday;               //今天
@property (nonatomic, readonly) BOOL isTomorrow;            //明天
@property (nonatomic, readonly) BOOL isTheDayAfterTomorrow; //后天
@property (nonatomic, readonly) BOOL isYesterday;           //昨天

#pragma mark - Date modify
- (NSDate *)dateByAddingYears:(NSInteger)years;

- (NSDate *)dateByAddingMonths:(NSInteger)months;

- (NSDate *)dateByAddingWeeks:(NSInteger)weeks;

- (NSDate *)dateByAddingDays:(NSInteger)days;

- (NSDate *)dateByAddingHours:(NSInteger)hours;

- (NSDate *)dateByAddingMinutes:(NSInteger)minutes;

- (NSDate *)dateByAddingSeconds:(NSInteger)seconds;


#pragma mark - Date Format

- (NSString *)stringWithFormat:(NSString *)format;

- (NSString *)stringWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale;

- (NSString *)stringWithISOFormat;

+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format;

+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale;

+ (NSDate *)dateWithISOFormatString:(NSString *)dateString;

@end
