//
//  BargainItemTableViewCell.m
//  Meidebi
//
//  Created by mdb-admin on 2017/10/16.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "BargainItemTableViewCell.h"
#import "MDB_UserDefault.h"
#import "BargainActivityViewModel.h"
#import "BargainParticipationViewModel.h"
@interface BargainItemTableViewCell ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *itemNameLabel;
@property (nonatomic, strong) UILabel *itemPriceLabel;
@property (nonatomic, strong) UILabel *itemParticipantNumberLabel;
@property (nonatomic, strong) UILabel *itemInventoryNumberLabel;
@property (nonatomic, strong) UILabel *itemBargainNumberLabel;
@property (nonatomic, strong) UIButton *stateBtn;
@end

@implementation BargainItemTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    _iconImageView = [UIImageView new];
    [self.contentView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(18);
        make.left.equalTo(self.contentView.mas_left).offset(11);
        make.size.mas_equalTo(CGSizeMake(120, 120));
    }];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.layer.cornerRadius = 4.f;
    
    _stateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_iconImageView addSubview:_stateBtn];
    [_stateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(_iconImageView);
        make.size.mas_equalTo(CGSizeMake(70, 25));
    }];
    _stateBtn.userInteractionEnabled = NO;
    _stateBtn.backgroundColor = [UIColor colorWithHexString:@"#838383"];
    [_stateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_stateBtn setTitle:@"被抢光了" forState:UIControlStateNormal];
    _stateBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    _stateBtn.hidden = YES;
    
    _itemNameLabel = [UILabel new];
    [self.contentView addSubview:_itemNameLabel];
    [_itemNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(26);
        make.left.equalTo(_iconImageView.mas_right).offset(13);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    _itemNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    _itemNameLabel.font = [UIFont systemFontOfSize:14.f];
    
    _itemPriceLabel = [UILabel new];
    [self.contentView addSubview:_itemPriceLabel];
    [_itemPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_itemNameLabel.mas_bottom).offset(14);
        make.left.right.equalTo(_itemNameLabel);
    }];
    _itemPriceLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _itemPriceLabel.font = [UIFont systemFontOfSize:12.f];
    
    _itemParticipantNumberLabel = [UILabel new];
    [self.contentView addSubview:_itemParticipantNumberLabel];
    [_itemParticipantNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_itemPriceLabel.mas_bottom).offset(10);
        make.left.right.equalTo(_itemNameLabel);
    }];
    _itemParticipantNumberLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _itemParticipantNumberLabel.font = [UIFont systemFontOfSize:12.f];
    
    _itemInventoryNumberLabel = [UILabel new];
    [self.contentView addSubview:_itemInventoryNumberLabel];
    [_itemInventoryNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_itemParticipantNumberLabel.mas_bottom).offset(10);
        make.left.right.equalTo(_itemNameLabel);
    }];
    _itemInventoryNumberLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _itemInventoryNumberLabel.font = [UIFont systemFontOfSize:12.f];
    
    _itemBargainNumberLabel = [UILabel new];
    [self.contentView addSubview:_itemBargainNumberLabel];
    [_itemBargainNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_itemInventoryNumberLabel.mas_bottom).offset(10);
        make.left.right.equalTo(_itemNameLabel);
    }];
    _itemBargainNumberLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _itemBargainNumberLabel.font = [UIFont systemFontOfSize:12.f];

}

- (void)bindDataWithModel:(BargainItemViewModel *)model{
    [[MDB_UserDefault defaultInstance] setViewWithImage:_iconImageView url:model.imageLink];
    _itemNameLabel.text = [NSString nullToString:model.title];
    _itemPriceLabel.text = [NSString stringWithFormat:@"售价：¥%@",[NSString nullToString:model.price preset:@"0"]];
    _itemParticipantNumberLabel.text = [NSString stringWithFormat:@"参与人数：%@",[NSString nullToString:model.participants preset:@"0"]];
    _itemInventoryNumberLabel.text = [NSString stringWithFormat:@"剩余数量：%@",[NSString nullToString:model.number preset:@"0"]];
    _itemBargainNumberLabel.text = [NSString stringWithFormat:@"需要刀数：%@",[NSString nullToString:model.required preset:@"0"]];
    if (model.number.integerValue > 0) {
        _stateBtn.hidden = YES;
    }else{
        _stateBtn.hidden = NO;
    }
}

- (void)bindParticiptationDataWithModel:(BargainParticipationViewModel *)model{
    [[MDB_UserDefault defaultInstance] setViewWithImage:_iconImageView url:model.imageLink];
    _itemNameLabel.text = [NSString nullToString:model.title];
    _itemPriceLabel.text = [NSString stringWithFormat:@"剩余数量：%@",[NSString nullToString:model.number preset:@"0"]];
    [_itemInventoryNumberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_itemParticipantNumberLabel.mas_bottom);
    }];
    _itemInventoryNumberLabel.text = [NSString stringWithFormat:@"需要刀数：%@",[NSString nullToString:model.required preset:@"0"]];
    _itemBargainNumberLabel.text = [NSString stringWithFormat:@"已砍刀数：%@",[NSString nullToString:model.finish preset:@"0"]];
    if (model.number.integerValue > 0) {
        _stateBtn.hidden = YES;
    }else{
        _stateBtn.hidden = NO;
    }
}
@end
