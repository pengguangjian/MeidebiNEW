//
//  PersonalShareTableViewCell.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/20.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "PersonalShareTableViewCell.h"
#import "PelsonalHandleButton.h"
#import "MDB_UserDefault.h"
@interface PersonalShareTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) PelsonalHandleButton *looksNumBtn;
@property (nonatomic, strong) PelsonalHandleButton *remarkNumBtn;
@property (nonatomic, strong) PelsonalHandleButton *collectNumBtn;

@end

@implementation PersonalShareTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
         self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    _iconImageView = [UIImageView new];
    [self.contentView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.right.equalTo(self.contentView.mas_right).offset(-12);
        make.height.equalTo(_iconImageView.mas_width).multipliedBy(0.47);
    }];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.layer.cornerRadius = 5.f;
    
    UIView *titleBgView = [UIView new];
    [_iconImageView addSubview:titleBgView];
    [titleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_iconImageView);
        make.height.offset(34);
    }];
    titleBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:.3];
    
    _titleLabel = [UILabel new];
    [titleBgView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(titleBgView).insets(UIEdgeInsetsMake(10, 12, 10, 12));
    }];
    _titleLabel.font = [UIFont systemFontOfSize:14.f];
    _titleLabel.textColor = [UIColor whiteColor];
    
    _contentLabel = [UILabel new];
    [self.contentView addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView.mas_bottom).offset(14);
        make.left.right.equalTo(_iconImageView);
    }];
    _contentLabel.numberOfLines = 2;
    _contentLabel.font = [UIFont systemFontOfSize:14.f];
    _contentLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    
    _remarkNumBtn = [PelsonalHandleButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_remarkNumBtn];
    [_remarkNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentLabel.mas_bottom).offset(16);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
    _remarkNumBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [_remarkNumBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    _remarkNumBtn.userInteractionEnabled = NO;
    [_remarkNumBtn setImage:[UIImage imageNamed:@"discount_comment_normal"] forState:UIControlStateNormal];
    
    UIView *lineView = [UIView new];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_remarkNumBtn.mas_left).offset(-26);
        make.centerY.equalTo(_remarkNumBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(1, 12));
    }];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    
    UIView *lineView1 = [UIView new];
    [self.contentView addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_remarkNumBtn.mas_right).offset(26);
        make.centerY.equalTo(_remarkNumBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(1, 12));
    }];
    lineView1.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    
    _looksNumBtn = [PelsonalHandleButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_looksNumBtn];
    [_looksNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_remarkNumBtn.mas_centerY);
        make.right.equalTo(lineView.mas_left).offset(-26);
    }];
    _looksNumBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [_looksNumBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    _looksNumBtn.userInteractionEnabled = NO;
    [_looksNumBtn setImage:[UIImage imageNamed:@"pelsonal_look_normal"] forState:UIControlStateNormal];
    
    _collectNumBtn = [PelsonalHandleButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_collectNumBtn];
    [_collectNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_remarkNumBtn.mas_centerY);
        make.left.equalTo(lineView1.mas_right).offset(26);
    }];
    _collectNumBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [_collectNumBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    _collectNumBtn.userInteractionEnabled = NO;
    [_collectNumBtn setImage:[UIImage imageNamed:@"discount_collect_normal"] forState:UIControlStateNormal];
}

- (void)bindDataWithModel:(PersonalShareViewModel *)model{
    if (!model) return;
    [[MDB_UserDefault defaultInstance] setViewWithImage:_iconImageView url:model.image];
    _titleLabel.text = model.artTitle;
    _contentLabel.text = model.content;
    [_looksNumBtn setTitle:[self numberChangeStringValue:[NSNumber numberWithInt:[NSString stringWithFormat:@"%@",model.showcount].intValue]] forState:UIControlStateNormal];
    [_remarkNumBtn setTitle:[self numberChangeStringValue:[NSNumber numberWithInt:[NSString stringWithFormat:@"%@",model.commentcount].intValue]] forState:UIControlStateNormal];
    [_collectNumBtn setTitle:[self numberChangeStringValue:[NSNumber numberWithInt:[NSString stringWithFormat:@"%@",model.collectcount].intValue]] forState:UIControlStateNormal];
    
    
    
}
-(NSString *)numberChangeStringValue:(NSNumber *)value
{
    NSString *strtemp = @"";
    if(value.integerValue>=1000&&value.integerValue<10000)
    {
        strtemp = [NSString stringWithFormat:@"%dk+",value.intValue/1000];
    }
    else if (value.integerValue>=10000)
    {
        strtemp = [NSString stringWithFormat:@"%dw+",value.intValue/10000];
    }
    else
    {
        strtemp = [NSString stringWithFormat:@"%d",value.intValue];
    }
    return strtemp;
}


@end
