//
//  BargainRankTableViewCell.m
//  Meidebi
//
//  Created by leecool on 2017/10/17.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "BargainRankTableViewCell.h"
#import "MDB_UserDefault.h"
@interface BargainRankTableViewCell ()
@property (nonatomic, strong) UIImageView *avaterImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation BargainRankTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    _avaterImageView = [UIImageView new];
    [self.contentView addSubview:_avaterImageView];
    [_avaterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(17);
        make.size.mas_equalTo(CGSizeMake(46, 46));
    }];
    _avaterImageView.userInteractionEnabled = YES;
    _avaterImageView.layer.masksToBounds = YES;
    _avaterImageView.layer.cornerRadius = 46/2;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToGesture:)];
    [_avaterImageView addGestureRecognizer:gesture];
    
    _timeLabel = [UILabel new];
    [self.contentView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    _timeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    _timeLabel.font = [UIFont systemFontOfSize:14.f];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    
    _nameLabel = [UILabel new];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avaterImageView.mas_right).offset(10);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.lessThanOrEqualTo(_timeLabel.mas_left).offset(-10);
    }];
    _nameLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    _nameLabel.font = [UIFont systemFontOfSize:14.f];
    
}

- (void)bindDataWithModel:(NSDictionary *)model{
    [[MDB_UserDefault defaultInstance] setViewWithImage:_avaterImageView url:[NSString nullToString:model[@"photo"]]];
    _nameLabel.text = [NSString nullToString:model[@"username"]];
    _timeLabel.text = [NSString stringWithFormat:@"助砍%@次",[NSString nullToString:model[@"count"]]];
}

- (void)respondsToGesture:(UIGestureRecognizer *)gesture{
    if ([self.delegate respondsToSelector:@selector(tableViewCellDidCickAvaterViewWithCell:)]) {
        [self.delegate tableViewCellDidCickAvaterViewWithCell:self];
    }
}
@end
