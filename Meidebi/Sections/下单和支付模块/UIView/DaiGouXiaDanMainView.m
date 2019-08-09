//
//  DaiGouXiaDanMainView.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/30.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "DaiGouXiaDanMainView.h"

#import "TZImagePickerController.h"

#import "DaiGouZhiFuViewController.h"

#import "AddressListModel.h"

#import "AddressListViewController.h"

#import "OrderGoodsInfoModel.h"

#import "MDB_UserDefault.h"

#import "DaiGouXiaDanDataController.h"

#import "DaiGouGuiZheViewController.h"

#import "DaiGouGongLueViewController.h"

#import "GuanLianYuDuViewController.h"

#import "DaiGouXiaDanGoodsView.h"

#import "DaiGouXiaDanQuanView.h"

#import "SSScanningController.h"

#import "WuLiuXieYiTangChuangView.h"

@interface DaiGouXiaDanMainView ()<UIScrollViewDelegate,UITextViewDelegate,AddressListSelectViewControllerDelegate,UITextFieldDelegate,DaiGouXiaDanGoodsViewDelegate,DaiGouXiaDanQuanViewDelegate,SSScanningControllerDelegate,WuLiuXieYiTangChuangViewSelectDelegate>
{
    UIScrollView *scvback;
    ///地址
    UIView *viewaddress;
    ///商品信息
    DaiGouXiaDanGoodsView *viewGoodsMessage;
    
    
    ///快递
    UIView *viewKuaiDi;
    UIButton *btnowkuaidi;
    ///备注
    UIView *viewBeiZu;
    UITextView *beiZuTextView;
    
    
    ///身份证号码
    UIView *viewSFNumber;
    UITextField *fieldSFNumber;
    
    ///身份证信息
    UIView *viewShenFen;
    NSMutableArray *arrsfimage;
    NSMutableArray *arrsfimage1;
//    NSMutableArray *arrassets;
//    NSMutableArray *arrassets1;
    ///当前选中的是那个身份证图片
    NSInteger itpselectnow;
    
    NSString *strsfIdCoard;
    NSString *strsfname;
    
    SSCardModel *cardmodel;
    SSCardModel *cardmodel1;
    
    ///规则
    UIView *viewGuiZe;
    BOOL isguize;
    ///底部
    UIView *viewBottom;
    UILabel *lbprice;
    UILabel *lbshouxufei;
    
    
    NSMutableArray *arrkuaidiMoney;
    NSString *strpindanid;
    
    DaiGouXiaDanDataController *dataControl;
    ///地址model
    AddressListModel *addressmodel;
    ///商品信息
    NSMutableArray *arrshopinfoMOdel;
    
    
    ///快递公司
    NSMutableArray *arrExpress;
    
    ///抵扣运费
    UIView *viewdikoumoney;
    
    UILabel *lbdikoumoney;
    
    ///优惠券
    UIView *viewyouhuiquan;
    UILabel *lbyouhuimoney;
    NSMutableArray *arruseablecoupons;
    NSInteger inomoselectuseab;
    MyGoodsCouponModel *couponmodel;
    
    ////用户信息
    NSDictionary *dicUserInfo;
    
    ///订单号
    NSString *strdingdanhao;
    NSString *strdingdanid;
    ///身份证正反面url
    NSString *strfront_pic;
    NSString *strback_pic;
    
    BOOL ischange;
    
    ///费率
    float ffeilv;
    
    ///我的奖励金
    NSString *strmyremain_bonus;
    ///是否要抵扣运费
    BOOL isdikoumoney;
    
    
    ///订单拆分成多少个包裹
    int iordercount;
    
    ///多个订单号
    NSArray *arrordernumbers;
    ///订单id
    NSArray *arrorderids;
    
    
    NSTimer *toptimer;
    
    ///默认数量
    int igoodsnomonum;
    
    ///判断是否是单独的现货
    BOOL isxianhuoedit;
    
    ///是否需要提示协议
    NSString *stris_slow;
    
    ///是否有规格的商品
    BOOL isyouguige;
}
@end


@implementation DaiGouXiaDanMainView

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
        [self drawSonView];
        [arrsfimage removeObject:@""];[arrsfimage removeAllObjects];[arrsfimage removeObjectAtIndex:1];
        [arrsfimage removeLastObject];
    }
    return self;
}

-(void)drawSonView
{
    scvback = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height-110)];
    [scvback setBackgroundColor:RGB(241,241,241)];
    [scvback setDelegate:self];
    [self addSubview:scvback];
    
    dataControl = [[DaiGouXiaDanDataController alloc] init];
    
    
}
-(void)bindUrl:(NSString *)strid andstrpindan_id:(NSString *)strpindan_id
{
    strpindanid = strpindan_id;
    NSDictionary *dicpush = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],@"id":strid};
    if(strpindan_id.length>0)
    {
        dicpush = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],@"id":strid,@"pindanid":strpindan_id};
    }
    [dataControl requestDGHomeDataInView:self dicpush:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
        if(state)
        {
            [self bindData:dataControl.dicValue andstrpindan_id:strpindan_id];
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self];
        }
        
    }];
}

-(void)bindData:(NSDictionary *)dicvalue andstrpindan_id:(NSString *)strpindan_id
{
    if([[dicvalue objectForKey:@"defaultaddress"] isKindOfClass:[NSDictionary class]])
    {
        addressmodel = [AddressListModel dicChangeToModel:[dicvalue objectForKey:@"defaultaddress"]];
        
        
    }
    _iscanyupintuan = YES;
    
    if([[NSString nullToString:[dicvalue objectForKey:@"needIdcard"]] integerValue]==1)
    {
        _iscanyupintuan = NO;
    }
    
    
    if([[dicvalue objectForKey:@"useablecoupons"] isKindOfClass:[NSArray class]])
    {
        NSArray *useablecoupons = [dicvalue objectForKey:@"useablecoupons"];
        arruseablecoupons = [NSMutableArray new];
        for(NSDictionary *dic in useablecoupons)
        {
            
            /////
            [arruseablecoupons addObject:[MyGoodsCouponModel dicValueChangeModelValue:dic]];
        }
        
    }
    
    strmyremain_bonus = [dicvalue objectForKey:@"remain_bonus"];
    iordercount = [[dicvalue objectForKey:@"ordercount"]  intValue];
    
    if([[dicvalue objectForKey:@"goodsinfo"] isKindOfClass:[NSArray class]])
    {
        arrshopinfoMOdel = [NSMutableArray new];
        NSArray *arrtemp = [dicvalue objectForKey:@"goodsinfo"] ;
        for(NSDictionary *dic in arrtemp)
        {
            [arrshopinfoMOdel addObject:[OrderShopInfoModel viewModelWithSubject:dic]];
        }
        
        if(arrshopinfoMOdel.count < 1)
        {
            return;
        }
    }
    else if([[dicvalue objectForKey:@"goodsinfo"] isKindOfClass:[NSDictionary class]])
    {
        arrshopinfoMOdel = [NSMutableArray new];
        igoodsnomonum = [[NSString nullToString:[dicvalue objectForKey:@"num"]] intValue];
        NSDictionary *arrtemp = [dicvalue objectForKey:@"goodsinfo"] ;
        [arrshopinfoMOdel addObject:[OrderShopInfoModel viewModelWithSubject:arrtemp]];
        
        
        
        if(arrshopinfoMOdel.count < 1)
        {
            return;
        }
        
    }
    else
    {
       return;
    }
    if([[dicvalue objectForKey:@"guoneiexpress"] isKindOfClass:[NSArray class]])
    {
        arrExpress = [dicvalue objectForKey:@"guoneiexpress"];
        
    }
    else
    {
        return;
    }
    
    stris_slow = [NSString nullToString:[dicvalue objectForKey:@"is_slow"]];
    
    //    if(goodsInfoModel.incidentals.count > 0)
    //    {
    //        moneyModel = goodsInfoModel.incidentals[0];
    //    }
    //    else
    //    {
    //        return;
    //    }
    
    ///判断是否是单独的现货
    isxianhuoedit = NO;
    if(arrshopinfoMOdel.count==1)
    {
        OrderShopInfoModel *model0 = arrshopinfoMOdel[0];
        if(model0.arrgoods.count==1)
        {
            OrderGoodsInfoModel *model = model0.arrgoods[0];
            if(model.isspotgoods.integerValue == 1)
            {
                isxianhuoedit = YES;
            }
        }
    }
    
    
    ffeilv = [[dicvalue objectForKey:@"orderpoundage"] floatValue];
    
    strpindanid = strpindan_id;
    [self getExpressValue:addressmodel.strid];
    
    [self getUserMessage:addressmodel.strname];
    
    
    
    
    UIView *viewtop = [self drawTopLineView:CGRectMake(0, 0, BOUNDS_WIDTH, 40*kScale)];
    [scvback addSubview:viewtop];
    
    
    viewaddress = [self drawAddress:CGRectMake(0, viewtop.bottom, scvback.width, 50) andvalue:addressmodel];
    [scvback addSubview:viewaddress];
    
    ///商品列表
    isyouguige = YES;///是否有规格的商品
    float ftemphh = 0.0;
    for(OrderShopInfoModel *model in arrshopinfoMOdel)
    {
        OrderGoodsInfoModel *modeltemp;
        for(OrderGoodsInfoModel *model1 in model.arrgoods)
        {
            if(modeltemp==nil)
            {
                modeltemp = model1;
            }
            else
            {
                if([modeltemp.share_id isEqualToString:model1.share_id])
                {
                    modeltemp.onelimit = @"0";
                    
                }
                modeltemp = model1;
            }
            if([NSString nullToString:model1.goodsdetail_id].length == 0 || model1.goodsdetail_id.integerValue<=0)
            {
                isyouguige = NO;
            }
            
        }
    }
    
    for(OrderShopInfoModel *model in arrshopinfoMOdel)
    {
        ftemphh+=60;
        for(OrderGoodsInfoModel *model1 in model.arrgoods)
        {
            if(model1.onelimit.integerValue>0)
            {
                ftemphh+=178;
            }
            else
            {
                ftemphh+=145;
            }
            
        }
    }
    
    viewGoodsMessage = [[DaiGouXiaDanGoodsView alloc] initWithFrame:CGRectMake(0, viewaddress.bottom+10, viewaddress.width, ftemphh)];
    viewGoodsMessage.arrgoods = arrshopinfoMOdel;
    [viewGoodsMessage setDelegate:self];
    viewGoodsMessage.iseditnumber = _iseditnumber;
    viewGoodsMessage.igoodsnomonum = igoodsnomonum;
    [scvback addSubview:viewGoodsMessage];
    
    
    
    NSMutableArray *arrtitle = [NSMutableArray new];
    for(NSDictionary *dic in arrExpress)
    {
        [arrtitle addObject:[dic objectForKey:@"name"]];
    }
    viewKuaiDi = [self drawKuaiDi:CGRectMake(0, viewGoodsMessage.bottom+10, viewGoodsMessage.width, 45) andarrtitle:arrtitle];
    [scvback addSubview:viewKuaiDi];
    
    isdikoumoney = YES;
    float ftemptop = viewKuaiDi.bottom;
    viewdikoumoney = [self drawyunfeiDiKou:CGRectMake(0, viewKuaiDi.bottom+10, viewGoodsMessage.width, 45) andmoney:@"0.0"];
    [scvback addSubview:viewdikoumoney];
    ftemptop = viewdikoumoney.bottom;
    
    if(arruseablecoupons.count>0)
    {
        float fallprice = [self getallGoodsPriceNotsf];
        MyGoodsCouponModel *modeltemp=nil;
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        
        NSTimeInterval a=[dat timeIntervalSince1970];
        
        ///可用的优惠券
        NSMutableArray *arryhqtemp = [NSMutableArray new];
        ///不可用的优惠券
        NSMutableArray *arrgqyhqtemp = [NSMutableArray new];
        
        for(MyGoodsCouponModel *model in arruseablecoupons)
        {
            if(model.usecondition.floatValue<= fallprice && model.denomination.floatValue<= fallprice && a<model.use_endtime.floatValue)
            {
                [arryhqtemp addObject:model];
            }
            else
            {
                [arrgqyhqtemp addObject:model];
            }
        }
        if(arryhqtemp.count>0)
        {
            modeltemp = arryhqtemp[0];
        }
        [arryhqtemp addObjectsFromArray:arrgqyhqtemp];
        
        arruseablecoupons = arryhqtemp;
        
        inomoselectuseab = 0;
        if(modeltemp==nil)
        {
            inomoselectuseab = -1;
        }
        
        viewyouhuiquan = [self drawGoodsYouHui:CGRectMake(0, ftemptop, scvback.width, 45) andmoney:modeltemp.denomination];
        [scvback addSubview:viewyouhuiquan];
        ftemptop = viewyouhuiquan.bottom;
        couponmodel = modeltemp;
    }
    
    if(isyouguige)
    {
        
    }
    else
    {
        viewBeiZu = [self drawBeiZu:CGRectMake(0, ftemptop+10, viewGoodsMessage.width, 150)];
        [scvback addSubview:viewBeiZu];
        
        ftemptop = viewBeiZu.bottom+10;
    }
    
    
    
    if(_iscanyupintuan==YES || isxianhuoedit == YES)
    {
        
//        viewGuiZe = [self drawGuiZe:CGRectMake(0, ftemptop, viewGoodsMessage.width, 50)];
//        [scvback addSubview:viewGuiZe];
    }
    else
    {
        viewSFNumber = [self drawCodeNumber:CGRectMake(0, ftemptop, viewGoodsMessage.width, 150)];
        [scvback addSubview:viewSFNumber];
        
        viewShenFen = [self drawShenFen:CGRectMake(0, viewSFNumber.bottom+10, viewGoodsMessage.width, 150) andvalue:nil];
        [scvback addSubview:viewShenFen];
        
        ftemptop = viewShenFen.bottom;
//        viewGuiZe = [self drawGuiZe:CGRectMake(0, viewShenFen.bottom+10, viewGoodsMessage.width, 50)];
//        [scvback addSubview:viewGuiZe];
        
        
    }
    
    
    
    viewBottom = [self drawBottom:CGRectMake(0, scvback.bottom, viewGoodsMessage.width, 110)];
    [self addSubview:viewBottom];
    
    [scvback setContentSize:CGSizeMake(0, ftemptop)];
    
    [self setShowAllPrice];
    
}

