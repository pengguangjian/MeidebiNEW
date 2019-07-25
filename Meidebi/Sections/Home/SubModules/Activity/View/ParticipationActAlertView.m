//
//  ParticipationActAlertView.m
//  Meidebi
//
//  Created by mdb-admin on 2017/10/13.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "ParticipationActAlertView.h"
static NSString *const kName = @"name";
static NSString *const kImage = @"image";
@interface ParticipationActAlertView ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSArray *shareItems;
@end

@implementation ParticipationActAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    [self addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.left.equalTo(self.mas_left).offset(20);
        make.right.equalTo(self.mas_right).offset(-20);
    }];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.containerView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.containerView);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [closeBtn setImage:[UIImage imageNamed:@"black_close_ico"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(respondsToCloseBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *headerImageView = [UIImageView new];
    [self.containerView addSubview:headerImageView];
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_top).offset(27);
        make.centerX.equalTo(self.containerView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    headerImageView.contentMode = UIViewContentModeScaleAspectFit;
    headerImageView.image = [UIImage imageNamed:@"reg_successs"];
    
    
    UILabel *titleLabel = [UILabel new];
    [self.containerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerImageView.mas_bottom).offset(30);
        make.left.equalTo(self.containerView.mas_left).offset(15);
        make.right.equalTo(self.containerView.mas_right).offset(-15);
    }];
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:14.f];
    titleLabel.textColor = [UIColor colorWithHexString:@"#555555"];
    titleLabel.text = @"参与成功！\n分享给好友，一起来参与活动吧.";
    
    NSMutableArray *arr = @[].mutableCopy;
    for (int i = 0; i < self.shareItems.count; i++) {
        UIControl *control = [self setupHandleElementWithName:self.shareItems[i][kName] icon:self.shareItems[i][kImage]];
        control.tag = 10000+i;
        [self.containerView addSubview:control];
        [control addTarget:self action:@selector(respondsToBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [arr addObject:control];
    }
    [arr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:20 leadSpacing:20 tailSpacing:20];
    [arr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(30);
    }];
    UIButton *lastBtn = arr.firstObject;
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastBtn.mas_bottom).offset(15);
    }];
}
- (void)show{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
}

- (void)dismiss{
    [self removeFromSuperview];
}

- (void)respondsToCloseBtnEvent:(UIButton *)sender{
    [self dismiss];
}

- (void)respondsToBtnEvent:(UIControl *)sender{
    ActAlertHandleShareType type;
    switch (sender.tag) {
        case ActAlertHandleShareTypeWeChat:
            type = ActAlertHandleShareTypeWeChat;
            break;
        case ActAlertHandleShareTypeWeMoments:
            type = ActAlertHandleShareTypeWeMoments;
            break;
        case ActAlertHandleShareTypeQQ:
            type = ActAlertHandleShareTypeQQ;
            break;
        case ActAlertHandleShareTypeSinaWeibo:
            type = ActAlertHandleShareTypeSinaWeibo;
            break;
        default:
            type = ActAlertHandleShareTypeSinaWeibo;
            break;
    }
    if ([self.delegate respondsToSelector:@selector(shareAlertViewDidClickedShareButtonAtType:)]) {
        [self.delegate shareAlertViewDidClickedShareButtonAtType:type];
    }
    [self dismiss];
}

- (UIControl *)setupHandleElementWithName:(NSString *)name
                                     icon:(UIImage *)icon{
    UIControl *control = [UIControl new];
    control.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [UIImageView new];
    [control addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(control.mas_centerX);
        make.top.equalTo(control.mas_top).offset(10);
        make.left.equalTo(control.mas_left).offset(10);
        make.right.equalTo(control.mas_right).offset(-10);
        make.height.equalTo(imageView.mas_width);
    }];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = icon;
    
    UILabel *nameLabel = [UILabel new];
    [control addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(10);
        make.centerX.equalTo(control.mas_centerX);
    }];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:12.f];
    nameLabel.textColor = [UIColor colorWithHexString:@"#BEBEBE"];
    nameLabel.text = name;
    [control mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(nameLabel.mas_bottom);
    }];
    return control;
}

#pragma mark - getters and setters
- (UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.layer.masksToBounds = YES;
        _containerView.layer.cornerRadius = 5;
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}

- (NSArray *)shareItems{
    if (!_shareItems) {
        _shareItems = @[@{kName:@"微信好友",
                         kImage:[UIImage imageNamed:@"invite_weChat"]},
                        @{kName:@"新浪微博",
                           kImage:[UIImage imageNamed:@"invite_sinaWeibo"]},
                         @{kName:@"朋友圈",
                            kImage:[UIImage imageNamed:@"invite_weMoments"]},
                          @{kName:@"QQ好友",
                             kImage:[UIImage imageNamed:@"invite_tencentQQ"]}];
    }
    return _shareItems;
}

@end
