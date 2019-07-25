//
//  ZiZhuInForView.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/5/22.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import "ZiZhuInForView.h"

#import "ZiZhuUserInfoViewController.h"

#import "SelectColorAndSizeView.h"

#import "DaiGouXiaDanQuanView.h"

#import "BrokeShareDataController.h"
#import "BrokeTypeActionSheetView.h"
#import "MDB_UserDefault.h"

@interface ZiZhuInForView ()<UITextViewDelegate,UIScrollViewDelegate,SelectColorAndSizeViewDelegate,DaiGouXiaDanQuanViewDelegate,BrokeTypeActionSheetViewDelegate>
{
    UIScrollView *scvback;
    
    UIImageView *imgvhead;
    
    
    ///需要选择的信息
    UIView *viewSelectInfo;
    
    
    
    UITextField *fieldnumber;
    
    UILabel *lbguigep;
    UILabel *lbyouhuip;
    
    
    UIView *viewfenlei;
    ///商品分类
    UILabel *lbfeileivalue;
    
    ///商品标题和价格
    UIView *viewinfo;

    
    BrokeShareDataController *dataController;
    
}

@end

@implementation ZiZhuInForView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self drawSubview];
        
    }
    return self;
}

-(void)drawSubview
{
    scvback = [[UIScrollView alloc] init];
    [scvback setDelegate:self];
    [self addSubview:scvback];
    [scvback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-50);
    }];
    
    
    imgvhead = [[UIImageView alloc] init];
    [imgvhead setContentMode:UIViewContentModeScaleAspectFit];
    [imgvhead setUserInteractionEnabled:YES];
    [imgvhead setBackgroundColor:[UIColor grayColor]];
    [scvback addSubview:imgvhead];
    [imgvhead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(scvback).offset(10);
        make.height.offset(150*kScale);
    }];
    UIView *viewline = [[UIView alloc] init];
    [viewline setBackgroundColor:RGB(236, 236, 236)];
    [scvback addSubview:viewline];
    [viewline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.offset(1);
        make.top.equalTo(imgvhead.mas_bottom).offset(10);
    }];
    
    ////
    viewinfo = [[UIView alloc] init];
    [scvback addSubview:viewinfo];
    [viewinfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(viewline);
        make.top.equalTo(viewline.mas_bottom);
    }];
    [self drawinfo:viewinfo];
    
    ///商品分类
    viewfenlei = [[UIView alloc] init];
    [scvback addSubview:viewfenlei];
    [viewfenlei mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(viewinfo);
        make.top.equalTo(viewinfo.mas_bottom);
    }];
    [self drawFenLei:viewfenlei];
    
    [scvback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(viewfenlei.mas_bottom).offset(10);
    }];
}


-(void)drawSelectInfoView
{
    
    viewSelectInfo = [[UIView alloc] init];
    [scvback addSubview:viewSelectInfo];
    [viewSelectInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(viewinfo);
        make.top.equalTo(viewinfo.mas_bottom);
    }];
    
    /////
    UIView *viewyunfei = [[UIView alloc] init];
    [viewSelectInfo addSubview:viewyunfei];
    [viewyunfei mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(viewSelectInfo);
        make.top.offset(0);
    }];
    [self drawYunFei:viewyunfei];
    
    
    ////规格和优惠
    UIView *viewgeyh = [[UIView alloc] init];
    [viewSelectInfo addSubview:viewgeyh];
    [viewgeyh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(viewSelectInfo);
        make.top.equalTo(viewyunfei.mas_bottom);
    }];
    [self drawggyh:viewgeyh];
    
    ///订单备注
    UIView *viewbeizhu = [[UIView alloc] init];
    [viewSelectInfo addSubview:viewbeizhu];
    [viewbeizhu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(viewSelectInfo);
        make.top.equalTo(viewgeyh.mas_bottom);
    }];
    [self drawbeizhu:viewbeizhu];
    
    [viewSelectInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(viewbeizhu.mas_bottom);
    }];
    [scvback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(viewSelectInfo.mas_bottom).offset(10);
    }];
    
    
    UIView *viewbottom = [[UIView alloc] init];
    [viewbottom setBackgroundColor:RGB(246, 246, 246)];
    [self addSubview:viewbottom];
    [viewbottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.offset(60);
    }];
    [self drawbottom:viewbottom];
}


