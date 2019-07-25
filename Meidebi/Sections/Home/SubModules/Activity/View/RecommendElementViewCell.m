//
//  RecommendElementViewCell.m
//  Meidebi
//
//  Created by mdb-admin on 2017/5/12.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "RecommendElementViewCell.h"
#import "MDB_UserDefault.h"
@interface RecommendElementViewCell ()

@property (nonatomic, strong) UIImageView *activityIconImageView;
@property (nonatomic, strong) NSArray *avatars;
@property (nonatomic, strong) HomeActivitieViewModel *elementModel;
@property (nonatomic, strong) UILabel *attendNumberLabel;
@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *personalInfoView;
@property (nonatomic, strong) UIImageView *activityStateBgImageView;
@end

@implementation RecommendElementViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    
    UIView *personalInfoView = [UIView new];
    [self.contentView addSubview:personalInfoView];
    [personalInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    _personalInfoView = personalInfoView;
    
    UIImageView *lastAvatarImageView = nil;
    CGFloat avatarHeight = IS_IPHONE_WIDE_SCREEN ? 20.f : 16.f;
    for (NSInteger i = 0; i < self.avatars.count; i++) {
        UIImageView *avatarImageView = self.avatars[i];
        [personalInfoView addSubview:avatarImageView];
        [avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(personalInfoView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(avatarHeight, avatarHeight));
            if (lastAvatarImageView) {
                make.left.equalTo(lastAvatarImageView.mas_right).offset(2);
            }else{
                make.left.equalTo(personalInfoView.mas_left).offset(8);
            }
            make.bottom.equalTo(personalInfoView.mas_bottom);
        }];
        avatarImageView.layer.masksToBounds = YES;
        avatarImageView.layer.cornerRadius = avatarHeight/2;
        lastAvatarImageView = avatarImageView;
    }
    
    _attendNumberLabel = [UILabel new];
    [personalInfoView addSubview:_attendNumberLabel];
    [_attendNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lastAvatarImageView.mas_right).offset(3);
        make.right.equalTo(personalInfoView.mas_right).offset(-8);
        make.centerY.equalTo(lastAvatarImageView.mas_centerY);
    }];
    
    UIView *firstAvaterView = (UIImageView *)self.avatars.firstObject;
    [personalInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(firstAvaterView.mas_height);
        make.left.equalTo(firstAvaterView.mas_left);
        make.right.equalTo(_attendNumberLabel.mas_right);
    }];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(8);
        make.right.equalTo(self.contentView.mas_right).offset(-8);
        make.bottom.equalTo(_attendNumberLabel.mas_top).offset(-9);
        make.height.equalTo(@14);
    }];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel = titleLabel;
    
    _activityIconImageView = [UIImageView new];
    [self.contentView addSubview:_activityIconImageView];
    [_activityIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(4);
        make.left.equalTo(self.contentView.mas_left).offset(8);
        make.right.equalTo(self.contentView.mas_right).offset(-8);
        make.bottom.equalTo(titleLabel.mas_top).offset(-10);
    }];
    _activityIconImageView.contentMode = UIViewContentModeScaleAspectFill;
    _activityIconImageView.layer.masksToBounds = YES;
    _activityIconImageView.layer.cornerRadius = 5.f;
    
    _activityStateBgImageView = [UIImageView new];
    [_activityIconImageView addSubview:_activityStateBgImageView];
    [_activityStateBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_activityIconImageView.mas_top).offset(5);
        make.right.equalTo(_activityIconImageView.mas_right).offset(-5);
        make.size.mas_equalTo(CGSizeMake(53, 20));
    }];

}

- (void)bindRecommendElementData:(HomeActivitieViewModel *)model{
    if (!model) return;
    _elementModel = model;
    _titleLabel.text = [NSString nullToString:model.title];
    if (model.status == ActivityStateTypeIng) {
        _activityStateBgImageView.image = [UIImage imageNamed:@"avtivity_ing"];
    }else if (model.status == ActivityStateTypeEnd) {
        _activityStateBgImageView.image = [UIImage imageNamed:@"avtivity_end"];
    }else if (model.status == ActivityStateTypeNoBegin) {
        _activityStateBgImageView.image = [UIImage imageNamed:@"avtivity_no_star"];
    }else{
        _activityStateBgImageView.image = nil;
    }
    NSString *fixedStr = @"人正在参与";
    NSString *numberStr = [NSString nullToString:model.totaluser];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:[numberStr stringByAppendingString:fixedStr]];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor colorWithHexString:@"#F2463A"]
                          range:NSMakeRange(0, numberStr.length)];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor colorWithHexString:@"#666666"]
                          range:NSMakeRange(numberStr.length, fixedStr.length)];
    [attributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:11]
                          range:NSMakeRange(0, numberStr.length+ fixedStr.length)];
    _attendNumberLabel.attributedText = attributedStr.mutableCopy;
    [[MDB_UserDefault defaultInstance] setViewWithImage:_activityIconImageView url:model.imageLink];
    if (model.users.count > 0) {
        UIImageView *lastAvatarImageView = self.avatars[model.users.count-1];
        [_attendNumberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastAvatarImageView.mas_right).offset(3);
            make.right.equalTo(_personalInfoView.mas_right).offset(-8);
            make.centerY.equalTo(lastAvatarImageView.mas_centerY);
        }];
        for (NSInteger i = 0; i < self.avatars.count; i++) {
            UIImageView *avatarImageView = self.avatars[i];
            avatarImageView.hidden = NO;
            if (i>model.users.count-1) {
                avatarImageView.hidden = YES;
            }else{
                HomeUserViewModel *userModel = model.users[i];
                [[MDB_UserDefault defaultInstance] setViewWithImage:avatarImageView url:userModel.avatar];
            }
        }
    }else{
        UIImageView *lastAvatarImageView = self.avatars.firstObject;
        [_attendNumberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastAvatarImageView.mas_left);
            make.right.equalTo(_personalInfoView.mas_right).offset(-8);
            make.centerY.equalTo(lastAvatarImageView.mas_centerY);
        }];
        for (UIImageView *imageView in self.avatars) {
            imageView.hidden = YES;
        }
    }
}

#pragma mark - setters and getters
- (NSArray *)avatars{
    if (!_avatars) {
        NSMutableArray *imageViews = [NSMutableArray array];
        for (NSInteger i = 0; i<4; i++) {
            UIImageView *imageView = [UIImageView new];
            [imageViews addObject:imageView];
        }
        _avatars = imageViews.mutableCopy;
    }
    return _avatars;
}

@end
