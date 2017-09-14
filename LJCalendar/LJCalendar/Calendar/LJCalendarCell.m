//
//  LJCalendarCell.m
//  LJCalendar
//
//  Created by LiJie on 2017/9/12.
//  Copyright © 2017年 LiJie. All rights reserved.
//

#import "LJCalendarCell.h"

@interface LJCalendarCell ()

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *todayBackView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *todayBackWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateNumCenterOffest;

@end

@implementation LJCalendarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.dateNumLabel.layer.cornerRadius = 14;
    self.todayBackView.hidden = YES;
    self.todayBackView.layer.cornerRadius = 18;
    self.todayBackWidthConstraint.constant = 0;
    self.todayBackView.layer.borderWidth = 1;
    self.todayBackView.layer.borderColor = self.backView.backgroundColor.CGColor;
    self.todayBackView.backgroundColor = [UIColor whiteColor];
    
    self.backView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0, 0);
    self.backView.layer.cornerRadius = 18;
}

-(void)setHasChineseCalendar:(BOOL)hasChineseCalendar{
    _hasChineseCalendar = hasChineseCalendar;
    if (hasChineseCalendar) {
        self.dateNumCenterOffest.constant = -10;
        self.chineseNumLabel.hidden = NO;
        
    }else{
        self.dateNumCenterOffest.constant = 0;
        self.chineseNumLabel.hidden = YES;
    }
}

/**  设置是否是今天 */
-(void)setIsToday:(BOOL)isToday{
    if (isToday) {
        self.todayBackView.hidden = NO;
        self.todayBackWidthConstraint.constant = 36;
    }else{
        self.todayBackView.hidden = YES;
        self.todayBackWidthConstraint.constant = 0;
    }
}

-(void)setIsWeekend:(BOOL)isWeekend{
    if (isWeekend) {
        self.dateNumLabel.textColor = [UIColor colorWithRed:0.8 green:0.2 blue:0.2 alpha:1];
    }else{
        self.dateNumLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    }
    self.chineseNumLabel.textColor = self.dateNumLabel.textColor;
}

-(void)tapCell:(BOOL)animation{
    
    self.isTap = YES;
    if (animation) {
        [UIView animateWithDuration:0.45 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.backViewWidthConstraint.constant = 36;
            self.backView.transform = CGAffineTransformIdentity;
            [self layoutIfNeeded];
        } completion:nil];
    }else{
        self.backViewWidthConstraint.constant = 36;
        self.backView.transform = CGAffineTransformIdentity;
    }
}

-(void)cancelTap:(BOOL)animation{
    self.isTap = NO;
    if (animation) {
        [UIView animateWithDuration:0.45 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.backViewWidthConstraint.constant = 30;
            self.backView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0, 0);
            [self layoutIfNeeded];
        } completion:nil];
    }else{
        self.backViewWidthConstraint.constant = 30;
        self.backView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0, 0);
    }
    
}




@end
