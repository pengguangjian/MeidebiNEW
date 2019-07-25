//
//  ReminderButton.m
//  Meidebi
//
//  Created by mdb-admin on 2017/11/22.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "ReminderButton.h"

@interface ReminderButton()

@property (nonatomic, strong) UIView *reminderView;

@end

@implementation ReminderButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _reminderView = [UIView new];
        [self addSubview:_reminderView];
        _reminderView.backgroundColor = [UIColor redColor];
        _reminderView.layer.masksToBounds = YES;
        _reminderView.layer.cornerRadius = 4;
        _reminderView.hidden = YES;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _reminderView.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame)-10, CGRectGetMinY(self.titleLabel.frame), 8, 8);
}

- (void)showReminder:(BOOL)show{
    _reminderView.hidden = !show;
}

@end
