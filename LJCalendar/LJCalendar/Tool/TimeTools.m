//
//  TimeTools.m
//  testJson
//
//  Created by gorson on 3/10/15.
//  Copyright (c) 2015 gorson. All rights reserved.
//

#import "TimeTools.h"

#define kStart_Year 2017
#define kStart_Date @"2017-08-01"
static NSInteger const appStartMonth = 8;

static NSCalendar* calendar;
static NSCalendar* chineseCalendar;

static NSArray* chineseYear;
static NSArray* chineseMonth;
static NSArray* chineseDay;
static NSArray* chineseWeek;

@implementation TimeTools

+(void)initialize{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        chineseCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierChinese];
        
        chineseYear = @[@"甲子鼠年", @"乙丑牛年", @"丙寅虎年", @"丁卯兔年", @"戊辰龙年", @"己巳蛇年", @"庚午马年", @"辛未羊年", @"壬申猴年", @"癸酉鸡年",
                        @"甲戌狗年", @"乙亥猪年", @"丙子鼠年", @"丁丑牛年", @"戊寅虎年", @"己卯兔年", @"庚辰龙年", @"辛己蛇年", @"壬午马年", @"癸未羊年",
                        @"甲申猴年", @"乙酉鸡年", @"丙戌狗年", @"丁亥猪年", @"戊子鼠年", @"己丑牛年", @"庚寅虎年", @"辛卯兔年", @"壬辰龙年", @"癸巳蛇年",
                        @"甲午马年", @"乙未羊年", @"丙申猴年", @"丁酉鸡年", @"戊戌狗年", @"己亥猪年", @"庚子鼠年", @"辛丑牛年", @"壬寅虎年", @"癸卯兔年",
                        @"甲辰龙年", @"乙巳蛇年", @"丙午马年", @"丁未羊年", @"戊申猴年", @"己酉鸡年", @"庚戌狗年", @"辛亥猪年", @"壬子鼠年", @"癸丑牛年",
                        @"甲寅虎年", @"乙卯兔年", @"丙辰龙年", @"丁巳蛇年", @"戊午马年", @"己未羊年", @"庚申猴年", @"辛酉鸡年", @"壬戌狗年", @"癸亥猪年"];
        chineseMonth = @[@"正月", @"二月", @"三月", @"四月", @"五月", @"六月",
                         @"七月", @"八月", @"九月", @"十月", @"冬月", @"腊月"];
        chineseDay = @[@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                       @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                       @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十"];
        chineseWeek = @[@"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
    });
}

#pragma mark - ================ 当前时间 ==================
+ (uint64_t)getCurrentTimestamp{
    //获取系统当前的时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    return a;
}

/**  获取当前标准时间（例子：2015-02-03） */
+ (NSString *)getCurrentStandarTime{
    NSDate*  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString*  locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}

/**  获取当前时间，格式自定义 ：yyyy-MM-dd HH:mm:ss（完整） */
+ (NSString*)getCurrentTimesType:(NSString*)type{
    NSDate*  senddate=[NSDate date];
    NSDateFormatter* dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:type];
    NSString*  locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}

/**  获取当天凌晨零点 的时间戳 */
+(double)getCurrentDayStartTimestamp{
    NSString* currentStr = [self getCurrentTimesType:@"yyyy-MM-dd"];
    double currentTimestamp = [self getTimestampFromTime:currentStr dateType:@"yyyy-MM-dd"];
    return currentTimestamp;
}

#pragma mark - ================ 互换 ==================
/**  时间戳转换为时间的方法 -> yyyy-MM-dd HH:mm:ss*/
+ (NSString *)timestampChangesToStandarTime:(uint64_t)timestamp{

    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSString* dateString = [formatter stringFromDate:date];
    
    return dateString;
}

/**  时间戳 -> 自定义格式的时间：yyyy-MM-dd HH:mm:ss（完整） */
+ (NSString*)timestamp:(uint64_t)timestamp changeToTimeType:(NSString*)type{
    if (timestamp<1){
        return @"";
    }
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:type];
    if (timestamp < 1000000000) {
        [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    }
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSString* dateString = [formatter stringFromDate:date];
    
    return dateString;
}

