//
//  JinRiPinDanListTableViewCell.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/29.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "JinRiPinDanListTableViewCell.h"

#import "MDB_UserDefault.h"

@interface JinRiPinDanListTableViewCell ()
{
    UIView *viewback;
    
    UIImageView *imgvhead;
    
    UILabel *lbzhiding;
    
    UILabel *lbtitle;
    
    UILabel *lbprice;
    
    UILabel *lbshop;
    
    UILabel *lbtime;
    
    UILabel *lbzhiyou;
    
    UIView *viewline;
    
    UIImageView *imgvhd0;
    UIImageView *imgvhd1;
    UIImageView *imgvhd2;
    NSMutableArray *arrimgvhd;
    UILabel *lbpintuan;
    
    UILabel *lbjiedan;
    
    UIButton *btaddgouwucar;
    
    UILabel *lbisspotgoods;
    
}
@end

@implementation JinRiPinDanListTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        viewback = [[UIView alloc] initWithFrame:CGRectZero];
        [viewback setBackgroundColor:[UIColor whiteColor]];
        
        imgvhead = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        
        lbzhiding = [[UILabel alloc] initWithFrame:CGRectZero];
//        [lbzhiding setText:@"置顶"];
        [lbzhiding setTextColor:[UIColor whiteColor]];
        [lbzhiding setTextAlignment:NSTextAlignmentCenter];
        [lbzhiding setFont:[UIFont systemFontOfSize:11]];
        [lbzhiding setBackgroundColor:RGB(243,93,0)];
        
        
        lbtitle = [[UILabel alloc] initWithFrame:CGRectZero];
        [lbtitle setTextColor:RGB(102,102,102)];
        [lbtitle setTextAlignment:NSTextAlignmentLeft];
        [lbtitle setFont:[UIFont systemFontOfSize:16]];
        [lbtitle setNumberOfLines:2];
        
        
        lbprice = [[UILabel alloc] initWithFrame:CGRectZero];
        [lbprice setTextColor:RGB(243,93,0)];
        [lbprice setTextAlignment:NSTextAlignmentLeft];
        [lbprice setFont:[UIFont systemFontOfSize:16]];
        
        lbshop = [[UILabel alloc] initWithFrame:CGRectZero];
        [lbshop setTextColor:RGB(153,153,153)];
        [lbshop setTextAlignment:NSTextAlignmentLeft];
        [lbshop setFont:[UIFont systemFontOfSize:10]];
        
        