-(UIView *)drawTopLineView:(CGRect)rect
{
    UIView *viewtop = [[UIView alloc] initWithFrame:rect];
    [viewtop setBackgroundColor:RGB(254, 236, 226)];
    [viewtop setClipsToBounds:YES];
    
    UILabel *lbtop = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewtop.width, viewtop.height)];
    [lbtop setText:@"因海淘特性，到货时间无法预估，正常情况一般20-40个工作日，特殊情况除外，请知悉。"];
    [lbtop setTextColor:RadMenuColor];
    [lbtop setTextAlignment:NSTextAlignmentCenter];
    [lbtop setFont:[UIFont systemFontOfSize:14]];
    [lbtop setBackgroundColor:RGB(254, 236, 226)];
    [viewtop addSubview:lbtop];
    
    UIButton *btdel = [[UIButton alloc] initWithFrame:CGRectMake(viewtop.width-viewtop.height, 0, viewtop.height, viewtop.height)];
    [btdel setImage:[UIImage imageNamed:@"delguanggao_gundong"] forState:UIControlStateNormal];
    //    [btdel.imageView setBackgroundColor:RGBAlpha(0, 0, 0, 0.3)];
    [btdel addTarget:self action:@selector(delgundongguanggaoAction:) forControlEvents:UIControlEventTouchUpInside];
    [viewtop addSubview:btdel];
    if(toptimer != nil)
    {
        [toptimer timeInterval];
        toptimer = nil;
    }
    
    float flbtopw = [MDB_UserDefault getStrWightFont:lbtop.font str:lbtop.text hight:20].width;
    if(lbtop.width<flbtopw)
    {
        toptimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(toptimer:) userInfo:lbtop repeats:YES];
        [lbtop setWidth:flbtopw];
        [lbtop setLeft:10];
        
        [toptimer setFireDate:[NSDate dateWithTimeIntervalSince1970:[[NSDate date] timeIntervalSince1970]+3]];
        _toptimeer = toptimer;
        
        [[NSRunLoop mainRunLoop] addTimer:toptimer forMode:NSRunLoopCommonModes];
        
        
    }
    return viewtop;
}

-(void)uploadLoca
{
    float ftop = viewaddress.top;
    [viewaddress setTop:ftop];
    [viewGoodsMessage setTop:viewaddress.bottom+5];
    [viewKuaiDi setTop:viewGoodsMessage.bottom];
    NSString *strkuaidi = @"0";
    if(arrkuaidiMoney.count>0)
    {
        strkuaidi = arrkuaidiMoney[btnowkuaidi.tag];
    }
    float ftempbottom = viewKuaiDi.bottom;
    if(strmyremain_bonus.floatValue>0&&strkuaidi.floatValue>0)
    {
        [viewdikoumoney setHidden:NO];
        [viewdikoumoney setTop:viewKuaiDi.bottom+5];
        
        ftempbottom = viewdikoumoney.bottom;
    }
    else
    {
        [viewdikoumoney setHidden:YES];
    }
    
    ///优惠券判断
    if(arruseablecoupons.count>0)
    {
        [viewyouhuiquan setHidden:NO];
        [viewyouhuiquan setTop:ftempbottom+5];
        ftempbottom = viewyouhuiquan.bottom;
        
    }
    else
    {
        [viewyouhuiquan setHidden:YES];
    }
    if(isyouguige)
    {
        
    }
    else
    {
        [viewBeiZu setTop:ftempbottom+5];
        ftempbottom = viewBeiZu.bottom;
    }
    
    
    if(_iscanyupintuan==YES || isxianhuoedit==YES)
    {
//        [viewGuiZe setTop:ftempbottom];
    }
    else
    {
        if(strsfIdCoard.length>10)
        {
            [viewSFNumber setHidden:NO];
            [viewSFNumber setTop:ftempbottom+5];
            [viewShenFen setTop:viewSFNumber.bottom+5];
            
            ftempbottom = viewShenFen.bottom;
            
//            [viewGuiZe setTop:viewShenFen.bottom+5];
            
        }
        else
        {
            [viewSFNumber setHidden:YES];
            
            [viewShenFen setTop:ftempbottom+5];
            
            
            ftempbottom = viewShenFen.bottom;
            
//            [viewGuiZe setTop:viewShenFen.bottom+5];
            
        }
        
    }
    
    
    
    //    [viewBottom setTop:viewGuiZe.bottom+10];
    [scvback setContentSize:CGSizeMake(0, ftempbottom)];
    
}

-(void)delgundongguanggaoAction:(UIButton *)sender
{
    [sender.superview removeFromSuperview];
    [viewaddress setTop:0];
    [self uploadLoca];
}

#pragma mark - 地址信息
-(UIView *)drawAddress:(CGRect)rect andvalue:(AddressListModel *)value
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view setUserInteractionEnabled:YES];
    
    
    if(value == nil)
    {
        UIImageView *imgvadd = [[UIImageView alloc] initWithFrame:CGRectMake(15, 17, 15, 15)];
        [imgvadd setImage:[UIImage imageNamed:@"dingdan_address"]];
        [view addSubview:imgvadd];
        
        UILabel *lbtext = [[UILabel alloc] initWithFrame:CGRectMake(imgvadd.right+8, imgvadd.top-5, 150, 25)];
        [lbtext setText:@"添加收货地址"];
        [lbtext setTextColor:RGB(102,102,102)];
        [lbtext setTextAlignment:NSTextAlignmentLeft];
        [lbtext setFont:[UIFont systemFontOfSize:14]];
        [view addSubview:lbtext];
        
        
        
        [view setHeight:49];
    }
    else
    {
        
        UILabel *lbtext = [[UILabel alloc] initWithFrame:CGRectMake(12, 17, view.width-60, 18)];
        [lbtext setText:[NSString stringWithFormat:@"%@，%@",value.strname,value.strphone]];
        [lbtext setTextColor:RGB(102,102,102)];
        [lbtext setTextAlignment:NSTextAlignmentLeft];
        [lbtext setFont:[UIFont systemFontOfSize:14]];
        [view addSubview:lbtext];
        
        UILabel *lbtext1 = [[UILabel alloc] initWithFrame:CGRectMake(lbtext.left, lbtext.bottom, lbtext.width, 25)];
        [lbtext1 setText:value.straddress];
        [lbtext1 setTextColor:RGB(102,102,102)];
        [lbtext1 setTextAlignment:NSTextAlignmentLeft];
        [lbtext1 setFont:[UIFont systemFontOfSize:14]];
        [lbtext1 setNumberOfLines:2];
        [lbtext1 sizeToFit];
        [view addSubview:lbtext1];
        [view setHeight:lbtext1.bottom+17];
        
        
    }
    
    UIImageView *imgvnext= [[UIImageView alloc] initWithFrame:CGRectMake(view.width-25, 15, 15, 15)];
    [imgvnext setImage:[UIImage imageNamed:@"dingdan_address_next"]];
    [imgvnext setCenter:CGPointMake(0, view.height/2.0)];
    [imgvnext setRight:view.width-10];
    [view addSubview:imgvnext];
    
    UIView *viewlin = [[UIView alloc] initWithFrame:CGRectMake(0, view.height-1,view.width , 1)];
    [viewlin setBackgroundColor:RGB(218,218,218)];
    [view addSubview:viewlin];
    
    [view setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressAction)];
    [view addGestureRecognizer:tap];
    
    return view;
}

