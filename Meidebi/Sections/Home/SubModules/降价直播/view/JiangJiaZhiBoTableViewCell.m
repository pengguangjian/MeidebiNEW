//
//  JiangJiaZhiBoTableViewCell.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/3/25.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import "JiangJiaZhiBoTableViewCell.h"

#import "MDB_UserDefault.h"

@interface JiangJiaZhiBoTableViewCell ()
{
    
    UIImageView *imgvhead;
    UILabel *lbstate;
    UILabel *lbtitle;
    UILabel *lbxianjia;
    UILabel *lbshangcijia;
    UILabel *lbshangcheng;
    UIButton *btjj;
    UILabel *lbtime;
    
    UILabel *lbjiangjia;
    
}
@end

@implementation JiangJiaZhiBoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
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
        [lbxianjia setFont:[UIFont systemFontOfSize:16]];
        [viewback addSubview:lbxianjia];
        [lbxianjia mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lbtitle.mas_bottom).offset(4);
            make.left.equalTo(lbtitle);
            make.height.offset(18);
            make.width.offset(kMainScreenW*0.5);
        }];
        
        lbshangcijia = [[UILabel alloc] init];
        [lbshangcijia setTextColor:RGB(169, 169, 169)];
        [lbshangcijia setTextAlignment:NSTextAlignmentLeft];
        [lbshangcijia setFont:[UIFont systemFontOfSize:13]];
        [viewback addSubview:lbshangcijia];
        [lbshangcijia mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lbxianjia.mas_bottom);
            make.left.equalTo(lbxianjia);
            make.height.offset(18);
            make.width.offset(kMainScreenW*0.5);
        }];
        
        lbshangcheng = [[UILabel alloc] init];
        [lbshangcheng setTextColor:RGB(190, 190, 190)];
        [lbshangcheng setTextAlignment:NSTextAlignmentLeft];
        [lbshangcheng setFont:[UIFont systemFontOfSize:12]];
        [viewback addSubview:lbshangcheng];
        [lbshangcheng mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lbshangcijia.mas_bottom).offset(5);
            make.left.equalTo(lbxianjia);
            make.height.offset(20);
            make.width.offset(kMainScreenW*0.5);
        }];
        
        
        UIImage *image = [UIImage imageNamed:@"jiangjiazhibo_jiangjia"];
        btjj = [[UIButton alloc] init];
        [btjj setBackgroundImage:image forState:UIControlStateNormal];
        [viewback addSubview:btjj];
        [btjj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lbtitle.mas_bottom).offset(3);
            make.right.equalTo(viewback.mas_right).offset(-15);
            make.height.offset(42);
            make.width.offset(38);
        }];
        [btjj setTitleEdgeInsets:UIEdgeInsetsMake(-8, 0, 0, 0)];
        [btjj setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btjj.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [btjj.titleLabel setNumberOfLines:2];
        [btjj.titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        UILabel *lbjiang = [[UILabel alloc] init];
        [lbjiang setTextColor:[UIColor whiteColor]];
        [lbjiang setTextAlignment:NSTextAlignmentCenter];
        [lbjiang setFont:[UIFont systemFontOfSize:13]];
        [btjj addSubview:lbjiang];
        [lbjiang mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(btjj.mas_top).offset(3);
            make.right.left.equalTo(btjj);
            make.height.equalTo(btjj.mas_height).multipliedBy(0.37);
        }];
        [lbjiang setText:@"降"];
        
        lbjiangjia = [[UILabel alloc] init];
        [lbjiangjia setTextColor:[UIColor whiteColor]];
        [lbjiangjia setTextAlignment:NSTextAlignmentCenter];
        [lbjiangjia setFont:[UIFont systemFontOfSize:13]];
        [btjj addSubview:lbjiangjia];
        [lbjiangjia mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lbjiang.mas_bottom);
            make.right.left.equalTo(btjj);
            make.height.equalTo(btjj.mas_height).multipliedBy(0.38);
        }];
        lbjiangjia.adjustsFontSizeToFitWidth = YES;
        lbjiangjia.minimumScaleFactor = 0.1;
        
        
        
        lbtime = [[UILabel alloc] init];
        [lbtime setTextColor:RGB(190, 190, 190)];
        [lbtime setTextAlignment:NSTextAlignmentRight];
        [lbtime setFont:[UIFont systemFontOfSize:12]];
        [viewback addSubview:lbtime];
        [lbtime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lbshangcheng.mas_top);
            make.right.equalTo(viewback.mas_right).offset(-15);
            make.height.offset(20);
            make.width.offset(100);
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
    
    NSMutableArray *arrbldj = [[NSUserDefaults standardUserDefaults] objectForKey:@"baoliaoyidianji"];
    BOOL isbool = [arrbldj containsObject:[NSString stringWithFormat:@"%@", _model.did]];
    if(_model.isSelected == YES || isbool==YES)
    {
        [lbtitle setTextColor:RGB(150, 150, 150)];
    }
    else
    {
        [lbtitle setTextColor:RGB(30, 30, 30)];
    }
    
    [lbxianjia setText:[NSString stringWithFormat:@"现 价：￥%@",_model.activeprice]];
    [lbshangcijia setText:[NSString stringWithFormat:@"上次价：￥%@",_model.last_price]];
    
    
    
    [lbshangcheng setText:_model.sitename];
    
    
    [lbtime setText:_model.createtime];
    
    [lbjiangjia setText:[NSString stringWithFormat:@"￥%.2lf",_model.last_price.floatValue-_model.activeprice.floatValue]];
    
}

@end
