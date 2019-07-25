//
//  BestShareCollectionViewCell.m
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/8.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "BestShareCollectionViewCell.h"
#import "MDB_UserDefault.h"

@interface BestShareCollectionViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *siteLabel;
@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation BestShareCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    UIView *containerView = [UIView new];
    [self.contentView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 15, 48, 15));
    }];
    containerView.backgroundColor = [UIColor whiteColor];
    
    _iconImageView = [UIImageView new];
    [containerView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(containerView.mas_left).offset(18);
        make.top.equalTo(containerView.mas_top).offset(10);
        make.bottom.equalTo(containerView.mas_bottom).offset(-10);
        make.width.equalTo(_iconImageView.mas_height);
    }];
    
    _titleLabel = [UILabel new];
    [containerView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.mas_right).offset(10);
        make.right.equalTo(containerView.mas_right).offset(-15);
        make.top.equalTo(containerView.mas_top).offset(15);
    }];
    _titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    _titleLabel.font = [UIFont systemFontOfSize:14.f];
    _titleLabel.numberOfLines = 2;
    
    _priceLabel = [UILabel new];
    [containerView addSubview:_priceLabel];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.mas_right).offset(10);
        make.right.equalTo(containerView.mas_right).offset(-15);
        make.top.equalTo(_titleLabel.mas_bottom).offset(9);
    }];
    _priceLabel.textColor = [UIColor colorWithHexString:@"#F2463A"];
    _priceLabel.font = [UIFont systemFontOfSize:12.f];

    _siteLabel = [UILabel new];
    [containerView addSubview:_siteLabel];
    [_siteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.mas_right).offset(10);
        make.right.equalTo(containerView.mas_right).offset(-15);
        make.top.equalTo(_priceLabel.mas_bottom).offset(9);
    }];
    _siteLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _siteLabel.font = [UIFont systemFontOfSize:12.f];

}

- (void)bindDataWithModel:(NSDictionary *)model{
    if (!model) return;
    [[MDB_UserDefault defaultInstance] setViewWithImage:_iconImageView url:[NSString nullToString:model[@"image"]]];
    _titleLabel.text = [NSString nullToString:model[@"title"]];
    _priceLabel.text = [NSString stringWithFormat:@"%@",[NSString nullToString:model[@"strDown"]]];
    _siteLabel.text = [NSString nullToString:model[@"shop_name"]];
}




@end
