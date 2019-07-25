//
//  SpecialTableViewCell.m
//  Meidebi
//
//  Created by mdb-admin on 2017/5/15.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "SpecialTableViewCell.h"
#import "MDB_UserDefault.h"
static NSInteger const kSepcialItemIconTag = 10000;
static NSInteger const kSepcialItemNameTag = 11000;
static NSInteger const kSepcialItemPriceTag = 12000;


@interface SpecialTableViewCell ()

@property (nonatomic, strong) UIImageView *specialIconImageView;
@property (nonatomic, strong) UILabel *specialNameLabel;
@property (nonatomic, strong) UILabel *specialContentLabel;

@property (nonatomic, strong) NSArray *specialItems;
@property (nonatomic, strong) UILabel *publishNameLabel;
@property (nonatomic, strong) UILabel *likeNumberLabel;
@property (nonatomic, strong) UILabel *collectNumberLabel;
@property (nonatomic, strong) UIImageView *likeIconImageView;
@property (nonatomic, strong) UIImageView *collectIconImageView;
@end


@implementation SpecialTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setupSubviews{
    _specialIconImageView = [UIImageView new];
    [self.contentView addSubview:_specialIconImageView];
    [_specialIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.height.equalTo(_specialIconImageView.mas_width).multipliedBy(0.44);
    }];
    _specialIconImageView.layer.masksToBounds = YES;
    _specialIconImageView.layer.cornerRadius = 4.f;
    _specialIconImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    //    UIView *cellBottomLineView = [UIView new];
    //    [self.contentView addSubview:cellBottomLineView];
    //    [cellBottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.right.bottom.equalTo(self.contentView);
    //        make.height.offset(8);
    //    }];
    //    cellBottomLineView.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
    
    _specialNameLabel = [UILabel new];
    [self.contentView addSubview:_specialNameLabel];
    [_specialNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_specialIconImageView);
        make.top.equalTo(_specialIconImageView.mas_bottom).offset(19);
    }];
    _specialNameLabel.textAlignment = NSTextAlignmentCenter;
    _specialNameLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    _specialNameLabel.font = [UIFont systemFontOfSize:15.f];
    
}

- (UIControl *)setupSepcialItemView{
    UIControl *control = [UIControl new];
    UIImageView *iconImageView = [UIImageView new];
    [control addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(control);
        make.height.equalTo(iconImageView.mas_width);
    }];
    iconImageView.tag = kSepcialItemIconTag;
    iconImageView.backgroundColor = [UIColor whiteColor];
    iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel *nameLabel = [UILabel new];
    [control addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageView.mas_bottom).offset(6);
        make.left.right.equalTo(iconImageView);
    }];
    nameLabel.tag = kSepcialItemNameTag;
    nameLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    nameLabel.font = [UIFont systemFontOfSize:10.f];
    
    UILabel *priceLabel = [UILabel new];
    [control addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(4);
        make.left.right.equalTo(nameLabel);
    }];
    priceLabel.tag = kSepcialItemPriceTag;
    priceLabel.textColor = [UIColor colorWithHexString:@"#F2463A"];
    priceLabel.font = [UIFont systemFontOfSize:10.f];
    
    [control mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(priceLabel.mas_bottom).offset(5);
    }];
    return control;
}

- (void)bindSpeicalWithModel:(SpecialViewModel *)model{
    if (!model) return;
    _specialNameLabel.text = model.title;
    _likeIconImageView.image = [UIImage imageNamed:@"home_like_normal"];
    _likeNumberLabel.text = model.praisecount;
    _collectIconImageView.image = [UIImage imageNamed:@"discount_comment_normal"];
    _collectNumberLabel.text = model.commentcount;
    [[MDB_UserDefault defaultInstance] setViewWithImage:_specialIconImageView url:model.imageLink];
}
@end
