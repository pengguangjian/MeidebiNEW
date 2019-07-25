//
//  SearchGoodsTableViewCell.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/12.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "SearchGoodsTableViewCell.h"
#import "MDB_UserDefault.h"

@interface SearchGoodsTableViewCell ()

@property (nonatomic , retain) UIView *viewback;
///图标
@property (nonatomic , retain) UIImageView *imgvpic;
///类型
@property (nonatomic , retain) UILabel *lbtype;
///标题
@property (nonatomic , retain) UILabel *lbtitle;
///价格
@property (nonatomic , retain) UILabel *lbprice;
///优惠券
@property (nonatomic , retain) UIImageView *imgvyouhuiquan;
@property (nonatomic , retain) UILabel *lbyouhuiquan;
///商店
@property (nonatomic , retain) UILabel *lbshop;

@property (nonatomic , retain) UIView *viewline;

@property (nonatomic , retain) UILabel *lbhongbao;

@end;

@implementation SearchGoodsTableViewCell
@synthesize model;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
        _viewback = [[UIView alloc]initWithFrame:CGRectZero];
        [_viewback setBackgroundColor:[UIColor whiteColor]];
        
        _imgvpic = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_imgvpic.layer setMasksToBounds:YES];
        [_imgvpic setContentMode:UIViewContentModeScaleAspectFit];
        
        
        
        
        
        _lbtype = [[UILabel alloc]initWithFrame:CGRectZero];
        [_lbtype.layer setMasksToBounds:YES];
        [_lbtype setTextColor:[UIColor whiteColor]];
        [_lbtype setTextAlignment:NSTextAlignmentCenter];
        [_lbtype setFont:[UIFont systemFontOfSize:12]];
        
        
        _lbhongbao = [[UILabel alloc] init];
        _lbhongbao.textColor = [UIColor whiteColor];
        _lbhongbao.font = [UIFont systemFontOfSize:10.f];
        [_lbhongbao setBackgroundColor:[UIColor redColor]];
        [_lbhongbao.layer setMasksToBounds:YES];
        [_lbhongbao.layer setCornerRadius:2];
        [_lbhongbao setTextAlignment:NSTextAlignmentCenter];
        [_lbhongbao setText:@"红包"];
        [_lbhongbao setHidden:YES];
        
        _lbtitle = [[UILabel alloc]initWithFrame:CGRectZero];
        [_lbtitle setTextColor:RGB(30, 30, 30)];
        [_lbtitle setTextAlignment:NSTextAlignmentLeft];
        [_lbtitle setFont:[UIFont systemFontOfSize:16]];
        [_lbtitle setNumberOfLines:2];
        
        
        _lbprice = [[UILabel alloc]initWithFrame:CGRectZero];
        [_lbprice setTextColor:RGB(240, 60, 50)];
        [_lbprice setTextAlignment:NSTextAlignmentLeft];
        [_lbprice setFont:[UIFont systemFontOfSize:14]];
        
        _imgvyouhuiquan = [[UIImageView alloc]initWithFrame:CGRectZero];
        
        _lbyouhuiquan = [[UILabel alloc]initWithFrame:CGRectZero];
        [_lbyouhuiquan.layer setMasksToBounds:YES];
        [_lbyouhuiquan setTextColor:[UIColor whiteColor]];
        [_lbyouhuiquan setTextAlignment:NSTextAlignmentCenter];
        [_lbyouhuiquan setFont:[UIFont systemFontOfSize:13]];
        
        _lbshop = [[UILabel alloc]initWithFrame:CGRectZero];
        [_lbshop setTextColor:RGB(150, 150, 150)];
        [_lbshop setTextAlignment:NSTextAlignmentRight];
        [_lbshop setFont:[UIFont systemFontOfSize:12]];
        
        _viewline = [[UIView alloc]initWithFrame:CGRectZero];
        [_viewline setBackgroundColor:RGB(239, 239, 239)];
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [_viewback setFrame:CGRectMake(0, 0, self.width, self.height)];
    [self.contentView addSubview:_viewback];
    
    [_imgvpic setFrame:CGRectMake(15, 15, _viewback.height-30, _viewback.height-30)];
    [_imgvpic.layer setCornerRadius:4];
    [_viewback addSubview:_imgvpic];
    
    
    [[MDB_UserDefault defaultInstance]setViewWithImage:_imgvpic url:model.strpicurl options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image) {
            _imgvpic.image=image;
        }else{
            _imgvpic.image=[UIImage imageNamed:@"punot.png"];
        }
        
    }];
    
    
