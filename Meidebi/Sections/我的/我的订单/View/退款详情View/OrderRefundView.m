//
//  OrderRefundView.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/9.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "OrderRefundView.h"

#import "MDB_UserDefault.h"

@interface OrderRefundView ()
{
    
    UIScrollView *scvback;
    
    NSDictionary *dictuikuan;
    NSDictionary *dicgoods;
    NSDictionary *dicbalance;
    
    NSString *strqq;
    
    NSArray *arrrefund;
    ///总退款金额
    UILabel *lballltuikuanMoney;
    ///退款编号
    UILabel *lbtuikuanbiaohao;
}
@end
@implementation OrderRefundView

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
        
    }
    return self;
}


-(void)bindSubview:(NSDictionary *)dic
{
    scvback = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [scvback setBackgroundColor:RGB(241,241,241)];
    [self addSubview:scvback];
    
    if([[dic objectForKey:@"refund"] isKindOfClass:[NSDictionary class]])
    {
//        [MDB_UserDefault showNotifyHUDwithtext:@"退款信息错误" inView:self];
//        return;
        dictuikuan = [dic objectForKey:@"refund"];
    }
    if([[dic objectForKey:@"refund"] isKindOfClass:[NSArray class]])
    {
        arrrefund = [dic objectForKey:@"refund"];
    }
    
    dicgoods = [dic objectForKey:@"goods"];
    dicbalance = [dic objectForKey:@"balance"];
    strqq = [dic objectForKey:@"qq"];
    
    float fbottomtemp = 0;
    if(arrrefund != nil)
    {
        fbottomtemp = 0;
        ///
        UIView *viewtkmoney = [self drawTKMoney:CGRectMake(0, 0, scvback.width, 50) andisone:NO];
        [scvback addSubview:viewtkmoney];
        fbottomtemp = viewtkmoney.bottom;
        
        [scvback setBackgroundColor:[UIColor whiteColor]];
        
        float ftemp = 0;
        NSString *strtuikuannumber = @"";
        for(NSDictionary *dictemp in arrrefund)
        {
            UIView *viewtuikuaninfo = [self drawTuiKuanInfo:CGRectMake(0, fbottomtemp, scvback.width, 100) andisone:NO andvalue:dictemp];
            [scvback addSubview:viewtuikuaninfo];
            fbottomtemp = viewtuikuaninfo.bottom+10;
            ftemp+=[[dictemp objectForKey:@"amount"] floatValue];
            strtuikuannumber = [NSString nullToString:[dictemp objectForKey:@"batch_no"]];
        }
        [lballltuikuanMoney setText:[NSString stringWithFormat:@"￥%.2lf",ftemp]];
        [lbtuikuanbiaohao setText:strtuikuannumber];
        fbottomtemp-=10;
    }
    else
    {///新版本应该会遗弃
        ////只有一条退款信息
        UIView *viewtop = [self drawtop:CGRectMake(0, 0, scvback.width, 50) andtype:1];
        [scvback addSubview:viewtop];
        fbottomtemp = viewtop.bottom;
        if(dictuikuan!=nil)
        {
            ///
            UIView *viewtkmoney = [self drawTKMoney:CGRectMake(0, viewtop.bottom, viewtop.width, 50) andisone:YES];
            [scvback addSubview:viewtkmoney];
            fbottomtemp = viewtkmoney.bottom;
        }
        
        UIView *viewtuikuaninfo = [self drawTuiKuanInfo:CGRectMake(0, fbottomtemp, scvback.width, 100) andisone:YES andvalue:dictuikuan];
        [scvback addSubview:viewtuikuaninfo];
        fbottomtemp = viewtuikuaninfo.bottom;
        ///////
        
    }
    ///
    UIView *viewortk = [self drawordermessage:CGRectMake(0, fbottomtemp, scvback.width, 100)];
    [scvback addSubview:viewortk];
    
    [scvback setContentSize:CGSizeMake(0, viewortk.bottom)];
    
    
}