#pragma mark - 快递
-(UIView *)drawKuaiDi:(CGRect)rect andarrtitle:(NSArray *)arrtitle
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UIScrollView *scvback = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, view.width, 45)];
    [scvback setShowsHorizontalScrollIndicator:NO];
    [view addSubview:scvback];
    
    UILabel *lbtext = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 45)];
    [lbtext setText:@"国内快递"];
    [lbtext setTextColor:RGB(102,102,102)];
    [lbtext setTextAlignment:NSTextAlignmentLeft];
    [lbtext setFont:[UIFont systemFontOfSize:14]];
    [lbtext sizeToFit];
    [lbtext setHeight:view.height];
    [scvback addSubview:lbtext];
    
    float fjianju = 7;
    if(BOUNDS_WIDTH>320)
    {
        fjianju = 20;
    }
    
    float fleft = lbtext.right+fjianju;
    
    for(int i = 0 ; i < arrtitle.count; i++)
    {
        UIButton *btkd = [[UIButton alloc] initWithFrame:CGRectMake(fleft, 0, 50, 45)];
        
        UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
        [imgv setImage:[UIImage imageNamed:@"yuan_select_no"]];
        [imgv setCenter:CGPointMake(0, btkd.height/2.0)];
        [imgv setTag:112];
        [imgv setLeft:0];
        [btkd addSubview:imgv];
        
        UILabel *lbkd = [[UILabel alloc] initWithFrame:CGRectMake(imgv.right+5, 0, 100, btkd.height)];
        [lbkd setText:arrtitle[i]];
        [lbkd setTextColor:RGB(102,102,102)];
        [lbkd setTextAlignment:NSTextAlignmentLeft];
        [lbkd setFont:[UIFont systemFontOfSize:12]];
        [lbkd sizeToFit];
        [lbkd setHeight:btkd.height];
        [btkd addSubview:lbkd];
        [btkd setWidth:lbkd.right];
        
        fleft = btkd.right+fjianju;
        [scvback addSubview:btkd];
        [scvback setContentSize:CGSizeMake(btkd.right, 0)];
        [btkd setTag:i];
        [btkd addTarget:self action:@selector(kuaiDiAction:) forControlEvents:UIControlEventTouchUpInside];
        if(addressmodel.strid.length>1)
        {
            if(btnowkuaidi!=nil)
            {
                if(i==btnowkuaidi.tag)
                {
                    [imgv setImage:[UIImage imageNamed:@"yuan_select_yes"]];
                    btnowkuaidi = btkd;
                }
                
                
            }
            else
            {
                if(i==0)
                {
                    btnowkuaidi = btkd;
                    [imgv setImage:[UIImage imageNamed:@"yuan_select_yes"]];
                }
            }
        }
        
        
    }
    
    float ftempbot = scvback.bottom;
    
    if(iordercount>1)
    {
        UIView *viewkdsm = [[UIView alloc] initWithFrame:CGRectMake(10, scvback.bottom, view.width-20, 100)];
        [viewkdsm setBackgroundColor:RGB(244, 244, 244)];
        [viewkdsm.layer setMasksToBounds:YES];
        [viewkdsm.layer setCornerRadius:3];
        [view addSubview:viewkdsm];
        
        UILabel *lbkdsm = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, viewkdsm.width-20, 100)];
        [lbkdsm setTextColor:RGB(153, 153, 153)];
        [lbkdsm setTextAlignment:NSTextAlignmentLeft];
        [lbkdsm setNumberOfLines:0];
        [lbkdsm setFont:[UIFont systemFontOfSize:13]];
        [lbkdsm setText:[NSString stringWithFormat:@"您的订单需要拆单处理，国内邮费暂收%d个包裹，如货品同时到达没得比，将合并发货并退多余的邮费。",iordercount]];
        [lbkdsm sizeToFit];
        [viewkdsm addSubview:lbkdsm];
        [viewkdsm setHeight:lbkdsm.bottom+20];
        
        UIButton *btyfsm = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 20)];
        [btyfsm setRight:viewkdsm.width];
        [btyfsm setBottom:viewkdsm.height];
        [btyfsm setTitle:@"运费说明" forState:UIControlStateNormal];
        [btyfsm setTitleColor:RGB(141, 101, 57) forState:UIControlStateNormal];
        [btyfsm.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btyfsm setImage:[UIImage imageNamed:@"yunfeishuoming_icon"] forState:UIControlStateNormal];
        [btyfsm setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
        [btyfsm addTarget:self action:@selector(yunfeisuomingAction) forControlEvents:UIControlEventTouchUpInside];
        [viewkdsm addSubview:btyfsm];
        
        ftempbot = viewkdsm.bottom;
    }
    
    
    
    
    UIView *viewlin = [[UIView alloc] initWithFrame:CGRectMake(0, ftempbot+10,view.width , 1)];
    [viewlin setBackgroundColor:RGB(218,218,218)];
    [view addSubview:viewlin];
    
    [view setHeight:viewlin.bottom];
    
    return view;
}

#pragma mark - 运费抵扣
-(UIView *)drawyunfeiDiKou:(CGRect)rect andmoney:(NSString *)strmoney
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *lbtext = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, view.height)];
    [lbtext setText:@"运费抵扣"];
    [lbtext setTextColor:RGB(102,102,102)];
    [lbtext setTextAlignment:NSTextAlignmentLeft];
    [lbtext setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbtext];
    
    
    lbdikoumoney = [[UILabel alloc] initWithFrame:CGRectMake(lbtext.right, 0, 100, view.height)];
    [lbdikoumoney setText:[NSString nullToString:[NSString stringWithFormat:@"￥%@",strmoney]]];
    [lbdikoumoney setTextColor:RGB(102,102,102)];
    [lbdikoumoney setTextAlignment:NSTextAlignmentLeft];
    [lbdikoumoney setFont:[UIFont systemFontOfSize:13]];
    [view addSubview:lbdikoumoney];
    
    
    UISwitch *itemswitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [itemswitch setCenter:CGPointMake(0, view.height/2.0)];
    [itemswitch setRight:view.width-10];
    [itemswitch addTarget:self action:@selector(yunfeidikouAction:) forControlEvents:UIControlEventValueChanged];
    [itemswitch setOn:YES];
    [view addSubview:itemswitch];
    
    
    return view;
}

#pragma mark - 商品优惠
-(UIView *)drawGoodsYouHui:(CGRect)rect andmoney:(NSString *)strmoney
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapv = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(youhuiAction)];
    [view addGestureRecognizer:tapv];
    
    UILabel *lbtext = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, view.height)];
    [lbtext setText:@"商品优惠"];
    [lbtext setTextColor:RGB(102,102,102)];
    [lbtext setTextAlignment:NSTextAlignmentLeft];
    [lbtext setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbtext];
    
    
    lbyouhuimoney = [[UILabel alloc] initWithFrame:CGRectMake(view.width-135, 0, 100, view.height)];
    if(strmoney==nil)
    {
        [lbyouhuimoney setText:@"暂无可用"];
    }
    else
    {
        [lbyouhuimoney setText:[NSString nullToString:[NSString stringWithFormat:@"￥%@",strmoney]]];
    }
    
    [lbyouhuimoney setTextColor:RGB(102,102,102)];
    [lbyouhuimoney setTextAlignment:NSTextAlignmentRight];
    [lbyouhuimoney setFont:[UIFont systemFontOfSize:13]];
    [view addSubview:lbyouhuimoney];
    
    
    UIImageView *imgvnext=[[UIImageView alloc] initWithFrame:CGRectMake(lbyouhuimoney.right+5, (view.height-15)/2.0, 15, 15)];
    [imgvnext setImage:[UIImage imageNamed:@"wodejiangli_next"]];
    [view addSubview:imgvnext];
    
    return view;
}

#pragma mark - 订单备注
-(UIView *)drawBeiZu:(CGRect)rect
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    
    UILabel *lbtext = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, 45)];
    [lbtext setText:@"订单备注"];
    [lbtext setTextColor:RGB(102,102,102)];
    [lbtext setTextAlignment:NSTextAlignmentLeft];
    [lbtext setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbtext];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"(请仔细阅读代购《下单须知》，一经下单概不取消)"];
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"changjianwenti://"
                             range:[[attributedString string] rangeOfString:@"《下单须知》"]];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, attributedString.length)];
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:RGB(255,65,65) range:NSMakeRange(0, attributedString.length)];
    
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:RGB(60, 114, 163)
                             range:[[attributedString string] rangeOfString:@"《下单须知》"]];
    
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    [attributedString addAttributes:attribtDic range:[[attributedString string] rangeOfString:@"下单须知"]];
    
    
    
    UITextView *lbtexttishi = [[UITextView alloc] initWithFrame:CGRectMake(lbtext.right, 0, view.width-lbtext.right-10, 45)];
    [lbtexttishi setTextColor:RGB(255,65,65)];
    [lbtexttishi setTextAlignment:NSTextAlignmentLeft];
    [lbtexttishi setFont:[UIFont systemFontOfSize:10]];
    lbtexttishi.editable = NO;        //必须禁止输入，否则点击将弹出输入键盘
    lbtexttishi.scrollEnabled = NO;
    [lbtexttishi setAttributedText:attributedString];
    lbtexttishi.delegate = self;
    [lbtexttishi setTag:111];
    [lbtexttishi sizeToFit];
    [lbtexttishi setCenterY:lbtext.centerY];
    [view addSubview:lbtexttishi];
    
    
    UITextView *textview = [[UITextView alloc] initWithFrame:CGRectMake(10, lbtext.bottom, view.width-20, view.height-lbtext.bottom-15)];
    [textview setTextColor:RGB(102,102,102)];
    [textview setTextAlignment:NSTextAlignmentLeft];
    [textview setTextContainerInset:UIEdgeInsetsMake(10, 8, 10, 10)];
    [textview setFont:[UIFont systemFontOfSize:13]];
    [textview.layer setMasksToBounds:YES];
    [textview.layer setCornerRadius:4];
    [textview.layer setBorderColor:RGB(218,218,218).CGColor];
    [textview.layer setBorderWidth:1];
    [view addSubview:textview];
    beiZuTextView = textview;
    [beiZuTextView setDelegate:self];
    
    UILabel *lbplach = [[UILabel alloc] initWithFrame:CGRectMake(11, 10, textview.width-22, 15)];
    [lbplach setText:@"请确认商品是否选择具体的尺码折扣，鞋子请备注英码或美码，无备注时写“无”即可。"];
    [lbplach setTextColor:RGB(193,193,193)];
    [lbplach setTextAlignment:NSTextAlignmentLeft];
    [lbplach setFont:[UIFont systemFontOfSize:13]];
    [lbplach setNumberOfLines:0];
    [lbplach sizeToFit];
    [lbplach setTag:22];
    [textview addSubview:lbplach];
    
    UIView *viewlin = [[UIView alloc] initWithFrame:CGRectMake(0, view.height-1,view.width , 1)];
    [viewlin setBackgroundColor:RGB(218,218,218)];
    [view addSubview:viewlin];
    
    return view;
}