///价格和标题
-(void)drawinfo:(UIView *)view
{
    
    UILabel *lbtitle = [[UILabel alloc] init];
    [lbtitle setText:@"水电费了上岛咖啡圣诞快乐"];
    [lbtitle setTextColor:RGB(30, 30, 30)];
    [lbtitle setTextAlignment:NSTextAlignmentLeft];
    [lbtitle setNumberOfLines:2];
    [lbtitle setFont:[UIFont systemFontOfSize:16]];
    [view addSubview:lbtitle];
    [lbtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.equalTo(view).offset(-15);
        make.top.offset(10);
        make.height.offset(40);
    }];
    
    
    UILabel *lboldprice = [[UILabel alloc] init];
    [lboldprice setText:@"$55.99"];
    [lboldprice setTextColor:RGB(30, 30, 30)];
    [lboldprice setTextAlignment:NSTextAlignmentLeft];
    [lboldprice setFont:[UIFont systemFontOfSize:16]];
    [view addSubview:lboldprice];
    [lboldprice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbtitle);
        make.top.equalTo(lbtitle.mas_bottom);
        make.height.offset(30);
        make.width.offset(kMainScreenW/2.0-20);
    }];
    
    
    UILabel *lbnewprice = [[UILabel alloc] init];
    [lbnewprice setText:@"折合￥410.56"];
    [lbnewprice setTextColor:[UIColor redColor]];
    [lbnewprice setTextAlignment:NSTextAlignmentRight];
    [lbnewprice setFont:[UIFont systemFontOfSize:16]];
    [view addSubview:lbnewprice];
    [lbnewprice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lbtitle);
        make.top.equalTo(lboldprice);
        make.height.equalTo(lboldprice);
        make.width.offset(kMainScreenW/2.0-20);
    }];
    
    UIView *viewline = [[UIView alloc] init];
    [viewline setBackgroundColor:RGB(236, 236, 236)];
    [view addSubview:viewline];
    [viewline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.height.offset(1);
        make.top.equalTo(lbnewprice.mas_bottom).offset(10);
    }];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(viewline.mas_bottom);
    }];
}