#pragma mark - 头部订单状态 type 1显示2行 其他1行
-(UIView *)drawtop:(CGRect)rect andtype:(int)type
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:RGB(253,122,14)];
    
    UILabel *lbname = [[UILabel alloc] initWithFrame:CGRectMake(38, 20, 250, 20)];
    [lbname setText:@"退款中"];
    type = 0;
    if([[dictuikuan objectForKey:@"status"] intValue] == 1)
    {
        [lbname setText:@"退款成功"];
        type = 1;
    }
    
    if([NSString nullToString:[dictuikuan objectForKey:@"re_status"]].length>0)
    {
        [lbname setText:[NSString nullToString:[dictuikuan objectForKey:@"re_status"]]];
    }
    
    [lbname setTextColor:RGB(255,255,255)];
    [lbname setTextAlignment:NSTextAlignmentLeft];
    [lbname setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbname];
    if(type == 1)
    {
        UILabel *lbother = [[UILabel alloc] initWithFrame:CGRectMake(lbname.left, lbname.bottom+5, 250, 20)];
        [lbother setText:[MDB_UserDefault strTimefromData:[[dictuikuan objectForKey:@"successtime"] integerValue] dataFormat:@"yyyy.MM.dd HH:mm:ss"]];
        [lbother setTextColor:RGB(255,255,255)];
        [lbother setTextAlignment:NSTextAlignmentLeft];
        [lbother setFont:[UIFont systemFontOfSize:12]];
        [view addSubview:lbother];
        
        [view setHeight:lbother.bottom+20];
    }
    else
    {
        [view setHeight:lbname.bottom+20];
    }
    
    
    return view;
}
#pragma mark - 退款金额的方式
-(UIView *)drawTKMoney:(CGRect)rect andisone:(BOOL)isone
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *lbname = [[UILabel alloc] initWithFrame:CGRectMake(38, 20, 150, 20)];
    [lbname setText:@"退款金额"];
    [lbname setTextColor:RGB(102,102,102)];
    [lbname setTextAlignment:NSTextAlignmentLeft];
    [lbname setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:lbname];
    
    UILabel *lbvalue = [[UILabel alloc] initWithFrame:CGRectMake(38, lbname.top, 150, lbname.height)];
    if(dictuikuan != nil)
    {
        [lbvalue setText:[NSString stringWithFormat:@"￥%@",[dictuikuan objectForKey:@"amount"]]];
    }
    else
    {
        [lbvalue setText:@""];
    }
    
    [lbvalue setTextColor:RGB(230,56,47)];
    [lbvalue setTextAlignment:NSTextAlignmentRight];
    [lbvalue setFont:[UIFont systemFontOfSize:12]];
    [lbvalue setRight:view.width-38];
    [view addSubview:lbvalue];
    lballltuikuanMoney = lbvalue;
    
    UILabel *lbname1 = [[UILabel alloc] initWithFrame:CGRectMake(lbname.left, lbname.bottom+8, 150, 20)];
    [lbname1 setText:@"退款方式"];
    [lbname1 setTextColor:RGB(102,102,102)];
    [lbname1 setTextAlignment:NSTextAlignmentLeft];
    [lbname1 setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:lbname1];
    
    UILabel *lbvalue1 = [[UILabel alloc] initWithFrame:CGRectMake(38, lbname1.top, 150, lbname1.height)];
    [lbvalue1 setText:@"原路退回"];
    [lbvalue1 setTextColor:RGB(102,102,102)];
    [lbvalue1 setTextAlignment:NSTextAlignmentRight];
    [lbvalue1 setFont:[UIFont systemFontOfSize:12]];
    [lbvalue1 setRight:view.width-38];
    [view addSubview:lbvalue1];
    
    [view setHeight:lbname1.bottom+20];
    if(isone==NO)
    {
        UILabel *lbname2 = [[UILabel alloc] initWithFrame:CGRectMake(lbname1.left, lbname1.bottom+8, 150, 20)];
        [lbname2 setText:@"退款编号"];
        [lbname2 setTextColor:RGB(102,102,102)];
        [lbname2 setTextAlignment:NSTextAlignmentLeft];
        [lbname2 setFont:[UIFont systemFontOfSize:12]];
        [view addSubview:lbname2];
        
        UILabel *lbvalue2 = [[UILabel alloc] initWithFrame:CGRectMake(38, lbname2.top, 150, lbname2.height)];
        [lbvalue2 setText:@""];
        [lbvalue2 setTextColor:RGB(102,102,102)];
        [lbvalue2 setTextAlignment:NSTextAlignmentRight];
        [lbvalue2 setFont:[UIFont systemFontOfSize:12]];
        [lbvalue2 setRight:view.width-38];
        [view addSubview:lbvalue2];
        
        lbtuikuanbiaohao = lbvalue2;
        
        [view setHeight:lbname2.bottom+20];
    }
    
    
//    UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(0, view.height-1, view.width, 1)];
//    [viewline setBackgroundColor:RGB(218,218,218)];
//    [view addSubview:viewline];
    return view;
}

