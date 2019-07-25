//
//  RelevanceTableViewCell.m
//  Meidebi
//
//  Created by mdb-admin on 2017/5/16.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "RelevanceTableViewCell.h"
#import "MDB_UserDefault.h"
#import "PelsonalHandleButton.h"
@interface RelevanceTableViewCell ()

@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *siteLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) PelsonalHandleButton *likeBtn;
@end

@implementation RelevanceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setupSubviews{
    _goodsImageView = [UIImageView new];
    [self.contentView addSubview:_goodsImageView];
    [_goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(12);
        make.left.equalTo(self.contentView.mas_left).with.offset(12);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    _goodsImageView.contentMode = UIViewContentModeScaleAspectFit;
    _goodsImageView.layer.cornerRadius = 4.f;
    
    _nameLabel = [UILabel new];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_goodsImageView.mas_right).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-14);
        make.top.equalTo(_goodsImageView.mas_top);
    }];
    _nameLabel.numberOfLines = 2;
    _nameLabel.font = [UIFont systemFontOfSize:16.f];
    _nameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    
    _priceLabel = [UILabel new];
    [self.contentView addSubview:_priceLabel];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_nameLabel);
        make.top.equalTo(_nameLabel.mas_bottom).offset(10);
    }];
    _priceLabel.font = [UIFont systemFontOfSize:16.f];
    _priceLabel.textColor = [UIColor colorWithHexString:@"#F2463A"];
    
    _siteLabel = [UILabel new];
    [self.contentView addSubview:_siteLabel];
    [_siteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_goodsImageView.mas_right).offset(10);
        make.top.equalTo(_priceLabel.mas_bottom).offset(14);
    }];
    _siteLabel.font = [UIFont systemFontOfSize:10.f];
    _siteLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    
    UIView *lineView = [UIView new];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_siteLabel.mas_right).offset(5);
        make.top.equalTo(_siteLabel.mas_top);
        make.bottom.equalTo(_siteLabel.mas_bottom);
        make.width.offset(0.5);
    }];
    lineView.backgroundColor = _siteLabel.textColor;
    _lineView = lineView;
    
    _timeLabel = [UILabel new];
    [self.contentView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView.mas_right).offset(5);
        make.centerY.equalTo(_siteLabel.mas_centerY);
    }];
    _timeLabel.textColor = _siteLabel.textColor;
    _timeLabel.font = _siteLabel.font;
    
    _likeBtn = [PelsonalHandleButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_likeBtn];
    [_likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-17);
        make.centerY.equalTo(_siteLabel.mas_centerY);
        make.height.offset(30);
    }];
    [_likeBtn setImage:[UIImage imageNamed:@"pelsonal_linke_normal"] forState:UIControlStateNormal];
    [_likeBtn setImage:[UIImage imageNamed:@"pelsonal_linke_normal"] forState:UIControlStateHighlighted];
     _likeBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [_likeBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [_likeBtn addTarget:self action:@selector(repondsToBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)bindHotRecommendData:(RelevanceCellViewModel *)model{
    [[MDB_UserDefault defaultInstance] setViewWithImage:_goodsImageView url:[NSString nullToString:model.iconImageLink]];
    _nameLabel.text = model.title;
    if(model.isSelect)
    {
        [_nameLabel setTextColor:RGB(150, 150, 150)];
    }
    else
    {
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"#333333"]];
    }
    if (model.type == RelevanceTypeNormal) {
        _priceLabel.hidden = NO;
        _siteLabel.hidden = NO;
        _likeBtn.hidden = NO;
        _lineView.hidden = NO;
        _timeLabel.hidden = YES;
        [_goodsImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(12);
            make.left.equalTo(self.contentView.mas_left).with.offset(12);
            make.size.mas_equalTo(CGSizeMake(100, 100));
        }];
        [_nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_goodsImageView.mas_right).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-14);
            make.top.equalTo(_goodsImageView.mas_top);
        }];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _goodsImageView.layer.masksToBounds = YES;
        _goodsImageView.layer.cornerRadius = 0.f;
        _goodsImageView.contentMode = UIViewContentModeScaleAspectFit;
        _priceLabel.text = model.activeprice;
        _siteLabel.text = model.siteName;
        if ([[NSString nullToString:model.publishTime] isEqualToString:@""]) {
            _lineView.hidden = YES;
        }else{
            _timeLabel.text = model.publishTime;
            _lineView.hidden = NO;
        }
        [_likeBtn setTitle:[self numberChangeStringValue:[NSNumber numberWithInt:model.likeNumber.intValue]] forState:UIControlStateNormal];
        
        
        
        if (model.isLike) {
            [self.likeBtn setImage:[UIImage imageNamed:@"pelsonal_linke_select"] forState:UIControlStateNormal];
        }else{
            [self.likeBtn setImage:[UIImage imageNamed:@"pelsonal_linke_normal"] forState:UIControlStateNormal];
        }
    }else{
        _priceLabel.hidden = YES;
        _siteLabel.hidden = YES;
        _likeBtn.hidden = YES;
        _lineView.hidden = YES;
        _timeLabel.hidden = YES;
        [_goodsImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.top.equalTo(self.contentView.mas_top).offset(15);
            make.height.equalTo(_goodsImageView.mas_width).multipliedBy(0.44);
        }];
        [_nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(14);
            make.right.equalTo(self.contentView.mas_right).offset(-14);
            make.top.equalTo(_goodsImageView.mas_bottom).offset(14);
        }];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _goodsImageView.layer.masksToBounds = YES;
        _goodsImageView.layer.cornerRadius = 4.f;
        _goodsImageView.contentMode = UIViewContentModeScaleAspectFill;

    }
    
}

- (void)repondsToBtnEvent:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(RelevanceTableViewCellDidClickLikeBtn:)]) {
        [self.delegate RelevanceTableViewCellDidClickLikeBtn:self];
    }
}

-(NSString *)numberChangeStringValue:(NSNumber *)value
{
    NSString *strtemp = @"";
    if(value.integerValue>=1000&&value.integerValue<10000)
    {
        strtemp = [NSString stringWithFormat:@"%dk+",value.intValue/1000];
    }
    else if (value.integerValue>=10000)
    {
        strtemp = [NSString stringWithFormat:@"%dw+",value.intValue/10000];
    }
    else
    {
        strtemp = [NSString stringWithFormat:@"%d",value.intValue];
    }
    return strtemp;
}

@end