#pragma mark - 身份证号码
-(UIView *)drawCodeNumber:(CGRect)rect
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    
    UILabel *lbtext = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 45)];
    [lbtext setText:@"身份证号码"];
    [lbtext setTextColor:RGB(102,102,102)];
    [lbtext setTextAlignment:NSTextAlignmentLeft];
    [lbtext setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbtext];
    
    fieldSFNumber = [[UITextField alloc] initWithFrame:CGRectMake(10, lbtext.bottom, view.width-20, 36*kScale)];
    [fieldSFNumber setTextColor:RGB(153,153,153)];
    [fieldSFNumber setTextAlignment:NSTextAlignmentLeft];
    [fieldSFNumber setFont:[UIFont systemFontOfSize:13]];
    [fieldSFNumber setBorderStyle:UITextBorderStyleRoundedRect];
    [fieldSFNumber setDelegate:self];
    [fieldSFNumber setTag:1110];
    [fieldSFNumber setKeyboardType:UIKeyboardTypeEmailAddress];
    [fieldSFNumber setPlaceholder:@"请输入您的身份证号码"];
    [view addSubview:fieldSFNumber];
    [fieldSFNumber setUserInteractionEnabled:NO];
    
    [view setHeight:fieldSFNumber.bottom+15];
    return view;
}


#pragma mark -///身份证信息
-(UIView *)drawShenFen:(CGRect)rect andvalue:(NSArray *)arrvalue
{
    if(viewShenFen != nil)
    {
        for(UIView *view in viewShenFen.subviews)
        {
            [view removeFromSuperview];
        }
        viewShenFen = nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    if(_iscanyupintuan || isxianhuoedit)
    {
        [view setHidden:YES];
    }
    
    UILabel *lbtext = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, view.width-20, 25)];
    [lbtext setText:@"身份证信息（身份证正反面）"];
    [lbtext setTextColor:RGB(102,102,102)];
    [lbtext setTextAlignment:NSTextAlignmentLeft];
    [lbtext setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbtext];
    
    
    UIButton *btmoban = [[UIButton alloc] initWithFrame:CGRectMake(0, 15, 70, 25)];
    [btmoban setRight:view.width-8];
    [btmoban setTitleColor:RGB(152,152,152) forState:UIControlStateNormal];
    [btmoban.titleLabel setFont:[UIFont systemFontOfSize:13]];
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"身份证模板"];
    NSRange titleRange = {0,[title length]};
    [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
    //    [btmoban setAttributedTitle:title
    //                          forState:UIControlStateNormal];
    [btmoban setTitle:@"身份证模板" forState:UIControlStateNormal];
    [btmoban.titleLabel setAttributedText:title];
    [btmoban addTarget:self action:@selector(mubanAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btmoban];
    
    
    
    
    
    UILabel *lbtext1 = [[UILabel alloc] initWithFrame:CGRectMake(lbtext.left, lbtext.bottom, view.width-20, 20)];
    [lbtext1 setText:@"请上传与收货人一致的身份证正反面（不能带水印）"];
    [lbtext1 setTextColor:RGB(153,153,153)];
    [lbtext1 setTextAlignment:NSTextAlignmentLeft];
    [lbtext1 setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:lbtext1];
    
    float fitemwh = (view.width-50)/4.0;
    
    UIView *imgvadd = [[UIView alloc] initWithFrame:CGRectMake(10, lbtext1.bottom+15, fitemwh, fitemwh)];
    [imgvadd setBackgroundColor:RGB(252,252,252)];
    [imgvadd.layer setMasksToBounds:YES];
    [imgvadd.layer setCornerRadius:4];
    [imgvadd.layer setBorderColor:RGB(218,218,218).CGColor];
    [imgvadd.layer setBorderWidth:1];
    UIImageView *imgvaddson = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgvadd.width/3.0, imgvadd.width/3.0)];
    [imgvaddson setImage:[UIImage imageNamed:@"topic_picture_add"]];
    [imgvaddson setCenter:CGPointMake(imgvadd.width/2.0, imgvadd.height/2.0)];
    [imgvadd addSubview:imgvaddson];
    [view addSubview:imgvadd];
    [imgvadd setUserInteractionEnabled:YES];
    UILabel *lbimgvadd = [[UILabel alloc] initWithFrame:CGRectMake(0,0, imgvadd.width, 15)];
    [lbimgvadd setText:@"正面身份证"];
    [lbimgvadd setTextColor:RGB(153,153,153)];
    [lbimgvadd setTextAlignment:NSTextAlignmentCenter];
    [lbimgvadd setFont:[UIFont systemFontOfSize:10]];
    [imgvadd addSubview:lbimgvadd];
    [imgvaddson setTop:(imgvadd.height-imgvaddson.height-lbimgvadd.height-3)/2.0];
    [lbimgvadd setTop:imgvaddson.bottom+3];
    [imgvadd setTag:0];
    UITapGestureRecognizer *tapimgvadd = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageAddAction:)];
    [imgvadd addGestureRecognizer:tapimgvadd];
    
    
    UIView *imgvadd1 = [[UIView alloc] initWithFrame:CGRectMake(imgvadd.right+10, lbtext1.bottom+15, fitemwh, fitemwh)];
    [imgvadd1 setBackgroundColor:RGB(252,252,252)];
    [imgvadd1.layer setMasksToBounds:YES];
    [imgvadd1.layer setCornerRadius:4];
    [imgvadd1.layer setBorderColor:RGB(218,218,218).CGColor];
    [imgvadd1.layer setBorderWidth:1];
    UIImageView *imgvaddson1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgvadd1.width/3.0, imgvadd1.width/3.0)];
    [imgvaddson1 setImage:[UIImage imageNamed:@"topic_picture_add"]];
    [imgvaddson1 setCenter:CGPointMake(imgvadd.width/2.0, imgvadd.height/2.0)];
    [imgvadd1 addSubview:imgvaddson1];
    [view addSubview:imgvadd1];
    [imgvadd1 setUserInteractionEnabled:YES];
    UILabel *lbimgvadd1 = [[UILabel alloc] initWithFrame:CGRectMake(0,0, imgvadd.width, 15)];
    [lbimgvadd1 setText:@"反面身份证"];
    [lbimgvadd1 setTextColor:RGB(153,153,153)];
    [lbimgvadd1 setTextAlignment:NSTextAlignmentCenter];
    [lbimgvadd1 setFont:[UIFont systemFontOfSize:10]];
    [imgvadd1 addSubview:lbimgvadd1];
    [imgvaddson1 setTop:(imgvadd1.height-imgvaddson1.height-lbimgvadd1.height-3)/2.0];
    [lbimgvadd1 setTop:imgvaddson1.bottom+3];
    [imgvadd1 setTag:1];
    UITapGestureRecognizer *tapimgvadd1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageAddAction:)];
    [imgvadd1 addGestureRecognizer:tapimgvadd1];
    
    
    NSMutableArray *arrtemp = [NSMutableArray new];
    if(arrsfimage.count>0)
    {
        [arrtemp addObjectsFromArray:arrsfimage];
        
        UIImageView *imgv = [self drawImageViewItem:CGRectMake(0, 0, fitemwh, fitemwh) andtag:0];
        if([arrtemp[0] isKindOfClass:[UIImage class]])
        {
            [imgv setImage:arrtemp[0]];
        }
        else
        {
            [[MDB_UserDefault defaultInstance] setViewWithImage:imgv url:arrtemp[0]];
        }
        [imgv setTag:0];
        UITapGestureRecognizer *tapimgvadd = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageAddAction:)];
        [imgv addGestureRecognizer:tapimgvadd];
        [imgvadd addSubview:imgv];
        [imgv setContentMode:UIViewContentModeScaleAspectFit];
        
    }
    if(arrsfimage1.count>0)
    {
        [arrtemp addObjectsFromArray:arrsfimage1];
        
        
        UIImageView *imgv = [self drawImageViewItem:CGRectMake(0, 0, fitemwh, fitemwh) andtag:((int)arrtemp.count-1)];
        if([arrtemp[arrtemp.count-1] isKindOfClass:[UIImage class]])
        {
            [imgv setImage:arrtemp[arrtemp.count-1]];
        }
        else
        {
            [[MDB_UserDefault defaultInstance] setViewWithImage:imgv url:arrtemp[arrtemp.count-1]];
        }
        [imgv setTag:1];
        UITapGestureRecognizer *tapimgvadd1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageAddAction:)];
        [imgv addGestureRecognizer:tapimgvadd1];
        [imgvadd1 addSubview:imgv];
        [imgv setContentMode:UIViewContentModeScaleAspectFit];
    }
    //    for(int i = 0 ; i < arrtemp.count; i++)
    //    {///
    //
    //        UIImageView *imgv = [self drawImageViewItem:CGRectMake(imgvadd1.right+10+(fitemwh+10)*i, imgvadd.top, fitemwh, fitemwh) andtag:i];
    //        if([arrtemp[i] isKindOfClass:[UIImage class]])
    //        {
    //            [imgv setImage:arrtemp[i]];
    //        }
    //        else
    //        {
    //            [[MDB_UserDefault defaultInstance] setViewWithImage:imgv url:arrtemp[i]];
    //        }
    //
    //        [view addSubview:imgv];
    //
    //    }
    
    
    
    [view setHeight:imgvadd.bottom+15];
    
    UIView *viewlin = [[UIView alloc] initWithFrame:CGRectMake(0, view.height-1,view.width , 1)];
    [viewlin setBackgroundColor:RGB(218,218,218)];
    [view addSubview:viewlin];
    
    return view;
}

