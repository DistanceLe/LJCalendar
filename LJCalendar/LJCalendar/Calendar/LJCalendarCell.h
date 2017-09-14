//
//  LJCalendarCell.h
//  LJCalendar
//
//  Created by LiJie on 2017/9/12.
//  Copyright © 2017年 LiJie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJCalendarCell : UICollectionViewCell

/**  新历的日期 */
@property (weak, nonatomic) IBOutlet UILabel *dateNumLabel;
/**  农历的 日期 */
@property (weak, nonatomic) IBOutlet UILabel *chineseNumLabel;

@property (nonatomic, assign)BOOL isTap;
@property (nonatomic, assign)BOOL hasChineseCalendar;

/**  设置是否是今天 */
-(void)setIsToday:(BOOL)isToday;

/**  设置是否是 周末 */
-(void)setIsWeekend:(BOOL)isWeekend;

/**  点击了cell */
-(void)tapCell:(BOOL)animation;

/**  恢复原状 */
-(void)cancelTap:(BOOL)animation;

@end
