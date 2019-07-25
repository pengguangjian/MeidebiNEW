//
//  MyZanAndCallMeTableViewCell.m
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/7.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "MyZanAndCallMeTableViewCell.h"
#import "MDB_UserDefault.h"
@interface MyZanAndCallMeTableViewCell ()

@property (nonatomic, strong) UIImageView *avaterImageView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *handleLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *describleLabel;

@end

@implementation MyZanAndCallMeTableViewCell

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
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    _avaterImageView.layer.masksToBounds = YES;
    _avaterImageView.layer.cornerRadius = 15.f;
    _avaterImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToAvaterImageView:)];
    [_avaterImageView addGestureRecognizer:tapGesture];
    
    _userNameLabel = [UILabel new];
    [self.contentView addSubview:_userNameLabel];
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avaterImageView.mas_right).offset(8);
        make.centerY.equalTo(_avaterImageView.mas_centerY);
        make.width.mas_lessThanOrEqualTo(@60);
    }];
    _userNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    _userNameLabel.font = [UIFont systemFontOfSize:14.f];
    
    _handleLabel = [UILabel new];
    [self.contentView addSubview:_handleLabel];
    [_handleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userNameLabel.mas_right).offset(13);
        make.centerY.equalTo(_userNameLabel.mas_centerY);
    }];
    _handleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    _handleLabel.font = [UIFont systemFontOfSize:12.f];

    
    _dateLabel = [UILabel new];
    [self.contentView addSubview:_dateLabel];
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.centerY.equalTo(_handleLabel.mas_centerY);
    }];
    _dateLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    _dateLabel.font = [UIFont systemFontOfSize:12.f];
    _dateLabel.textAlignment = NSTextAlignmentRight;
    
    _iconImageView = [UIImageView new];
    [self.contentView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avaterImageView.mas_bottom).offset(8);
        make.left.equalTo(_avaterImageView.mas_right).offset(8);
        make.size.mas_equalTo(CGSizeMake(61, 61));
    }];
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.layer.cornerRadius = 4.f;
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _describleLabel = [UILabel new];
    [self.contentView addSubview:_describleLabel];
    [_describleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.left.equalTo(_iconImageView.mas_right).offset(8);
        make.centerY.equalTo(_iconImageView.mas_centerY);
    }];
    _describleLabel.numberOfLines = 3;
    _describleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _describleLabel.font = [UIFont systemFontOfSize:12.f];
}

- (void)respondsToAvaterImageView:(UIGestureRecognizer *)gesture{
    if ([self.delegate respondsToSelector:@selector(tableViewCellDidClickAvaterImageView:)]) {
        [self.delegate tableViewCellDidClickAvaterImageView:self];
    }
}

- (void)bindDataWithModel:(NSDictionary *)model{
    [[MDB_UserDefault defaultInstance] setViewWithImage:_avaterImageView url:[NSString nullToString:model[@"photo"]]];
    [[MDB_UserDefault defaultInstance] setViewWithImage:_iconImageView url:[NSString nullToString:model[@"image"]]];
    _userNameLabel.text = [NSString nullToString:model[@"username"]];
    if ([@"5" isEqualToString:[NSString nullToString:model[@"type"]]]) {
        _handleLabel.text = [NSString stringWithFormat:@"赞了我的活动"];
    }else if ([@"1" isEqualToString:[NSString nullToString:model[@"type"]]]) {
        _handleLabel.text = [NSString stringWithFormat:@"赞了我的爆料"];
    }
    else
    {
        
        NSLog(@"其他赞");
        
    }
    
    _dateLabel.text = [MDB_UserDefault strTimefromDatas:[NSDate dateWithTimeIntervalSince1970:[[NSString nullToString:model[@"createtime"]] integerValue]] dataFormat:@"yyyy-MM-dd"];;
    _describleLabel.text = [NSString nullToString:model[@"title"]];
}



@end
