//
//  NJPushSetAlertView.m
//  Meidebi
//
//  Created by mdb-admin on 16/4/5.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "NJPushSetAlertView.h"

@interface NJPushSetAlertView ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *alertTitleLabel;
@property (nonatomic, strong) UILabel *alertContentLabel;

@end

@implementation NJPushSetAlertView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, BOUNDS_WIDTH, BOUNDS_HEIGHT);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    
    _containerView = ({
        UIView *view = [UIView new];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.left.equalTo(self.mas_left).offset(30);
            make.right.equalTo(self.mas_right).offset(-30);
            make.height.offset(150);
        }];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 5.f;
        view.backgroundColor = [UIColor whiteColor];
        view;
    });

    _alertTitleLabel = ({
        UILabel *label = [UILabel new];
        [_containerView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_containerView).centerOffset(CGPointMake(10, -25));
        }];
        label.text = @"恭喜您，设置成功！";
        label;
    });
    
    UIImageView *imageView = [UIImageView new];
    [_containerView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_alertTitleLabel.mas_centerY);
        make.right.equalTo(_alertTitleLabel.mas_left).offset(-8);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    imageView.image = [UIImage imageNamed:@"icon_correct_80"];
    
    _alertContentLabel = [UILabel new];
    [_containerView addSubview:_alertContentLabel];
    [_alertContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(15);
        make.centerX.equalTo(_containerView.mas_centerX);
        make.left.equalTo(_containerView.mas_left).offset(20);
        make.right.equalTo(_containerView.mas_right).offset(-20);
    }];
    _alertContentLabel.numberOfLines = 0;
    _alertContentLabel.font = [UIFont systemFontOfSize:14.f];
    _alertContentLabel.textColor = [UIColor colorWithRed:0.7797 green:0.7797 blue:0.7797 alpha:1.0];
    _alertContentLabel.text = @"如需更改自定义推送，请前往：“没得比->我的->推送设置”进行修改";
    
}

- (void)show{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss];
    });
}

- (void)dismiss{
    [self removeFromSuperview];
}

#pragma mark - getters and setters
- (void)setAlertTitle:(NSString *)alertTitle{
    _alertTitle = alertTitle;
    _alertTitleLabel.text = _alertTitle;
}

- (void)setAlertContent:(NSString *)alertContent{
    _alertContent = alertContent;
    _alertContentLabel.text = _alertContent;
}

@end
