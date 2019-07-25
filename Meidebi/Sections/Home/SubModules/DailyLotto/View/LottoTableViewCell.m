//
//  LottoTableViewCell.m
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/8/28.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "LottoTableViewCell.h"
#import "MDB_UserDefault.h"
@interface LottoTableViewCell ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *prizeLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@end

@implementation LottoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    _avatarImageView = [UIImageView new];
    [self.contentView addSubview:_avatarImageView];
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    _avatarImageView.layer.masksToBounds = YES;
    _avatarImageView.layer.cornerRadius = 36/2.f;
    
    _dateLabel = [UILabel new];
    [self.contentView addSubview:_dateLabel];
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
    }];
    _dateLabel.font = [UIFont systemFontOfSize:13.f];
    _dateLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _dateLabel.textAlignment = NSTextAlignmentRight;

    _prizeLabel = [UILabel new];
    [self.contentView addSubview:_prizeLabel];
    [_prizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(_dateLabel.mas_left).offset(-10);
    }];
    _prizeLabel.font = [UIFont systemFontOfSize:13.f];
    _prizeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    
    _nameLabel = [UILabel new];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(_avatarImageView.mas_right).offset(13);
        make.right.equalTo(_prizeLabel.mas_left).offset(-10);
    }];
    _nameLabel.font = [UIFont systemFontOfSize:13.f];
    _nameLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    [_nameLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_dateLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_nameLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_dateLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)bindDataWithModel:(NSDictionary *)model{
    if (!model) return;
    [[MDB_UserDefault defaultInstance] setViewWithImage:_avatarImageView url:[NSString nullToString:model[@"photo"]]];
    _nameLabel.text = [NSString nullToString:model[@"username"]];
    _prizeLabel.text = [NSString nullToString:model[@"prize"]];
    _dateLabel.text = [NSString stringWithFormat:@"%@",[MDB_UserDefault CalDateIntervalFromData:[NSDate dateWithTimeIntervalSince1970:[[NSString nullToString:model[@"createtime"]] integerValue]] endDate:[NSDate date] ]];
}


@end