-(UIImageView *)drawImageViewItem:(CGRect)rect andtag:(int)tag
{
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:rect];
    [imgv setUserInteractionEnabled:YES];
    
    UIButton *btdelimgv = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, imgv.width*0.3, imgv.width*0.3)];
    [btdelimgv setTag:tag];
    [imgv addSubview:btdelimgv];
    [btdelimgv setRight:imgv.width];
    [btdelimgv setTop:0];
    [btdelimgv addTarget:self action:@selector(imgvDelAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imgvdel = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    [imgvdel setImage:[UIImage imageNamed:@"photo_delete"]];
    [imgvdel setTop:3];
    [imgvdel setRight:btdelimgv.width-3];
    [btdelimgv addSubview:imgvdel];
    
    
    return imgv;
}

#pragma mark -运费说明
-(void)yunfeisuomingAction
{
    
    DaiGouGuiZheViewController *dvc = [[DaiGouGuiZheViewController alloc] init];
    dvc.strtitle = @"运费说明";
    dvc.strurl = WenZheng_ALL_rol;
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:@"freight_xpln" forKey:@"key"];
    dvc.dicpush = dicpush;
    [self.viewController.navigationController pushViewController:dvc animated:YES];
    
    
    
}

#pragma mark - 规则
-(UIView *)drawGuiZe:(CGRect)rect
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    
    UIButton *btkd = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 50, view.height)];
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
    [imgv setCenter:CGPointMake(0, btkd.height/2.0)];
    [imgv setImage:[UIImage imageNamed:@"fang_select_no"]];
    isguize = NO;
    [imgv setLeft:0];
    [imgv setTag:2];
    [btkd addSubview:imgv];
    UILabel *lbkd = [[UILabel alloc] initWithFrame:CGRectMake(imgv.right+5, 0, 100, btkd.height)];
    [lbkd setText:@"同意"];
    [lbkd setTextColor:RGB(102,102,102)];
    [lbkd setTextAlignment:NSTextAlignmentLeft];
    [lbkd setFont:[UIFont systemFontOfSize:13]];
    [lbkd sizeToFit];
    [lbkd setHeight:btkd.height];
    [btkd addSubview:lbkd];
    [btkd setWidth:lbkd.right];
    [view addSubview:btkd];
    [btkd addTarget:self action:@selector(guizeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *lbtext1 = [[UILabel alloc] initWithFrame:CGRectMake(btkd.right, 0, 140, view.height)];
    [lbtext1 setText:@"<<没得比代购协议>>"];
    [lbtext1 setTextColor:RGB(153,153,153)];
    [lbtext1 setTextAlignment:NSTextAlignmentLeft];
    [lbtext1 setFont:[UIFont systemFontOfSize:13]];
    [view addSubview:lbtext1];
    [lbtext1 setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapguiz = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(guizeDetaileAction)];
    [lbtext1 addGestureRecognizer:tapguiz];
    
    
    UIView *viewlin = [[UIView alloc] initWithFrame:CGRectMake(0, view.height-1,view.width , 1)];
    [viewlin setBackgroundColor:RGB(218,218,218)];
    [view addSubview:viewlin];
    
    return view;
}

#pragma mark - 底部
-(UIView *)drawBottom:(CGRect)rect
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:RGB(247,247,247)];
    
    viewGuiZe = [self drawGuiZe:CGRectMake(0, 0, viewGoodsMessage.width, 50)];
    [view addSubview:viewGuiZe];
    
    
    UILabel *lbkd = [[UILabel alloc] initWithFrame:CGRectMake(10, viewGuiZe.bottom + 5, 100, view.height-75)];
    [lbkd setText:@"总计: "];
    [lbkd setTextColor:RGB(51,51,51)];
    [lbkd setTextAlignment:NSTextAlignmentLeft];
    [lbkd setFont:[UIFont systemFontOfSize:15]];
    [lbkd sizeToFit];
    [lbkd setHeight:view.height-75];
    [view addSubview:lbkd];
    
    lbprice = [[UILabel alloc] initWithFrame:CGRectMake(lbkd.right, lbkd.top, 150, lbkd.height)];
    [lbprice setText:@"￥0.0"];
    [lbprice setTextColor:RGB(253,122,14)];
    [lbprice setTextAlignment:NSTextAlignmentLeft];
    [lbprice setFont:[UIFont fontWithName:@"Arial_BlodMT" size:15]];
    [view addSubview:lbprice];
    
    lbshouxufei = [[UILabel alloc] initWithFrame:CGRectMake(10, lbprice.bottom, 200, 15)];
    [lbshouxufei setText:@"（支付平台手续费0元）"];
    [lbshouxufei setTextColor:RGB(151,151,151)];
    [lbshouxufei setTextAlignment:NSTextAlignmentLeft];
    [lbshouxufei setFont:[UIFont systemFontOfSize:13]];
    [view addSubview:lbshouxufei];
    
    
    UIButton *btsend = [[UIButton alloc] initWithFrame:CGRectMake(view.width-120, viewGuiZe.bottom, 120, view.height-50)];
    [btsend setTitle:@"提交订单" forState:UIControlStateNormal];
    [btsend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btsend.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [btsend addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    [btsend setBackgroundColor:RGB(253,122,14)];
    [view addSubview:btsend];
    
    return view;
}

#pragma mark - 地址点击
-(void)addressAction
{
    ischange = YES;
    AddressListViewController *avc = [[AddressListViewController alloc] init];
    avc.delegateitem = self;
    if(addressmodel!= nil)
    {
        avc.strnomoid = addressmodel.strid;
    }
    [self.viewController.navigationController pushViewController:avc animated:YES];
    
}

#pragma mark - 快递选择
-(void)kuaiDiAction:(UIButton *)sender
{
    if(addressmodel.strid.length<1)
    {
        
        [MDB_UserDefault showNotifyHUDwithtext:@"请先添加收货地址哦" inView:self.window];
        return;
    }
    ischange = YES;
    if(btnowkuaidi !=nil)
    {
        UIImageView *imgv = [btnowkuaidi viewWithTag:112];
        [imgv setImage:[UIImage imageNamed:@"yuan_select_no"]];
    }
    btnowkuaidi = sender;
    
    UIImageView *imgv = [sender viewWithTag:112];
    [imgv setImage:[UIImage imageNamed:@"yuan_select_yes"]];
    
    [self setShowAllPrice];
    
}

#pragma mark - 是否抵扣运费
-(void)yunfeidikouAction:(UISwitch *)sender
{
    isdikoumoney = sender.isOn;
    [self setShowAllPrice];
    
    
}

#pragma mark - 商品的价格 包含h邮费税费
-(float )getallGoodsPrice
{
    float fallprice = 0.0;
    for(OrderShopInfoModel *shopmodel in arrshopinfoMOdel)
    {
        for(OrderGoodsInfoModel *goodsmodel in shopmodel.arrgoods)
        {
            OrderGoodsMoneyInfoModel *moneyModel = goodsmodel.incidentals[goodsmodel.iselectnumber-1];
            if(goodsmodel.transfertype.intValue == 1)
            {
                fallprice+= goodsmodel.price.floatValue*moneyModel.ikey+moneyModel.tariff.floatValue+moneyModel.transfermoney.floatValue+moneyModel.hpostage.floatValue;
                
            }
            else
            {
                fallprice+= goodsmodel.price.floatValue*moneyModel.ikey+moneyModel.tariff.floatValue+moneyModel.directmailmoney.floatValue;
                
            }
            
            
        }
    }
    return fallprice;
}
#pragma mark - 商品的价格 不包含h邮费税费
-(float )getallGoodsPriceNotsf
{
    float fallprice = 0.0;
    for(OrderShopInfoModel *shopmodel in arrshopinfoMOdel)
    {
        for(OrderGoodsInfoModel *goodsmodel in shopmodel.arrgoods)
        {
            OrderGoodsMoneyInfoModel *moneyModel = goodsmodel.incidentals[goodsmodel.iselectnumber-1];
            if(goodsmodel.transfertype.intValue == 1)
            {
                fallprice+= goodsmodel.price.floatValue*moneyModel.ikey;
                
            }
            else
            {
                fallprice+= goodsmodel.price.floatValue*moneyModel.ikey;
                
            }
            
            
        }
    }
    return fallprice;
}

#pragma mark - 重新选择优惠券
-(void)youhuiAction
{
    float fallprice = [self getallGoodsPriceNotsf];
    
    [beiZuTextView resignFirstResponder];
    [fieldSFNumber resignFirstResponder];
    DaiGouXiaDanQuanView *dview = [[DaiGouXiaDanQuanView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [dview setDelegate:self];
    [self addSubview:dview];
    dview.strgoodsprice = [NSString stringWithFormat:@"%.2lf",fallprice];
    dview.arrdata = arruseablecoupons;
    dview.inomoselect = inomoselectuseab;
    [dview showQuan];
}
-(void)selectitem:(MyGoodsCouponModel *)model andnum:(NSInteger)inum
{
    inomoselectuseab = inum;
    couponmodel = model;
    if(couponmodel==nil)
    {
        [lbyouhuimoney setText:@""];
    }
    else
    {
        [lbyouhuimoney setText:[NSString nullToString:[NSString stringWithFormat:@"￥%@",couponmodel.denomination]]];
    }
    
    [self setShowAllPrice];
}


#pragma mark - 规则确定
-(void)guizeAction:(UIButton *)sender
{
    UIImageView *imgv = [sender viewWithTag:2];
    if(isguize)
    {
        [imgv setImage:[UIImage imageNamed:@"fang_select_no"]];
        isguize = NO;
    }
    else
    {
        [imgv setImage:[UIImage imageNamed:@"fang_select_yes"]];
        isguize = YES;
    }
    
}

#pragma mark - 规则详情
-(void)guizeDetaileAction
{
    ///DaiGouGuiZheViewController DaiGouGongLueViewController
    DaiGouGuiZheViewController *dvc = [[DaiGouGuiZheViewController alloc] init];
    dvc.strtitle = @"代购协议";
    dvc.strurl = WenZheng_ALL_rol;
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:@"service" forKey:@"key"];
    dvc.dicpush = dicpush;
    [self.viewController.navigationController pushViewController:dvc animated:YES];
    
    
}
#pragma mark - 身份证模板
-(void)mubanAction
{
    //    GuanLianYuDuViewController *gvc = [[GuanLianYuDuViewController alloc] init];
    //    gvc.strtitle = @"身份证模板";
    //    gvc.strurl = [NSString stringWithFormat:@"https://m.meidebi.com/article-359.html"];
    //    [self.viewController.navigationController pushViewController:gvc animated:YES];
    
    
    DaiGouGuiZheViewController *dvc = [[DaiGouGuiZheViewController alloc] init];
    dvc.strtitle = @"身份证模板";
    dvc.strurl = WenZheng_ALL_rol;
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:@"id_template" forKey:@"key"];
    dvc.dicpush = dicpush;
    [self.viewController.navigationController pushViewController:dvc animated:YES];
    
}


#pragma mark - 删除图片
-(void)imgvDelAction:(UIButton *)sender
{
    
    if(sender.tag == 0)
    {
        if(arrsfimage.count>0)
        {
//            [arrassets removeObjectAtIndex:0];
            [arrsfimage removeObjectAtIndex:0];
            strfront_pic = nil;
        }
        else
        {
//            [arrassets1 removeObjectAtIndex:0];
            [arrsfimage1 removeObjectAtIndex:0];
            strback_pic = nil;
        }
        
        cardmodel = nil;
        
        
    }
    else if (sender.tag == 1)
    {
//        [arrassets1 removeObjectAtIndex:0];
        [arrsfimage1 removeObjectAtIndex:0];
        strback_pic = nil;
        cardmodel1 = nil;
    }
    
    if(cardmodel1.num==nil&&cardmodel.num==nil)
    {
        strsfIdCoard = @"";
        strsfname = @"";
        [fieldSFNumber setText:@""];
        
        
    }
    
    CGRect rect = viewShenFen.frame;
    [viewShenFen removeFromSuperview];
    viewShenFen = nil;
    viewShenFen = [self drawShenFen:rect andvalue:arrsfimage];
    [scvback addSubview:viewShenFen];
    
    [self uploadLoca];
}

#pragma mark - 添加图片点击
-(void)imageAddAction:(UIGestureRecognizer *)gesture
{
    /*
    ischange = YES;
    //    if(gesture.view.tag == 0)
    //    {
    //        if(arrsfimage.count >=1)
    //            return;
    //    }
    //    if(gesture.view.tag == 1)
    //    {
    //        if(arrsfimage1.count >=1)
    //            return;
    //    }
    
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:nil pushPhotoPickerVc:YES];
    imagePickerVc.isSelectOriginalPhoto = NO;
    
    if(gesture.view.tag == 0)
    {
        //        imagePickerVc.selectedAssets = arrassets; // 目前已经选中的图片数组
    }
    else if(gesture.view.tag == 1)
    {
        //        imagePickerVc.selectedAssets = arrassets1; // 目前已经选中的图片数组
    }
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    // 2. 在这里设置imagePickerVc的外观
    if (iOS7Later) {
        imagePickerVc.navigationBar.barTintColor = RadMenuColor;
    }
    imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    imagePickerVc.navigationBar.translucent = NO;
    
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = NO;
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if(gesture.view.tag == 0)
        {
            [arrsfimage removeAllObjects];
            arrsfimage = [NSMutableArray arrayWithArray:photos];
            arrassets = [NSMutableArray arrayWithArray:assets];
            strfront_pic = nil;
        }
        else if(gesture.view.tag == 1)
        {
            [arrsfimage1 removeAllObjects];
            arrsfimage1 = [NSMutableArray arrayWithArray:photos];
            arrassets1 = [NSMutableArray arrayWithArray:assets];
            strback_pic = nil;
        }
        
        
        CGRect rect = viewShenFen.frame;
        [viewShenFen removeFromSuperview];
        viewShenFen = nil;
        viewShenFen = [self drawShenFen:rect andvalue:arrsfimage];
        [scvback addSubview:viewShenFen];
        
        //        _isSelectOriginalPhoto = isSelectOriginalPhoto;
    }];
    [self.viewController presentViewController:imagePickerVc animated:YES completion:^{
        
    }];
    
    */
    itpselectnow = gesture.view.tag;
    SSScanningController *svc = [[SSScanningController alloc] init];
    svc.delegate = self;
    [self.viewController.navigationController pushViewController:svc animated:YES];
    
    
}
#pragma mark - 身份证信息扫描获取
-(void)SSScanningControllerPopController:(SSCardModel *)model
{
    if(itpselectnow==0)
    {
        if(model.num!=nil||model.name!=nil)
        {//正面
            model.open = YES;
        }
        else
        {//反面
            model.back = YES;
        }
        
        if(cardmodel1!= nil)
        {
            if(cardmodel1.num!=nil||cardmodel1.name!=nil)
            {//正面
                if(model.open == YES)
                {
                    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请传入身份证背面" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alter show];
                    return;
                }
            }
            else
            {//反面
                if(model.back == YES)
                {
                    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请传入身份证正面" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alter show];
                    return;
                }
                cardmodel1.back = YES;
            }
        }
        cardmodel = model;
    }
    else
    {
        if(model.num!=nil||model.name!=nil)
        {//正面
            model.open = YES;
        }
        else
        {//反面
            model.back = YES;
        }
        
        if(cardmodel!= nil)
        {
            if(cardmodel.num!=nil||cardmodel.name!=nil)
            {//正面
                if(model.open == YES)
                {
                    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请传入身份证背面" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alter show];
                    return;
                }
            }
            else
            {//反面
                if(model.back == YES)
                {
                    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请传入身份证正面" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alter show];
                    return;
                }
            }
        }
        
       cardmodel1 = model;
    }

    ischange = YES;
    if(itpselectnow == 0)
    {
        [arrsfimage removeAllObjects];
        arrsfimage = [NSMutableArray arrayWithObject:model.image];
        
        strfront_pic = nil;
    }
    else if(itpselectnow == 1)
    {
        [arrsfimage1 removeAllObjects];
        arrsfimage1 = [NSMutableArray arrayWithObject:model.image];
        
        strback_pic = nil;
    }
    
    
    CGRect rect = viewShenFen.frame;
    [viewShenFen removeFromSuperview];
    viewShenFen = nil;
    viewShenFen = [self drawShenFen:rect andvalue:arrsfimage];
    [scvback addSubview:viewShenFen];
    
    
    if(model.num!=nil||model.name!=nil)
    {//正面
        strsfIdCoard = model.num;
        strsfname = model.name;
        [fieldSFNumber setText:strsfIdCoard];
        if(addressmodel!=nil)
        {
            if(![addressmodel.strname isEqualToString:model.name])
            {
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"身份证图片必须与收货人一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alter show];
            }
        }
        
    }
    else
    {///反面
       if(model.issue!=nil||model.valid!=nil)
       {
           NSArray *arrtemp = [model.valid componentsSeparatedByString:@"-"];
           if(arrtemp.count==2)
           {
               NSString *strendtime = arrtemp[1];
               
               if([[self getUTCFormateDate:strendtime] integerValue]<3)
               {
                   UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请上传有效期大于3个月的身份证图片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                   [alter show];
               }
               
           }
           
       }
    }
    [self uploadLoca];
}

-(NSString *)getUTCFormateDate:(NSString *)newsDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSDate *newsDateFormatted = [dateFormatter dateFromString:newsDate];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];[dateFormatter setTimeZone:timeZone];
    NSDate* current_date = [[NSDate alloc] init];
    NSTimeInterval time=[newsDateFormatted timeIntervalSinceDate:current_date];//间隔的秒数
    int year =((int)time)/(3600*24*30*12);
    int month=((int)time)/(3600*24*30);
    NSString *dateContent;
    if (year!=0) {
        dateContent = @"3";
        
    }else if(month!=0){
        dateContent = [NSString stringWithFormat:@"%i",month];
        
    }else {
        dateContent = @"0";
        
    }
    return dateContent;
}
    

