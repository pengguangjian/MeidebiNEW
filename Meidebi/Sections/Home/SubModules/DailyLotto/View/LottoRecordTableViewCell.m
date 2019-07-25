//
//  LottoRecordTableViewCell.m
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/8/30.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "LottoRecordTableViewCell.h"

@interface LottoRecordTableViewCell ()
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *prizeLabel;
@property (nonatomic, strong) UILabel *prizeStateLabel;
@end

@implementation LottoRecordTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    
    _dateLabel = [UILabel new];
    [self.contentView addSubview:_dateLabel];
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(26*kScale);

    }];
    _dateLabel.font = [UIFont systemFontOfSize:13.f];
    _dateLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _dateLabel.textAlignment = NSTextAlignmentRight;

    _prizeStateLabel = [UILabel new];
    [self.contentView addSubview:_prizeStateLabel];
    [_prizeStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-30*kScale);
    }];
    _prizeStateLabel.font = [UIFont systemFontOfSize:13.f];
    _prizeStateLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    [_prizeStateLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    _prizeLabel = [UILabel new];
    [self.contentView addSubview:_prizeLabel];
    [_prizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_centerX).offset(-25*kScale);
        make.right.equalTo(_prizeStateLabel.mas_left).offset(-10);
    }];
    _prizeLabel.numberOfLines = 0;
    _prizeLabel.font = [UIFont systemFontOfSize:13.f];
    _prizeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    
}

- (void)bindDataWithModel:(NSDictionary *)model{
    _dateLabel.text = [NSString nullToString:model[@"createtime"]];
    _prizeLabel.text = [NSString nullToString:model[@"prize"]];
    NSString *stateStr = @"未发放";
    if ([@"1" isEqualToString:[NSString stringWithFormat:@"%@",[NSString nullToString:model[@"is_giveout"]]]]) {
        stateStr = @"已发放";
    }
    _prizeStateLabel.text = stateStr;
}




@end
