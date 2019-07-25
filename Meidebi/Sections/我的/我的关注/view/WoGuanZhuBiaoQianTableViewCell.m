//
//  WoGuanZhuBiaoQianTableViewCell.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/3/26.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import "WoGuanZhuBiaoQianTableViewCell.h"
@interface WoGuanZhuBiaoQianTableViewCell ()
{
    UILabel *lbtitle;
    
    
    UIButton *btguanzhu;
}
@end

@implementation WoGuanZhuBiaoQianTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UIView *viewback = [[UIView alloc] init];
        [viewback setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:viewback];
        [viewback mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self);
        }];
        
        
        lbtitle = [[UILabel alloc] init];
        [lbtitle setTextColor:RGB(30, 30, 30)];
        [lbtitle setTextAlignment:NSTextAlignmentLeft];
        [lbtitle setFont:[UIFont systemFontOfSize:16]];
        [lbtitle setNumberOfLines:2];
        [viewback addSubview:lbtitle];
        [lbtitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(viewback.mas_top);
            make.left.equalTo(viewback.mas_left).offset(30);
            make.right.equalTo(viewback.mas_right).offset(-83);
            make.bottom.equalTo(viewback.mas_bottom).offset(-1);
        }];
        
        
        
        btguanzhu = [[UIButton alloc] init];
        [viewback addSubview:btguanzhu];
        [btguanzhu mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(viewback.mas_right).offset(-13);
            make.height.offset(35);
            make.centerY.equalTo(viewback);
            make.width.offset(68);
        }];
        [btguanzhu.layer setMasksToBounds:YES];
        [btguanzhu.layer setCornerRadius:3];
        [btguanzhu.layer setBorderColor:RGB(230, 230, 230).CGColor];
        [btguanzhu.layer setBorderWidth:1];
        [btguanzhu setTitle:@"取消关注" forState:UIControlStateNormal];
        [btguanzhu setTitleColor:RGB(200, 200, 200) forState:UIControlStateNormal];
        [btguanzhu.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [btguanzhu addTarget:self action:@selector(guanzhuAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        UIView *viewline = [[UIView alloc] init];
        [viewline setBackgroundColor:RGB(245, 245, 245)];
        [viewback addSubview:viewline];
        [viewline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(viewback);
            make.height.offset(1);
        }];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [lbtitle setText:_model.name];
    
    if(_model.iscancle)
    {
        [btguanzhu.layer setBorderColor:RadMenuColor.CGColor];
        [btguanzhu setTitle:@"+关注" forState:UIControlStateNormal];
        [btguanzhu setTitleColor:RadMenuColor forState:UIControlStateNormal];
    }
    else
    {
        [btguanzhu.layer setBorderColor:RGB(230, 230, 230).CGColor];
        [btguanzhu setTitle:@"取消关注" forState:UIControlStateNormal];
        [btguanzhu setTitleColor:RGB(200, 200, 200) forState:UIControlStateNormal];
    }
}
-(void)guanzhuAction
{
    [self.delegate guanzhuAction:_model];
}

@end
