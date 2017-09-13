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

/**  选中某一天的回调 */
@property(nonatomic, strong)void(^tapHandler)(NSInteger index);

-(void)refreshCell:(NSArray*)array;

-(void)setCustomSelectIndex:(NSInteger)index;

@end
