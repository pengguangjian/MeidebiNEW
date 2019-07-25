//
//  RewardRecordTableViewCell.m
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/7.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "RewardRecordTableViewCell.h"
#import "MDB_UserDefault.h"
@interface RewardRecordTableViewCell ()
@property (nonatomic, strong) UIImageView *avaterImageView;
@property (nonatomic, strong) UILabel *cionLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@end

@implementation RewardRecordTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


- (void)setupSubviews{
    _avaterImageView = [UIImageView new];
    [self.contentView addSubview:_avaterImageView];
    [_avaterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(17);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(45,45));
    }];
    _avaterImageView.layer.masksToBounds = YES;
    _avaterImageView.layer.cornerRadius = 45/2.f;
    _avaterImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [_avaterImageView addGestureRecognizer:gesture];
    
    _nameLabel = [UILabel new];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avaterImageView.mas_right).offset(12);
        make.centerY.equalTo(_avaterImageView.mas_centerY);
    }];
    _nameLabel.font = [UIFont systemFontOfSize:14.f];
    _nameLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    
    _cionLabel = [UILabel new];
    [self.contentView addSubview:_cionLabel];
    [_cionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-24);
        make.centerY.equalTo(_avaterImageView.mas_centerY);
    }];
    _cionLabel.font = [UIFont systemFontOfSize:14.f];
    _cionLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    _cionLabel.textAlignment = NSTextAlignmentRight;
}

- (void)bindDataWithModel:(NSDictionary *)model{
    if (!model) return;
    [[MDB_UserDefault defaultInstance] setViewWithImage:_avaterImageView url:[NSString nullToString:model[@"photo"]]];
    _nameLabel.text = [NSString nullToString:model[@"username"]];
    _cionLabel.text = [NSString stringWithFormat:@"%@铜币",[NSString nullToString:model[@"coppernum"]]];
}


- (void)tapGesture:(UIGestureRecognizer *)gesture{
    if ([self.delegate respondsToSelector:@selector(tableViewCellDidSelctAvater:)]) {
        [self.delegate tableViewCellDidSelctAvater:self];
    }
}


@end
