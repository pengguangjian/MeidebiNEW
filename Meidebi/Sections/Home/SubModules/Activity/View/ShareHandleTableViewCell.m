//
//  ShareHandleTableViewCell.m
//  Meidebi
//
//  Created by mdb-admin on 2017/10/16.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "ShareHandleTableViewCell.h"

@interface ShareHandleTableViewCell ()
@property (nonatomic, strong) NSArray *shareItems;
@end

@implementation ShareHandleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    self.backgroundColor = [UIColor colorWithHexString:@"#F7F5F6"];
    UILabel *nameLabel = [UILabel new];
    [self.contentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(21);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
    nameLabel.font = [UIFont systemFontOfSize:14.f];
    nameLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    nameLabel.text = @"分享给朋友";
    
    UIView *leftLineView = [UIView new];
    [self.contentView addSubview:leftLineView];
    [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(nameLabel.mas_left).offset(-8);
        make.centerY.equalTo(nameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(16, 1));
    }];
    leftLineView.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    
    UIView *rightLineView = [UIView new];
    [self.contentView addSubview:rightLineView];
    [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_right).offset(8);
        make.centerY.equalTo(nameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(16, 1));
    }];
    rightLineView.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    
    NSMutableArray *arr = @[].mutableCopy;
    for (int i = 0; i < self.shareItems.count; i++) {
        UIButton *sharBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sharBtn setImage:self.shareItems[i] forState:UIControlStateNormal];
        sharBtn.tag = 10000+i;
        [self.contentView addSubview:sharBtn];
        [sharBtn addTarget:self action:@selector(respondsToBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [arr addObject:sharBtn];
        [sharBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(sharBtn.mas_width);
        }];
    }
    [arr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:15*kScale leadSpacing:15 tailSpacing:15];
    [arr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(20);
    }];
}

- (void)respondsToBtnEvent:(UIControl *)sender{
    ShareHandleType type;
    switch (sender.tag) {
        case ShareHandleTypeQQ:
            type = ShareHandleTypeQQ;
            break;
        case ShareHandleTypeWeChat:
            type = ShareHandleTypeWeChat;
            break;
        case ShareHandleTypeQQSpace:
            type = ShareHandleTypeQQSpace;
            break;
        case ShareHandleTypeSinaWeibo:
            type = ShareHandleTypeSinaWeibo;
            break;
        case ShareHandleTypeWeMoments:
            type = ShareHandleTypeWeMoments;
            break;
        default:
            type = ShareHandleTypeSinaWeibo;
            break;
    }
    if ([self.delegate respondsToSelector:@selector(shareHandleTableViewCellDidClickedShareButtonAtType:)]) {
        [self.delegate shareHandleTableViewCellDidClickedShareButtonAtType:type];
    }
}


#pragma mark - getters and setters

- (NSArray *)shareItems{
    if (!_shareItems) {
        _shareItems = @[[UIImage imageNamed:@"bargain_share_sina"],
                        [UIImage imageNamed:@"bargain_share_weMoments"],
                        [UIImage imageNamed:@"bargain_share_QQSpace"],
                        [UIImage imageNamed:@"bargain_share_QQ"],
                        [UIImage imageNamed:@"bargain_share_weChat"]];
    }
    return _shareItems;
}
@end