///商品分类
-(void)drawFenLei:(UIView *)view
{
    UILabel *lbmyunfei = [[UILabel alloc] init];
    [lbmyunfei setText:@"订单满50美金即可免美国运费，否则收取3.95美金美国运费"];
    [lbmyunfei setTextColor:RGB(141, 114, 85)];
    [lbmyunfei setTextAlignment:NSTextAlignmentLeft];
    [lbmyunfei setNumberOfLines:2];
    [lbmyunfei setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbmyunfei];
    [lbmyunfei mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.equalTo(view).offset(-15);
        make.top.offset(10);
        make.height.offset(40);
    }];
    
    ///
    UILabel *lbfeilei = [[UILabel alloc] init];
    [lbfeilei setText:@"商品分类"];
    [lbfeilei setTextColor:RGB(30, 30, 30)];
    [lbfeilei setTextAlignment:NSTextAlignmentLeft];
    [lbfeilei setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbfeilei];
    [lbfeilei mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbmyunfei);
        make.top.equalTo(lbmyunfei.mas_bottom).offset(10);
        make.height.offset(30);
    }];
    
    UILabel *lbfeileic = [[UILabel alloc] init];
    [lbfeileic setText:@"（请如实选择分类）"];
    [lbfeileic setTextColor:RGB(180, 180, 180)];
    [lbfeileic setTextAlignment:NSTextAlignmentLeft];
    [lbfeileic setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbfeileic];
    [lbfeileic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbfeilei.mas_right);
        make.top.height.equalTo(lbfeilei);
    }];
    
    UIButton *btFeiLei = [[UIButton alloc] init];
    [btFeiLei.layer setBorderColor:RGB(245, 245, 245).CGColor];
    [btFeiLei.layer setBorderWidth:1];
    [btFeiLei.layer setCornerRadius:3];
    [view addSubview:btFeiLei];
    [btFeiLei mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(lbmyunfei);
        make.top.equalTo(lbfeilei.mas_bottom).offset(15);
        make.height.offset(45);
    }];
    [btFeiLei addTarget:self action:@selector(selectFenLeiAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lbbtFeiLei = [[UILabel alloc] init];
    [lbbtFeiLei setText:@"请选择商品分类"];
    [lbbtFeiLei setTextColor:RGB(190, 190, 190)];
    [lbbtFeiLei setFont:[UIFont systemFontOfSize:14]];
    [btFeiLei addSubview:lbbtFeiLei];
    [lbbtFeiLei mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.height.equalTo(btFeiLei);
    }];
    
    UIImageView *imgvnet = [[UIImageView alloc] init];
    [imgvnet setImage:[UIImage imageNamed:@"zizhudaigouselect_fenlei"]];
    [btFeiLei addSubview:imgvnet];
    [imgvnet mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btFeiLei);
        make.right.equalTo(btFeiLei.mas_right).offset(-15);
        make.size.sizeOffset(CGSizeMake(18, 18));
    }];
    
    
    
    
    
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(btFeiLei.mas_bottom);
    }];
    
}
////数量运费
-(void)drawYunFei:(UIView *)view
{
    
    UILabel *lbmyunfei = [[UILabel alloc] init];
    [lbmyunfei setText:@"订单满50美金即可免美国运费，否则收取3.95美金美国运费"];
    [lbmyunfei setTextColor:RGB(141, 114, 85)];
    [lbmyunfei setTextAlignment:NSTextAlignmentLeft];
    [lbmyunfei setNumberOfLines:2];
    [lbmyunfei setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbmyunfei];
    [lbmyunfei mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.equalTo(view).offset(-15);
        make.top.offset(10);
        make.height.offset(40);
    }];
    
    ///
    UILabel *lbfeilei = [[UILabel alloc] init];
    [lbfeilei setText:@"商品分类"];
    [lbfeilei setTextColor:RGB(30, 30, 30)];
    [lbfeilei setTextAlignment:NSTextAlignmentLeft];
    [lbfeilei setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbfeilei];
    [lbfeilei mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbmyunfei);
        make.top.equalTo(lbmyunfei.mas_bottom).offset(10);
        make.height.offset(30);
    }];
    
    lbfeileivalue = [[UILabel alloc] init];
    [lbfeileivalue setText:@""];
    [lbfeileivalue setTextColor:RGB(180, 180, 180)];
    [lbfeileivalue setTextAlignment:NSTextAlignmentLeft];
    [lbfeileivalue setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbfeileivalue];
    [lbfeileivalue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbfeilei.mas_right).offset(10);
        make.top.height.equalTo(lbfeilei);;
        make.right.equalTo(view.mas_right).offset(-15);
    }];
    [lbfeileivalue setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapfenlei = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectFenLeiAction)];
    [lbfeileivalue addGestureRecognizer:tapfenlei];
    
    
    
    ///
    UILabel *lbbentuyunfei = [[UILabel alloc] init];
    [lbbentuyunfei setText:@"本土运费"];
    [lbbentuyunfei setTextColor:RGB(30, 30, 30)];
    [lbbentuyunfei setTextAlignment:NSTextAlignmentLeft];
    [lbbentuyunfei setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbbentuyunfei];
    [lbbentuyunfei mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbmyunfei);
        make.top.equalTo(lbfeilei.mas_bottom).offset(5);
        make.height.offset(30);
    }];
    
    UILabel *lbbentuyunfeip = [[UILabel alloc] init];
    [lbbentuyunfeip setText:@"￥0.00"];
    [lbbentuyunfeip setTextColor:RGB(30, 30, 30)];
    [lbbentuyunfeip setTextAlignment:NSTextAlignmentLeft];
    [lbbentuyunfeip setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbbentuyunfeip];
    [lbbentuyunfeip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-15);
        make.top.equalTo(lbbentuyunfei);
        make.height.equalTo(lbbentuyunfei);
        make.width.offset(93);
    }];
    
    
    UILabel *lbpaynum = [[UILabel alloc] init];
    [lbpaynum setText:@"购买数量"];
    [lbpaynum setTextColor:RGB(30, 30, 30)];
    [lbpaynum setTextAlignment:NSTextAlignmentLeft];
    [lbpaynum setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbpaynum];
    [lbpaynum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbbentuyunfei);
        make.top.equalTo(lbbentuyunfei.mas_bottom).offset(5);
        make.height.equalTo(lbbentuyunfei);
    }];
    ///
    UIView *viewnumber = [self drawNumberSelect:CGRectMake(0, 0, 93, 30) andframe:view];
    [viewnumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(lbbentuyunfeip);
        make.top.equalTo(lbpaynum);
    }];
    
    
    UILabel *lbygheight = [[UILabel alloc] init];
    [lbygheight setText:@"预估重量"];
    [lbygheight setTextColor:RGB(30, 30, 30)];
    [lbygheight setTextAlignment:NSTextAlignmentLeft];
    [lbygheight setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbygheight];
    [lbygheight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbbentuyunfei);
        make.top.equalTo(lbpaynum.mas_bottom).offset(5);
        make.height.equalTo(lbbentuyunfei);
    }];
    UILabel *lbygheightp = [[UILabel alloc] init];
    [lbygheightp setText:@"0.58kg"];
    [lbygheightp setTextColor:RGB(30, 30, 30)];
    [lbygheightp setTextAlignment:NSTextAlignmentLeft];
    [lbygheightp setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbygheightp];
    [lbygheightp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-15);
        make.top.equalTo(lbygheight);
        make.height.equalTo(lbygheight);
        make.width.equalTo(lbbentuyunfeip);
    }];
    
    
    
    
    UILabel *lbyggjmoney = [[UILabel alloc] init];
    [lbyggjmoney setText:@"预估国际运费"];
    [lbyggjmoney setTextColor:RGB(30, 30, 30)];
    [lbyggjmoney setTextAlignment:NSTextAlignmentLeft];
    [lbyggjmoney setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbyggjmoney];
    [lbyggjmoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbbentuyunfei);
        make.top.equalTo(lbygheight.mas_bottom).offset(5);
        make.height.equalTo(lbbentuyunfei);
    }];
    UILabel *lbyggjmoneyp = [[UILabel alloc] init];
    [lbyggjmoneyp setText:@"￥58.00"];
    [lbyggjmoneyp setTextColor:RGB(30, 30, 30)];
    [lbyggjmoneyp setTextAlignment:NSTextAlignmentLeft];
    [lbyggjmoneyp setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbyggjmoneyp];
    [lbyggjmoneyp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-15);
        make.top.equalTo(lbyggjmoney);
        make.height.equalTo(lbyggjmoney);
        make.width.equalTo(lbbentuyunfeip);
    }];
    
    
    UILabel *lbyggjmoneyjieshou = [[UILabel alloc] init];
    [lbyggjmoneyjieshou setText:@"(国际运费为预估值，多退少补)"];
    [lbyggjmoneyjieshou setTextColor:RGB(130, 130, 130)];
    [lbyggjmoneyjieshou setTextAlignment:NSTextAlignmentLeft];
    [lbyggjmoneyjieshou setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbyggjmoneyjieshou];
    [lbyggjmoneyjieshou mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbbentuyunfei);
        make.top.equalTo(lbyggjmoney.mas_bottom);
        make.height.offset(20);
    }];
    
    
    UIView *viewline = [[UIView alloc] init];
    [viewline setBackgroundColor:RGB(236, 236, 236)];
    [view addSubview:viewline];
    [viewline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.height.offset(1);
        make.top.equalTo(lbyggjmoneyjieshou.mas_bottom).offset(20);
    }];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(viewline.mas_bottom);
    }];
}


