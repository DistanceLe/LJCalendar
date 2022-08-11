//
//  LJCalendarPageCell.m
//  LJCalendar
//
//  Created by LiJie on 2017/9/12.
//  Copyright © 2017年 LiJie. All rights reserved.
//

#import "LJCalendarPageCell.h"
#import "LJCalendarCell.h"
#import "TimeTools.h"

@interface LJCalendarPageCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic, assign)NSInteger itemNum;
@property(nonatomic, assign)NSInteger firstWeekDay;

@property(nonatomic, assign)NSInteger itemWidth;
@property(nonatomic, assign)NSInteger itemHeight;

@property(nonatomic, strong)NSArray* chineseData;

@end

@implementation LJCalendarPageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerNib:
     [UINib nibWithNibName:NSStringFromClass([LJCalendarCell class]) bundle:[NSBundle bundleForClass:[LJCalendarCell class]]]
          forCellWithReuseIdentifier:@"cell"];
//    self.backgroundColor = [UIColor clearColor];
//    self.backgroundView.backgroundColor = [UIColor clearColor];
}

-(void)refreshFlowLayout:(NSInteger)lineNum{
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    _itemWidth = CGRectGetWidth(self.frame)/7.0;
    _itemHeight = (CGRectGetHeight(self.frame)-8)/lineNum/1.0;
    
    UICollectionViewFlowLayout* flowLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    if (!flowLayout) {
        flowLayout = [[UICollectionViewFlowLayout alloc]init];
    }
    
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 0, 3, 0);
    flowLayout.itemSize = CGSizeMake(_itemWidth, _itemHeight);
//    self.collectionView.collectionViewLayout = flowLayout;
    [self.collectionView setCollectionViewLayout:flowLayout animated:NO];
}

-(void)refreshCell:(NSArray *)array{
    
    [self refreshFlowLayout:[array[1] integerValue]];
    
    self.itemNum = [array[0] integerValue];
    self.firstWeekDay = [array[2] integerValue];
    
    if (self.todayIndex < 0) {
        self.selectIndex = [array[2] integerValue]-1;
    }
    self.chineseData = [NSArray arrayWithArray:array.lastObject];
}

-(void)setCustomSelectIndex:(NSInteger)index{
    self.selectIndex = index;
    [self.collectionView reloadData];
}

#pragma mark - ================ Delegate ==================

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.itemNum + self.firstWeekDay -1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LJCalendarCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    {//根据frame 设置字体大小
        CGFloat minSize = MIN(_itemWidth, _itemHeight); //53 -> 23 11
        CGFloat dateFontSize = 23;
        CGFloat chineseFontSize = 11;
        CGFloat labelWidth = 30;
        if (minSize < 53 && minSize >= 25) {
            chineseFontSize -= (53-minSize)/4.0;
            dateFontSize -= (53-minSize)/4.0;
            labelWidth -= (53-minSize)/2.8;
            
        }else if (minSize < 25){
            chineseFontSize -= 8;
            dateFontSize -= 8;
            labelWidth -= 10;
        }
        cell.chineseNumLabel.font = [UIFont systemFontOfSize:chineseFontSize];
        cell.dateNumLabel.font = [UIFont systemFontOfSize:dateFontSize];
        cell.dateLabelWidth.constant = labelWidth;
    }

    cell.hasChineseCalendar = self.showChineseCalendar;
    if (indexPath.item < self.firstWeekDay-1) {
        //最前面的几天是空的。
        cell.contentView.hidden = YES;
    }else{
        //从星期几(firstWeekDay)开始 显示
        cell.contentView.hidden = NO;
        
        if (!self.showLastLine) {
            NSInteger lastCount = ((self.itemNum + self.firstWeekDay -1)%7);
            lastCount = lastCount>0?lastCount:7;
            
            if ((indexPath.item+lastCount) >= (self.itemNum + self.firstWeekDay -1)) {
                cell.bottomLine.hidden = YES;
            }else{
                cell.bottomLine.hidden = NO;
            }
        }else{
            cell.bottomLine.hidden = NO;
        }
        
        
        NSInteger dayNum = indexPath.item-self.firstWeekDay+2;
        //新历几号
        cell.dateNumLabel.text = [@(dayNum) stringValue];
        
        //显示农历日期
        NSInteger i = 0;
        NSInteger totalDayNum = [self.chineseData.firstObject[0] integerValue];
        NSArray* chineseDate = self.chineseData.firstObject;//总的天数，当月的有效天数，第一天的日期，月份
        while (totalDayNum < dayNum) {
            i++;
            totalDayNum = [self.chineseData[i][0] integerValue];
            chineseDate = self.chineseData[i];
        }
        NSInteger startDay = [chineseDate[2] integerValue];
        NSInteger startNum = [chineseDate[0] integerValue] - [chineseDate[1] integerValue];
        NSInteger interval = dayNum - startNum;
        if (interval == 1 && startDay ==1) {
            NSString* month = [TimeTools getChineseMonthString:[chineseDate[3] integerValue]];
            cell.chineseNumLabel.text = month;
        }else{
            startDay = startDay+interval-1;
            NSString* day = [TimeTools getChineseDayString:startDay];
            cell.chineseNumLabel.text = day;
        }
        
        //判断是否在有效日期中：
        BOOL isValid = YES;
        if (self.minDate && self.maxDate) {
            NSString* dateStr = [NSString stringWithFormat:@"%@-%ld", self.currentYearAndMonth, dayNum];
            double timestamp = [TimeTools getTimestampFromTime:dateStr dateType:@"yyyy-MM-dd"];
            if (timestamp < self.minDate.timeIntervalSince1970 ||
                timestamp > self.maxDate.timeIntervalSince1970) {
                isValid = NO;
            }
        }
        
        
        //周末 改变对应的颜色
        if ((indexPath.item+1) % 7 == 0 || indexPath.item % 7 == 0) {
            [cell setIsWeekend:YES isValid:isValid];
        }else{
            [cell setIsWeekend:NO isValid:isValid];
        }
        
        //是否是今天的日期，特殊标志
        [cell setIsToday:NO];
        if (self.todayIndex == indexPath.item) {
            [cell setIsToday:YES];
        }
        
        //是否选中
        if (self.selectIndex == indexPath.item) {
            if (!cell.isTap) {
                [cell tapCell:NO];
            }
        }else{
            if (cell.isTap) {
                [cell cancelTap:NO];
            }
        }
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.selectIndex == indexPath.item) {
        return;
    }
    LJCalendarCell* tapCell = (LJCalendarCell*)[collectionView cellForItemAtIndexPath:indexPath];
    if (!tapCell.isValid) {
        return;
    }
    
    if (self.selectIndex >= 0) {
        LJCalendarCell* cell = (LJCalendarCell*)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectIndex inSection:0]];
        if (cell) {
            [cell cancelTap:YES];
        }
    }
    
    
    [tapCell tapCell:YES];
    self.selectIndex = indexPath.item;
    if (self.tapHandler) {
        self.tapHandler(self.selectIndex);
    }
}



@end
