//
//  HomeHotCollectionViewCell.m
//  Meidebi
//
//  Created by mdb-admin on 2017/5/27.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "HomeHotCollectionViewCell.h"
#import "MDB_UserDefault.h"
@interface HomeHotCollectionViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *siteLabel;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation HomeHotCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    self.backgroundColor = [UIColor whiteColor];
    _iconImageView = [UIImageView new];
    [self.contentView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.equalTo(_iconImageView.mas_width);
    }];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _titleLabel = [UILabel new];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView.mas_bottom).offset(13);
        make.left.equalTo(self.contentView.mas_left).offset(6);
        make.right.equalTo(self.contentView.mas_right).offset(-6);
    }];
    _titleLabel.font = [UIFont systemFontOfSize:14.f];
    _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UIView *lineView = [UIView new];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(8);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(1, 12));
    }];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    _lineView = lineView;
    
    _priceLabel = [UILabel new];
    [self.contentView addSubview:_priceLabel];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lineView.mas_left).offset(-6);
        make.centerY.equalTo(lineView.mas_centerY);
        make.left.equalTo(_titleLabel.mas_left);
    }];
    _priceLabel.font = [UIFont systemFontOfSize:14.f];
    _priceLabel.textColor = [UIColor colorWithHexString:@"#F2463A"];
    _priceLabel.textAlignment = NSTextAlignmentRight;
    
    _siteLabel = [UILabel new];
    [self.contentView addSubview:_siteLabel];
    [_siteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView.mas_right).offset(6);
        make.centerY.equalTo(lineView.mas_centerY);
        make.right.equalTo(_titleLabel.mas_right);
    }];
    _siteLabel.font = [UIFont systemFontOfSize:12.f];
    _siteLabel.textColor = [UIColor colorWithHexString:@"#999999"];
   
}

- (void)bindDataWithModel:(Commodity *)model{
    [_priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_lineView.mas_left).offset(-6);
        make.centerY.equalTo(_lineView.mas_centerY);
        make.left.equalTo(_titleLabel.mas_left);
    }];
    _lineView.hidden = NO;
    _siteLabel.hidden = NO;
    _priceLabel.textAlignment = NSTextAlignmentRight;
    [[MDB_UserDefault defaultInstance]setViewWithImage:_iconImageView url:model.image options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            _iconImageView.image=image;
        }else{
            _iconImageView.image=[UIImage imageNamed:@"punot.png"];
        }
    }];
    [_titleLabel setText:model.title];
    if ([model.linktype intValue]==2) {
        if (![model.prodescription isKindOfClass:[NSNull class]]) {
            _priceLabel.text=[NSString stringWithFormat:@"%@",model.prodescription];
        }
        [_priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_titleLabel.mas_right);
            make.centerY.equalTo(_lineView.mas_centerY);
            make.left.equalTo(_titleLabel.mas_left);
        }];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _lineView.hidden = YES;
        _siteLabel.hidden = YES;
    }else{
        if ([model.proprice floatValue]<[model.price floatValue]&&[model.proprice floatValue]!=0.0f) {
            [_priceLabel setText:[NSString stringWithFormat:@"￥%.2f",[model.proprice floatValue]]];
        }else{
            [_priceLabel setText:[NSString stringWithFormat:@"￥%.2f",[model.price floatValue]]];
        }
    }
    [_siteLabel setText:model.sitename];
    if ([[NSString nullToString:model.sitename] isEqualToString:@""]) {
        [_priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_titleLabel.mas_right);
            make.centerY.equalTo(_lineView.mas_centerY);
            make.left.equalTo(_titleLabel.mas_left);
        }];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _lineView.hidden = YES;
        _siteLabel.hidden = YES;
    }
}
@end
