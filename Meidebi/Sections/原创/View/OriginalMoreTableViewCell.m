//
//  OriginalMoreTableViewCell.m
//  Meidebi
//
//  Created by mdb-admin on 2017/9/27.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "OriginalMoreTableViewCell.h"
#import "MDB_UserDefault.h"
#import "PelsonalHandleButton.h"
@interface OriginalMoreTableViewCell ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) PelsonalHandleButton *likeBtn;
@property (nonatomic, strong) PelsonalHandleButton *contentBtn;
@end

@implementation OriginalMoreTableViewCell

-  (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
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
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.top.equalTo(self.contentView.mas_top).offset(12);
        make.height.width.equalTo(self.mas_height).offset(-24);
//        make.right.equalTo(self.contentView.mas_right).offset(-16);
//        make.height.equalTo(_iconImageView.mas_width).multipliedBy(0.44);
    }];
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.layer.cornerRadius = 4.f;
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    
    _titleLabel = [UILabel new];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.mas_right).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(_iconImageView.mas_top);
        make.height.offset(38);
    }];
    _titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    _titleLabel.font = [UIFont systemFontOfSize:15.f];
    [_titleLabel setNumberOfLines:2];
    [_titleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [_titleLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    
    _contentLabel = [UILabel new];
    [self.contentView addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_left);
        make.right.equalTo(_titleLabel.mas_right);
        make.top.equalTo(_titleLabel.mas_bottom);
        make.height.equalTo(_iconImageView.mas_height).multipliedBy(0.44);
    }];
    _contentLabel.textColor = [UIColor colorWithHexString:@"#888888"];
    _contentLabel.font = [UIFont systemFontOfSize:13.f];
    [_contentLabel setNumberOfLines:3];
    [_contentLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [_contentLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    
    
     _likeBtn = [PelsonalHandleButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_likeBtn];
    [_likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_contentLabel.mas_right);
        make.bottom.equalTo(_iconImageView.mas_bottom).offset(5);
        make.height.offset(30);
    }];
    [_likeBtn setImage:[UIImage imageNamed:@"pelsonal_linke_normal"] forState:UIControlStateNormal];
    [_likeBtn setImage:[UIImage imageNamed:@"pelsonal_linke_normal"] forState:UIControlStateHighlighted];
    _likeBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [_likeBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [_likeBtn addTarget:self action:@selector(repondsToBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_likeBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_likeBtn setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    
     _contentBtn = [PelsonalHandleButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_contentBtn];
    [_contentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_likeBtn.mas_left).offset(-20);
        make.bottom.equalTo(_likeBtn.mas_bottom);
        make.height.equalTo(_likeBtn.mas_height);
    }];
    [_contentBtn setImage:[UIImage imageNamed:@"discount_comment_normal"] forState:UIControlStateNormal];
    _contentBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [_contentBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
//    [_contentBtn addTarget:self action:@selector(pinlunToBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_contentBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_contentBtn setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    
    
}

- (void)bindDataWithModel:(NSDictionary *)model{
    if (!model) return;
    [[MDB_UserDefault defaultInstance] setViewWithImage:_iconImageView url:[MDB_UserDefault getCompleteWebsite:[NSString nullToString:model[@"pic"]]]];
    
    
    _titleLabel.text = [NSString nullToString:model[@"title"]];
    _contentLabel.text = [NSString nullToString:model[@"shortcontent"]];
    
    if (![@"" isEqualToString:[NSString nullToString:model[@"votesp"]]]) {
        _likeBtn.hidden = NO;
        [_likeBtn setTitle:[self numberChangeStringValue:[NSNumber numberWithInt:[NSString stringWithFormat:@"%@",model[@"votesp"]].intValue]] forState:UIControlStateNormal];
        
    }else{
        _likeBtn.hidden = YES;
    }
    if ([@"1" isEqualToString:model[@"isLike"]]) {
        [_likeBtn setImage:[UIImage imageNamed:@"pelsonal_linke_select"] forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"pelsonal_linke_select"] forState:UIControlStateHighlighted];
    }else{
        [_likeBtn setImage:[UIImage imageNamed:@"pelsonal_linke_normal"] forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"pelsonal_linke_normal"] forState:UIControlStateHighlighted];
    }
    
    
    [_contentBtn setTitle:[self numberChangeStringValue:[NSNumber numberWithInt:[NSString stringWithFormat:@"%@",model[@"commentcount"]].intValue]] forState:UIControlStateNormal];
    
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

- (void)repondsToBtnEvent:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(OriginalMoreTableViewCellDidClickLikeBtnWithCell:)]) {
        [self.delegate OriginalMoreTableViewCellDidClickLikeBtnWithCell:self];
    }
}

@end