#pragma mark - 能抵扣多少运费
-(float)dikoumoneyCount
{
    NSString *strkuaidi = arrkuaidiMoney[btnowkuaidi.tag];
    float ftempmoney = 0.0;
//    for(OrderShopInfoModel *shopmodel in arrshopinfoMOdel)
//    {
//        for(OrderGoodsInfoModel *goodsmodel in shopmodel.arrgoods)
//        {
//            OrderGoodsMoneyInfoModel *moneyModel = goodsmodel.incidentals[goodsmodel.iselectnumber-1];
//            float ftemp = moneyModel.transfermoney.floatValue+moneyModel.hpostage.floatValue+moneyModel.directmailmoney.floatValue;///所有的快递费
//            ftempmoney+=ftemp;
//        }
//    }
//    
//    ftempmoney+=strkuaidi.floatValue;
    ftempmoney=strkuaidi.floatValue;
    
    float fdikousuifei = 0.0;
    if(ftempmoney>strmyremain_bonus.floatValue)
    {
        if(strmyremain_bonus.floatValue>10)
        {
            fdikousuifei = 10;
        }
        else
        {
            fdikousuifei = strmyremain_bonus.floatValue;
        }
    }
    else
    {
        if(ftempmoney>10)
        {

            fdikousuifei = 10;
        }
        else
        {

            fdikousuifei = ftempmoney;
        }
    }
    if(isdikoumoney == NO)
    {
        fdikousuifei = 0.0;
    }
    return fdikousuifei;
}

