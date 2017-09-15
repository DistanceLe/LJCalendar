
//
//  LJCalendarView.m
//  LJCalendar
//
//  Created by LiJie on 2017/9/12.
//  Copyright © 2017年 LiJie. All rights reserved.
//

#import "LJCalendarView.h"
#import "TimeTools.h"

#import "LJCalendarPageCell.h"

@interface LJCalendarView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *calendarCollectionView;

@property(nonatomic, strong)NSMutableArray* dateArray;
@property(nonatomic, strong)NSMutableArray* dateStringArray;

@property(nonatomic, strong)NSString* todayDateStr;
@property(nonatomic, assign)NSInteger todayIndex;

@property(nonatomic, assign)NSInteger selectIndex;
@property(nonatomic, assign)NSInteger selectDayNum;
@property(nonatomic, strong)NSString* selectDateStr;

@property(nonatomic, strong)NSString* currentDateStr;

@end

@implementation LJCalendarView

-(void)awakeFromNib{
    [super awakeFromNib];
}

+(instancetype)getCalendarWithFrame:(CGRect)frame{
    LJCalendarView* calendarView = (LJCalendarView*)[[[NSBundle bundleForClass:[LJCalendarView class]]loadNibNamed:NSStringFromClass([LJCalendarView class]) owner:nil options:nil]lastObject];
    
    calendarView.frame = frame;
    [calendarView refreshFlowLayout];
    [calendarView initData:[NSDate date]];
    
    return calendarView;
}

-(void)setShowChineseCalendar:(BOOL)showChineseCalendar{
    _showChineseCalendar = showChineseCalendar;
    [self.calendarCollectionView reloadData];
}

/**  显示今天的日历 */
-(void)showToday{
    [self initData:[NSDate date]];
}

/**  显示到设置的日期 */
-(void)setCustomDate:(NSDate*)date{
    [self initData:date];
}

-(void)refreshFlowLayout{
    _showChineseCalendar = YES;
    
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-25);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.calendarCollectionView.delegate = self;
    self.calendarCollectionView.dataSource = self;
    self.calendarCollectionView.prefetchingEnabled = NO;
    self.calendarCollectionView.collectionViewLayout = flowLayout;
    [self.calendarCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LJCalendarPageCell class]) bundle:[NSBundle bundleForClass:[LJCalendarPageCell class]]] forCellWithReuseIdentifier:@"cell"];
}

-(void)initData:(NSDate*)date{
    self.dateArray = [NSMutableArray array];
    self.dateStringArray = [NSMutableArray array];
    self.todayIndex = [TimeTools getDayWithDate:[NSDate date]];
    self.selectIndex = [TimeTools getDayWithDate:date];
    self.selectDayNum = self.selectIndex;
    
    //当前的 年月
    self.currentDateStr = [TimeTools timestamp:date.timeIntervalSince1970 changeToTimeType:@"yyyy-MM"];
    self.todayDateStr = [TimeTools getCurrentTimesType:@"yyyy-MM"];
    [self.dateStringArray addObject:self.currentDateStr];
    
    //当前月 一号的时间
    NSDate* currentDate = [NSDate dateWithTimeIntervalSince1970:[TimeTools getTimestampFromTime:self.dateStringArray.firstObject dateType:@"yyyy-MM"]];
    [self.dateArray addObject:[self getDataFromDate:currentDate]];
    self.selectIndex += ([self.dateArray.firstObject[2] integerValue] -2);
    self.selectDateStr = self.currentDateStr;
    
    //今天的 index
    NSString* todayStr = [TimeTools timestamp:[NSDate date].timeIntervalSince1970 changeToTimeType:@"yyyy-MM"];
    NSArray* todayArray = [self getDataFromDate:[NSDate dateWithTimeIntervalSince1970:[TimeTools getTimestampFromTime:todayStr dateType:@"yyyy-MM"]]];
    self.todayIndex += ([todayArray[2] integerValue] - 2);
    
    //添加上一个月的数据
    [self addPreviousDataFromDateStr:nil];
    
    [self.calendarCollectionView reloadData];
    
    //加载下一个月的数据
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addNextDataFromDateStr:nil];
        [self scrollCurrentIndex];
    });
    [self scrollCurrentIndex];
    
    //第一次回调，的日期
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.dateHandler) {
            self.dateHandler(self.currentDateStr, date, [NSString stringWithFormat:@"%@-%ld", self.selectDateStr, self.selectDayNum]);
        }
    });
}

/**  获取一个月的日历信息 */
-(NSArray*)getDataFromDate:(NSDate*)date{
    NSInteger dayNum = [TimeTools getMonthDayNumFromDate:date];
    NSInteger weekNum = [TimeTools getMonthWeekNumFromDate:date];
    NSInteger weekday = [TimeTools getWeekdayFromDate:date];
    
    NSArray* chineseDate = [TimeTools getChineseDateFromDate:date dayNumOfMonth:dayNum];
    
    //         总天数，     总周数，   第一天的星期数, 农历信息
    return @[@(dayNum), @(weekNum), @(weekday), chineseDate];
}