//        lbtime = [[UILabel alloc] initWithFrame:CGRectZero];
//        [lbtime setTextColor:RGB(153,153,153)];
//        [lbtime setTextAlignment:NSTextAlignmentRight];
//        [lbtime setFont:[UIFont systemFontOfSize:10]];
//
//
//        lbzhiyou = [[UILabel alloc] initWithFrame:CGRectZero];
//        [lbzhiyou setTextColor:RGB(230,56,47)];
//        [lbzhiyou setTextAlignment:NSTextAlignmentCenter];
//        [lbzhiyou setFont:[UIFont systemFontOfSize:11]];
//        [lbzhiyou.layer setMasksToBounds:YES];
//        [lbzhiyou.layer setBorderColor:RGB(230,56,47).CGColor];
//        [lbzhiyou setText:@"直邮"];
//        [lbzhiyou.layer setBorderWidth:1];
        
        
        lbisspotgoods = [[UILabel alloc] initWithFrame:CGRectZero];
        [lbisspotgoods setTextColor:RadMenuColor];
        [lbisspotgoods setTextAlignment:NSTextAlignmentCenter];
        [lbisspotgoods setFont:[UIFont systemFontOfSize:11]];
        [lbisspotgoods.layer setMasksToBounds:YES];
        [lbisspotgoods.layer setBorderColor:RadMenuColor.CGColor];
        [lbisspotgoods setText:@"现货"];
        [lbisspotgoods.layer setBorderWidth:1];
        
        arrimgvhd = [NSMutableArray new];
        imgvhd0 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        [imgvhd0.layer setMasksToBounds:YES];
        [imgvhd0.layer setCornerRadius:imgvhd0.height/2.0];
        [arrimgvhd addObject:imgvhd0];
        
        imgvhd1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgvhd0.width, imgvhd0.height)];
        [imgvhd1.layer setMasksToBounds:YES];
        [imgvhd1.layer setCornerRadius:imgvhd1.height/2.0];
        [arrimgvhd addObject:imgvhd1];
        
        imgvhd2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgvhd0.width, imgvhd0.height)];
        [imgvhd2.layer setMasksToBounds:YES];
        [imgvhd2.layer setCornerRadius:imgvhd2.height/2.0];
        [arrimgvhd addObject:imgvhd2];
        
        lbpintuan = [[UILabel alloc] initWithFrame:CGRectZero];
        [lbpintuan setTextColor:RGB(153,153,153)];
        [lbpintuan setTextAlignment:NSTextAlignmentLeft];
        [lbpintuan setFont:[UIFont systemFontOfSize:11]];
        
        lbjiedan = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [lbjiedan setTextColor:[UIColor whiteColor]];
        [lbjiedan setTextAlignment:NSTextAlignmentCenter];
        [lbjiedan setFont:[UIFont systemFontOfSize:14]];
        [lbjiedan.layer setMasksToBounds:YES];
        [lbjiedan.layer setCornerRadius:lbjiedan.height/2.0];
        [lbjiedan setBackgroundColor:RGBAlpha(0, 0, 0, 0.7)];
        [lbjiedan setText:@"已截单"];
        
        viewline = [[UIView alloc] initWithFrame:CGRectZero];
        [viewline setBackgroundColor:RGB(236,236,236)];
        
        btaddgouwucar = [[UIButton alloc] initWithFrame:CGRectZero];
        [btaddgouwucar setImage:[UIImage imageNamed:@"addgouwuche_remu"] forState:UIControlStateNormal];
        [btaddgouwucar addTarget:self action:@selector(addgouwuche) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    for(UIImageView *imgv in arrimgvhd)
    {
        [imgv removeFromSuperview];
    }
    
    [viewback setFrame:CGRectMake(0, 0, self.width, self.height)];
    [self.contentView addSubview:viewback];
    
    
    [imgvhead setFrame:CGRectMake(10, 13, viewback.height-26, viewback.height-26)];
    [[MDB_UserDefault defaultInstance] setViewWithImage:imgvhead url:_model.strimage];
    [viewback addSubview:imgvhead];
    [imgvhead setContentMode:UIViewContentModeScaleAspectFit];
    
//    [lbzhiding setFrame:CGRectMake(0, 0, 38, 17)];
//    [imgvhead addSubview:lbzhiding];
    
    [lbtitle setFrame:CGRectMake(imgvhead.right+10, imgvhead.top, viewback.width-imgvhead.right-20, 40)];
    [lbtitle setText:_model.strtitle];
    [viewback addSubview:lbtitle];
    NSMutableArray *arrbldj = [[NSUserDefaults standardUserDefaults] objectForKey:@"baoliaoyidianji"];
    BOOL isbool = [arrbldj containsObject:[NSString stringWithFormat:@"%@", _model.strshare_id]];
    if(isbool==YES)
    {
        [lbtitle setTextColor:RGB(150, 150, 150)];
    }
    else
    {
        [lbtitle setTextColor:RGB(30, 30, 30)];
    }
    
    
    [lbprice setFrame:CGRectMake(lbtitle.left, lbtitle.bottom+12, lbtitle.width, 15)];
    [lbprice setText:[NSString stringWithFormat:@"拼单价￥%@",_model.strprice]];
    [lbprice sizeToFit];
    [lbprice setHeight:15];
    [viewback addSubview:lbprice];
    
    
    [lbshop setFrame:CGRectMake(lbprice.right+10, lbprice.top, viewback.width-lbprice.right-10, lbprice.height)];
    [lbshop setText:_model.strname];
//    [lbshop setRight:viewback.width-10];
    [viewback addSubview:lbshop];
    
    
//    [lbzhiyou setFrame:CGRectMake(viewback.width-39, lbshop.top, 29, lbshop.height)];
//    [lbzhiyou.layer setCornerRadius:2];
//    [viewback addSubview:lbzhiyou];
    
    
//    [lbtime setFrame:CGRectMake(0, lbshop.top, 100, lbshop.height)];
//    [lbtime setText:@"4小时前"];
//    [viewback addSubview:lbtime];
//    [lbtime setRight:lbzhiyou.left-8];
    float fleft = lbprice.left;
    int inum = (int)_model.arrpindanusers.count;
    if(inum>3)
    {
        inum = 3;
    }
    for(int i = 0 ; i < inum; i++)
    {
        UIImageView *imgv = arrimgvhd[i];
        [imgv setFrame:CGRectMake(lbprice.left+17*i, imgvhead.bottom-18, 15, 15)];
        [[MDB_UserDefault defaultInstance] setViewWithImage:imgv url:_model.arrpindanusers[i]];
        [viewback addSubview:imgv];
        fleft = imgv.right+10;
    }
    
    
    [lbpintuan setFrame:CGRectMake(fleft, imgvhead.bottom-18, 120, 15)];
    [lbpintuan setText:[NSString stringWithFormat:@"已拼%@件，%@件/团", _model.strpurchased_nums,_model.strpindannum]];//
    [viewback addSubview:lbpintuan];
    
    
    [lbjiedan setTop:11];
    [lbjiedan setRight:viewback.width-10];
    [viewback addSubview:lbjiedan];
    
    [btaddgouwucar setFrame:CGRectMake(0, 0, 35*kScale, 35*kScale)];
    [btaddgouwucar setRight:viewback.width-10];
    [btaddgouwucar setBottom:viewback.height-13];
    [viewback addSubview:btaddgouwucar];
    
    
    [lbisspotgoods setFrame:CGRectMake(imgvhead.left, imgvhead.top, 29, 17)];
    [lbisspotgoods.layer setCornerRadius:2];
    [viewback addSubview:lbisspotgoods];
    if(_model.isspotgoods.integerValue==1)
    {
        [lbisspotgoods setWidth:29];
        [lbisspotgoods setHidden:NO];
        
    }
    else
    {
        [lbisspotgoods setHidden:YES];
    }
    
    
//    if([_model.strstatus intValue] == 1)
//    {
//        [lbjiedan setHidden:YES];
//
//    }
//    else if([_model.strstatus intValue] == 2)
//    {
//        [lbjiedan setHidden:NO];
//    }
//    else
//    {
//        [lbjiedan setHidden:YES];
//    }
    if(_model.strisend.intValue == 1)
    {
        [lbjiedan setHidden:NO];
        [btaddgouwucar setHidden:YES];
    }
    else
    {
        [lbjiedan setHidden:YES];
        [btaddgouwucar setHidden:NO];
    }
    
    [viewline setFrame:CGRectMake(0, viewback.height-1, viewback.width, 1)];
    [viewback addSubview:viewline];
    
    
}

-(void)addgouwuche
{
    if(self.delegate)
    {
        [self.delegate JinRiPinDanListTableViewCellAddByCar:self.model];
    }
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
