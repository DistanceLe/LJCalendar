//
//  LJCalendarView.h
//  LJCalendar
//
//  Created by LiJie on 2017/9/12.
//  Copyright © 2017年 LiJie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJCalendarView : UIView

/**  是否显示农历，默认YES 显示 */
@property(nonatomic, assign)BOOL showChineseCalendar;
/**  是否显示 最后一行的线， 默认不显示 */
@property(nonatomic, assign)BOOL showLastLine;


/**  最小 有效的日期 */
@property(nonatomic, strong)NSDate* minDate;
/**  最大 有效的日期 */
@property(nonatomic, strong)NSDate* maxDate;


/**  当前页面显示的 年月， 选中的日期 */
@property(nonatomic, strong)void(^dateHandler)(NSString* currentShowYearAndMonth, NSDate* selectDate, NSString* selectedDateStr);

+(instancetype)getCalendarWithFrame:(CGRect)frame;

-(void)refreshFlowLayout;

/**  显示今天的日历 */
-(void)showToday;

/**  显示到设置的日期 */
-(void)setCustomDate:(NSDate*)date;

@end
