//
//  AttentionCollectionViewCell.m
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/21.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "AttentionCollectionViewCell.h"
#import "MDB_UserDefault.h"
@interface AttentionCollectionViewCell ()
@property (nonatomic, strong) UIImageView *avaterImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *followBtn;
@end

@implementation AttentionCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    _avaterImageView = [UIImageView new];
    [self.contentView addSubview:_avaterImageView];
    [_avaterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(45*kScale, 45*kScale));
    }];
    _avaterImageView.layer.masksToBounds = YES;
    _avaterImageView.layer.cornerRadius = (45*kScale)/2.f;
    _avaterImageView.layer.borderWidth = 2.f;
    _avaterImageView.layer.borderColor = [UIColor colorWithHexString:@"#F27A30"].CGColor;
    
    _nameLabel = [UILabel new];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avaterImageView.mas_bottom).offset(6);
        make.right.equalTo(self.contentView.mas_right).offset(-5);
        make.left.equalTo(self.contentView.mas_left).offset(5);
    }];
    _nameLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    _nameLabel.font = [UIFont systemFontOfSize:11.f];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    
    _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_followBtn];
    [_followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(_nameLabel.mas_bottom).offset(8);
        make.size.mas_equalTo(CGSizeMake(51, 20));
    }];
    _followBtn.titleLabel.font = [UIFont systemFontOfSize:11.f];
    [_followBtn setTitleColor:[UIColor colorWithHexString:@"#F27A30"] forState:UIControlStateNormal];
    [_followBtn setTitleColor:[UIColor colorWithHexString:@"#F27A30"] forState:UIControlStateHighlighted];
    [_followBtn setTitle:@"+ 关注" forState:UIControlStateNormal];
    _followBtn.layer.masksToBounds = YES;
    _followBtn.layer.cornerRadius = 4.f;
    _followBtn.layer.borderWidth = 1.f;
    _followBtn.layer.borderColor = [UIColor colorWithHexString:@"#F27A30"].CGColor;
    [_followBtn addTarget:self action:@selector(respondsToBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)respondsToBtnEvent:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(collectionViewCellDidSelect:)]) {
        [self.delegate collectionViewCellDidSelect:self];
    }
}

- (void)bindDataWithModel:(NSDictionary *)model{
    if (!model) return;
    [[MDB_UserDefault defaultInstance] setViewWithImage:_avaterImageView url:[NSString nullToString:model[@"photo"]]];
    _nameLabel.text = [NSString nullToString:model[@"username"]];
    if ([@"1" isEqualToString:model[kUserFollowState]]) {
        _followBtn.userInteractionEnabled = NO;
        [_followBtn setTitle:@"已关注" forState:UIControlStateNormal];
        [_followBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [_followBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateHighlighted];
        _followBtn.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;

    }else{
        _followBtn.userInteractionEnabled = YES;
        [_followBtn setTitle:@"+ 关注" forState:UIControlStateNormal];
        [_followBtn setTitleColor:[UIColor colorWithHexString:@"#F27A30"] forState:UIControlStateNormal];
        [_followBtn setTitleColor:[UIColor colorWithHexString:@"#F27A30"] forState:UIControlStateHighlighted];
        _followBtn.layer.borderColor = [UIColor colorWithHexString:@"#F27A30"].CGColor;
    }
}
@end
