//
//  CouponSimpleCollectionViewCell.m
//  Meidebi
//
//  Created by mdb-admin on 2017/7/10.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "CouponSimpleCollectionViewCell.h"
#import "MDB_UserDefault.h"
@interface CouponSimpleCollectionViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *salesLabel;
@property (nonatomic, strong) UIButton *drawCouponBtn;

@end

@implementation CouponSimpleCollectionViewCell

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
    _titleLabel.numberOfLines = 2;
    
    _priceLabel = [UILabel new];
    [self.contentView addSubview:_priceLabel];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(10);
        make.left.equalTo(_titleLabel.mas_left);
    }];
    _priceLabel.font = [UIFont systemFontOfSize:14.f];
    _priceLabel.textColor = [UIColor colorWithHexString:@"#F2463A"];
    _priceLabel.textAlignment = NSTextAlignmentRight;
    
    _salesLabel = [UILabel new];
    [self.contentView addSubview:_salesLabel];
    [_salesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_priceLabel.mas_top);
        make.right.equalTo(_titleLabel.mas_right);
    }];
    _salesLabel.textAlignment = NSTextAlignmentRight;
    _salesLabel.font = [UIFont systemFontOfSize:12.f];
    _salesLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    
    _drawCouponBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_drawCouponBtn];
    [_drawCouponBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_titleLabel);
        make.height.offset(30);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-9);
    }];
    _drawCouponBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [_drawCouponBtn setTitleColor:[UIColor colorWithHexString:@"#F4F4F4"] forState:UIControlStateNormal];
    [_drawCouponBtn setBackgroundImage:[UIImage imageNamed:@"coupon_denomination"] forState:UIControlStateNormal];
    [_drawCouponBtn addTarget:self action:@selector(respondsToBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)respondsToBtnEvent:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(couponSimpleCollectionViewCellDidClickDrawBtn:)]) {
        [self.delegate couponSimpleCollectionViewCellDidClickDrawBtn:self];
    }
}

- (void)bindDataWithModel:(NSDictionary *)model{
    if (!model) return;
    [[MDB_UserDefault defaultInstance] setViewWithImage:_iconImageView url:[NSString nullToString:model[@"pict_url"]]];
    _titleLabel.text = [NSString nullToString:model[@"title"]];
    _priceLabel.attributedText = [self setAttributeStr:@"券后价 " contentStr:[NSString stringWithFormat:@"￥%@",@([NSString nullToString:model[@"final_price"]].floatValue)]];
    _salesLabel.text = [NSString stringWithFormat:@"月销%@",[NSString nullToString:model[@"volume"]]];
    [_drawCouponBtn setTitle:[NSString stringWithFormat:@"领%@元券",[NSString nullToString:model[@"denomination"]]] forState:UIControlStateNormal];
}


- (NSAttributedString *)setAttributeStr:(NSString *)fixationStr
                             contentStr:(NSString *)contentStr{
    if (!fixationStr || !contentStr) return nil;
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:[fixationStr stringByAppendingString:contentStr]];
    [attributeStr addAttribute:NSFontAttributeName
                         value:[UIFont systemFontOfSize:12.f]
                         range:NSMakeRange(0, fixationStr.length)];
    [attributeStr addAttribute:NSFontAttributeName
                         value:[UIFont systemFontOfSize:14.f]
                         range:NSMakeRange(fixationStr.length, contentStr.length)];
    
    [attributeStr addAttribute:NSForegroundColorAttributeName
                         value:[UIColor colorWithHexString:@"#999999"]
                         range:NSMakeRange(0, fixationStr.length)];
    [attributeStr addAttribute:NSForegroundColorAttributeName
                         value:[UIColor colorWithHexString:@"#F2463A"]
                         range:NSMakeRange(fixationStr.length, contentStr.length)];
    return attributeStr.mutableCopy;
}

@end
