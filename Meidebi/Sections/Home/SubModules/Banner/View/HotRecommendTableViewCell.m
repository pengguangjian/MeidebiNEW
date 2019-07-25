//
//  HotRecommendTableViewCell.m
//  Meidebi
//
//  Created by mdb-admin on 2017/5/16.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "HotRecommendTableViewCell.h"

@interface HotRecommendTableViewCell ()

@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *siteLabel;

@end

@implementation HotRecommendTableViewCell

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

    // Configure the view for the selected state
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
    
    _nameLabel = [UILabel new];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_goodsImageView.mas_right).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-14);
        make.top.equalTo(_goodsImageView.mas_top);
    }];
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
    
    UIButton *openUrlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:openUrlBtn];
    [openUrlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLabel.mas_bottom).offset(20);
        make.right.equalTo(self.contentView.mas_right).offset(-13);
        make.size.mas_equalTo(CGSizeMake(91, 34));
    }];
    [openUrlBtn setBackgroundImage:[UIImage imageNamed:@"open_url_btn_normal"] forState:UIControlStateNormal];
    [openUrlBtn.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
    [openUrlBtn setTitle:@"直达链接" forState:UIControlStateNormal];
    [openUrlBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [openUrlBtn addTarget:self action:@selector(respondsToBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)respondsToBtnEvent:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(tableViewCellDidClickOpenUrlBtn:)]) {
        [self.delegate tableViewCellDidClickOpenUrlBtn:@""];
    }
}

- (void)bindHotRecommendData:(NSDictionary *)modelDict{
    _goodsImageView.backgroundColor = [UIColor orangeColor];
    _nameLabel.text = @"成人可穿！NIKE耐克童款ROSHE...";
    _priceLabel.text = @"￥9.9";
    _siteLabel.text = @"亚马逊中国";
}

@end