/**  时间戳 -> 星期 （日 一 二...六） */
+(NSString *)timeToweek:(uint64_t)time{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"EEEE"];
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:time];
    NSString* dateString = [formatter stringFromDate:date];
    
    return dateString;
}

/**  数字转 时间样式 3600 -> HH:mm:ss（完整）*/
+(NSString *)timestampChangeTimeStyle:(double)timestamp{
    if (timestamp < 0){
        return @"";
    }
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    if (timestamp>=3600) {
        [formatter setDateFormat:@"HH:mm:ss"];
    }else{
        [formatter setDateFormat:@"mm:ss"];
    }
    
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSString* dateString = [formatter stringFromDate:date];
    
    return dateString;
}

/**  yyyy-MM-dd HH:mm:ss（完整） -> 时间戳 */
+(double)getTimestampFromTime:(NSString*)time dateType:(NSString*)dateType{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:dateType];
    
    NSTimeZone* timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    
    //------------将字符串按formatter转成nsdate
    NSDate* date = [formatter dateFromString:time];
    
    double timestamp = [date timeIntervalSince1970];
    return timestamp;
}


#pragma mark - ================ 获取月份，周 ==================
/**  获取距离2017年 的所有月份 */
+(NSArray*)getAllMonths{
    NSMutableArray* monthsArray = [NSMutableArray array];
    NSMutableArray* monthsTimestamp = [NSMutableArray array];
    
    //double startTimestamp = [self getTimestampFromTime:@"2017-01-01" dateType:@"yyyy-MM-dd"];
    double currentTimestamp = [self getCurrentTimestamp];
    
    BOOL isEnd = NO;
    NSInteger year = kStart_Year;
    while (!isEnd) {
        NSInteger i = (year == kStart_Year) ? appStartMonth : 1;
        for ( ; i<13; i++) {
            NSString* monthStr = [NSString stringWithFormat:@"%ld-%ld-01", year, i];
            double monthTimestamp = [self getTimestampFromTime:monthStr dateType:@"yyyy-MM-dd"];
            if (monthTimestamp >= currentTimestamp) {
                isEnd = YES;
                break;
            }else{
                [monthsArray addObject:[@(i) stringValue]];
                [monthsTimestamp addObject:@(monthTimestamp)];
            }
        }
        year ++;
    }
    [monthsTimestamp addObject:@(currentTimestamp)];
    
    //逆向 降序 ->  从当前时间 排到2017/01/01
//    [monthsArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//        return NSOrderedDescending;
//    }];
//    [monthsTimestamp sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//        return NSOrderedDescending;
//    }];
    
    [monthsArray addObject:monthsTimestamp];
    
    return monthsArray;
}

