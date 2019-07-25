//
//  QuanwangYHDetailLikeTableViewCell.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/10/18.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "QuanwangYHDetailLikeTableViewCell.h"

#import "MDB_UserDefault.h"

@interface QuanwangYHDetailLikeTableViewCell ()
{
    
    UIView *viewback;
    
    UIImageView *imgvpic;
    
    UILabel *lbtitle;
    
    UILabel *lbprice;
    
    UILabel *lboldprice;
    
//    UILabel *lbshop;
//
//    UIImageView *imgvhbq;
//    UILabel *lbhbq;
    
    UILabel *lbpaynumber;
    
    UIView *viewline;
    
    
}
@end

@implementation QuanwangYHDetailLikeTableViewCell

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
        [self.contentView addSubview:viewback];
        
        imgvpic = [[UIImageView alloc] initWithFrame:CGRectZero];
        [viewback addSubview:imgvpic];
        
        lbtitle =[[UILabel alloc] initWithFrame:CGRectZero];
        [lbtitle setNumberOfLines:2];
        [lbtitle setTextColor:RGB(60, 60, 60)];
        [lbtitle setTextAlignment:NSTextAlignmentLeft];
        [lbtitle setFont:[UIFont systemFontOfSize:16]];
        [viewback addSubview:lbtitle];
        
        
        lbprice =[[UILabel alloc] initWithFrame:CGRectZero];
        [lbprice setTextColor:RGB(255, 30, 30)];
        [lbprice setTextAlignment:NSTextAlignmentLeft];
        [lbprice setFont:[UIFont systemFontOfSize:14]];
        [viewback addSubview:lbprice];
        
        lboldprice =[[UILabel alloc] initWithFrame:CGRectZero];
        [lboldprice setTextColor:RGB(180, 180, 180)];
        [lboldprice setTextAlignment:NSTextAlignmentLeft];
        [lboldprice setFont:[UIFont systemFontOfSize:14]];
        [viewback addSubview:lboldprice];
        
//        lbshop =[[UILabel alloc] initWithFrame:CGRectZero];
//        [lbshop setTextColor:RGB(180, 180, 180)];
//        [lbshop setTextAlignment:NSTextAlignmentRight];
//        [lbshop setFont:[UIFont systemFontOfSize:14]];
//        [viewback addSubview:lbshop];
        
//        imgvhbq = [[UIImageView alloc] initWithFrame:CGRectZero];
//        [imgvhbq setImage:[[UIImage imageNamed:@"coupon_value_bg"] stretchableImageWithLeftCapWidth:5 topCapHeight:0]];
//        [viewback addSubview:imgvhbq];
//
//        lbhbq =[[UILabel alloc] initWithFrame:CGRectZero];
//        [lbhbq setTextColor:[UIColor whiteColor]];
//        [lbhbq setTextAlignment:NSTextAlignmentCenter];
//        [lbhbq setFont:[UIFont systemFontOfSize:14]];
//        [viewback addSubview:lbhbq];
        
        
        lbpaynumber =[[UILabel alloc] initWithFrame:CGRectZero];
        [lbpaynumber setTextColor:RGB(180, 180, 180)];
        [lbpaynumber setTextAlignment:NSTextAlignmentLeft];
        [lbpaynumber setFont:[UIFont systemFontOfSize:14]];
        [viewback addSubview:lbpaynumber];
        
        viewline = [[UIView alloc] initWithFrame:CGRectZero];
        [viewline setBackgroundColor:RGB(245, 245, 245)];
        [viewback addSubview:viewline];
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [viewback setFrame:CGRectMake(0, 0, self.width, self.height)];
    
    
    [imgvpic setFrame:CGRectMake(10, 15, viewback.height-20, viewback.height-20)];
    [imgvpic setContentMode:UIViewContentModeScaleAspectFit];
    [[MDB_UserDefault defaultInstance] setViewWithImage:imgvpic url:_model.itempic];
    
    
    [lbtitle setFrame:CGRectMake(imgvpic.right+10, imgvpic.top-5, viewback.width-imgvpic.right-20, 40)];
    [lbtitle setText:_model.title];
    if(_model.isSelected)
    {
        [lbtitle setTextColor:RGB(160, 160, 160)];
    }
    else
    {
        [lbtitle setTextColor:RGB(60, 60, 60)];
    }
    
    [lbprice setFrame:CGRectMake(lbtitle.left, lbtitle.bottom, 100, 25)];
    [lbprice setText:[NSString stringWithFormat:@"券后￥%@",_model.activeprice]];
    [lbprice sizeToFit];
    [lbprice setHeight:25];
    
    [lboldprice setFrame:CGRectMake(lbprice.right+5, lbprice.top, 100, 25)];
    [lboldprice setText:[NSString stringWithFormat:@"￥%@",_model.proprice]];
    [lboldprice sizeToFit];
    [lboldprice setHeight:25];
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:lboldprice.text attributes:attribtDic];
    lboldprice.attributedText = attribtStr;
    
    
//    [lbshop setFrame:CGRectMake(viewback.width-100, lbprice.top, 90, 25)];
//    [lbshop setText:@""];
//
//
//    [lbhbq setFrame:CGRectMake(lbtitle.left, lbprice.bottom, 100, 25)];
//    [lbhbq setText:@"10元券"];
//    [lbhbq sizeToFit];
//    [lbhbq setHeight:25];
//    [lbhbq setWidth:lbhbq.width+20];
//
//    [imgvhbq setFrame:CGRectMake(lbhbq.left, lbhbq.top, lbhbq.width, lbhbq.height)];
    
    
    [lbpaynumber setFrame:CGRectMake(lbtitle.left, lbprice.bottom, 140, 25)];
    [lbpaynumber setText:[NSString stringWithFormat:@"已售%@件",_model.salesnum]];
    
    
    [viewline setFrame:CGRectMake(0, viewback.height-1, viewback.width, 1)];
    
    
}


@end
