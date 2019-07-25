//
//  TrendTableViewCell.m
//  Meidebi
//
//  Created by mdb-admin on 2017/11/30.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "TrendTableViewCell.h"
#import "MDB_UserDefault.h"
@interface TrendNumberFlagView: UIView
@property (nonatomic, strong) UILabel *numberLabel;
@end

@implementation TrendNumberFlagView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configurUI];
    }
    return self;
}
- (void)configurUI{
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.layer.contents = (__bridge id _Nullable)[UIImage imageNamed:@"rank_num_ico"].CGImage;
    
    _numberLabel = [UILabel new];
    [self addSubview:_numberLabel];
    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.textColor = [UIColor whiteColor];
    _numberLabel.font = [UIFont systemFontOfSize:13];
}
@end

@interface TrendTableViewCell()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *couponPriceLabel;
@property (nonatomic, strong) UILabel *siteLabel;
@property (nonatomic, strong) TrendNumberFlagView *flagView;
@property (nonatomic, strong) UIView *couponHandleView;
@end

@implementation TrendTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configurUI];
    }
    return self;
}

- (void)configurUI{
    _iconImageView = [UIImageView new];
    [self.contentView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(14);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(111, 111));
    }];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _titleLabel = [UILabel new];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.mas_right).offset(14);
        make.right.equalTo(self.contentView.mas_right).offset(-14);
        make.top.equalTo(self.contentView.mas_top).offset(28);
    }];
    _titleLabel.numberOfLines = 2;
    _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    
    _priceLabel = [UILabel new];
    [self.contentView addSubview:_priceLabel];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_left);
        make.top.equalTo(_titleLabel.mas_bottom).offset(13);
    }];
    _priceLabel.textColor = [UIColor colorWithHexString:@"#F2463A"];
    _priceLabel.font = [UIFont systemFontOfSize:14];
    
    _siteLabel = [UILabel new];
    [self.contentView addSubview:_siteLabel];
    [_siteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_priceLabel.mas_right).offset(6);
        make.centerY.equalTo(_priceLabel.mas_centerY);
    }];
    _siteLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _siteLabel.font = [UIFont systemFontOfSize:12];
    
    _flagView = [TrendNumberFlagView new];
    [self.contentView addSubview:_flagView];
    [_flagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView.mas_top).offset(2);
        make.left.equalTo(_iconImageView.mas_left).offset(2);
        make.size.mas_equalTo(CGSizeMake(21, 21));
    }];
    _flagView.hidden = YES;
    
    UIView *couponHandleView = [UIView new];
    [self.contentView addSubview:couponHandleView];
    [couponHandleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_titleLabel);
        make.top.equalTo(_priceLabel.mas_bottom).offset(14);
        make.height.offset(27);
    }];
    couponHandleView.backgroundColor = [UIColor colorWithHexString:@"#FFF3E8"];
    _couponHandleView = couponHandleView;
    _couponHandleView.hidden = YES;
    
    UIImageView *couponIconImageView = [UIImageView new];
    [couponHandleView addSubview:couponIconImageView];
    [couponIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(couponHandleView.mas_left).offset(10*kScale);
        make.centerY.equalTo(couponHandleView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(15, 16));
    }];
    couponIconImageView.image = [UIImage imageNamed:@"rank_quan_ico"];
    couponIconImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    _couponPriceLabel = [UILabel new];
    [couponHandleView addSubview:_couponPriceLabel];
    [_couponPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(couponIconImageView.mas_right).offset(7*kScale);
        make.centerY.equalTo(couponHandleView.mas_centerY);
    }];
    _couponPriceLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _couponPriceLabel.font = [UIFont systemFontOfSize:12];
    
    UIButton *obtainCouponBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [couponHandleView addSubview:obtainCouponBtn];
    [obtainCouponBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(couponHandleView);
        make.width.offset(75*kScale);
    }];
    obtainCouponBtn.backgroundColor = [UIColor colorWithHexString:@"#F2463A"];
    obtainCouponBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [obtainCouponBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [obtainCouponBtn setTitle:@"领券抢购" forState:UIControlStateNormal];
    [obtainCouponBtn addTarget:self action:@selector(respondsToBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)respondsToBtnEvent:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(tableViewCellDidHandleCouponWithCell:)]) {
        [self.delegate tableViewCellDidHandleCouponWithCell:self];
    }
}

- (void)bindDataWithModel:(NSDictionary *)model row:(NSUInteger)row{
    [[MDB_UserDefault defaultInstance] setViewWithImage:_iconImageView url:[NSString nullToString:model[@"image"]]];
    _titleLabel.text = [NSString nullToString:model[@"title"]];
    
    
    if([[model objectForKey:@"isSelect"] boolValue] == YES)
    {
        [_titleLabel setTextColor:RGB(150, 150, 150)];
        
    }
    else
    {
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    
    _priceLabel.text = [@"" isEqualToString:[NSString nullToString:model[@"price"]]] ? @"": [NSString stringWithFormat:@"¥%@",[NSString nullToString:model[@"price"]]];
    if (row<3) {
        _flagView.hidden = NO;
        _flagView.numberLabel.text = [NSString stringWithFormat:@"%@",@(row+1)];
    }else{
        _flagView.hidden = YES;
    }
    if ([@"3" isEqualToString:[NSString nullToString:model[@"agttype"]]]) {
        _siteLabel.text = @"券后价";
        _couponHandleView.hidden = NO;
        _couponPriceLabel.text = [@"" isEqualToString:[NSString nullToString:model[@"denomination"]]] ? @"": [NSString stringWithFormat:@"%@元券",[NSString nullToString:model[@"denomination"]]];
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(17);
        }];
    }else{
        _siteLabel.text = [NSString nullToString:model[@"site_name"]];
        _couponHandleView.hidden = YES;
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(28);
        }];
    }
    
}

@end
