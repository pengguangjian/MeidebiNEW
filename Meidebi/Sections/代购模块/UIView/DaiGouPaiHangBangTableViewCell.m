//
//  DaiGouPaiHangBangTableViewCell.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/4/16.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import "DaiGouPaiHangBangTableViewCell.h"

#import "MDB_UserDefault.h"

@interface DaiGouPaiHangBangTableViewCell ()
{
    UIView *viewback;
    
    UIImageView *imgvhead;
    
    UILabel *lbzhiding;
    
    UILabel *lbtitle;
    
    UILabel *lbprice;
    
    UILabel *lbshop;
    
    ///改成已下单多少件
    UILabel *lbtime;
    
//    UIView *viewsline;
    
    UIButton *btaddgouwucar;
    UIImageView *imgvgouwucar;
    
    UILabel *lbzhiyou;
    
    UIView *viewline;
    
    UILabel *lbjiedan;
    
    UILabel *lbisspotgoods;
}
@end

@implementation DaiGouPaiHangBangTableViewCell

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
        
        
        lbtime = [[UILabel alloc] initWithFrame:CGRectZero];
        [lbtime setTextColor:RGB(153,153,153)];
        [lbtime setTextAlignment:NSTextAlignmentRight];
        [lbtime setFont:[UIFont systemFontOfSize:10]];
        
