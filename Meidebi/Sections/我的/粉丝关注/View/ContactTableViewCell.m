//
//  FansTableViewCell.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/19.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "ContactTableViewCell.h"
#import "MDB_UserDefault.h"
#import "FollowButton.h"
static NSString * const kFollowBtnNormalTitleColor = @"#F35D00";
static NSString * const kFollowBtnCancelTitleColor = @"#888888";

@interface ContactTableViewCell ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nickeLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIImageView *statusBgImageView;
@property (nonatomic, strong) FollowButton *addFollowBtn;
@end

@implementation ContactTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    _iconImageView = [UIImageView new];
    [self.contentView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(61, 61));
    }];
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.layer.cornerRadius = 61.f/2;
    _iconImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClicked:)];
    [_iconImageView addGestureRecognizer:tapGesture];
    
    
    _nickeLabel = [UILabel new];
    [self.contentView addSubview:_nickeLabel];
    [_nickeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_centerY).offset(-4);
        make.left.equalTo(_iconImageView.mas_right).offset(14);
    }];
    _nickeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    _nickeLabel.font = [UIFont systemFontOfSize:14.f];
    
    _timeLabel = [UILabel new];
    [self.contentView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_centerY).offset(4);
        make.left.equalTo(_nickeLabel.mas_left);
    }];
    _timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _timeLabel.font = [UIFont systemFontOfSize:11.f];
    
    _statusBgImageView = [UIImageView new];
    [self.contentView addSubview:_statusBgImageView];
    [_statusBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_iconImageView);
        make.height.offset(21);
    }];
    _statusBgImageView.image = [UIImage imageNamed:@"status_background"];
    
    _statusLabel = [UILabel new];
    [_statusBgImageView addSubview:_statusLabel];
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_statusBgImageView).insets(UIEdgeInsetsMake(7, 5, 10, 5));
    }];
    _statusLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    _statusLabel.font = [UIFont systemFontOfSize:11.f];
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    
    _addFollowBtn = [FollowButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_addFollowBtn];
    [_addFollowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(100, 60));
    }];
    _addFollowBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [_addFollowBtn addTarget:self action:@selector(respondsToBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)bindDataWithModel:(ContactViewModel *)model{
    if (!model) return;
    _model = model;
    [[MDB_UserDefault defaultInstance] setViewWithImage:_iconImageView url:model.avatarLink];
    _nickeLabel.text = model.nickname;
    _timeLabel.text = model.starttime;
    if ([model.standard isEqualToString:@""]) {
        _statusBgImageView.hidden = YES;
    }else{
        _statusBgImageView.hidden = NO;
        _statusLabel.text = model.standard;
    }
    _addFollowBtn.userInteractionEnabled = YES;
    if (_type == ContactTypeFollow) {
        if (model.isFollow) {
            [_addFollowBtn setTitle:@"已关注" forState:UIControlStateNormal];
            [_addFollowBtn setImage:[UIImage imageNamed:@"add_follow_select"] forState:UIControlStateNormal];
            [_addFollowBtn setTitleColor:[UIColor colorWithHexString:kFollowBtnCancelTitleColor] forState:UIControlStateNormal];
        }else{
            [_addFollowBtn setTitle:@"加关注" forState:UIControlStateNormal];
            [_addFollowBtn setImage:[UIImage imageNamed:@"add_follow_normal"] forState:UIControlStateNormal];
            [_addFollowBtn setTitleColor:[UIColor colorWithHexString:kFollowBtnNormalTitleColor] forState:UIControlStateNormal];
        }
    }else{
        if (model.isDirection) {
            [_addFollowBtn setTitle:@"互相关注" forState:UIControlStateNormal];
            [_addFollowBtn setImage:[UIImage imageNamed:@"add_follow_select"] forState:UIControlStateNormal];
            [_addFollowBtn setTitleColor:[UIColor colorWithHexString:kFollowBtnCancelTitleColor] forState:UIControlStateNormal];
            _addFollowBtn.userInteractionEnabled = NO;
        }else{
            [_addFollowBtn setTitle:@"加关注" forState:UIControlStateNormal];
            [_addFollowBtn setImage:[UIImage imageNamed:@"add_follow_normal"] forState:UIControlStateNormal];
            [_addFollowBtn setTitleColor:[UIColor colorWithHexString:kFollowBtnNormalTitleColor] forState:UIControlStateNormal];
        }
    }
}

- (void)respondsToBtnEvent:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(contactTableViewDidClickFollowBtnWithCell:)]) {
        [self.delegate contactTableViewDidClickFollowBtnWithCell:self];
    }
}

- (void)imageViewClicked :(UIGestureRecognizer *)gesture{
    if ([self.delegate respondsToSelector:@selector(avatarImageViewClickedWithCell:)]){
        [self.delegate avatarImageViewClickedWithCell:self];
    }
}
@end