////商品规格和优惠
-(void)drawggyh:(UIView *)view
{
    
    UIView *viewguige = [[UIView alloc] init];
    [view addSubview:viewguige];
    [viewguige mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(view);
        make.height.offset(50);
    }];
    [viewguige setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapguige = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(guigeAction)];
    [viewguige addGestureRecognizer:tapguige];
    
    
    UILabel *lbguige = [[UILabel alloc] init];
    [lbguige setText:@"商品规格"];
    [lbguige setTextColor:RGB(30, 30, 30)];
    [lbguige setTextAlignment:NSTextAlignmentLeft];
    [lbguige setFont:[UIFont systemFontOfSize:14]];
    [viewguige addSubview:lbguige];
    [lbguige mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(10);
        make.height.offset(30);
    }];
    
    lbguigep = [[UILabel alloc] init];
    [lbguigep setText:@"default"];
    [lbguigep setTextColor:RGB(30, 30, 30)];
    [lbguigep setTextAlignment:NSTextAlignmentLeft];
    [lbguigep setFont:[UIFont systemFontOfSize:14]];
    [lbguige setNumberOfLines:2];
    [viewguige addSubview:lbguigep];
    [lbguigep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-15);
        make.top.equalTo(lbguige).offset(-5);
        make.height.offset(40);
        make.width.offset(93);
    }];
    
    
    UIView *viewline = [[UIView alloc] init];
    [viewline setBackgroundColor:RGB(236, 236, 236)];
    [viewguige addSubview:viewline];
    [viewline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.height.offset(1);
        make.bottom.equalTo(viewguige.mas_bottom);
    }];
    
    
    
    
    
    UIView *viewyouhui = [[UIView alloc] init];
    [view addSubview:viewyouhui];
    [viewyouhui mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(viewguige);
        make.top.equalTo(viewguige.mas_bottom);
        make.height.offset(50);
    }];
    [viewyouhui setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapyouhui = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(youhuiAction)];
    [viewyouhui addGestureRecognizer:tapyouhui];
    
    UILabel *lbyouhui = [[UILabel alloc] init];
    [lbyouhui setText:@"商品优惠"];
    [lbyouhui setTextColor:RGB(30, 30, 30)];
    [lbyouhui setTextAlignment:NSTextAlignmentLeft];
    [lbyouhui setFont:[UIFont systemFontOfSize:14]];
    [viewyouhui addSubview:lbyouhui];
    [lbyouhui mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(viewyouhui).offset(10);
        make.height.offset(30);
    }];
    
    lbyouhuip = [[UILabel alloc] init];
    [lbyouhuip setText:@"￥2.3"];
    [lbyouhuip setTextColor:RGB(30, 30, 30)];
    [lbyouhuip setTextAlignment:NSTextAlignmentLeft];
    [lbyouhuip setFont:[UIFont systemFontOfSize:14]];
    [lbyouhuip setNumberOfLines:2];
    [viewyouhui addSubview:lbyouhuip];
    [lbyouhuip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-25);
        make.top.equalTo(lbyouhui).offset(-5);
        make.height.offset(40);
        make.width.offset(78);
    }];
    
    UIImageView *imgvnext = [[UIImageView alloc] init];
    [imgvnext setImage:[UIImage imageNamed:@"wodejiangli_next"]];
    [imgvnext setContentMode:UIViewContentModeScaleAspectFit];
    [viewyouhui addSubview:imgvnext];
    [imgvnext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbyouhuip.mas_right);
        make.width.height.offset(15);
        make.centerY.equalTo(lbyouhuip);
    }];
    
    
    UIView *viewline1 = [[UIView alloc] init];
    [viewline1 setBackgroundColor:RGB(236, 236, 236)];
    [viewyouhui addSubview:viewline1];
    [viewline1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.height.offset(1);
        make.bottom.equalTo(viewyouhui.mas_bottom);
    }];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(viewyouhui.mas_bottom);
    }];
}

