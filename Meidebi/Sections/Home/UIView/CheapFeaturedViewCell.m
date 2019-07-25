//
//  CheapFeaturedViewCell.m
//  Meidebi
//
//  Created by mdb-admin on 2017/8/22.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "CheapFeaturedViewCell.h"
#import "MDB_UserDefault.h"
@interface CheapFeaturedViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *describleLabel;

@end

@implementation CheapFeaturedViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    _iconImageView = [UIImageView new];
    [self.contentView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.contentView);
        make.width.equalTo(_iconImageView.mas_height);
    }];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _titleLabel = [UILabel new];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.mas_right).offset(5);
        make.top.equalTo(_iconImageView.mas_top).offset(9);
        make.right.equalTo(self.contentView.mas_right).offset(-5);
    }];
    _titleLabel.numberOfLines = 2;
    _titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    _titleLabel.font = [UIFont systemFontOfSize:12.f];
    
    _describleLabel = [UILabel new];
    [self.contentView addSubview:_describleLabel];
    [_describleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(6);
        make.left.right.equalTo(_titleLabel);
    }];
    _describleLabel.textColor = [UIColor colorWithHexString:@"#F35D00"];
    _describleLabel.font = [UIFont systemFontOfSize:11.f];
}

- (void)bindDataWithModel:(HomeCheapViewModel *)model{
    [[MDB_UserDefault defaultInstance] setViewWithImage:_iconImageView url:model.imageLink];
    _titleLabel.text = model.title;
    _describleLabel.text = model.info;
}

@end
