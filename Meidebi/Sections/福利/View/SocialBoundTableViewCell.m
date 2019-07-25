//
//  SocialBoundTableViewCell.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/28.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "SocialBoundTableViewCell.h"

@interface SocialBoundTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@end

@implementation SocialBoundTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
        make.size.mas_equalTo(CGSizeMake(23, 23));
    }];
    
    _nameLabel = [UILabel new];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.mas_right).offset(10);
        make.centerY.equalTo(_iconImageView.mas_centerY);
    }];
    _nameLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    _nameLabel.font = [UIFont systemFontOfSize:16.f];
    
    _statusLabel = [UILabel new];
    [self.contentView addSubview:_statusLabel];
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    _statusLabel.textColor = [UIColor colorWithHexString:@"#888888"];
    _statusLabel.font = [UIFont systemFontOfSize:14.f];
    _statusLabel.textAlignment = NSTextAlignmentRight;
}

- (void)bindDataWithModel:(NSDictionary *)dict{
    if (!dict) return;
    _iconImageView.image = dict[kSocialPlatmentImage];
    _nameLabel.text = dict[kSocialPlatmentName];
    BOOL status = [dict[kSocialPlatmentStatus] boolValue];
    if (status) {
        _statusLabel.text = @"已绑定";
    }else{
        _statusLabel.text = @"未绑定";
    }
}
@end