///订单备注
-(void)drawbeizhu:(UIView *)view
{
    UILabel *lbtext = [[UILabel alloc] init];
    [lbtext setText:@"订单备注"];
    [lbtext setTextColor:RGB(30,30,30)];
    [lbtext setTextAlignment:NSTextAlignmentLeft];
    [lbtext setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbtext];
    [lbtext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.width.offset(150);
        make.height.offset(30);
        make.top.offset(10);
    }];

    
    UITextView *textview = [[UITextView alloc] init];
    [textview setTextColor:RGB(102,102,102)];
    [textview setTextAlignment:NSTextAlignmentLeft];
    [textview setTextContainerInset:UIEdgeInsetsMake(10, 8, 10, 10)];
    [textview setFont:[UIFont systemFontOfSize:13]];
    [textview.layer setMasksToBounds:YES];
    [textview.layer setCornerRadius:4];
    [textview.layer setBorderColor:RGB(218,218,218).CGColor];
    [textview.layer setBorderWidth:1];
    [textview setDelegate:self];
    [view addSubview:textview];
    [textview mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.offset(15);
        make.right.equalTo(view).offset(-15);
        make.height.offset(120);
        make.top.equalTo(lbtext.mas_bottom).offset(10);
    }];
    
    
    UILabel *lbplach = [[UILabel alloc] init];
    [lbplach setText:@"提供规格尺寸颜色等备注，请按照源网站规格填写（如：Color Pale Apricont/Royal Navy）避免采购错误，造成交易纠纷，若客户未备注规格，买手按照链接默认规格进行采购。"];
    [lbplach setTextColor:RGB(193,193,193)];
    [lbplach setTextAlignment:NSTextAlignmentLeft];
    [lbplach setFont:[UIFont systemFontOfSize:13]];
    [lbplach setNumberOfLines:0];
    [lbplach sizeToFit];
    [lbplach setTag:22];
    [textview addSubview:lbplach];
    [lbplach mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(11);
        make.top.offset(10);
        make.width.equalTo(textview).offset(-22);
    }];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(textview.mas_bottom).offset(30);
    }];
}