//    [_lbtype setFrame:CGRectMake(0, 0, 100, 20)];
//    [_lbtype.layer setCornerRadius:3];
//    [_imgvpic addSubview:_lbtype];
//    if(model.type == 1)
//    {
//        [_lbtype setText:@"海淘"];
//        [_lbtype sizeToFit];
//        [_lbtype setBackgroundColor:RGB(2, 196, 128)];
//    }
//    else if (model.type == 2)
//    {
//        [_lbtype setText:@"国内"];
//        [_lbtype sizeToFit];
//        [_lbtype setBackgroundColor:RGB(82, 169, 227)];
//    }
//    else if (model.type == 3)
//    {
//        [_lbtype setText:@"优惠券"];
//        [_lbtype sizeToFit];
//        [_lbtype setBackgroundColor:RGB(255, 69, 88)];
//    }
//    [_lbtype setWidth:_lbtype.width+8];
//    [_lbtype setHeight:_lbtype.height+5];
    
    [_lbtitle setFrame:CGRectMake(_imgvpic.right+10, _imgvpic.top, _viewback.width-_imgvpic.right-20, 40)];
    [_lbtitle setText:model.strtitle];
    [_viewback addSubview:_lbtitle];
    if(model.isSelect)
    {
        [_lbtitle setTextColor:RGB(150, 150, 150)];
        
    }
    else
    {
        [_lbtitle setTextColor:RGB(30, 30, 30)];
    }
    
    
    [_lbprice setFrame:CGRectMake(_lbtitle.left, _lbtitle.bottom+10, 100, 20)];
    [_lbprice setText:[NSString stringWithFormat:@"%@",model.strprice]];
    [_lbprice sizeToFit];
    [_lbprice setHeight:20];
    [_viewback addSubview:_lbprice];
    [_lbprice setWidth:_viewback.width-_imgvpic.right-130];
    
    if(model.type == 3 && model.stryouhuiprice.floatValue>0)
    {
        [_imgvyouhuiquan setFrame:CGRectMake(_lbprice.right+10, _lbprice.top, 60, 20)];
        UIImage *imageq = [UIImage imageNamed:@"coupon_value_bg"];
        CGFloat width = imageq.size.width / 2.0;
        CGFloat height = imageq.size.height / 2.0;
        [_imgvyouhuiquan setImage:[imageq resizableImageWithCapInsets:UIEdgeInsetsMake(height,width,height,width) resizingMode:UIImageResizingModeStretch]];
        [_viewback addSubview:_imgvyouhuiquan];
        
        [_lbyouhuiquan setFrame:CGRectMake(10, 0, 100, 20)];
        [_lbyouhuiquan setText:[NSString stringWithFormat:@"%@元券",model.stryouhuiprice]];
        [_lbyouhuiquan sizeToFit];
        [_lbyouhuiquan setHeight:_imgvyouhuiquan.height];
        [_imgvyouhuiquan addSubview:_lbyouhuiquan];
        [_imgvyouhuiquan setWidth:_lbyouhuiquan.width+20];
        
        
    }
    else
    {
        [_imgvyouhuiquan removeFromSuperview];
    }
    
    
    [_lbshop setFrame:CGRectMake(200, _lbprice.top, 100, _lbprice.height)];
    [_lbshop setRight:_viewback.width-10];
    [_lbshop setText:model.strshop];
    [_viewback addSubview:_lbshop];
    
    [_viewline setFrame:CGRectMake(15, _viewback.height-1, _viewback.width-25, 1)];
    [_viewback addSubview:_viewline];
    
    [_lbhongbao setFrame:CGRectMake(0, 0, 25, 20)];
    [_viewback addSubview:_lbhongbao];
    if(model.tljurl.length>6||model.tljurl.integerValue==1)
    {
        [_lbhongbao setHidden:NO];
    }
    else
    {
        [_lbhongbao setHidden:YES];
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
