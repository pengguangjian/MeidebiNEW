//
//  OriginalFlagCollectionViewCell.m
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/21.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "OriginalFlagCollectionViewCell.h"
#import "MDB_UserDefault.h"
@interface OriginalFlagCollectionViewCell ()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@end

@implementation OriginalFlagCollectionViewCell

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
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(_iconImageView.mas_width).multipliedBy(0.65);
    }];
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.layer.cornerRadius = 4.f;
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    _nameLabel = [UILabel new];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView.mas_bottom).offset(9);
        make.left.right.equalTo(self.contentView);
    }];
    _nameLabel.font = [UIFont systemFontOfSize:14.f*kScale];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    
}

- (void)bindDataWithModel:(NSDictionary *)model{
//    if (!model) return;
//    [[MDB_UserDefault defaultInstance] setViewWithImage:_iconImageView url:[NSString nullToString:model[@"image"]]];
    _iconImageView.image = model[kFlageImage];
    _nameLabel.text = model[kFlageName];
}
@end
