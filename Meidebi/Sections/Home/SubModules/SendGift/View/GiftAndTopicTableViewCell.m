//
//  GiftAndTopicTableViewCell.m
//  Meidebi
//
//  Created by mdb-admin on 2017/11/30.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "GiftAndTopicTableViewCell.h"
#import "MDB_UserDefault.h"
@interface GiftAndTopicTableViewCell()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *actorNumLabel;
@property (nonatomic, strong) UIButton *stateBtn;
@end

@implementation GiftAndTopicTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configurUI];
    }
    return self;
}

- (void)configurUI{
    _iconImageView = [UIImageView new];
    [self.contentView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(14);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(111, 111));
    }];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    _titleLabel = [UILabel new];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.mas_right).offset(14);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.top.equalTo(self.contentView.mas_top).offset(26);
    }];
    _titleLabel.numberOfLines = 2;
    _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    
    _timeLabel = [UILabel new];
    [self.contentView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_titleLabel);
        make.top.equalTo(_titleLabel.mas_bottom).offset(13);
    }];
    _timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    
    _actorNumLabel = [UILabel new];
    [self.contentView addSubview:_actorNumLabel];
    [_actorNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_titleLabel);
        make.top.equalTo(_timeLabel.mas_bottom).offset(11);
    }];
    _actorNumLabel.textColor = [UIColor colorWithHexString:@"#F2463A"];
    _actorNumLabel.font = [UIFont systemFontOfSize:12];

    _stateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_stateBtn];
    [_stateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(_iconImageView);
        make.size.mas_equalTo(CGSizeMake(51, 23));
    }];
    _stateBtn.backgroundColor = [UIColor colorWithHexString:@"#838383"];
    _stateBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [_stateBtn setTitle:@"已过期" forState:UIControlStateNormal];
    _stateBtn.userInteractionEnabled = NO;
    _stateBtn.hidden = YES;
    
}


- (void)bindDataWithModel:(NSDictionary *)model{
    [[MDB_UserDefault defaultInstance] setViewWithImage:_iconImageView url:[NSString nullToString:model[@"image"]]];
    _titleLabel.text = [NSString nullToString:model[@"title"]];
    NSString *starDate = [MDB_UserDefault strTimefromDatas:[NSDate dateWithTimeIntervalSince1970:[model[@"starttime"] integerValue]] dataFormat:@"yyyy-MM-dd"];
    NSString *endDate = [MDB_UserDefault strTimefromDatas:[NSDate dateWithTimeIntervalSince1970:[model[@"endtime"] integerValue]] dataFormat:@"yyyy-MM-dd"];
    NSString *state = [NSString nullToString:model[@"state"]];
    if (state.integerValue == -1) {
        _stateBtn.hidden = NO;
    }else{
        _stateBtn.hidden = YES;
    }
    if ([model[@"starttime"] integerValue] > 0) {
        _timeLabel.text = [NSString stringWithFormat:@"%@至%@",starDate,endDate];
    }else{
        _timeLabel.text = [MDB_UserDefault strTimefromDatas:[NSDate dateWithTimeIntervalSince1970:[model[@"createtime"] integerValue]] dataFormat:@"yyyy-MM-dd"];
    }
    _actorNumLabel.text = [@"" isEqualToString:[NSString nullToString:model[@"denomination"]]] ? @"": [NSString stringWithFormat:@"%@元券",[NSString nullToString:model[@"denomination"]]];
    NSString *denominationStr = [NSString nullToString:model[@"commentcount"] preset:@"0"];
    NSString *trailerStr = @"人参与";
    NSString *totalStr = [denominationStr stringByAppendingString:trailerStr];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalStr];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor colorWithHexString:@"#F2463A"]
                          range:NSMakeRange(0, denominationStr.length)];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor colorWithHexString:@"#999999"]
                          range:NSMakeRange(denominationStr.length, trailerStr.length)];
    [attributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:12]
                          range:NSMakeRange(0, totalStr.length)];
    _actorNumLabel.attributedText = attributedStr;

}
@end
