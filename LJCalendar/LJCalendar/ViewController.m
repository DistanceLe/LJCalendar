//
//  ViewController.m
//  LJCalendar
//
//  Created by LiJie on 2017/9/8.
//  Copyright © 2017年 LiJie. All rights reserved.
//

#import "ViewController.h"

#import <objc/runtime.h>

#import "TimeTools.h"

#import "LJCalendarView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (nonatomic, weak) LJCalendarView* calendarView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) tempWeakSelf=self;
    LJCalendarView* calendar = [LJCalendarView getCalendarWithFrame:CGRectMake(0, 60, CGRectGetWidth(self.view.bounds), 400)];
    calendar.dateHandler = ^(NSString *dateString, NSDate *date) {
        NSString* commonDate = [TimeTools timestamp:date.timeIntervalSince1970 changeToTimeType:@"yyyy-MM-dd"];
        
        NSArray* chineseDate = [TimeTools getChineseDateDetailFromDate:date];
        tempWeakSelf.contentLabel.text = [NSString stringWithFormat:@"%@\n%@,%@,%@,%@",commonDate,chineseDate[0],chineseDate[1], chineseDate[2], chineseDate[3]];
    };
    [self.view addSubview:calendar];
    
    self.calendarView = calendar;
    
    //罗马日历， 通用
//    NSCalendar* calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    //农历
//    NSCalendar* chineseCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierChinese];

//    [self testCalendar:calendar];
//    [self testCalendar:chineseCalendar];
    
}
- (IBAction)todayClick:(id)sender {
    
    [self.calendarView showToday];
}

- (IBAction)setClick:(id)sender {
    
    NSDate* date = self.datePicker.date;
    [self.calendarView setCustomDate:date];
}



-(void)testCalendar:(NSCalendar*)calendar{
        unsigned int propertyCount = 0;
        objc_property_t* propertys = class_copyPropertyList([NSCalendar class], &propertyCount);
        for (NSInteger i = 0; i<propertyCount; i++) {
            objc_property_t property = propertys[i];
            NSString* propertyName = [NSString stringWithUTF8String:property_getName(property)];
            NSLog(@"key:%@", propertyName);
            NSLog(@"value:%@", [calendar valueForKey:propertyName]);
        }
    
    NSArray* calendarUnitStr = @[@"NSCalendarUnitEra",
                                 @"NSCalendarUnitYear",     //农历里面 60年 一个周期
                                 @"NSCalendarUnitMonth",    //共有12个月
                                 @"NSCalendarUnitDay",      //一个月有28~31天， 农历29~30
                                 @"NSCalendarUnitHour",     //一天有24小时
                                 @"NSCalendarUnitMinute",   //一小时有60分钟
                                 @"NSCalendarUnitSecond",   //一分钟有60秒
                                 @"NSCalendarUnitWeek",     //一年有 52~53周， 农历50~55
                                 @"NSCalendarUnitWeekday",  //一星期有七天
                                 @"NSCalendarUnitWeekdayOrdinal",
                                 @"NSCalendarUnitQuarter",  //一年有四季
                                 @"NSCalendarUnitWeekOfMonth",//一个月有 4~6 周
                                 @"NSCalendarUnitWeekOfYear",//一年有 52~53周， 农历50~55
                                 @"NSCalendarUnitYearForWeekOfYear"
                                 ];
    
    NSDate* startOfDayDate = [calendar startOfDayForDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    
    
    //当天的起始时间戳
    NSTimeInterval startDayTimestamp=[startOfDayDate timeIntervalSince1970];
    NSLog(@"起始时间：%@， 时间戳：%.1f", startOfDayDate, startDayTimestamp);
    
    //每个时间的最大最小 组成
    for (NSInteger i = 1; i<= calendarUnitStr.count; i++) {
        NSInteger calendarUnit = 1<<i;
        //最小
        NSRange min = [calendar minimumRangeOfUnit:calendarUnit];
        //最大
        NSRange max = [calendar maximumRangeOfUnit:calendarUnit];
        
        NSLog(@"type:%@  min:%ld, max:%ld", calendarUnitStr[i-1], min.length, max.length);
    }
    
    NSDate* julyDate = [NSDate dateWithTimeIntervalSince1970:[TimeTools getTimestampFromTime:@"2017-07-01" dateType:@"yyyy-MM-dd"]];
    
    //一个月里面含有多少天
    NSRange dayNum = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:julyDate];
    
    //一个月里面有几周
    NSRange weekNum = [calendar rangeOfUnit:NSCalendarUnitWeekOfMonth inUnit:NSCalendarUnitMonth forDate:julyDate];
    
    //当月一号 是星期几: 1~7  表示：周日、周一、~周六
    NSInteger weekday = [calendar component:NSCalendarUnitWeekday fromDate:julyDate];
    
    
    NSLog(@"..dayNum:%ld, weekNum:%ld, weekDay:%ld", dayNum.length, weekNum.length, weekday);
}


@end
