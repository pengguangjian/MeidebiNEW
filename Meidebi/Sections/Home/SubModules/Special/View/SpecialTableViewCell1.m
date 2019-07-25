//
//  SpecialTableViewCell1.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/23.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "SpecialTableViewCell1.h"
#import "MDB_UserDefault.h"

static NSInteger const kSepcialItemIconTag = 10000;
static NSInteger const kSepcialItemNameTag = 11000;
static NSInteger const kSepcialItemPriceTag = 12000;


@interface SpecialTableViewCell1 ()

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

@implementation SpecialTableViewCell1

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
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.height.equalTo(self.mas_height).offset(-20);
        make.width.equalTo(self.mas_height);
    }];
    _specialIconImageView.layer.masksToBounds = YES;
    _specialIconImageView.layer.cornerRadius = 4.f;
    _specialIconImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    
    _specialNameLabel = [UILabel new];
    [self.contentView addSubview:_specialNameLabel];
    [_specialNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_specialIconImageView.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(_specialIconImageView.mas_top);
        make.height.offset(40);
    }];
    _specialNameLabel.textAlignment = NSTextAlignmentLeft;
    _specialNameLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    _specialNameLabel.font = [UIFont systemFontOfSize:15.f];
    [_specialNameLabel setNumberOfLines:2];
    
    _specialContentLabel = [UILabel new];
    [self.contentView addSubview:_specialContentLabel];
    [_specialContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_specialNameLabel);
        make.right.equalTo(_specialNameLabel);
        make.top.equalTo(_specialNameLabel.mas_bottom);
        make.height.offset(70);
    }];
    _specialContentLabel.textAlignment = NSTextAlignmentLeft;
    _specialContentLabel.textColor = [UIColor colorWithHexString:@"#888888"];
    _specialContentLabel.font = [UIFont systemFontOfSize:13.f];
    [_specialContentLabel setNumberOfLines:4];
    
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
    
    _specialContentLabel.text = model.tbContent;
    
    [[MDB_UserDefault defaultInstance] setViewWithImage:_specialIconImageView url:model.imageLink];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