-(void)drawbottom:(UIView *)view
{
    UILabel *lbkd = [[UILabel alloc] init];
    [lbkd setText:@"总计: "];
    [lbkd setTextColor:RGB(51,51,51)];
    [lbkd setTextAlignment:NSTextAlignmentLeft];
    [lbkd setFont:[UIFont systemFontOfSize:15]];
    [view addSubview:lbkd];
    [lbkd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(10);
        make.height.offset(30);
    }];
    
    UILabel *lbprice = [[UILabel alloc] init];
    [lbprice setText:@"￥0.0"];
    [lbprice setTextColor:RGB(253,122,14)];
    [lbprice setTextAlignment:NSTextAlignmentLeft];
    [lbprice setFont:[UIFont fontWithName:@"Arial_BlodMT" size:15]];
    [view addSubview:lbprice];
    [lbprice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbkd.mas_right);
        make.top.height.equalTo(lbkd);
    }];
    
    UILabel *lbshouxufei = [[UILabel alloc] init];
    [lbshouxufei setText:@"（含手续费0元）"];
    [lbshouxufei setTextColor:RGB(151,151,151)];
    [lbshouxufei setTextAlignment:NSTextAlignmentLeft];
    [lbshouxufei setFont:[UIFont systemFontOfSize:13]];
    [view addSubview:lbshouxufei];
    [lbshouxufei mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbkd);
        make.top.equalTo(lbkd.mas_bottom);
    }];
    
    UIButton *btsend = [[UIButton alloc] init];
    [btsend setTitle:@"下一步" forState:UIControlStateNormal];
    [btsend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btsend.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [btsend addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [btsend setBackgroundColor:RGB(253,122,14)];
    [btsend.layer setMasksToBounds:YES];
    [btsend.layer setCornerRadius:3];
    [view addSubview:btsend];
    [btsend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-15);
        make.top.offset(10);
        make.bottom.equalTo(view).offset(-10);
        make.width.offset(90);
    }];
}