#pragma mark - 退款流程
-(UIView *)drawTKliuChen:(CGRect)rect
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    
    UIView *viewitem0 = [self drawliuchenItem:CGRectMake(0, 30, view.width/3.0, 50) andtype:1 andisselect:YES andtitle:@"没得比退款" andtime:@"2018.03.12 12:30:20"];
    [view addSubview:viewitem0];
    
    
    UIView *viewitem1 = [self drawliuchenItem:CGRectMake(viewitem0.right, viewitem0.top, viewitem0.width, 50) andtype:3 andisselect:NO andtitle:@"银行受理" andtime:@""];
    [view addSubview:viewitem1];
    
    UIView *viewitem2 = [self drawliuchenItem:CGRectMake(viewitem1.right, viewitem0.top, viewitem0.width, 50) andtype:2 andisselect:NO andtitle:@"退款成功" andtime:@""];
    [view addSubview:viewitem2];
    
    [view setHeight:viewitem0.bottom+30];
    
    UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(0, view.height-1, view.width, 1)];
    [viewline setBackgroundColor:RGB(218,218,218)];
    [view addSubview:viewline];
    
    return view;
}
/*
 type 1:左边为空 2右边为空 3全部
 */
-(UIView *)drawliuchenItem:(CGRect)rect andtype:(int)type andisselect:(BOOL)iselect andtitle:(NSString *)strtitle andtime:(NSString *)strtime
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view setClipsToBounds:YES];
    
    UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(0, 10, view.width, 3)];
    [viewline setBackgroundColor:RGB(101,177,84)];
    [view addSubview:viewline];
    if(type==1)
    {
        [viewline setWidth:view.width/2.0];
        [viewline setLeft:view.width/2.0];
        
    }
    else if (type == 2)
    {
        [viewline setWidth:view.width/2.0];
    }
    
    UIView *viewyuan = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 21, 21)];
    [viewyuan.layer setMasksToBounds:YES];
    [viewyuan.layer setCornerRadius:viewyuan.height/2.0];
    if(iselect)
    {
        [viewyuan setBackgroundColor:RGB(101,177,84)];
    }
    else
    {
        [viewyuan.layer setBorderColor:RGB(101,177,84).CGColor];
        [viewyuan.layer setBorderWidth:1];
        [viewyuan setBackgroundColor:[UIColor whiteColor]];
    }
    [viewyuan setCenter:CGPointMake(view.width/2.0, viewline.centerY)];
    [view addSubview:viewyuan];
    
    
    UILabel *lbtitle = [[UILabel alloc] initWithFrame:CGRectMake(0, viewyuan.bottom+15, view.width, 15)];
    [lbtitle setText:strtitle];
    [lbtitle setTextColor:RGB(102,102,102)];
    [lbtitle setTextAlignment:NSTextAlignmentCenter];
    [lbtitle setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:lbtitle];
    
    
    UILabel *lbtime = [[UILabel alloc] initWithFrame:CGRectMake(0, lbtitle.bottom+3, view.width, 15)];
    if(strtime == nil)
    {
        strtime = @"";
    }
    [lbtime setText:strtime];
    [lbtime setTextColor:RGB(102,102,102)];
    [lbtime setTextAlignment:NSTextAlignmentCenter];
    [lbtime setFont:[UIFont systemFontOfSize:10]];
    [view addSubview:lbtime];
    [view setHeight:lbtime.bottom];
    
    return view;
}

