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

@property(nonatomic, strong)void(^dateHandler)(NSString* dateString, NSDate* date, NSString* selectedDate);

+(instancetype)getCalendarWithFrame:(CGRect)frame;

/**  显示今天的日历 */
-(void)showToday;

/**  显示到设置的日期 */
-(void)setCustomDate:(NSDate*)date;

@end
