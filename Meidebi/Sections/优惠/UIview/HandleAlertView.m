//
//  HandleAlertView.m
//  Meidebi
//
//  Created by mdb-admin on 16/8/3.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "HandleAlertView.h"

@implementation HandleAlertView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
//        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        [self setupSubview];
    }
    return self;
}

- (void)setupSubview{
    UIControl *contairControl = [UIControl new];
    [self addSubview:contairControl];
    [contairControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(20);
        make.left.right.bottom.equalTo(self);
    }];
    contairControl.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [contairControl addTarget:self action:@selector(hiddenAlert) forControlEvents:UIControlEventTouchUpInside];

    UIImageView *iconImageView = [UIImageView new];
    [self addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.offset(150);
    }];
    iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    iconImageView.image = [UIImage imageNamed:@"ios_handle_alert"];
    
}

- (void)showAlert{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
//    [keyWindow sendSubviewToBack:self];
}

- (void)hiddenAlert{
    if ([self.delegate respondsToSelector:@selector(handleAlertViewDidePressDismissBtn)]) {
        [self.delegate handleAlertViewDidePressDismissBtn];
    }
    [self removeFromSuperview];
}

@end