#pragma mark - 提交订单点击
-(void)sendAction
{
    if(_iscanyupintuan==NO && isxianhuoedit == NO)
    {
        if(arrsfimage.count!=1)
        {
            [MDB_UserDefault showNotifyHUDwithtext:@"请添加身份证正面图片" inView:self];
            return;
        }
        if(arrsfimage1.count!=1)
        {
            [MDB_UserDefault showNotifyHUDwithtext:@"请添加身份证反面图片" inView:self];
            return;
        }
        if(fieldSFNumber.text.length!=18)
        {
            [MDB_UserDefault showNotifyHUDwithtext:@"请输入正确的身份证号码" inView:self];
            return;
        }
    }
    
    if(addressmodel.strid.length<1)
    {
        [MDB_UserDefault showNotifyHUDwithtext:@"请选择收货地址" inView:self];
        return;
    }
    if(isguize==NO)
    {
        [MDB_UserDefault showNotifyHUDwithtext:@"请先同意代购协议" inView:self];
        return;
    }
    
    if(stris_slow.integerValue == 1)
    {
        ////需要判断是否显示提示框
        WuLiuXieYiTangChuangView *wview = [[WuLiuXieYiTangChuangView alloc] init];
        [wview setDelegate:self];
        [self addSubview:wview];
        [wview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    else
    {
        [self tongyixieyiAction];
    }
    
    
    
}

-(void)tongyixieyiAction
{
    ////购物车订单处理
    if(strdingdanhao != nil && ischange == NO)
    {
        DaiGouZhiFuViewController *dvc = [[DaiGouZhiFuViewController alloc] init];
        dvc.strorderid = strdingdanhao;
        dvc.strdid = strdingdanid;
        dvc.arrordernumbers = arrordernumbers;
        dvc.arrorderids = arrorderids;
        NSString *strkuaidi = arrkuaidiMoney[btnowkuaidi.tag];
        NSString *strprice = @"";
        ///
        
        float fallprice = 0.0;
        float fgoodsprice = [self getallGoodsPrice];
        
        @try {
            NSString *strkuaidi = @"0";
            if(arrkuaidiMoney.count>btnowkuaidi.tag)
            {
                strkuaidi = arrkuaidiMoney[btnowkuaidi.tag];
            }
            else
            {
                strkuaidi = @"0";
            }
            
            float fdikousuifei = [self dikoumoneyCount];
            [lbdikoumoney setText:[NSString stringWithFormat:@"￥%.2lf",fdikousuifei]];
            
            
            fallprice+=fgoodsprice;
            
            fallprice+=strkuaidi.floatValue-fdikousuifei;
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
        if(couponmodel!=nil)
        {
            
            float allgoodstemp = [self getallGoodsPriceNotsf];
            if(allgoodstemp > couponmodel.denomination.floatValue)
            {
                fallprice = fallprice-couponmodel.denomination.floatValue;
            }
            else
            {
                fallprice = fallprice-allgoodstemp;
                
            }
            
            
            if(fallprice<0)
            {
                fallprice = 0.0;
            }
        }
        
        fallprice+=fallprice*ffeilv;
        
        strprice = [NSString stringWithFormat:@"%.2lf",fallprice];
        
        dvc.strprice = strprice;
        dvc.is_deduction = isdikoumoney;
        [self.viewController.navigationController pushViewController:dvc animated:YES];
        return;
    }
    else
    {
        
    }
    
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken] forKey:@"userkey"];
    [dicpush setObject:@"1" forKey:@"ischeck"];
    if(isdikoumoney)
    {
        [dicpush setObject:@"1" forKey:@"is_deduction"];
    }
    else
    {
        [dicpush setObject:@"0" forKey:@"is_deduction"];
    }
    [dicpush setObject:[arrExpress[btnowkuaidi.tag] objectForKey:@"id"] forKey:@"expressid"];
    ///
    [dicpush setObject:addressmodel.strid forKey:@"addressid"];
    
    if(beiZuTextView!= nil)
    {
        [dicpush setObject:beiZuTextView.text forKey:@"remark"];
    }
    
    if(isyouguige)
    {
        [dicpush setObject:@"[空]" forKey:@"remark"];
    }
    
    
    if(fieldSFNumber!=nil)
    {
        [dicpush setObject:fieldSFNumber.text forKey:@"idcard"];
    }
    else
    {
        [dicpush setObject:@"" forKey:@"idcard"];
    }
    
    
    int iimagetype = 0;
    if(strfront_pic != nil)
    {
        [dicpush setObject:strfront_pic forKey:@"front_pic"];
    }
    else
    {
        iimagetype = 1;
    }
    int iimagetype1 = 0;
    if(strback_pic != nil)
    {
        [dicpush setObject:strback_pic forKey:@"back_pic"];
    }
    else
    {
        iimagetype1 = 1;
    }
    
    
    ////
    if(_iseditnumber)
    {
        
        OrderShopInfoModel *shopInfoModeltemp= arrshopinfoMOdel[0];
        OrderGoodsInfoModel *goodsInfoModeltemp = shopInfoModeltemp.arrgoods[0];
        [dicpush setObject:goodsInfoModeltemp.did forKey:@"id"];
        [dicpush setObject:[NSString stringWithFormat:@"%d",goodsInfoModeltemp.iselectnumber] forKey:@"num"];
        if(strpindanid==nil || strpindanid.length<1)
        {
            
        }
        else
        {
            [dicpush setObject:strpindanid forKey:@"pindanid"];
        }
        
        [dicpush setObject:goodsInfoModeltemp.goodsdetail_id forKey:@"goodsdetailid"];
        
    }
    
    
    
    [dicpush setObject:@"appstore" forKey:@"channel"];
    
    if(couponmodel!= nil)
    {
        [dicpush setObject:couponmodel.did forKey:@"couponid"];
    }
    
    if(_iscanyupintuan==YES || isxianhuoedit == YES)
    {///参与拼团
        [self getOrder:dicpush];
    }
    else
    {///不是参与拼团
        if(iimagetype == 0 && iimagetype1 == 0)
        {
            [self getOrder:dicpush];
        }
        else
        {
            NSMutableArray *arrimagepush = [NSMutableArray new];
            if(iimagetype==1)
            {
                UIImage *image0 = arrsfimage[0];
                [arrimagepush addObject:[self imgcutsuo:image0 andsize:CGSizeMake(image0.size.width, image0.size.height)]];
            }
            if(iimagetype1==1)
            {
                UIImage *image1 = arrsfimage1[0];
                [arrimagepush addObject:[self imgcutsuo:image1 andsize:CGSizeMake(image1.size.width, image1.size.height)]];
            }
            [self setUserInteractionEnabled:NO];
            
            [dataControl requestqiniuImageDataInView:self dicpush:arrimagepush Callback:^(NSError *error, BOOL state, NSString *describle) {
                [self setUserInteractionEnabled:YES];
                if(state)
                {
                    if(dataControl.arrqiniu.count != arrimagepush.count)
                    {
                        [MDB_UserDefault showNotifyHUDwithtext:@"身份证上传失败" inView:self];
                        return;
                    }
                    if(arrimagepush.count == 1)
                    {
                        if(iimagetype == 1)
                        {
                            [dicpush setObject:dataControl.arrqiniu[0] forKey:@"front_pic"];
                            strfront_pic = dataControl.arrqiniu[0];
                            
                            
                            
                        }
                        else
                        {
                            [dicpush setObject:dataControl.arrqiniu[0] forKey:@"back_pic"];
                            strback_pic = dataControl.arrqiniu[0];
                        }
                    }
                    else
                    {
                        [dicpush setObject:dataControl.arrqiniu[0] forKey:@"front_pic"];
                        [dicpush setObject:dataControl.arrqiniu[1] forKey:@"back_pic"];
                        strfront_pic = dataControl.arrqiniu[0];
                        strback_pic = dataControl.arrqiniu[1];
                    }
                    
                    
                    [self getOrder:dicpush];
                    
                }
                else
                {
                    [MDB_UserDefault showNotifyHUDwithtext:describle inView:self];
                }
                
            }];
        }
    }
}

///对图片进行缩
-(UIImage *)imgcutsuo:(UIImage *)image andsize:(CGSize)size
{
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)getOrder:(NSDictionary *)dicpush
{
    
    [dataControl requestXiaDanDataInView:self dicpush:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
        
        NSLog(@"%@",dataControl.dicXiaDan);
        if(state)
        {
            if(_iseditnumber)
            {
                strdingdanhao = [NSString stringWithFormat:@"%@",[dataControl.dicXiaDan objectForKey:@"orderno"]];
                strdingdanid = [NSString stringWithFormat:@"%@",[dataControl.dicXiaDan objectForKey:@"order_id"]];
            }
            else
            {
                arrordernumbers = [dataControl.dicXiaDan objectForKey:@"ordernos"];
                arrorderids = [dataControl.dicXiaDan objectForKey:@"orderids"];
            }
            
            
            DaiGouZhiFuViewController *dvc = [[DaiGouZhiFuViewController alloc] init];
            dvc.strorderid = strdingdanhao;
            dvc.strdid = strdingdanid;
            dvc.arrordernumbers = arrordernumbers;
            dvc.arrorderids = arrorderids;
//            float fdikousuifei = [self dikoumoneyCount];
//
//            NSString *strkuaidi = arrkuaidiMoney[btnowkuaidi.tag];
            NSString *strprice = @"";
            
            float fallprice = 0.0;
            float fgoodsprice = [self getallGoodsPrice];
            
            @try {
                NSString *strkuaidi = @"0";
                if(arrkuaidiMoney.count>btnowkuaidi.tag)
                {
                    strkuaidi = arrkuaidiMoney[btnowkuaidi.tag];
                }
                else
                {
                    strkuaidi = @"0";
                }
                
                float fdikousuifei = [self dikoumoneyCount];
                [lbdikoumoney setText:[NSString stringWithFormat:@"￥%.2lf",fdikousuifei]];
                
                
                fallprice+=fgoodsprice;
                
                fallprice+=strkuaidi.floatValue-fdikousuifei;
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
            if(couponmodel!=nil)
            {
                float allgoodstemp = [self getallGoodsPriceNotsf];
                if(allgoodstemp > couponmodel.denomination.floatValue)
                {
                    fallprice = fallprice-couponmodel.denomination.floatValue;
                }
                else
                {
                    fallprice = fallprice-allgoodstemp;
                    
                }
                if(fallprice<0)
                {
                    fallprice = 0.0;
                }
            }
            
            fallprice+=fallprice*ffeilv;
            
            strprice = [NSString stringWithFormat:@"%.2lf",fallprice];
            dvc.strprice =  strprice;
            dvc.is_deduction = isdikoumoney;
            [self.viewController.navigationController pushViewController:dvc animated:YES];
            ischange = NO;
            
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self];
        }
    }];
}

#pragma mark - UIScrollView
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [beiZuTextView resignFirstResponder];
    [fieldSFNumber resignFirstResponder];
}