#pragma mark - 退款商品信息
#pragma mark - 商品信息
-(UIView *)drawShangPin:(CGRect)rect
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    float fleft = 10;
    
    
    UILabel *lbshop = [[UILabel alloc] initWithFrame:CGRectMake(fleft, 17, 145, 17)];
    [lbshop setText:@"退款信息"];
    [lbshop setTextColor:RGB(102,102,102)];
    [lbshop setTextAlignment:NSTextAlignmentLeft];
    [lbshop setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:lbshop];
    
    UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(0, lbshop.bottom+17, view.width, 1)];
    [viewline setBackgroundColor:RGB(231,231,231)];
    [view addSubview:viewline];
    
    NSDictionary *dicsnap_goodsinfo = [dicgoods objectForKey:@"snap_goodsinfo"];
    
    UIImageView *imgvhead = [[UIImageView alloc] initWithFrame:CGRectMake(10, viewline.bottom+17, 71, 71)];
    [imgvhead.layer setMasksToBounds:YES];
    [imgvhead.layer setCornerRadius:4];
    [[MDB_UserDefault defaultInstance] setViewWithImage:imgvhead url:[dicsnap_goodsinfo objectForKey:@"image"]];
    [view addSubview:imgvhead];
    
    UILabel *lbtitle = [[UILabel alloc] initWithFrame:CGRectMake(imgvhead.right+10, imgvhead.top, view.width-imgvhead.right-75, 45)];
    [lbtitle setText:[dicsnap_goodsinfo objectForKey:@"title"]];
    [lbtitle setTextColor:RGB(102,102,102)];
    [lbtitle setTextAlignment:NSTextAlignmentLeft];
    [lbtitle setFont:[UIFont systemFontOfSize:12]];
    [lbtitle setNumberOfLines:3];
    [view addSubview:lbtitle];
    
    
    UILabel *lbprice = [[UILabel alloc] initWithFrame:CGRectMake(lbtitle.right, lbtitle.top, view.width-lbtitle.right-10, lbtitle.height)];
    [lbprice setText:[NSString stringWithFormat:@"￥%@",[dicbalance objectForKey:@"price"]]];
    [lbprice setTextColor:RGB(243,93,0)];
    [lbprice setTextAlignment:NSTextAlignmentRight];
    [lbprice setFont:[UIFont systemFontOfSize:13]];
    [lbprice setNumberOfLines:2];
    [view addSubview:lbprice];
    
    ///颜色尺码
    UILabel *lbcmcolor = [[UILabel alloc] initWithFrame:CGRectMake(lbtitle.left, lbtitle.bottom, lbtitle.width, 20)];
    [lbcmcolor setText:[dicgoods objectForKey:@"extra"]];
    [lbcmcolor setTextColor:RGB(153,153,153)];
    [lbcmcolor setTextAlignment:NSTextAlignmentLeft];
    [lbcmcolor setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:lbcmcolor];
    
    UILabel *lbnumber = [[UILabel alloc] initWithFrame:CGRectMake(lbcmcolor.right, lbcmcolor.top, lbprice.width, lbcmcolor.height)];
    [lbnumber setText:[NSString stringWithFormat:@"x%@",[dicgoods objectForKey:@"num"]]];
    [lbnumber setTextColor:RGB(153,153,153)];
    [lbnumber setTextAlignment:NSTextAlignmentRight];
    [lbnumber setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:lbnumber];
    
    UIView *viewlin1 = [[UIView alloc] initWithFrame:CGRectMake(0, imgvhead.bottom+16,view.width , 1)];
    [viewlin1 setBackgroundColor:RGB(218,218,218)];
    [view addSubview:viewlin1];
    
    ////邮费税费
    UILabel *lbotherprice = [[UILabel alloc] initWithFrame:CGRectMake(imgvhead.left, viewlin1.bottom, view.width-20, 40)];
    NSString *stryoufei = [NSString stringWithFormat:@"%.2lf",[[dicbalance objectForKey:@"guonei_cost"] floatValue]+[[dicbalance objectForKey:@"guonei_cost"] floatValue]];
    [lbotherprice setText:[NSString stringWithFormat:@"邮费%@元，税费%@元（均为预估，多退少补）",stryoufei,[dicbalance objectForKey:@"tariff_cost"]]];
    
    [lbotherprice setTextColor:RGB(153,153,153)];
    [lbotherprice setTextAlignment:NSTextAlignmentLeft];
    [lbotherprice setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:lbotherprice];
    
    [view setHeight:lbotherprice.bottom+1];
    
    
    UIView *viewlin3 = [[UIView alloc] initWithFrame:CGRectMake(0, view.height-1,view.width , 1)];
    [viewlin3 setBackgroundColor:RGB(218,218,218)];
    [view addSubview:viewlin3];
    
    return view;
}

-(UIView *)drawTuiKuanInfo:(CGRect )rect andisone:(BOOL)isone andvalue:(NSDictionary *)dicvalue
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:RGB(255,255,255)];
    
    
    
    UIView *vieworder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.width, 100)];
    [vieworder setBackgroundColor:RGB(249,249,249)];
    [view addSubview:vieworder];
    NSString *stryuany = [dicvalue objectForKey:@"cancel_reason"];
    if(stryuany.length<1){
        stryuany = @"无";
    }
    NSMutableArray *arrvalue = [NSMutableArray arrayWithObjects:
                                [NSString stringWithFormat:@"退款原因：%@",stryuany],nil];
    if([[NSString nullToString:[dicvalue objectForKey:@"amount"]] floatValue]>0)
    {
        [arrvalue addObject: [NSString stringWithFormat:@"退款金额：¥%@",[NSString nullToString:[dicvalue objectForKey:@"amount"]]]];
    }
    if(isone)
    {
        if([[NSString nullToString:[dicvalue objectForKey:@"batch_no"]] length]>0)
        {
            [arrvalue addObject: [NSString stringWithFormat:@"退款编号：%@",[NSString nullToString:[dicvalue objectForKey:@"batch_no"]]]];
        }
    }
    
    
    
    if(dicvalue == nil)
    {
        arrvalue = [NSMutableArray arrayWithObjects:
                    [NSString stringWithFormat:@"退款原因：%@",stryuany],nil];
    }
    
    if([[NSString nullToString:[dicvalue objectForKey:@"re_status"]] length]>0)
    {
        [arrvalue addObject:[NSString stringWithFormat:@"退款状态：%@",[NSString nullToString:[dicvalue objectForKey:@"re_status"]]]];
    }
    else
    {
        [arrvalue addObject:[NSString stringWithFormat:@"退款状态：%@",@"退款失败，请联系客服"]];
    }