#pragma mark - 商品分类选择
-(void)selectFenLeiAction
{
    if(dataController== nil || dataController.resultMessage)
    {
        dataController = [[BrokeShareDataController alloc] init];
        [dataController requestGetCateDataWithInView:self callback:^(NSError *error, BOOL state, NSString *describle) {
            if (dataController.resultMessage) {
                [MDB_UserDefault showNotifyHUDwithtext:dataController.resultMessage inView:self];
            }else{
                BrokeTypeActionSheetView *actionSheetView = [[BrokeTypeActionSheetView alloc] init];
                actionSheetView.types = dataController.requestCateResults;
                actionSheetView.delegate = self;
                [actionSheetView showActionSheet];
            }
        }];
    }
    else
    {
        BrokeTypeActionSheetView *actionSheetView = [[BrokeTypeActionSheetView alloc] init];
        actionSheetView.types = dataController.requestCateResults;
        actionSheetView.delegate = self;
        [actionSheetView showActionSheet];
    }
    
    
}
- (void)brokeTypeActionSheetView:(BrokeTypeActionSheetView *)alertView
                   didSelectType:(NSDictionary *)dict
{
    
    [viewfenlei removeFromSuperview];
    if(viewSelectInfo==nil)
    {
        [self drawSelectInfoView];
    }
    [lbfeileivalue setText:[NSString stringWithFormat:@"%@ > %@",[dict objectForKey:@"supername"],[dict objectForKey:@"name"]]];
    
    
    
    
}