/**  添加下一个月的数据 */
-(void)addNextDataFromDateStr:(NSString*)dateStr{
    double timestamp = [TimeTools getTimestampFromTime:self.dateStringArray.lastObject dateType:@"yyyy-MM"];
    NSInteger dayNum = [self.dateArray.lastObject[0] integerValue];
    timestamp += dayNum*24*60*60;
    
    NSDate* nextDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
    [self.dateStringArray addObject:[TimeTools timestamp:timestamp changeToTimeType:@"yyyy-MM"]];
    [self.dateArray addObject:[self getDataFromDate:nextDate]];
    
    [self.calendarCollectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:(self.dateArray.count-1) inSection:0]]];
}

/**  添加上一个月的数据 */
-(void)addPreviousDataFromDateStr:(NSString*)dateStr{
    double timestamp = [TimeTools getTimestampFromTime:self.dateStringArray.firstObject dateType:@"yyyy-MM"];
    timestamp -= 24*60*60;
    if (timestamp > 0) {
        NSString* previousStr = [TimeTools timestamp:timestamp changeToTimeType:@"yyyy-MM"];
        timestamp = [TimeTools getTimestampFromTime:previousStr dateType:@"yyyy-MM"];
        
        NSDate* nextDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
        [self.dateStringArray insertObject:previousStr atIndex:0];
        [self.dateArray insertObject:[self getDataFromDate:nextDate] atIndex:0];
    }
}

-(void)scrollCurrentIndex{
    NSInteger index = [self.dateStringArray indexOfObject:self.currentDateStr];
    
    self.calendarCollectionView.contentOffset = CGPointMake(CGRectGetWidth(self.calendarCollectionView.bounds)*index, 0);
    
//    [self.calendarCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

#pragma mark - ================ Delegate ==================

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dateArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LJCalendarPageCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.showChineseCalendar = self.showChineseCalendar;
    if ([self.dateStringArray[indexPath.item] isEqualToString:self.todayDateStr]) {
        [cell setTodayIndex:self.todayIndex];
        //cell.selectIndex = self.todayIndex;
    }else{
        [cell setTodayIndex:-1];
    }
    
    [cell refreshCell:self.dateArray[indexPath.item]];
    
    //设置 用户手动设置的日期
    if (self.selectIndex >= 0 && [self.dateStringArray[indexPath.item] isEqualToString:self.selectDateStr]) {
        [cell setCustomSelectIndex:self.selectIndex];
        //self.selectIndex = -1;
    }else{
        [cell setCustomSelectIndex:-1];
    }
    
    __weak typeof(self) tempWeakSelf=self;
    
    //点击的回调
    cell.tapHandler = ^(NSInteger index) {
        //点击的日期 时间戳
        tempWeakSelf.selectIndex = index;
        tempWeakSelf.selectDateStr = tempWeakSelf.currentDateStr;
        
        NSInteger dayNum = index - [tempWeakSelf.dateArray[indexPath.item][2] integerValue] + 2;
        NSString* dateStr = [NSString stringWithFormat:@"%@-%ld", tempWeakSelf.currentDateStr, dayNum];
        double timestamp = [TimeTools getTimestampFromTime:dateStr dateType:@"yyyy-MM-dd"];
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:timestamp];
        
        tempWeakSelf.selectDayNum = dayNum;
        if (tempWeakSelf.dateHandler) {
            tempWeakSelf.dateHandler(tempWeakSelf.currentDateStr, date, dateStr);
        }
    };
    
    return cell;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSArray<NSIndexPath *> * indexPaths = [self.calendarCollectionView indexPathsForVisibleItems];
    if (indexPaths.count) {
        NSIndexPath* visible = indexPaths.firstObject;
        self.currentDateStr = self.dateStringArray[visible.item];
        
        //加载前面一个月的数据
        if (visible.item == 0) {
            [self addPreviousDataFromDateStr:nil];
            
            [self.calendarCollectionView reloadData];
            [self scrollCurrentIndex];
        }
        //加载后面一个月的数据
        if (visible.item == self.dateStringArray.count-1) {
            [self addNextDataFromDateStr:nil];
        }
        //回调新的一个月
        if (self.dateHandler) {
            double timestamp = [TimeTools getTimestampFromTime:self.currentDateStr dateType:@"yyyy-MM"];
            NSDate* date = [NSDate dateWithTimeIntervalSince1970:timestamp];
            self.dateHandler(self.currentDateStr, date, [NSString stringWithFormat:@"%@-%ld", self.selectDateStr, self.selectDayNum]);
        }
    }
}



@end