//    if([[NSString nullToString:[dicvalue objectForKey:@"status"]] intValue] == 0 )
//    {
//        [arrvalue addObject:[NSString stringWithFormat:@"退款状态：%@",@"退款中"]];
//    }
//    else if([[NSString nullToString:[dicvalue objectForKey:@"status"]] intValue] == 1 )
//    {
//        [arrvalue addObject:[NSString stringWithFormat:@"退款状态：%@",@"退款成功"]];
//    }
//    else
//    {
//       [arrvalue addObject:[NSString stringWithFormat:@"退款状态：%@",@"退款失败，请联系客服"]];
//    }
    
    float fbottom = 0.0;
    for(int i = 0 ; i < arrvalue.count; i++)
    {
        UILabel *lb = [self draworderlb:CGRectMake(20, 5+20*i, vieworder.width-40, 20) andvalue:arrvalue[i]];
        [vieworder addSubview:lb];
        fbottom = lb.bottom+5;
    }
    [vieworder setHeight:fbottom];
    
    
    UIButton *btcopy = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30*kScale, 17*kScale)];
    [btcopy setTitle:@"复制" forState:UIControlStateNormal];
    [btcopy setTitleColor:RGB(51,51,51) forState:UIControlStateNormal];
    [btcopy.titleLabel setFont:[UIFont systemFontOfSize:11]];
    [btcopy.layer setMasksToBounds:YES];
    [btcopy.layer setCornerRadius:2];
    [btcopy.layer setBorderColor:RGB(102,102,102).CGColor];
    [btcopy.layer setBorderWidth:1];
    [btcopy setAlpha:0.8];
    [btcopy setTop:7];
    [btcopy setRight:vieworder.width-10];
    [vieworder addSubview:btcopy];
    [btcopy addTarget:self action:@selector(copyAction:) forControlEvents:UIControlEventTouchUpInside];
    if(dictuikuan==nil)
    {
        [btcopy setHidden:YES];
    }
    
    [view setHeight:vieworder.bottom];
    
    return view;
}

#pragma mark - 订单信息
-(UIView *)drawordermessage:(CGRect)rect
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:RGB(255,255,255)];
    
    UILabel *lbname = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, view.width-20, 75)];
    [lbname setText:[NSString stringWithFormat:@"联系没得比客服：QQ %@",strqq]];
    [lbname setTextColor:RGB(102,102,102)];
    [lbname setTextAlignment:NSTextAlignmentCenter];
    [lbname setFont:[UIFont systemFontOfSize:12]];
    [lbname setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:lbname];
    [lbname setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapname = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(QQAction)];
    [lbname addGestureRecognizer:tapname];
    
    [view setHeight:lbname.bottom];
    
    return view;
}

-(UILabel *)draworderlb:(CGRect)rect andvalue:(NSString *)strvalue
{
    UILabel *lbname = [[UILabel alloc] initWithFrame:rect];
    [lbname setText:strvalue];
    [lbname setTextColor:RGB(153,153,153)];
    [lbname setTextAlignment:NSTextAlignmentLeft];
    [lbname setFont:[UIFont systemFontOfSize:12]];
    [lbname setNumberOfLines:0];
    [lbname sizeToFit];
    if(lbname.height<20)
    {
        [lbname setHeight:20];
    }
    
    
    return lbname;
}


-(void)copyAction:(UIButton *)sernder
{
    NSString *strbno = [dictuikuan objectForKey:@"batch_no"];
    UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
    
    pasteboard.string=strbno;
    [MDB_UserDefault showNotifyHUDwithtext:@"复制成功" inView:self];
    
}


-(void)QQAction
{
    UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
    
    pasteboard.string=strqq;
    [MDB_UserDefault showNotifyHUDwithtext:@"复制成功" inView:self];
}

@end
