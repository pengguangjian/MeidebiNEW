//
//  InviteFriendListTableViewCell.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/22.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "InviteFriendListTableViewCell.h"

@interface InviteFriendListTableViewCell ()

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *accountLabel;
@property (nonatomic, strong) UILabel *statusLabel;

@end

@implementation InviteFriendListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    _accountLabel = [UILabel new];
    [self.contentView addSubview:_accountLabel];
    [_accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];
    _accountLabel.font = [UIFont systemFontOfSize:13.f];
    _accountLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    _accountLabel.textAlignment = NSTextAlignmentCenter;
    
    _timeLabel = [UILabel new];
    [self.contentView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(18);
        make.centerY.equalTo(_accountLabel.mas_centerY);
    }];
    _timeLabel.font = _accountLabel.font;
    _timeLabel.textColor = _accountLabel.textColor;
    
    _statusLabel = [UILabel new];
    [self.contentView addSubview:_statusLabel];
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-28);
        make.centerY.equalTo(_accountLabel.mas_centerY);
    }];
    _statusLabel.font = _accountLabel.font;
    _statusLabel.textColor = _accountLabel.textColor;
    _statusLabel.textAlignment = NSTextAlignmentRight;
}

- (void)bindDataWithModel:(NSDictionary *)model{
    if (!model) return;
    _accountLabel.text = [NSString nullToString:model[@"username"]];
    _timeLabel.text = [NSString nullToString:model[@"createtime"]];
    if ([[NSString stringWithFormat:@"%@",[NSString nullToString:model[@"is_register"]]] isEqualToString:@"1"]) {
        _statusLabel.text = @"注册会员";
    }else{
        _statusLabel.text = @"未注册";
    }
}


@end
