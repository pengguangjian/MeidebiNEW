//
//  HotShowdanTableViewCell.m
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/6.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "HotShowdanTableViewCell.h"
#import "MDB_UserDefault.h"
@interface HotShowdanTableViewCell ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *avaterImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) NSArray *specialItems;
@property (nonatomic, strong) UILabel *publishNameLabel;
@property (nonatomic, strong) UILabel *likeNumberLabel;
@property (nonatomic, strong) UILabel *collectNumberLabel;
@property (nonatomic, strong) UIImageView *likeIconImageView;
@property (nonatomic, strong) UIImageView *collectIconImageView;
@end

@implementation HotShowdanTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupSubviews{
    _iconImageView = [UIImageView new];
    [self.contentView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.height.equalTo(_iconImageView.mas_width).multipliedBy(0.44);
    }];
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.layer.cornerRadius = 4.f;
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    _nameLabel = [UILabel new];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_iconImageView);
        make.top.equalTo(_iconImageView.mas_bottom).offset(19);
    }];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    _nameLabel.font = [UIFont systemFontOfSize:15.f];
    
    // 精品推荐信息
    UIView *specialInfoView = [UIView new];
    [self.contentView addSubview:specialInfoView];
    [specialInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLabel.mas_bottom).offset(14);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
    
    _publishNameLabel = [UILabel new];
    [specialInfoView addSubview:_publishNameLabel];
    [_publishNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(specialInfoView);
    }];
    _publishNameLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _publishNameLabel.font = [UIFont systemFontOfSize:12.f];
    
    _avaterImageView = [UIImageView new];
    [specialInfoView addSubview:_avaterImageView];
    [_avaterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_publishNameLabel.mas_left).offset(-5);
        make.centerY.equalTo(_publishNameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(23, 23));
    }];
    _avaterImageView.layer.masksToBounds = YES;
    _avaterImageView.layer.cornerRadius = 23/2.f;
    
    _likeIconImageView = [UIImageView new];
    [specialInfoView addSubview:_likeIconImageView];
    [_likeIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_publishNameLabel.mas_right).offset(13);
        make.centerY.equalTo(specialInfoView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    _likeIconImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _likeNumberLabel = [UILabel new];
    [specialInfoView addSubview:_likeNumberLabel];
    [_likeNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_likeIconImageView.mas_right).offset(4);
        make.centerY.equalTo(_likeIconImageView.mas_centerY);
    }];
    _likeNumberLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _likeNumberLabel.font = [UIFont systemFontOfSize:12.f];
    
    UIView *lineView = [UIView new];
    [specialInfoView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_likeNumberLabel.mas_right).offset(10);
        make.top.bottom.equalTo(specialInfoView);
        make.width.offset(1);
    }];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    
    _collectIconImageView = [UIImageView new];
    [specialInfoView addSubview:_collectIconImageView];
    [_collectIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView.mas_right).offset(10);
        make.centerY.equalTo(specialInfoView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    _collectIconImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _collectNumberLabel = [UILabel new];
    [specialInfoView addSubview:_collectNumberLabel];
    [_collectNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_collectIconImageView.mas_right).offset(4);
        make.centerY.equalTo(_collectIconImageView.mas_centerY);
    }];
    _collectNumberLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _collectNumberLabel.font = [UIFont systemFontOfSize:12.f];
    
    [specialInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_publishNameLabel.mas_bottom);
        make.right.equalTo(_collectNumberLabel.mas_right);
    }];
    
}

- (void)bindDataWithModel:(NSDictionary *)model{
    if (!model) return;
    _publishNameLabel.text = [NSString nullToString:model[@"username"]];
    _nameLabel.text = [NSString nullToString:model[@"title"]];
    _likeIconImageView.image = [UIImage imageNamed:@"home_like_normal"];
    _likeNumberLabel.text = [NSString nullToString:model[@"votesp"]];
    _collectIconImageView.image = [UIImage imageNamed:@"discount_comment_normal"];
    _collectNumberLabel.text = [NSString nullToString:model[@"commentcount"]];
    [[MDB_UserDefault defaultInstance] setViewWithImage:_iconImageView url:[NSString nullToString:model[@"pic"]]];
    [[MDB_UserDefault defaultInstance] setViewWithImage:_avaterImageView url:[NSString nullToString:model[@"photo"]]];
}

@end