//        viewsline = [[UIView alloc] initWithFrame:CGRectZero];
//        [viewsline setBackgroundColor:RGB(236,236,236)];
        
        lbzhiyou = [[UILabel alloc] initWithFrame:CGRectZero];
        [lbzhiyou setTextColor:RGB(230,56,47)];
        [lbzhiyou setTextAlignment:NSTextAlignmentCenter];
        [lbzhiyou setFont:[UIFont systemFontOfSize:11]];
        [lbzhiyou.layer setMasksToBounds:YES];
        [lbzhiyou.layer setBorderColor:RGB(230,56,47).CGColor];
        [lbzhiyou setText:@"直邮"];
        [lbzhiyou.layer setBorderWidth:1];
        
        
        lbisspotgoods = [[UILabel alloc] initWithFrame:CGRectZero];
        [lbisspotgoods setTextColor:RadMenuColor];
        [lbisspotgoods setTextAlignment:NSTextAlignmentCenter];
        [lbisspotgoods setFont:[UIFont systemFontOfSize:11]];
        [lbisspotgoods.layer setMasksToBounds:YES];
        [lbisspotgoods.layer setBorderColor:RadMenuColor.CGColor];
        [lbisspotgoods setText:@"现货"];
        [lbisspotgoods.layer setBorderWidth:1];
        
        
        viewline = [[UIView alloc] initWithFrame:CGRectZero];
        [viewline setBackgroundColor:RGB(236,236,236)];
        
        
        lbjiedan = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [lbjiedan setTextColor:[UIColor whiteColor]];
        [lbjiedan setTextAlignment:NSTextAlignmentCenter];
        [lbjiedan setFont:[UIFont systemFontOfSize:14]];
        [lbjiedan.layer setMasksToBounds:YES];
        [lbjiedan.layer setCornerRadius:lbjiedan.height/2.0];
        [lbjiedan setBackgroundColor:RGBAlpha(0, 0, 0, 0.7)];
        [lbjiedan setText:@"已截单"];
        
        
        btaddgouwucar = [[UIButton alloc] initWithFrame:CGRectZero];
        //        [btaddgouwucar setImage:[UIImage imageNamed:@"addgouwuche_remu"] forState:UIControlStateNormal];
        [btaddgouwucar addTarget:self action:@selector(addGouWuCheAction) forControlEvents:UIControlEventTouchUpInside];
        imgvgouwucar = [[UIImageView alloc] initWithFrame:CGRectZero];
        [imgvgouwucar setImage:[UIImage imageNamed:@"addgouwuche_remu"]];
        [btaddgouwucar addSubview:imgvgouwucar];
        
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    [viewback setFrame:CGRectMake(0, 0, self.width, self.height)];
    [self.contentView addSubview:viewback];
    
    
    [imgvhead setFrame:CGRectMake(10, 13, viewback.height-26, viewback.height-26)];
    [[MDB_UserDefault defaultInstance] setViewWithImage:imgvhead url:_model.image];
    [viewback addSubview:imgvhead];
    [imgvhead setContentMode:UIViewContentModeScaleAspectFit];
    
    //    [lbzhiding setFrame:CGRectMake(0, 0, 38, 17)];
    //    [imgvhead addSubview:lbzhiding];
    //    if([_model.istop intValue] == 1 && _ishidden == NO)
    //    {
    //        [lbzhiding setHidden:NO];
    //    }
    //    else
    //    {
    //        [lbzhiding setHidden:YES];
    //    }
    
    [lbtitle setFrame:CGRectMake(imgvhead.right+10, imgvhead.top, viewback.width-imgvhead.right-20, 40)];
    [lbtitle setText:_model.title];
    [viewback addSubview:lbtitle];
    
    NSMutableArray *arrbldj = [[NSUserDefaults standardUserDefaults] objectForKey:@"baoliaoyidianji"];
    BOOL isbool = [arrbldj containsObject:[NSString stringWithFormat:@"%@", _model.share_id]];
    if(isbool==YES)
    {
        [lbtitle setTextColor:RGB(150, 150, 150)];
    }
    else
    {
        [lbtitle setTextColor:RGB(30, 30, 30)];
    }
    
    
    [lbprice setFrame:CGRectMake(lbtitle.left, lbtitle.bottom+8, lbtitle.width, 15)];
    [lbprice setText:[NSString stringWithFormat:@"￥%@", _model.price]];
    [viewback addSubview:lbprice];
    
    
    [lbzhiyou setFrame:CGRectMake(lbtitle.left, imgvhead.bottom-17, 29, 17)];
    [lbzhiyou.layer setCornerRadius:2];
    [viewback addSubview:lbzhiyou];
    if([_model.transfertype intValue] == 2)
    {
        //        [lbzhiyou setWidth:29];
        //        [lbzhiyou setHidden:NO];
        //
        //        [lbshop setFrame:CGRectMake(lbzhiyou.right+2, imgvhead.bottom-17, 100*kScale, 17)];
        
        [lbzhiyou setWidth:1];
        [lbzhiyou setHidden:YES];
        [lbshop setFrame:CGRectMake(lbtitle.left, imgvhead.bottom-17, 100*kScale, 17)];
    }
    else
    {
        [lbzhiyou setWidth:1];
        [lbzhiyou setHidden:YES];
        [lbshop setFrame:CGRectMake(lbtitle.left, imgvhead.bottom-17, 100*kScale, 17)];
        
    }
    
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
    
    
    [lbshop setText:_model.name];
    [lbshop sizeToFit];
    lbshop.height = 17;
    if(lbshop.width>100*kScale)
    {
        lbshop.width = 100*kScale;
    }
    [viewback addSubview:lbshop];
    
    ///
    [lbtime setFrame:CGRectMake(lbshop.right+10, lbshop.top, 100, lbshop.height)];
    [lbtime setText:[NSString stringWithFormat:@"已下单%@件", _model.purchased_nums]];
    lbtime.right = viewback.width-10;
    [viewback addSubview:lbtime];
    
    [viewline setFrame:CGRectMake(0, viewback.height-1, viewback.width, 1)];
    [viewback addSubview:viewline];
    
    
    [btaddgouwucar setFrame:CGRectMake(0, 0, 40*kScale, 40*kScale)];
    [btaddgouwucar setRight:viewback.width-10];
    [btaddgouwucar setTop:lbtitle.bottom+5];
    [viewback addSubview:btaddgouwucar];
    [imgvgouwucar setFrame:CGRectMake(0, 0, 30*kScale, 30*kScale)];
    [imgvgouwucar setCenter:CGPointMake(btaddgouwucar.width/2.0, btaddgouwucar.height/2.0)];
    
    [lbjiedan setTop:11];
    [lbjiedan setRight:viewback.width-10];
    [viewback addSubview:lbjiedan];
    if([_model.isend intValue] == 1)
    {
        [lbjiedan setHidden:NO];
        [btaddgouwucar setHidden:YES];
        
    }
    else
    {
        [lbjiedan setHidden:YES];
        [btaddgouwucar setHidden:NO];
    }
    //    else if([_model.status intValue] == 2)
    //    {
    //        [lbjiedan setHidden:NO];
    //    }
    //    else
    //    {
    //        [lbjiedan setHidden:YES];
    //    }
    
    
}


-(void)addGouWuCheAction
{
    if(self.delegate)
    {
        [self.delegate DaiGouHomeTableViewCellAddGouWuChe:_model];
    }
    
}



@end
