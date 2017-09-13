//
//  TimeTools.h
//  testJson
//
//  Created by gorson on 3/10/15.
//  Copyright (c) 2015 gorson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeTools : NSObject

#pragma mark - ================ 当前时间 ==================
/**  获取当前时间戳（例子：1464326536） */
+ (uint64_t)getCurrentTimestamp;

/**  获取当前标准时间（例子：2015-02-03） */
+ (NSString *)getCurrentStandarTime;

/**  获取当前时间，格式自定义 ：yyyy-MM-dd HH:mm:ss（完整） */
+ (NSString*)getCurrentTimesType:(NSString*)type;

/**  获取当天凌晨零点 的时间戳 */
+(double)getCurrentDayStartTimestamp;



#pragma mark - ================ 互换 ==================
/**  时间戳转换为时间的方法 -> yyyy-MM-dd HH:mm:ss*/
+ (NSString *)timestampChangesToStandarTime:(uint64_t)timestamp;

/**  时间戳 -> 自定义格式的时间：yyyy-MM-dd HH:mm:ss（完整） */
+ (NSString*)timestamp:(uint64_t)timestamp changeToTimeType:(NSString*)type;


/**  时间戳 -> 星期 （日 一 二...六） */
+(NSString *)timeToweek:(uint64_t)time;

/**  数字转 时间样式 3600 -> HH:mm:ss（完整）*/
+(NSString*)timestampChangeTimeStyle:(double)timestamp;

/**  yyyy-MM-dd HH:mm:ss（完整） -> 时间戳 */
+(double)getTimestampFromTime:(NSString*)time dateType:(NSString*)dateType;



#pragma mark - ================ 获取月份，周 ==================
/**  获取距离2017年 的所有月份 
    返回值：每个月的月份值 
          及最后一个元素是 每个月的起始时间戳 到 当前时间戳 数组*/
+(NSArray*)getAllMonths;

/**  获取距离2017年 的所有周 
    返回值: 逆推 每个周的起始月日和结束月日。 
           及最后一个元素是 每周的起始时间戳到当前时间戳*/
+(NSArray*)getAllWeeks;

/**  获取距离2017年 的所有日期 1~31 
     返回值：逆推 每个月日， 及最后一个元素是 每个月日的 时间戳*/
+(NSArray*)getAllDays;


#pragma mark - ================ 日历 ==================
/**  yyyy-MM-dd 换算星期几: 1~7  表示：周日、周一、~周六 */
+(NSInteger)getWeekdayFromDateString:(NSString*)dateString;

/**  一个月里面含有多少天  yyyy-MM */
+(NSInteger)getMonthDayNumFromDateString:(NSString*)dateString;

/**  一个月里面有几周  yyyy-MM */
+(NSInteger)getMonthWeekNumFromDateString:(NSString*)dateString;


/**  date 换算星期几: 1~7  表示：周日、周一、~周六 */
+(NSInteger)getWeekdayFromDate:(NSDate*)date;

/**  一个月里面含有多少天  date */
+(NSInteger)getMonthDayNumFromDate:(NSDate*)date;

/**  一个月里面有几周  date */
+(NSInteger)getMonthWeekNumFromDate:(NSDate*)date;

/**  获取是几号 */
+(NSInteger)getDayWithDate:(NSDate*)date;

#pragma mark - ================ 农历 ==================
/**  根据date 获取 农历月份 */
+(NSInteger)getChineseMonthFromDate:(NSDate*)date;

/**  根据Date 获取 农历初几 */
+(NSInteger)getChineseDayNumFromDate:(NSDate*)date;

/**  根据月初Date 和 当月天数，获取农历信息 */
+(NSArray*)getChineseDateFromDate:(NSDate*)date dayNumOfMonth:(NSInteger)dayNum;

/**  如：23 -> 廿三， 1 -> 初一 */
+(NSString*)getChineseDayString:(NSInteger)dayNum;

/**  如 6 -> 六月 */
+(NSString*)getChineseMonthString:(NSInteger)month;

/**  2017年 -> 丁酉鸡年 */
+(NSString*)getChineseYearString:(NSInteger)year;

/**  1 -> 星期日， 2->星期一 ... 7->星期六 */
+(NSString*)getChineseWeekString:(NSInteger)week;

/**  根据Date获取 农历的 年，月，日，星期 */
+(NSArray*)getChineseDateDetailFromDate:(NSDate*)date;



@end
