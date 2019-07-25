//
//  TaskHomeTableViewCell.m
//  Meidebi
//
//  Created by mdb-admin on 16/8/19.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "TaskHomeTableViewCell.h"
#import "MDB_UserDefault.h"
@interface TaskHomeTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIButton *taskHandleBtn;
@property (nonatomic, strong) UILabel *copperSumLabel;

@end

@implementation TaskHomeTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    _iconImageView = [UIImageView new];
    [self addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(16);
        make.size.mas_equalTo(CGSizeMake(63, 63));
    }];
    
    _taskHandleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_taskHandleBtn];
    [_taskHandleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-16);
        make.top.equalTo(self.mas_top).offset(19);
        make.size.mas_equalTo(CGSizeMake(71, 30));
    }];
    [_taskHandleBtn setBackgroundImage:[MDB_UserDefault createImageWithColor:[UIColor colorWithHexString:@"#FD7A0E"]] forState:UIControlStateNormal];
    [_taskHandleBtn setBackgroundImage:[MDB_UserDefault createImageWithColor:[UIColor colorWithHexString:@"#ff8721"]] forState:UIControlStateHighlighted];
    [_taskHandleBtn.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
    [_taskHandleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _taskHandleBtn.layer.masksToBounds = YES;
    _taskHandleBtn.layer.cornerRadius = 4.f;
    [_taskHandleBtn addTarget:self action:@selector(responsBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    _titleLabel = [UILabel new];
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView.mas_top).offset(4);
        make.left.equalTo(_iconImageView.mas_right).offset(12);
    }];
    _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    
    _copperSumLabel = [UILabel new];
    [self addSubview:_copperSumLabel];
    [_copperSumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_right).offset(3);
        make.bottom.equalTo(_titleLabel.mas_bottom).offset(-1);
        make.right.equalTo(_taskHandleBtn.mas_left).offset(-8);
    }];
    _copperSumLabel.textColor = [UIColor colorWithHexString:@"#F60000"];
    _copperSumLabel.font = [UIFont systemFontOfSize:12.f];
    
    _subTitleLabel = [UILabel new];
    [self addSubview:_subTitleLabel];
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(5);
        make.left.equalTo(_titleLabel.mas_left);
        make.right.equalTo(_taskHandleBtn.mas_left).offset(-5);
    }];
    _subTitleLabel.numberOfLines = 0;
    _subTitleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _subTitleLabel.font = [UIFont systemFontOfSize:12];

}

- (void)responsBtnEvent:(id)sender{
    if ([self.delegate respondsToSelector:@selector(tableViewCellDidPressHandleBtnWithHomeCell:)]) {
        [self.delegate tableViewCellDidPressHandleBtnWithHomeCell:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (BOOL)compareDate:(NSDate *)lastDate{
    if (!lastDate) return NO;

    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [NSDate date];
    NSDate *tomorrow, *yesterday;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
    NSString * dateString = [[lastDate description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString])
    {
        return YES;
    }else if ([dateString isEqualToString:yesterdayString]){
        return NO;
    }else if ([dateString isEqualToString:tomorrowString]){
        return NO;
    }else{
        return NO;
    }
    
}

#pragma mark - setters and getters
- (void)setTaskItemDict:(NSDictionary *)taskItemDict{
    _taskItemDict = taskItemDict;
    _iconImageView.image = taskItemDict[@"icon"];
    _titleLabel.text = taskItemDict[@"title"];
    _subTitleLabel.text = taskItemDict[@"subtitle"];
    _copperSumLabel.text = taskItemDict[@"copper"];
    
    switch ([taskItemDict[@"type"] integerValue]) {
        case 0:{
            [_taskHandleBtn setTitle:@"去做任务" forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
            if ([self compareDate:[MDB_UserDefault finishShareDate]]) {
                [_taskHandleBtn setTitle:@"再去赚" forState:UIControlStateNormal];
            }else{
                [_taskHandleBtn setTitle:@"去做任务" forState:UIControlStateNormal];
            }
        }
            break;
            
        case 2:
        {
            if ([self compareDate:[MDB_UserDefault finishBaskDate]]) {
                [_taskHandleBtn setTitle:@"再去赚" forState:UIControlStateNormal];
            }else{
                [_taskHandleBtn setTitle:@"去做任务" forState:UIControlStateNormal];
            }
        }
            break;
            
        case 3:
        {
            if ([self compareDate:[MDB_UserDefault finishBrokeDate]]) {
                [_taskHandleBtn setTitle:@"再去赚" forState:UIControlStateNormal];
            }else{
                [_taskHandleBtn setTitle:@"去做任务" forState:UIControlStateNormal];
            }
        }
            break;
        default:
            break;
    }
    
}




@end