/**  获取距离2017年 的所有周 */
+(NSArray*)getAllWeeks{
    NSMutableArray* weeksArray = [NSMutableArray array];
    NSMutableArray* weeksTimestamp = [NSMutableArray array];
    long oneWeekSecond = 60*60*24*7;
    long oneDaySecond = 60*60*24;
    double startTimestamp = [self getTimestampFromTime:kStart_Date dateType:@"yyyy-MM-dd"];
    double currentTimestamp = [self getCurrentTimestamp];
    
    
    NSCalendar* calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    //1~7  日 一 二 三 四 五 六
    NSInteger currentWeekNum = [calendar component:NSCalendarUnitWeekday fromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    //currentWeekNum = currentWeekNum == 1 ? 7 : (currentWeekNum-1);
    
    //第一逆推的周日 时间戳
    double firstWeekTimestamp = currentTimestamp - oneDaySecond*(currentWeekNum-1);
    NSString* firstWeekStr = [self timestamp:firstWeekTimestamp changeToTimeType:@"yyyy-MM-dd"];
    firstWeekTimestamp = [self getTimestampFromTime:firstWeekStr dateType:@"yyyy-MM-dd"];
    
    //保存第一个时间戳  （当前时间戳）
    [weeksTimestamp addObject:@(currentTimestamp)];
    
    //开始 本周的结束 月/日
    NSString* weekEndStr = [self timestamp:currentTimestamp changeToTimeType:@"MM/dd"];
    
    while (1) {
        if (firstWeekTimestamp < startTimestamp) {
            break;
        }else{
            [weeksTimestamp addObject:@(firstWeekTimestamp)];
            
            NSString* weekStartStr = [self timestamp:firstWeekTimestamp changeToTimeType:@"MM/dd"];
            
            [weeksArray addObject:[NSString stringWithFormat:@"%@\n%@", weekStartStr, weekEndStr]];
            
            weekEndStr = [self timestamp:(firstWeekTimestamp - oneDaySecond) changeToTimeType:@"MM/dd"];
        }
        
        firstWeekTimestamp -= oneWeekSecond;
    }
    
    //逆序：
    [weeksTimestamp sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return NSOrderedDescending;
    }];
    [weeksArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return NSOrderedDescending;
    }];
    
    [weeksArray addObject:weeksTimestamp];
    
    return weeksArray;
}

/**  获取距离2017年 的所有日期 1~31 */
+(NSArray*)getAllDays{
    
    NSMutableArray* daysArray = [NSMutableArray array];
    NSMutableArray* daysTimestampArray = [NSMutableArray array];
    
    long oneDaySecond = 60*60*24;
    double startTimestamp = [self getTimestampFromTime:kStart_Date dateType:@"yyyy-MM-dd"];
    double currentTimestamp = [self getCurrentTimestamp];
    
    NSString* curretnDayStr = [self timestamp:currentTimestamp changeToTimeType:@"yyyy-MM-dd"];
    double currentDayTimestamp = [self getTimestampFromTime:curretnDayStr dateType:@"yyyy-MM-dd"];
    curretnDayStr = [self timestamp:currentDayTimestamp changeToTimeType:@"MM\ndd"];
    
    //添加 今天00：00 的 月日，及 时间戳
    [daysArray addObject:curretnDayStr];
    [daysTimestampArray addObject:@(currentDayTimestamp)];
    
    while (1) {
        currentDayTimestamp -= oneDaySecond;
        if (currentDayTimestamp < startTimestamp) {
            break;
        }else{
            curretnDayStr = [self timestamp:currentDayTimestamp changeToTimeType:@"MM\ndd"];
            [daysArray addObject:curretnDayStr];
            [daysTimestampArray addObject:@(currentDayTimestamp)];
        }
    }
    
    //逆序：
    [daysTimestampArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return NSOrderedDescending;
    }];
    [daysArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return NSOrderedDescending;
    }];
    
    [daysArray addObject:daysTimestampArray];
    
    return daysArray;
}

#pragma mark - ================ 日历 ==================
/**  yyyy-MM-dd 换算星期几: 1~7  表示：周日、周一、~周六 */
+(NSInteger)getWeekdayFromDateString:(NSString*)dateString{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[self getTimestampFromTime:dateString dateType:@"yyyy-MM-dd"]];
    return [self getWeekdayFromDate:date];
}

/**  一个月里面含有多少天  yyyy-MM */
+(NSInteger)getMonthDayNumFromDateString:(NSString*)dateString{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[self getTimestampFromTime:dateString dateType:@"yyyy-MM"]];
    return [self getMonthDayNumFromDate:date];
}

/**  一个月里面有几周  yyyy-MM */
+(NSInteger)getMonthWeekNumFromDateString:(NSString*)dateString{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[self getTimestampFromTime:dateString dateType:@"yyyy-MM"]];
    return [self getMonthWeekNumFromDate:date];
}

//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

/**  date 换算星期几: 1~7  表示：周日、周一、~周六 */
+(NSInteger)getWeekdayFromDate:(NSDate*)date{
    NSInteger weekday = [calendar component:NSCalendarUnitWeekday fromDate:date];
    return weekday;
}

