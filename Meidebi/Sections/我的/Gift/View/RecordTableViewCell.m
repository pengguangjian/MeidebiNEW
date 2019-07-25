//
//  RecordTableViewCell.m
//  Meidebi
//
//  Created by mdb-admin on 2016/11/7.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "RecordTableViewCell.h"
#import "MDB_UserDefault.h"
@interface RecordTableViewCell ()

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *copperLabel;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation RecordTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setupSubViews{
    
    _timeLabel = [UILabel new];
    [self.contentView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(17);
    }];
    _timeLabel.textColor = [UIColor colorWithHexString:@"#8B8B8B"];
    _timeLabel.font = [UIFont systemFontOfSize:12.f];
    
    _copperLabel = [UILabel new];
    [self.contentView addSubview:_copperLabel];
    [_copperLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-18);
        make.centerY.equalTo(_timeLabel.mas_centerY);
    }];
    _copperLabel.textColor = _timeLabel.textColor;
    _copperLabel.font = _timeLabel.font;
    
    _nameLabel = [UILabel new];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeLabel.mas_bottom).offset(17);
        make.left.equalTo(_timeLabel.mas_left);
        make.right.equalTo(_copperLabel.mas_right);
    }];
    _nameLabel.font = [UIFont systemFontOfSize:14.f];
    _nameLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    
}

- (void)setRecordDict:(NSDictionary *)recordDict{
    _recordDict = recordDict;
    _timeLabel.text = [NSString nullToString:recordDict[@"createdate"]];
    NSString *strtemp = [NSString nullToString:recordDict[@"copper"]];
    if(strtemp.intValue>0)
    {
        _copperLabel.text  = [NSString stringWithFormat:@"%@铜币",[NSString nullToString:recordDict[@"copper"]]];
    }
    else
    {
        _copperLabel.text  = [NSString stringWithFormat:@"%@贡献值",[NSString nullToString:recordDict[@"contribution"]]];
    }
    
    _nameLabel.text  = [NSString nullToString:recordDict[@"title"]];
}
@end
