//
//  BrokeTimeChoicePickerView.m
//  Meidebi
//
//  Created by mdb-losaic on 2017/12/4.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "BrokeTimeChoicePickerView.h"

@interface BrokeTimeChoicePickerView()
@property (nonatomic, strong) UIView *containerView;
@end

@implementation BrokeTimeChoicePickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         self.frame = [UIScreen mainScreen].bounds;
        [self configurUI];
    }
    return self;
}

- (void)configurUI{
    
    _containerView = [UIView new];
    [self addSubview:_containerView];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.offset(280);
    }];
    _containerView.backgroundColor = [UIColor whiteColor];
    UIDatePicker *pickerView = [[UIDatePicker alloc] init];
    [_containerView addSubview:pickerView];
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_containerView);
        make.top.equalTo(_containerView.mas_top).offset(28);
    }];
    pickerView.datePickerMode = UIDatePickerModeTime;
    
}

- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)dismis{
    [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismis];
}

@end