#pragma mark - 数量选择
-(UIView *)drawNumberSelect:(CGRect)rect andframe:(UIView *)view
{
    UIView *viewnumber = [[UIView alloc] initWithFrame:rect];
    [viewnumber.layer setMasksToBounds:YES];
    [viewnumber.layer setCornerRadius:3];
    [viewnumber.layer setBorderColor:RGB(204,204,204).CGColor];
    [viewnumber.layer setBorderWidth:1];
    [viewnumber setClipsToBounds:YES];
    [view addSubview:viewnumber];
    
    UIButton *btdel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, viewnumber.height, viewnumber.height)];
    [btdel setTitle:@"-" forState:UIControlStateNormal];
    [btdel setTitleColor:RGB(153,153,153) forState:UIControlStateNormal];
    [btdel.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [btdel addTarget:self action:@selector(delNumberAction) forControlEvents:UIControlEventTouchUpInside];
    [viewnumber addSubview:btdel];
    
    UIView *viewline0 = [[UIView alloc] initWithFrame:CGRectMake(btdel.right, 0, 1, viewnumber.height)];
    [viewline0 setBackgroundColor:RGB(204,204,204)];
    [viewnumber addSubview:viewline0];
    
    fieldnumber = [[UITextField alloc] initWithFrame:CGRectMake(viewline0.right, 0, viewnumber.height*1.1, viewnumber.height)];
    [fieldnumber setText:@"1"];
    [fieldnumber setTextColor:RadMenuColor];
    [fieldnumber setTextAlignment:NSTextAlignmentCenter];
    [fieldnumber setFont:[UIFont systemFontOfSize:12]];
    [fieldnumber setUserInteractionEnabled:NO];
    [fieldnumber setBackgroundColor:[UIColor whiteColor]];
    [viewnumber addSubview:fieldnumber];
    
    
    UIView *viewline1 = [[UIView alloc] initWithFrame:CGRectMake(fieldnumber.right, 0, 1, viewnumber.height)];
    [viewline1 setBackgroundColor:RGB(204,204,204)];
    [viewnumber addSubview:viewline1];
    
    
    UIButton *btadd = [[UIButton alloc] initWithFrame:CGRectMake(viewline1.right, 0, viewnumber.height, viewnumber.height)];
    [btadd setTitle:@"+" forState:UIControlStateNormal];
    [btadd setTitleColor:RGB(153,153,153) forState:UIControlStateNormal];
    [btadd.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [viewnumber addSubview:btadd];
    [btadd addTarget:self action:@selector(addNumberAction) forControlEvents:UIControlEventTouchUpInside];
    [viewnumber setWidth:btadd.right];
    
    return viewnumber;
}

-(void)delNumberAction
{
    NSInteger itemp = fieldnumber.text.integerValue;
    if(itemp>1)
    {
        itemp--;
    }
    
    fieldnumber.text = [NSString stringWithFormat:@"%ld",itemp];
    
}

-(void)addNumberAction
{
    NSInteger itemp = fieldnumber.text.integerValue;
    if(itemp<10)
    {
        itemp++;
    }
    
    fieldnumber.text = [NSString stringWithFormat:@"%ld",itemp];
}

#pragma mark - 规格
-(void)guigeAction
{
    /*
    NSMutableDictionary *dicinfo = [NSMutableDictionary new];
    [dicinfo setObject:@"id" forKey:@"id"];
    [dicinfo setObject:@"" forKey:@"image"];
    [dicinfo setObject:@"" forKey:@"title"];
    
    SelectColorAndSizeView *svc = [[SelectColorAndSizeView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, kMainScreenH) andvalue:dicinfo andtype:1];
    [svc setDelegate:self];
    [self.window addSubview:svc];
    [svc showView];
     */
}
#pragma mark - 优惠
-(void)youhuiAction
{
    float fallprice = 100;
    /*
    DaiGouXiaDanQuanView *dview = [[DaiGouXiaDanQuanView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [dview setDelegate:self];
    [self addSubview:dview];
    dview.strgoodsprice = [NSString stringWithFormat:@"%.2lf",fallprice];
    dview.arrdata = arruseablecoupons;
    dview.inomoselect = inomoselectuseab;
    [dview showQuan];
     */
}

#pragma mark - 下一步
-(void)nextAction
{
    ZiZhuUserInfoViewController *zvc = [[ZiZhuUserInfoViewController alloc] init];
    [self.viewController.navigationController pushViewController:zvc animated:YES];
}

#pragma mark - 选择优惠券代理
-(void)selectitem:(MyGoodsCouponModel *)model andnum:(NSInteger)inum
{
    
}

#pragma mark - 选择规格代理
///购买商品
-(void)buyGoods:(NSString *)strid andnum:(NSString *)strnum
{
    
}
///添加购物车
-(void)addGouWuChe:(NSString *)strid andnum:(NSString *)strnum
{
    
}
///修改购物车规格
-(void)changeGouWuChe:(NSString *)strid andcartid:(NSString *)strcartid
{
    
}


#pragma mark - UITextView
- (void)textViewDidChange:(UITextView *)textView
{
    if(textView.tag!=111)
    {
        UILabel *lb = [textView viewWithTag:22];
        if(textView.text.length>0)
        {
            [lb setHidden:YES];
        }
        else
        {
            [lb setHidden:NO];
        }
    }
    
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self endEditing:YES];
}
@end