#pragma mark - UITextView
- (void)textViewDidChange:(UITextView *)textView
{
    if(textView.tag!=111)
    {
        UILabel *lb = [beiZuTextView viewWithTag:22];
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

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if(textView.tag==111)
    {
        if ([[URL scheme] isEqualToString:@"changjianwenti"]) {
            DaiGouGuiZheViewController *dvc = [[DaiGouGuiZheViewController alloc] init];
            dvc.strtitle = @"常见问题解答";
            dvc.strurl = WenZheng_ALL_rol;
            NSMutableDictionary *dicpush = [NSMutableDictionary new];
            [dicpush setObject:@"strategy" forKey:@"key"];
            dvc.dicpush = dicpush;
            [self.viewController.navigationController pushViewController:dvc animated:YES];
            return NO;
        }
    }
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction
{
    if(textView.tag==111)
    {
        if ([[URL scheme] isEqualToString:@"changjianwenti"]) {
            DaiGouGuiZheViewController *dvc = [[DaiGouGuiZheViewController alloc] init];
            dvc.strtitle = @"常见问题解答";
            dvc.strurl = WenZheng_ALL_rol;
            NSMutableDictionary *dicpush = [NSMutableDictionary new];
            [dicpush setObject:@"strategy" forKey:@"key"];
            dvc.dicpush = dicpush;
            [self.viewController.navigationController pushViewController:dvc animated:YES];
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - 地址点击返回
-(void)addressSelectItem:(id)value
{
    addressmodel = value;
    [viewaddress removeFromSuperview];
    
    
    if(strsfname!= nil)
    {
        if(![addressmodel.strname isEqualToString:strsfname])
        {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"身份证图片必须与收货人一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alter show];
        }
    }
    
    float ftop = viewaddress.top;
    viewaddress = nil;
    viewaddress = [self drawAddress:CGRectMake(0, ftop, scvback.width, 50) andvalue:addressmodel];
    [scvback addSubview:viewaddress];
    [self uploadLoca];
    
    ////需要获取快递的价格
    [self getExpressValue:addressmodel.strid];
    
    ///
    [self getUserMessage:addressmodel.strname];
}

///删除item
-(void)addressDelItem:(id)value
{
    //    NSString *straddressid = value;
    
    addressmodel = nil;
    [viewaddress removeFromSuperview];
    float ftop = viewaddress.top;
    viewaddress = nil;
    viewaddress = [self drawAddress:CGRectMake(0, ftop, scvback.width, 50) andvalue:addressmodel];
    [scvback addSubview:viewaddress];
    [self uploadLoca];
}

#pragma mark - 获取快递费用
-(void)getExpressValue:(NSString *)straddressid
{
    
    if(straddressid.length<1)return;
    
    
    
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken] forKey:@"userkey"];
    [dicpush setObject:straddressid forKey:@"addressid"];

    NSMutableArray *arrexpressid = [NSMutableArray new];
    for(NSDictionary *dic in arrExpress)
    {
        [arrexpressid addObject:[dic objectForKey:@"id"]];
    }
    [dicpush setObject:arrexpressid forKey:@"expressid"];
    
    if(_iseditnumber)
    {
        OrderShopInfoModel *shopInfoModeltemp= arrshopinfoMOdel[0];
        OrderGoodsInfoModel *goodsInfoModeltemp = shopInfoModeltemp.arrgoods[0];
        [dicpush setObject:goodsInfoModeltemp.did forKey:@"id"];
        [dicpush setObject:[NSString stringWithFormat:@"%d",goodsInfoModeltemp.iselectnumber] forKey:@"num"];
        
    }
    
    
    [dataControl requestExpressDataInView:self dicpush:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
        if(state)
        {
            //            NSLog(@"%@",dataControl.arrExrequest);
            
            if(arrExpress.count == dataControl.arrExrequest.count)
            {
                NSMutableArray *arrvalue = [NSMutableArray new];
                arrkuaidiMoney = [NSMutableArray new];
                for(int i = 0 ; i < arrExpress.count; i++)
                {
                    NSDictionary *dic = arrExpress[i];
                    [arrvalue addObject:[NSString stringWithFormat:@"%@(￥%@)",[dic objectForKey:@"name"],dataControl.arrExrequest[i]]];
                    [arrkuaidiMoney addObject:dataControl.arrExrequest[i]];
                }
                [viewKuaiDi removeFromSuperview];
                viewKuaiDi = [self drawKuaiDi:CGRectMake(0, viewGoodsMessage.bottom+10, viewGoodsMessage.width, 45) andarrtitle:arrvalue];
                [scvback addSubview:viewKuaiDi];
                [self uploadLoca];
                [self setShowAllPrice];
                
            }
            else
            {
                [MDB_UserDefault showNotifyHUDwithtext:@"数据错误" inView:self];
            }
            
        }
        else
        {
//            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self];
        }
        
        
    }];
    
}

#pragma mark - 获取身份证信息
-(void)getUserMessage:(NSString *)truename
{
    if(_iscanyupintuan==YES || isxianhuoedit == YES )return;
    if(truename.length<1)return;
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken] forKey:@"userkey"];
    [dicpush setObject:truename forKey:@"truename"];
    
    [dataControl requestUserInfoDataInView:self dicpush:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
        if(state)
        {
            NSLog(@"%@",dataControl.dicUserInfo);
            
            dicUserInfo = dataControl.dicUserInfo;
            if(dicUserInfo.count == 3)
            {
                strsfIdCoard = [NSString nullToString:[dicUserInfo objectForKey:@"idcard"]];
                [fieldSFNumber setText:strsfIdCoard];
                
                strfront_pic = [dicUserInfo objectForKey:@"front_pic"];
                strback_pic = [dicUserInfo objectForKey:@"back_pic"];
                arrsfimage = [NSMutableArray new];
                [arrsfimage addObject:strfront_pic];
                arrsfimage1 = [NSMutableArray new];
                [arrsfimage1 addObject:strback_pic];
                
                CGRect rect = viewShenFen.frame;
                [viewShenFen removeFromSuperview];
                viewShenFen = nil;
                viewShenFen = [self drawShenFen:rect andvalue:arrsfimage];
                [scvback addSubview:viewShenFen];
                
            }
            else
            {
                @try {
                    strsfIdCoard = [NSString nullToString:[dicUserInfo objectForKey:@"idcard"]];
                } @catch (NSException *exception) {
                    
                } @finally {
                    
                }
                
                [fieldSFNumber setText:@""];
                
                arrsfimage = [NSMutableArray new];
                arrsfimage1 = [NSMutableArray new];
                
                CGRect rect = viewShenFen.frame;
                [viewShenFen removeFromSuperview];
                viewShenFen = nil;
                viewShenFen = [self drawShenFen:rect andvalue:nil];
                [scvback addSubview:viewShenFen];
            }
            
            [self uploadLoca];
        }
        else
        {
//            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self];
        }
    }];
    
    
}

-(void)setShowAllPrice
{
    
    float fallprice = 0.0;
    float fgoodsprice = [self getallGoodsPrice];
    
    @try {
        NSString *strkuaidi = @"0";
        if(arrkuaidiMoney.count>btnowkuaidi.tag)
        {
            strkuaidi = arrkuaidiMoney[btnowkuaidi.tag];
        }
        else
        {
            strkuaidi = @"0";
        }
        
        float fdikousuifei = [self dikoumoneyCount];
        [lbdikoumoney setText:[NSString stringWithFormat:@"￥%.2lf",fdikousuifei]];
        
        
        fallprice+=fgoodsprice;
        
        fallprice+=strkuaidi.floatValue-fdikousuifei;
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    if(couponmodel!=nil)
    {
        float allgoodstemp = [self getallGoodsPriceNotsf];
        if(allgoodstemp > couponmodel.denomination.floatValue)
        {
            fallprice = fallprice-couponmodel.denomination.floatValue;
        }
        else
        {
            fallprice = fallprice-allgoodstemp;
            
        }
        if(fallprice<0)
        {
            fallprice = 0.0;
        }
    }
    
    
    [lbprice setText:[NSString stringWithFormat:@"￥%.2lf",fallprice+fallprice*ffeilv]];
    [lbshouxufei setText:[NSString stringWithFormat:@"（支付平台手续费%.2lf元）",fallprice*ffeilv]];
    
}


#pragma mark - UITextField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@""])
    {
        return YES;
    }
    if(textField.tag == 1110)
    {
        if(textField.text.length>=18 && ![string isEqualToString:@""] && [self inputShouldLetterOrNum:string] == YES)
        {
            [textField setText:[NSString stringWithFormat:@"%@%@",[textField.text substringToIndex:17],string]];
            return NO;
        }
        else if (textField.text.length == 17 && ![string isEqualToString:@""] && [self inputShouldLetterOrNum:string] == YES) {
            // 如果是17位，并通过前17位计算出18位为X，自动补全，并返回NO，禁止编辑。
            textField.text = [NSString stringWithFormat:@"%@%@", textField.text, string];
            return NO;
        }
        
        if([self inputShouldLetterOrNum:string] == NO)
        {
            return NO;
        }
        
        
    }
    
    return YES;
}

- (BOOL)inputShouldLetterOrNum:(NSString *)inputString {
    if (inputString.length == 0) return NO;
    NSString *regex =@"[a-zA-Z0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:inputString];
}


#pragma mark - 数量发生改变
-(void)DaiGouXiaDanGoodsNumChange
{
    
    MyGoodsCouponModel *modeltemp=nil;
    int i = 0;
    float fgoodsprice = [self getallGoodsPrice];
    float fallprice = [self getallGoodsPriceNotsf];
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a=[dat timeIntervalSince1970];
    
    ///可用的优惠券
    NSMutableArray *arryhqtemp = [NSMutableArray new];
    ///不可用的优惠券
    NSMutableArray *arrgqyhqtemp = [NSMutableArray new];
    
    for(MyGoodsCouponModel *model in arruseablecoupons)
    {
        if(model.usecondition.floatValue<= fallprice && model.denomination.floatValue<= fallprice && a<model.use_endtime.floatValue)
        {
            [arryhqtemp addObject:model];
        }
        else
        {
            [arrgqyhqtemp addObject:model];
        }
    }
    if(arryhqtemp.count>0)
    {
        modeltemp = arryhqtemp[0];
    }
    [arryhqtemp addObjectsFromArray:arrgqyhqtemp];
    
    arruseablecoupons = arryhqtemp;
    
    inomoselectuseab = 0;
    if(modeltemp==nil)
    {
        inomoselectuseab = -1;
    }
    
//    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
//
//    NSTimeInterval a=[dat timeIntervalSince1970];
//    for(MyGoodsCouponModel *model in arruseablecoupons)
//    {
//        if(model.usecondition.floatValue<= fallprice && model.denomination.floatValue<= fallprice && a<model.use_endtime.floatValue)
//        {
//            modeltemp = model;
//            break;
//        }
//        i++;
//    }
//    couponmodel = modeltemp;
//    inomoselectuseab = i;
//    if(couponmodel==nil)
//    {
//        inomoselectuseab = -1;
//    }
    if(couponmodel!=nil)
    {
        [lbyouhuimoney setText:[NSString nullToString:[NSString stringWithFormat:@"￥%@",couponmodel.denomination]]];
    }
    else
    {
        [lbyouhuimoney setText:@"暂无可用"];
    }
    
    if(_iseditnumber)
    {
        [self getExpressValue:addressmodel.strid];
    }
    
    
    [self setShowAllPrice];
}

#pragma mark - lbtop移动
-(void)toptimer:(NSTimer *)timer
{
    
    UILabel *lb = timer.userInfo;
    
    if(lb.right>0)
    {
        [lb setRight:lb.right-1];
    }
    else
    {
        [lb setLeft:self.width];
    }
}


-(void)dealloc
{
    [toptimer invalidate];
    toptimer = nil;
    
}

@end