/**  一个月里面含有多少天  date */
+(NSInteger)getMonthDayNumFromDate:(NSDate*)date{
    NSRange dayNum = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return dayNum.length;
}

/**  一个月里面有几周  date */
+(NSInteger)getMonthWeekNumFromDate:(NSDate*)date{
    NSRange weekNum = [calendar rangeOfUnit:NSCalendarUnitWeekOfMonth inUnit:NSCalendarUnitMonth forDate:date];
    return weekNum.length;
}

/**  获取是几号 */
+(NSInteger)getDayWithDate:(NSDate*)date{
    NSInteger day = [calendar component:NSCalendarUnitDay fromDate:date];
    return day;
}

#pragma mark - ================ 农历 ==================
/**  根据date 获取 农历月份 */
+(NSInteger)getChineseMonthFromDate:(NSDate*)date{
    NSInteger month = [chineseCalendar component:NSCalendarUnitMonth fromDate:date];
    return month;
}

/**  根据Date 获取 农历初几 */
+(NSInteger)getChineseDayNumFromDate:(NSDate*)date{
    NSInteger month = [chineseCalendar component:NSCalendarUnitDay fromDate:date];
    return month;
}

/**  根据月初Date 和 当月天数，获取农历信息 */
+(NSArray*)getChineseDateFromDate:(NSDate*)date dayNumOfMonth:(NSInteger)dayNum{
    
    NSDate* currentDate = [NSDate dateWithTimeIntervalSince1970:date.timeIntervalSince1970];
    NSInteger totalDayNum = 0;
    NSMutableArray* result = [NSMutableArray array];
    
    while (totalDayNum < dayNum) {
        
        NSRange dayNumRange = [chineseCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:currentDate];
        NSInteger month = [self getChineseMonthFromDate:currentDate];
        NSInteger firstDayNum = [self getChineseDayNumFromDate:currentDate];
        
        totalDayNum += dayNumRange.length-firstDayNum+1;
        [result addObject:@[@(totalDayNum), @(dayNumRange.length-firstDayNum+1), @(firstDayNum), @(month)]];
        
        currentDate = [NSDate dateWithTimeIntervalSince1970:
                       currentDate.timeIntervalSince1970+24*60*60*(totalDayNum)];
        //NSLog(@"...%.0f", currentDate.timeIntervalSince1970);
    }
    return result;
}


/**  如：23 -> 廿三， 1 -> 初一 */
+(NSString*)getChineseDayString:(NSInteger)dayNum{
    return chineseDay[dayNum-1];
}

/**  如 6 -> 六月 */
+(NSString*)getChineseMonthString:(NSInteger)month{
    return chineseMonth[month-1];
}

/**  2017年 -> 丁酉鸡年 */
+(NSString*)getChineseYearString:(NSInteger)year{
    double timestamp = [self getTimestampFromTime:[@(year) stringValue] dateType:@"yyyy"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSInteger yearIndex = [chineseCalendar component:NSCalendarUnitYear fromDate:date];
    return chineseYear[yearIndex-1];
}

/**  1 -> 星期日， 2->星期一 */
+(NSString*)getChineseWeekString:(NSInteger)week{
    return chineseWeek[week-1];
}

/**  根据Date获取 农历的 年，月，日，星期 */
+(NSArray*)getChineseDateDetailFromDate:(NSDate*)date{
    
    NSInteger yearIndex = [chineseCalendar component:NSCalendarUnitYear fromDate:date];
    NSInteger monthIndex = [chineseCalendar component:NSCalendarUnitMonth fromDate:date];
    NSInteger dayIndex = [chineseCalendar component:NSCalendarUnitDay fromDate:date];
    NSInteger weekIndex = [chineseCalendar component:NSCalendarUnitWeekday fromDate:date];
    
    return @[chineseYear[yearIndex-1],
             chineseMonth[monthIndex-1],
             chineseDay[dayIndex-1],
             chineseWeek[weekIndex-1]];
}










@end
