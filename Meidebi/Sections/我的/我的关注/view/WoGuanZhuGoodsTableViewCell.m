//
//  WoGuanZhuGoodsTableViewCell.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/3/26.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import "WoGuanZhuGoodsTableViewCell.h"
#import "MDB_UserDefault.h"

@interface WoGuanZhuGoodsTableViewCell ()
{
    UIImageView *imgvhead;
    UILabel *lbstate;
    UILabel *lbtitle;
    UILabel *lbxianjia;
    UILabel *lbshangcheng;
 
    UIButton *btguanzhu;
    
}
@end

@implementation WoGuanZhuGoodsTableViewCell

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
        
        
        lbstate = [[UILabel alloc] init];
        [lbstate setTextColor:[UIColor whiteColor]];
        [lbstate setTextAlignment:NSTextAlignmentCenter];
        [lbstate setFont:[UIFont systemFontOfSize:10]];
        [viewback addSubview:lbstate];
        [lbstate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(imgvhead);
            make.height.offset(18);
            make.width.offset(50);
        }];
        [lbstate setBackgroundColor:RGB(255, 98, 91)];
        [lbstate.layer setMasksToBounds:YES];
        [lbstate.layer setCornerRadius:2];
        
        lbtitle = [[UILabel alloc] init];
        [lbtitle setTextColor:RGB(30, 30, 30)];
        [lbtitle setTextAlignment:NSTextAlignmentLeft];
        [lbtitle setFont:[UIFont systemFontOfSize:16]];
        [lbtitle setNumberOfLines:2];
        [viewback addSubview:lbtitle];
        [lbtitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgvhead.mas_top);
            make.left.equalTo(imgvhead.mas_right).offset(15);
            make.right.equalTo(viewback.mas_right).offset(-15);
            make.height.offset(40);
        }];
        
        
        lbxianjia = [[UILabel alloc] init];
        [lbxianjia setTextColor:RadMenuColor];
        [lbxianjia setTextAlignment:NSTextAlignmentLeft];
        [lbxianjia setFont:[UIFont systemFontOfSize:14]];
        [viewback addSubview:lbxianjia];
        [lbxianjia mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lbtitle.mas_bottom).offset(4);
            make.left.equalTo(lbtitle);
            make.height.offset(20);
            make.width.offset(kMainScreenW*0.5);
        }];
        
        
        lbshangcheng = [[UILabel alloc] init];
        [lbshangcheng setTextColor:RGB(190, 190, 190)];
        [lbshangcheng setTextAlignment:NSTextAlignmentLeft];
        [lbshangcheng setFont:[UIFont systemFontOfSize:12]];
        [viewback addSubview:lbshangcheng];
        [lbshangcheng mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lbxianjia.mas_bottom).offset(5);
            make.left.equalTo(lbxianjia);
            make.height.offset(20);
//            make.width.offset(kMainScreenW*0.35*kScale);
        }];
        
        btguanzhu = [[UIButton alloc] init];
        [viewback addSubview:btguanzhu];
        [btguanzhu mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.right.equalTo(viewback.mas_right).offset(-15);
            make.height.offset(35);
            make.top.equalTo(lbxianjia.mas_top).offset(10);
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
        [lbshangcheng mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(btguanzhu.mas_left).offset(-5);
        }];
        
        
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
    [[MDB_UserDefault defaultInstance] setViewWithImage:imgvhead url:_model.image];
    
    [lbstate setHidden:NO];
    if(_model.lowpricetype.integerValue == 1)
    {
        [lbstate setText:@"历史低价"];
        [lbstate setBackgroundColor:RGB(191, 213, 180)];
    }
    else if(_model.lowpricetype.integerValue == 2)
    {
        [lbstate setText:@"近期好价"];
        [lbstate setBackgroundColor:RGB(255, 98, 91)];
    }
    else
    {
        [lbstate setHidden:YES];
    }
    
    [lbtitle setText:_model.title];
    
    [lbxianjia setText:[NSString stringWithFormat:@"￥%@",_model.price]];
    
    [lbshangcheng setText:_model.name];
    
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
