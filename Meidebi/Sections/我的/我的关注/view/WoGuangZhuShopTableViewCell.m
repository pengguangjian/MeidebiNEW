//
//  WoGuangZhuShopTableViewCell.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/3/26.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import "WoGuangZhuShopTableViewCell.h"
#import "MDB_UserDefault.h"
@interface WoGuangZhuShopTableViewCell ()
{
    UIImageView *imgvhead;
    UILabel *lbtitle;
    UILabel *lbcontent;
    
    UIButton *btguanzhu;
    
}
@end

@implementation WoGuangZhuShopTableViewCell

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
        
        imgvhead = [[UIImageView alloc] init];
        [viewback addSubview:imgvhead];
        [imgvhead setContentMode:UIViewContentModeScaleAspectFit];
        [imgvhead mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.offset(10);
            make.bottom.equalTo(viewback.mas_bottom).offset(-10);
            make.width.equalTo(viewback.mas_height).offset(-20);
        }];
        
    
        
        lbtitle = [[UILabel alloc] init];
        [lbtitle setTextColor:RGB(30, 30, 30)];
        [lbtitle setTextAlignment:NSTextAlignmentLeft];
        [lbtitle setFont:[UIFont systemFontOfSize:16]];
        [lbtitle setNumberOfLines:2];
        [viewback addSubview:lbtitle];
        [lbtitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgvhead.mas_top);
            make.left.equalTo(imgvhead.mas_right).offset(15);
            make.right.equalTo(viewback.mas_right).offset(-83);
            make.height.offset(40);
        }];
        
        
        
        lbcontent = [[UILabel alloc] init];
        [lbcontent setTextColor:RGB(190, 190, 190)];
        [lbcontent setTextAlignment:NSTextAlignmentLeft];
        [lbcontent setFont:[UIFont systemFontOfSize:12]];
        [lbcontent setNumberOfLines:2];
        [viewback addSubview:lbcontent];
        [lbcontent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lbtitle.mas_bottom).offset(5);
            make.left.equalTo(lbtitle);
            make.height.offset(35);
            make.right.equalTo(viewback.mas_right).offset(-15);
        }];
        
        btguanzhu = [[UIButton alloc] init];
        [viewback addSubview:btguanzhu];
        [btguanzhu mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(viewback.mas_right).offset(-13);
            make.height.offset(35);
            make.top.equalTo(lbtitle.mas_top);
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
    
    [[MDB_UserDefault defaultInstance] setViewWithImage:imgvhead url:_model.logo1];
    [lbtitle setText:_model.name];
    
    [lbcontent setText:_model.sitesigndes];
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
