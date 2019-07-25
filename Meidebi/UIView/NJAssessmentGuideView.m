//
//  NJAssessmentGuideView.m
//  Meidebi
//
//  Created by mdb-admin on 16/6/1.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "NJAssessmentGuideView.h"
#import <YYKit/UIImage+YYAdd.h>
@interface NJAssessmentGuideView ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIWindow *keyWindow;

@end

@implementation NJAssessmentGuideView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    self.frame = CGRectMake(0, 0, BOUNDS_WIDTH, BOUNDS_HEIGHT);
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];

    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.left.equalTo(self.mas_left).offset(20);
        make.right.equalTo(self.mas_right).offset(-20);
    }];
    
    UIImageView *headerImageView = [UIImageView new];
    [self.contentView addSubview:headerImageView];
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(20);
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.height.offset(200);
    }];
    headerImageView.contentMode = UIViewContentModeScaleAspectFit;
    headerImageView.image = [UIImage imageNamed:@"assessmentGuide"];
    
    
    UILabel *titleLabel = [UILabel new];
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerImageView.mas_bottom).offset(20);
        make.left.right.equalTo(self.contentView);
    }];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16.f];
    titleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    titleLabel.text = @"需要你的支持和鼓励，么么哒";
    
    UIView *linView = [UIView new];
    [self.contentView addSubview:linView];
    [linView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(titleLabel.mas_bottom).offset(25);
        make.size.mas_equalTo(CGSizeMake(1, 45));
    }];
    linView.backgroundColor = [UIColor colorWithHexString:@"#d0d0d0"];
    UIView *lineView1 = [UIView new];
    [self.contentView addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(linView.mas_top);
        make.height.offset(1);
    }];
    lineView1.backgroundColor = [UIColor colorWithHexString:@"#d0d0d0"];
    
    
    UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:likeBtn];
    [likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView1.mas_bottom);
        make.left.equalTo(linView.mas_right);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(linView.mas_height);
    }];
    likeBtn.tag = 11;
    [likeBtn setTitle:@"给个好评" forState:UIControlStateNormal];
    [likeBtn setTitleColor:[UIColor colorWithHexString:@"#e2574c"] forState:UIControlStateNormal];
    [likeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [likeBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [likeBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ff5e42"]] forState:UIControlStateHighlighted];
    [likeBtn addTarget:self action:@selector(respondsToBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *noLikeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:noLikeBtn];
    [noLikeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView1.mas_bottom);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(linView.mas_left);
        make.height.equalTo(linView.mas_height);
    }];
    noLikeBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [noLikeBtn setTitle:@"残忍拒绝" forState:UIControlStateNormal];
    [noLikeBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [noLikeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [noLikeBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [noLikeBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ff5e42"]] forState:UIControlStateHighlighted];
    noLikeBtn.tag = 22;
    [noLikeBtn addTarget:self action:@selector(respondsToBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(noLikeBtn.mas_bottom);
    }];
}


- (void)show{
    _keyWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, kMainScreenH)];
    _keyWindow.backgroundColor = [UIColor clearColor];
    _keyWindow.windowLevel = UIWindowLevelStatusBar;
    [_keyWindow addSubview:self];
    [_keyWindow makeKeyAndVisible];
}

- (void)dismiss{
    [self removeFromSuperview];
    _keyWindow.hidden = YES;
    _keyWindow = nil;
}


- (void)respondsToBtnEvent:(id)sender{
    UIButton *button = (UIButton *)sender;
    if (button.tag == 11) {
        if ([self.delegate respondsToSelector:@selector(assessmentGuideViewDidPressLinkBtn)]) {
            [self.delegate assessmentGuideViewDidPressLinkBtn];
        }
    }

    [self dismiss];
}

#pragma mark - getters and setters
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 5;
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}
@end

