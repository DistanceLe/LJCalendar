//
//  LJCalendarPageCell.h
//  LJCalendar
//
//  Created by LiJie on 2017/9/12.
//  Copyright © 2017年 LiJie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJCalendarPageCell : UICollectionViewCell

 /**  当前选中的 */
@property(nonatomic, assign)NSInteger selectIndex;
/**  今天的日期 点 */
@property(nonatomic, assign)NSInteger todayIndex;

/**  是否显示农历 */
@property(nonatomic, assign)BOOL showChineseCalendar;

/**  选中某一天的回调 */
@property(nonatomic, strong)void(^tapHandler)(NSInteger index);

/**  刷新一个月的 日历 */
-(void)refreshCell:(NSArray*)array;

/**  设置当前月的选择位置，无选中-1 */
-(void)setCustomSelectIndex:(NSInteger)index;

@end
