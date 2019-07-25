//
//  DaiGouHomeView.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/28.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "DaiGouHomeView.h"

#import "ImagePlayerView.h"
#import <UMAnalytics/MobClick.h>

#import "DaiGouHomeTableViewCell.h"

#import "DaiGouBannerHotView.h"

#import "JinRiPinDanListViewController.h"

#import "DaiGouReMenShopViewController.h"

#import "DaiGouGongLueViewController.h"

#import "DaiGouHomeDataController.h"

#import "MDB_UserDefault.h"

#import <MJRefresh/MJRefresh.h>

#import "ShopMainTableViewController.h"
#import "ProductInfoViewController.h"

#import "SVModalWebViewController.h"

#import "OriginalDetailViewController.h"

#import "MyOrderMainViewController.h"

#import "VKLoginViewController.h"

#import "SelectColorAndSizeView.h"

#import "DaiGouKuaiJieDaoHangVuew.h"

#import "DaiGouFenLeiTableViewController.h"

#import "DaiGouPaiHangBangTableViewController.h"

@interface DaiGouHomeView()<UITableViewDelegate,UITableViewDataSource,ImagePlayerViewDelegate,UIAlertViewDelegate,DaiGouHomeTableViewCellDelegate,SelectColorAndSizeViewDelegate,DaiGouKuaiJieDaoHangVuewDelegate>
{
    
    NSDictionary *dicValue;
    ///滚动图
    NSMutableArray *arrbannerData;
    ///直邮商家
    NSMutableArray *arrzhiyouData;
    ///他们都在拼改成你可能也喜欢
    NSMutableArray *arrtamendData;
    
    ///现货区
    NSMutableArray *arrxianhuoData;
    
    NSMutableArray *arrListData;
    
    int ipage;
    
    NSTimer *listTimer;
    BOOL islistTimer;
    
    float flastscroll;
    
    ///代购商品id
    NSString *strdaigaouid;
    
    
    SelectColorAndSizeView *ggView;
    
    DaiGouKuaiJieDaoHangVuew *kjdhview;
    
}
@property (nonatomic ,strong) UITableView *tabView;
@property (nonatomic ,strong) ImagePlayerView *imagePlayerView;

@property (nonatomic , retain) UIButton *btdaohang;

@property (nonatomic ,retain) DaiGouHomeDataController *dataControl;
@property (nonatomic , retain) UIButton *btzhiding;

@end

@implementation DaiGouHomeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
        ipage = 1;
        arrListData = [NSMutableArray new];
        _dataControl = [[DaiGouHomeDataController alloc] init];
        [self bindData];
        [self bindListData];
    }
    return self;
}


-(void)setupSubViews
{
    [self setBackgroundColor:[UIColor whiteColor]];
    _tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [_tabView setDelegate:self];
    [_tabView setDataSource:self];
    [_tabView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addSubview:_tabView];
    self.tabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ipage = 1;
        [self bindData];
        [self bindListData];
    }];
    self.tabView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        ipage++;
        [self bindListData];
        
    }];
    
    
    _btdaohang = [[UIButton alloc] initWithFrame:CGRectMake(0, self.height/2.0-20, 50*kScale, 45*kScale)];
    [_btdaohang.layer setMasksToBounds:YES];
    [_btdaohang.layer setCornerRadius:4];
    [_btdaohang.layer setBorderColor:RGBAlpha(200, 200, 200, 0.7).CGColor];
    [_btdaohang.layer setBorderWidth:1];
    [_btdaohang setBackgroundColor:[UIColor whiteColor]];
    [_btdaohang setRight:self.width+4];
    [self addSubview:_btdaohang];
//    [_btdaohang setImage:[UIImage imageNamed:@"daigou_home_myorder"] forState:UIControlStateNormal];
    [_btdaohang setTitle:@"快捷\n导航" forState:UIControlStateNormal];
    [_btdaohang.titleLabel setNumberOfLines:2];
    [_btdaohang setTitleColor:RGB(50, 50, 50) forState:UIControlStateNormal];
    [_btdaohang.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [_btdaohang addTarget:self action:@selector(daohangAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    _btzhiding = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50*kScale, 50*kScale)];
    [_btzhiding.layer setMasksToBounds:YES];
    [_btzhiding.layer setCornerRadius:_btzhiding.height/2.0];
    [_btzhiding setRight:BOUNDS_WIDTH-10];
    [_btzhiding setBottom:self.size.height-50];
    [_btzhiding setImage:[UIImage imageNamed:@"zhiding_list"] forState:UIControlStateNormal];
    [_btzhiding setBackgroundColor:RGB(248, 248, 248)];
    [self addSubview:_btzhiding];
    [_btzhiding addTarget:self action:@selector(topScrollAction) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)topScrollAction
{
    [_tabView setContentOffset:CGPointMake(0, 0)];
}

-(void)loadListTimeData
{
    if(islistTimer==YES)
    {
        [_tabView setContentOffset:CGPointMake(0, 0) animated:YES];
        ipage = 1;
        [self bindData];
        [self bindListData];
        
    }
    
}

-(void)timerListAction
{
    
    islistTimer = YES;
}

-(void)bindData
{
    [_dataControl requestDGHomeDataInView:self Callback:^(NSError *error, BOOL state, NSString *describle) {
       
        dicValue = _dataControl.resultDict;
        
        [self drawTabviewHeader];
    }];
    
    
    
}

#pragma mark - 列表数据
-(void)bindListData
{
    ////还需要修改
    NSString *strlastid = @"";
    if(arrListData.count>0 && ipage>1)
    {
        DaiGouHomeListModel *model = arrListData.lastObject;
        strlastid = model.share_id;
    }
    
    
    [_dataControl requestDGHomeListDataLine:ipage lastid:strlastid Callback:^(NSError *error, BOOL state, NSString *describle) {
        
        if(ipage==1)
        {
            [listTimer timeInterval];
            listTimer = nil;
            [arrListData removeAllObjects];
            listTimer = [NSTimer scheduledTimerWithTimeInterval:600 target:self selector:@selector(timerListAction) userInfo:nil repeats:NO];
            islistTimer = NO;
        }
        if(_dataControl.arrListData.count>0)
        {
            for(NSDictionary *dic in _dataControl.arrListData)
            {
                [arrListData addObject:[DaiGouHomeListModel viewModelWithSubject:dic]];
            }
        }
        [_tabView reloadData];
        [_tabView.mj_header endRefreshing];
        [_tabView.mj_footer endRefreshing];
    }];
    
}



-(void)drawTabviewHeader
{
    
    [self.tabView setTableHeaderView:nil];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, 500)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    
    if([[dicValue objectForKey:@"channel_banner"] isKindOfClass:[NSArray class]])
    {
        arrbannerData = [dicValue objectForKey:@"channel_banner"];
    }
    if(arrbannerData.count>0)
    {
        ///banner
        _imagePlayerView=[[ImagePlayerView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenW,kMainScreenW*0.4)];
        [headerView addSubview:_imagePlayerView];
        _imagePlayerView.backgroundColor = [UIColor grayColor];
        [_imagePlayerView setDelagateCount:arrbannerData.count delegate:self];
        
        
        ////当前最热
        DaiGouBannerHotView *hotview = [[DaiGouBannerHotView alloc] initWithFrame:CGRectMake(10, 10, 180, 40)];
        [headerView addSubview:hotview];
        _timer = hotview.timer;
        if([[dicValue objectForKey:@"channel_banner_notice"] isKindOfClass:[NSArray class]])
        {
            NSMutableArray *arrnotice = [dicValue objectForKey:@"channel_banner_notice"];
            [hotview setArrData:arrnotice];
            [hotview timeAction];
            if(arrnotice.count>0)
            {
                [hotview setHidden:NO];
            }
            else
            {
                [hotview setHidden:YES];
            }
            
        }
        else
        {
            [hotview setHidden:YES];
        }
    }
    
    
    ///item
    NSArray *arritemimage = [NSArray arrayWithObjects:@"daigou_jinripindan",@"daigou_remenshangjia",@"daigou_daigougonglue",@"daigou_fenleiother", nil];
    NSArray *arritemcolor = [NSArray arrayWithObjects:RGB(223,124,134),RGB(117,186,238),RGB(186,153,208),RGB(242,180,84), nil];
    NSArray *arritemtitle = [NSArray arrayWithObjects:@"个护美妆",@"服饰鞋包",@"钟表镜饰",@"其他", nil];
    float fitewidth = (headerView.width)/4.0;
    float fbottom = _imagePlayerView.bottom;
    
    
    UIView *viewfenleiback = [[UIView alloc] initWithFrame:CGRectMake(0, _imagePlayerView.bottom, headerView.width, fitewidth*0.75)];
    [viewfenleiback setBackgroundColor:[UIColor whiteColor]];
    [headerView addSubview:viewfenleiback];
    
    UIView *viewfenlei = [[UIView alloc] initWithFrame:CGRectMake(0, _imagePlayerView.bottom, headerView.width, fitewidth*0.75)];
    [viewfenlei setBackgroundColor:[UIColor whiteColor]];
    [headerView addSubview:viewfenlei];
//    // 阴影颜色
//    viewfenlei.layer.shadowColor = [UIColor grayColor].CGColor;
//    // 阴影偏移，默认(0, -3)
//    viewfenlei.layer.shadowOffset = CGSizeMake(0,0);
//    // 阴影透明度，默认0
//    viewfenlei.layer.shadowOpacity = 0.4;
//    // 阴影半径，默认3
//    viewfenlei.layer.shadowRadius = 5;
    
    
    fbottom = viewfenlei.bottom;
    for(int i = 0 ; i < arritemtitle.count; i++)
    {
        
        UIView *viewitem = [self ItemDaiGouItem:CGRectMake((fitewidth)*i, 0, fitewidth, viewfenlei.height) andtitle:arritemtitle[i] andstrimage:arritemimage[i] andtitlecolor:arritemcolor[i]];
        [viewitem setTag:i];
        [viewfenlei addSubview:viewitem];
        
        [viewitem setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapitem = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemHAction:)];
        [viewitem addGestureRecognizer:tapitem];
    }
    
    
    
    if([[dicValue objectForKey:@"four_spot_list"] isKindOfClass:[NSArray class]])
    {
        arrxianhuoData = [dicValue objectForKey:@"four_spot_list"];
    }
    
    ////现货区
    UIView *xianhuoquView = [self xianHuoqu:CGRectMake(0, fbottom+8, headerView.width, 100)];
    [headerView addSubview:xianhuoquView];
    
//    if([[dicValue objectForKey:@"recommend_shop"] isKindOfClass:[NSArray class]])
//    {
//        arrzhiyouData = [dicValue objectForKey:@"recommend_shop"];
//    }
//    ///直邮商家
//    UIView *zysjView = [self zhiYouShangJia:CGRectMake(0, fbottom+8, headerView.width, 100)];
//    [headerView addSubview:zysjView];
    
    
    ////排行榜
    
    UIView *viewpaihangbang = [self paiHangBang:CGRectMake(0, xianhuoquView.bottom+8, headerView.width, 100)];
    [headerView addSubview:viewpaihangbang];
    
    
    ///他们都在拼改成猜你喜欢  four_spell_list
    if([[dicValue objectForKey:@"you_may_like_list"] isKindOfClass:[NSArray class]])
    {
        arrtamendData = [dicValue objectForKey:@"you_may_like_list"];
    }
    ///他们都在拼改成你可能也喜欢
    UIView *tmdzpView = [self taMenDouZaiPin:CGRectMake(0, viewpaihangbang.bottom, headerView.width, 100)];
    [headerView addSubview:tmdzpView];
    
    
    
    ///好物推荐
    UIView *hwtjView = [self haoWuTuiJian:CGRectMake(0, tmdzpView.bottom, headerView.width, 50)];
    [headerView addSubview:hwtjView];
                        
    
    
    [headerView setHeight:hwtjView.bottom];
    [_tabView setTableHeaderView:headerView];
}

#pragma mark - ///当前拼单最热 daigou_banneronItem
-(UIImageView *)drawNowHotPinDan:(CGRect)rect
{
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:rect];
    [imgv setImage:[UIImage imageNamed:@"daigou_banneronItem"]];
    [imgv setContentMode:UIViewContentModeScaleToFill];
    
    
    
    return imgv;
}



#pragma mark - 好物推荐
-(UIView *)haoWuTuiJian:(CGRect)rect
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:RGB(248,248,248)];
    
    UILabel *lbleft = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,100, 44)];
    [lbleft setText:@"好物推荐"];
    [lbleft setTextColor:RGB(243,93,0)];
    [lbleft setTextAlignment:NSTextAlignmentLeft];
    [lbleft setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:lbleft];
    
    UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(0, lbleft.bottom, view.width, 1)];
    [viewline setBackgroundColor:RGB(226,226,226)];
    [view addSubview:viewline];
    
    UIView *viewline1 = [[UIView alloc] initWithFrame:CGRectMake(10, lbleft.bottom-0.5, 50, 1.5)];
    [viewline1 setBackgroundColor:RGB(243,93,0)];
    [view addSubview:viewline1];
    
    [view setHeight:viewline.bottom];
    return view;
}

#pragma mark - ////排行榜
-(UIView *)paiHangBang:(CGRect)rect
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UIImage *image = [UIImage imageNamed:@"daigou_home_paihangbang"];
    
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, view.width-20, image.size.height*(view.width-20)/image.size.width)];
    [imgv setImage:image];
    [view addSubview:imgv];
    
    [view setHeight:imgv.bottom+10];
    
    [view setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapphb= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(panhangbangAction)];
    [view addGestureRecognizer:tapphb];
    
    return view;
}

#pragma mark - /// 现货区
-(UIView *)xianHuoqu:(CGRect)rect
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
 
    UILabel *lbleft = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,60, 44)];
//    [lbleft setText:@"现 货 区"];
    [lbleft setTextColor:RGB(243,93,0)];
    [lbleft setTextAlignment:NSTextAlignmentLeft];
    [lbleft setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:lbleft];
    
    UIView *lbleftte = [[UIView alloc] initWithFrame:CGRectMake(-17, 10,100, 34)];
    [lbleftte setBackgroundColor:RadMenuColor];
//    [lbleftte.layer setMasksToBounds:YES];
    [lbleftte.layer setCornerRadius:lbleftte.height/2.0];
    // 阴影颜色
    lbleftte.layer.shadowColor = [UIColor grayColor].CGColor;
    // 阴影偏移，默认(0, -3)
    lbleftte.layer.shadowOffset = CGSizeMake(0,0);
    // 阴影透明度，默认0
    lbleftte.layer.shadowOpacity = 0.4;
    // 阴影半径，默认3
    lbleftte.layer.shadowRadius = 3;
    [view addSubview:lbleftte];
    
    
    UILabel *lbleftte1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,lbleftte.width, lbleftte.height)];
    [lbleftte1 setText:@"现 货 区"];
    [lbleftte1 setTextColor:[UIColor whiteColor]];
    [lbleftte1 setTextAlignment:NSTextAlignmentCenter];
    [lbleftte1 setFont:[UIFont systemFontOfSize:12]];
    [lbleftte1 setBackgroundColor:[UIColor clearColor]];
    [lbleftte1.layer setMasksToBounds:YES];
    [lbleftte1.layer setCornerRadius:lbleftte1.height/2.0];
    [lbleftte addSubview:lbleftte1];
    
    
    UILabel *lbmore = [[UILabel alloc] initWithFrame:CGRectMake(view.width-70, 0,60, lbleft.height)];
    [lbmore setText:@"更多"];
    [lbmore setTextColor:RGB(153,153,153)];
    [lbmore setTextAlignment:NSTextAlignmentRight];
    [lbmore setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:lbmore];
    [lbmore setUserInteractionEnabled:YES];
    UITapGestureRecognizer *more = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xhmoreAction)];
    [lbmore addGestureRecognizer:more];
    
    UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(10, lbleft.bottom, view.width-20, 1)];
//    [viewline setBackgroundColor:RGB(226,226,226)];
    [view addSubview:viewline];
    
    UIView *viewline1 = [[UIView alloc] initWithFrame:CGRectMake(10, lbleft.bottom-0.5, 65, 1.5)];
//    [viewline1 setBackgroundColor:RGB(243,93,0)];
    [view addSubview:viewline1];
    
    if(arrxianhuoData.count>0)
    {
        UIScrollView *scvValue = [[UIScrollView alloc] initWithFrame:CGRectMake(0, viewline.bottom+10, view.width, 100)];
        [scvValue setShowsHorizontalScrollIndicator:NO];
        [view addSubview:scvValue];
        
        float fwidth = view.width/2.8;
        for(int i = 0 ; i < arrxianhuoData.count; i++)
        {
            UIView *viewitem = [self xianhuoquItem:CGRectMake(10+(fwidth+10)*i, 0, fwidth, 100) andvalue:arrxianhuoData[i]];
            [scvValue addSubview:viewitem];
            [scvValue setHeight:viewitem.height];
            [scvValue setContentSize:CGSizeMake(viewitem.right+10, 0)];
            [viewitem setUserInteractionEnabled:YES];
            [viewitem setTag:i];
            UITapGestureRecognizer *tapitem = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xianhuoAction:)];
            [viewitem addGestureRecognizer:tapitem];
        }
        
        [view setHeight:scvValue.bottom+12];
    }
    else
    {
        [view setHeight:0];
    }
    
    return view;
}

-(UIView *)xianhuoquItem:(CGRect)rect andvalue:(id)value
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view.layer setMasksToBounds:YES];
    [view.layer setCornerRadius:4];
    NSDictionary *dictemp = value;
    
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, view.width-30, view.width-30)];
    [[MDB_UserDefault defaultInstance] setViewWithImage:imgv url:[dictemp objectForKey:@"image"]];
    [view addSubview:imgv];
    [imgv setContentMode:UIViewContentModeScaleAspectFit];
    
    UILabel *lbtitle = [[UILabel alloc] initWithFrame:CGRectMake(5, imgv.bottom+8, view.width-10, 35)];
    [lbtitle setText:[NSString stringWithFormat:@"%@",[dictemp objectForKey:@"title"]]];
    [lbtitle setTextColor:RGB(102,102,102)];
    [lbtitle setTextAlignment:NSTextAlignmentLeft];
    [lbtitle setFont:[UIFont systemFontOfSize:14]];
    [lbtitle setNumberOfLines:2];
    [view addSubview:lbtitle];
    
    UILabel *lbprice = [[UILabel alloc] initWithFrame:CGRectMake(lbtitle.left, lbtitle.bottom, lbtitle.width, 25)];
    [lbprice setText:[NSString stringWithFormat:@"￥%@",[dictemp objectForKey:@"price"]]];
    [lbprice setTextColor:RGB(255,122,0)];
    [lbprice setTextAlignment:NSTextAlignmentLeft];
    [lbprice setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:lbprice];
    
    
    ////加入购物车
    UIButton *btgouwuche = [[UIButton alloc] initWithFrame:CGRectMake(0, 3, 30*kScale, 30*kScale)];
    [btgouwuche setImage:[UIImage imageNamed:@"addgouwuche_remu"] forState:UIControlStateNormal];
    [btgouwuche setRight:view.width-5];
    [btgouwuche addTarget:self action:@selector(gouwuchexhAction:) forControlEvents:UIControlEventTouchUpInside];
    if([[dictemp objectForKey:@"isend"] intValue] == 0)
    {
        [view addSubview:btgouwuche];
    }
    
    
    
    [view setHeight:lbprice.bottom];
    
    return view;
}

#pragma mark -///他们都在拼改成猜你喜欢
-(UIView *)taMenDouZaiPin:(CGRect)rect
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:RGB(248,248,248)];
    
    UILabel *lbleft = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,100, 54)];
    [lbleft setText:@"猜你喜欢"];
    [lbleft setTextColor:RGB(243,93,0)];
    [lbleft setTextAlignment:NSTextAlignmentLeft];
    [lbleft setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:lbleft];
    
//    UILabel *lbmore = [[UILabel alloc] initWithFrame:CGRectMake(view.width-70, 0,60, lbleft.height)];
//    [lbmore setText:@"更多"];
//    [lbmore setTextColor:RGB(153,153,153)];
//    [lbmore setTextAlignment:NSTextAlignmentRight];
//    [lbmore setFont:[UIFont systemFontOfSize:12]];
//    [view addSubview:lbmore];
//    [lbmore setUserInteractionEnabled:YES];
//    UITapGestureRecognizer *more = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreAction)];
//    [lbmore addGestureRecognizer:more];
    
    UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(10, lbleft.bottom, view.width-20, 1)];
    [viewline setBackgroundColor:RGB(226,226,226)];
    [view addSubview:viewline];
    
    UIView *viewline1 = [[UIView alloc] initWithFrame:CGRectMake(10, lbleft.bottom-0.5, 50, 1.5)];
    [viewline1 setBackgroundColor:RGB(243,93,0)];
    [view addSubview:viewline1];
    
    if(arrtamendData.count>0)
    {
        UIScrollView *scvValue = [[UIScrollView alloc] initWithFrame:CGRectMake(0, viewline.bottom+10, view.width, 100)];
        [scvValue setShowsHorizontalScrollIndicator:NO];
        [view addSubview:scvValue];
        
        float fwidth = view.width/2.8;
        for(int i = 0 ; i < arrtamendData.count; i++)
        {
            UIView *viewitem = [self taMenDouZaiPinItem:CGRectMake(10+(fwidth+10)*i, 0, fwidth, 100) andvalue:arrtamendData[i]];
            [scvValue addSubview:viewitem];
            [scvValue setHeight:viewitem.height];
            [scvValue setContentSize:CGSizeMake(viewitem.right+10, 0)];
            [viewitem setUserInteractionEnabled:YES];
            [viewitem setTag:i];
            UITapGestureRecognizer *tapitem = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(douzaiPinAction:)];
            [viewitem addGestureRecognizer:tapitem];
        }
        
        [view setHeight:scvValue.bottom+12];
    }
    else
    {
        [view setClipsToBounds:YES];
        
        [view setHeight:0];
    }
    
    return view;
}

-(UIView *)taMenDouZaiPinItem:(CGRect)rect andvalue:(id)value
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view.layer setMasksToBounds:YES];
    [view.layer setCornerRadius:4];
    NSDictionary *dictemp = value;
    
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, view.width-30, view.width-30)];
    [[MDB_UserDefault defaultInstance] setViewWithImage:imgv url:[dictemp objectForKey:@"image"]];
    [view addSubview:imgv];
    [imgv setContentMode:UIViewContentModeScaleAspectFit];
    
    UILabel *lbtitle = [[UILabel alloc] initWithFrame:CGRectMake(5, imgv.bottom+8, view.width-10, 35)];
    [lbtitle setText:[NSString stringWithFormat:@"%@",[dictemp objectForKey:@"title"]]];
    [lbtitle setTextColor:RGB(102,102,102)];
    [lbtitle setTextAlignment:NSTextAlignmentLeft];
    [lbtitle setFont:[UIFont systemFontOfSize:14]];
    [lbtitle setNumberOfLines:2];
    [view addSubview:lbtitle];
    
    UILabel *lbprice = [[UILabel alloc] initWithFrame:CGRectMake(lbtitle.left, lbtitle.bottom, lbtitle.width, 25)];
    [lbprice setText:[NSString stringWithFormat:@"￥%@",[dictemp objectForKey:@"price"]]];
    [lbprice setTextColor:RGB(255,122,0)];
    [lbprice setTextAlignment:NSTextAlignmentLeft];
    [lbprice setFont:[UIFont systemFontOfSize:13]];
    [view addSubview:lbprice];
    
    NSArray *arrtemp;
    if([[dictemp objectForKey:@"pindanusers"] isKindOfClass:[NSArray class]])
    {
        arrtemp = [dictemp objectForKey:@"pindanusers"];
    }
    
    int ipiccount = (int)arrtemp.count;
    if(ipiccount>3)
    {
        ipiccount = 3;
    }
    
    
    UILabel *lbmessage = [[UILabel alloc] initWithFrame:CGRectMake(lbtitle.left, lbprice.bottom, lbtitle.width, 20)];
    [lbmessage setText:[NSString nullToString:[dictemp objectForKey:@"name"]]];
    [lbmessage setTextColor:RGB(153,153,153)];
    [lbmessage setTextAlignment:NSTextAlignmentLeft];
    [lbmessage setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbmessage];
    
    
    ////加入购物车
    UIButton *btgouwuche = [[UIButton alloc] initWithFrame:CGRectMake(0, 3, 30*kScale, 30*kScale)];
    [btgouwuche setImage:[UIImage imageNamed:@"addgouwuche_remu"] forState:UIControlStateNormal];
    [btgouwuche setRight:view.width-5];
    [btgouwuche addTarget:self action:@selector(gouwucheAction:) forControlEvents:UIControlEventTouchUpInside];
    if([[dictemp objectForKey:@"isend"] intValue] == 0)
    {
        [view addSubview:btgouwuche];
    }
    
    
    [view setHeight:lbmessage.bottom+15];
    
    return view;
}


#pragma mark - 直邮商家
-(UIView *)zhiYouShangJia:(CGRect)rect
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *lbtitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, view.width, 15)];
    [lbtitle setText:@"直邮商家"];
    [lbtitle setTextColor:RGB(102,102,102)];
    [lbtitle setTextAlignment:NSTextAlignmentCenter];
    [lbtitle setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbtitle];
    [lbtitle sizeToFit];
    [lbtitle setHeight:15];
    
    UIImageView *imgvhd = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, lbtitle.height,lbtitle.height)];
    [imgvhd setImage:[UIImage imageNamed:@"daigou_HotShangjia"]];
    [view addSubview:imgvhd];
    [imgvhd setLeft:(view.width-imgvhd.width-lbtitle.width-5)/2.0];
    [lbtitle setLeft:imgvhd.right+5];
    
    
    UIView *viewlineleft = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 1)];
    [viewlineleft setBackgroundColor:RGB(153,153,153)];
    [viewlineleft setCenter:CGPointMake(0, lbtitle.center.y)];
    [viewlineleft setRight:imgvhd.left-10];
    [view addSubview:viewlineleft];
    
    
    UIView *viewlineright = [[UIView alloc] initWithFrame:CGRectMake(lbtitle.right+10, viewlineleft.top, 15, 1)];
    [viewlineright setBackgroundColor:RGB(153,153,153)];
    [view addSubview:viewlineright];
    
    float fbottom = 0.0;
    ////
    for(int i = 0 ; i < arrzhiyouData.count; i++)
    {
        NSDictionary *dic = arrzhiyouData[i];
        UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(10+((view.width-47)/4.0+9)*i, lbtitle.bottom+15, (view.width-47)/4.0, (view.width-47)/4.0*0.73)];
//        [imgv setBackgroundColor:[UIColor brownColor]];
        [imgv.layer setMasksToBounds:YES];
        [imgv.layer setCornerRadius:4];
        [imgv.layer setBorderColor:RGB(226,226,226).CGColor];
        [imgv.layer setBorderWidth:1];
        [imgv setContentMode:UIViewContentModeScaleAspectFit];
        [[MDB_UserDefault defaultInstance] setViewWithImage:imgv url:[dic objectForKey:@"logo1"]];
        [view addSubview:imgv];
        fbottom = imgv.bottom;
        [imgv setUserInteractionEnabled:YES];
        [imgv setTag:i];
        UITapGestureRecognizer *tapzhiyou = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zhiyouShopAction:)];
        [imgv addGestureRecognizer:tapzhiyou];
    }
    
    [view setHeight:fbottom+15];
    
    
    return view;
}


#pragma mark - @"个护美妆",@"服饰鞋包",@"钟表镜饰",@"其他",
-(UIView *)ItemDaiGouItem:(CGRect)rect andtitle:(NSString *)strtitle andstrimage:(NSString*)strimage andtitlecolor:(UIColor *)color
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *imgvicon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.height*0.4, view.height*0.4)];
    [imgvicon setImage:[UIImage imageNamed:strimage]];
    [imgvicon setCenter:CGPointMake(view.width/2.0, 0)];
    [imgvicon.layer setMasksToBounds:YES];
    [imgvicon.layer setCornerRadius:imgvicon.height/2.0];
    [imgvicon setContentMode:UIViewContentModeScaleAspectFit];
    [view addSubview:imgvicon];
    
    UILabel *lbtitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.width, 15)];
    [lbtitle setText:strtitle];
    [lbtitle setTextColor:RGB(30, 30, 30)];//color
    [lbtitle setTextAlignment:NSTextAlignmentCenter];
    [lbtitle setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:lbtitle];
    
    [imgvicon setTop:(view.height-lbtitle.height-imgvicon.height-5)/2.0];
    [lbtitle setTop:imgvicon.bottom+5];
    
    return view;
}

#pragma mark - 快捷导航
-(void)daohangAction
{
    kjdhview = [[DaiGouKuaiJieDaoHangVuew alloc] initWithFrame:CGRectMake(self.width, BOUNDS_HEIGHT/2.0-50*kScale*3, _btdaohang.width, 200)];
    kjdhview.superbt = _btdaohang;
    [kjdhview.layer setMasksToBounds:YES];
    [kjdhview.layer setCornerRadius:4];
    [kjdhview.layer setBorderColor:RGBAlpha(200, 200, 200, 0.7).CGColor];
    [kjdhview.layer setBorderWidth:1];
    [kjdhview setDelegate:self];
    [self addSubview:kjdhview];
    [_btdaohang setHidden:YES];
    
    [UIView animateWithDuration:0.2 animations:^{
        [kjdhview setRight:_btdaohang.right];
    }];
    
}
#pragma mark - @"个护美妆",@"服饰鞋包",@"钟表镜饰",@"其他",
-(void)itemHAction:(UIGestureRecognizer *)gesture
{
    NSArray *arrtitle = @[@"个护美妆",@"服饰鞋包",@"钟表镜饰",@"其他"];
    NSArray *arrtype = @[@"48",@"2",@"55",@"-1"];
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    
    [dicpush setObject:@"20" forKey:@"pagesize"];
    [dicpush setObject:arrtype[gesture.view.tag] forKey:@"type"];
    
    
    [dicpush setObject:[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken] forKey:@"userkey"];
    DaiGouFenLeiTableViewController *dvc = [[DaiGouFenLeiTableViewController alloc] init];
    dvc.strtitle = arrtitle[gesture.view.tag];
    dvc.strurl = MainDaiGouHomeListUrl;
    dvc.dicpush = dicpush;
    dvc.ipost = 1;
    [self.viewController.navigationController pushViewController:dvc animated:YES];
}

#pragma mark - DaiGouKuaiJieDaoHangVuewDelegate
-(void)kuaiJieDaoHangItemAction:(NSInteger )tag
{
    switch (tag) {
        case 0:
        {
            [MobClick event:@"dgchangjianwenti" label:@"代购频道常见问题"];
            DaiGouGongLueViewController *dvc = [[DaiGouGongLueViewController alloc] init];
            
            [self.viewController.navigationController pushViewController:dvc animated:YES];
            
            
        }
            break;
        case 1:
        {
            [MobClick event:@"dgremenshangcheng" label:@"代购频道热门商城"];
            DaiGouReMenShopViewController *dvc = [[DaiGouReMenShopViewController alloc] init];
            
            [self.viewController.navigationController pushViewController:dvc animated:YES];
        }
            break;
        case 2:
        {
            
            [MobClick event:@"dgwodedingdan" label:@"代购频道我的订单"];
            [self myorderAction];
//            JinRiPinDanListViewController *jvc = [[JinRiPinDanListViewController alloc] init];
//
//            [self.viewController.navigationController pushViewController:jvc animated:YES];
            
        }
            break;
//        case 3:
//        {
//            [MobClick event:@"dgwodedingdan" label:@"代购频道我的订单"];
//            [self myorderAction];
//        }
//            break;
        default:
            break;
    }
}

#pragma mark -现货更多
-(void)xhmoreAction
{
    [MobClick event:@"dgxianhuoqu" label:@"代购现货区-更多"];
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken] forKey:@"userkey"];
    DaiGouFenLeiTableViewController *dvc = [[DaiGouFenLeiTableViewController alloc] init];
    dvc.strtitle = @"现货";
    dvc.ishiddenxianhuo = YES;
    dvc.strurl = DaiGouXianHuoListUrl;
    dvc.ipost = 2;
    dvc.isxianhuo = YES;
    dvc.dicpush = dicpush;
    [self.viewController.navigationController pushViewController:dvc animated:YES];
}
#pragma mark - 他们都在拼改成猜你喜欢
-(void)moreAction
{
    JinRiPinDanListViewController *jvc = [[JinRiPinDanListViewController alloc] init];
    
    [self.viewController.navigationController pushViewController:jvc animated:YES];
}
#pragma mark - 排行榜点击
-(void)panhangbangAction
{
    NSLog(@"排行榜点击");
    DaiGouPaiHangBangTableViewController *dvc = [[DaiGouPaiHangBangTableViewController alloc] init];
    [self.viewController.navigationController pushViewController:dvc animated:YES];
}

#pragma mark - 他们都在拼改成猜你喜欢加入购物车
-(void)gouwucheAction:(UIButton *)sender
{
    NSDictionary *dicvalue = arrtamendData[sender.superview.tag];
    
//    DaiGouHomeListModel *model = [DaiGouHomeListModel viewModelWithSubject:dicvalue];
    strdaigaouid = [NSString nullToString:[dicvalue objectForKey:@"goods_id"]];
    
    if([[NSString nullToString:[dicvalue objectForKey:@"isspiderorder"]] intValue] ==1)
    {
        if ([MDB_UserDefault getIsLogin] == NO)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"请登录后再试"
                                                               delegate:self
                                                      cancelButtonTitle:Nil
                                                      otherButtonTitles:@"登录",@"取消", nil];
            [alertView setTag:110];
            [alertView show];
            return;
        }
        
        
        
        NSMutableDictionary *dicinfo = [NSMutableDictionary new];
        [dicinfo setObject:strdaigaouid forKey:@"id"];
        [dicinfo setObject:[NSString nullToString:[dicvalue objectForKey:@"image"]] forKey:@"image"];
        [dicinfo setObject:[NSString nullToString:[dicvalue objectForKey:@"title"]] forKey:@"title"];
        
        SelectColorAndSizeView *svc = [[SelectColorAndSizeView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, kMainScreenH) andvalue:dicinfo andtype:0];
        [svc setDelegate:self];
        [self.window addSubview:svc];
        [svc showView];
        ggView = svc;
    }
    else
    {
        [self gouwucheView:strdaigaouid andgoodsdetailid:@"" andnum:@"1"];
    }
    
}

#pragma mark - 现货加入购物车
-(void)gouwuchexhAction:(UIButton *)sender
{
 
    
    NSDictionary *dicvalue = arrxianhuoData[sender.superview.tag];
    
    //    DaiGouHomeListModel *model = [DaiGouHomeListModel viewModelWithSubject:dicvalue];
    strdaigaouid = [NSString nullToString:[dicvalue objectForKey:@"id"]];
    
    if([[NSString nullToString:[dicvalue objectForKey:@"isspiderorder"]] intValue] ==1)
    {
        if ([MDB_UserDefault getIsLogin] == NO)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"请登录后再试"
                                                               delegate:self
                                                      cancelButtonTitle:Nil
                                                      otherButtonTitles:@"登录",@"取消", nil];
            [alertView setTag:110];
            [alertView show];
            return;
        }
        
        
        
        NSMutableDictionary *dicinfo = [NSMutableDictionary new];
        [dicinfo setObject:strdaigaouid forKey:@"id"];
        [dicinfo setObject:[NSString nullToString:[dicvalue objectForKey:@"image"]] forKey:@"image"];
        [dicinfo setObject:[NSString nullToString:[dicvalue objectForKey:@"title"]] forKey:@"title"];
        
        SelectColorAndSizeView *svc = [[SelectColorAndSizeView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, kMainScreenH) andvalue:dicinfo andtype:0];
        [svc setDelegate:self];
        [self.window addSubview:svc];
        [svc showView];
        ggView = svc;
    }
    else
    {
        [self gouwucheView:strdaigaouid andgoodsdetailid:@"" andnum:@"1"];
    }
    
}


-(void)gouwucheView:(NSString *)strid andgoodsdetailid:(NSString *)goodsdetailid andnum:(NSString *)strnum
{
    
    [MobClick event:@"dgliebiaojiagouwuche" label:@"代购列表加购物车"];
    
    if ([MDB_UserDefault getIsLogin] == NO)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请登录后再试"
                                                           delegate:self
                                                  cancelButtonTitle:Nil
                                                  otherButtonTitles:@"登录",@"取消", nil];
        [alertView setTag:110];
        [alertView show];
        return;
    }
    
    if(strid==nil)return;
    
    NSDictionary *dicpush = @{@"id":strid,@"num":strnum,@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],@"goodsdetailid":goodsdetailid};
    
    [self.dataControl requestAddBuCarDataLine:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
        if(state)
        {
            [ggView dismisAction];
            //动画
            UIImageView *imgvtemp = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
            [imgvtemp setImage:[UIImage imageNamed:@"addgouwuche_remu"]];
            [imgvtemp setCenter:CGPointMake(self.width/2.0, self.height/2.0)];
            [self addSubview:imgvtemp];
            [UIView animateWithDuration:0.5 animations:^{
                [imgvtemp setWidth:1];
                [imgvtemp setHeight:1];
                [imgvtemp setTop:10];
                [imgvtemp setRight:self.width-20];
                
                
            } completion:^(BOOL finished) {
                [imgvtemp removeFromSuperview];
                if(self.delegate)
                {
                    [self.delegate gouwucheadd];
                }
            }];

//            [MDB_UserDefault showNotifyHUDwithtext:@"购物车添加成功" inView:self.window];
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.window];
        }
    }];
    
    
}


#pragma mark - 直邮商家点击
-(void)zhiyouShopAction:(UIGestureRecognizer *)gesture
{
    NSDictionary *dic = arrzhiyouData[gesture.view.tag];
    NSString *strid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    NSLog(@"直邮商家点击");
    ShopMainTableViewController *svc = [[ShopMainTableViewController alloc] init];
    svc.strshopid = strid;
    svc.strshopname = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    [self.viewController.navigationController pushViewController:svc animated:YES];
}

#pragma mark - 他们都在拼改成你可能也喜欢
-(void)douzaiPinAction:(UIGestureRecognizer *)gesture
{
    NSDictionary *dictemp = arrtamendData[gesture.view.tag];
//    NSDictionary *dic = [dictemp objectForKey:@"goods_message"];
    NSString *strid = [NSString stringWithFormat:@"%@",[dictemp objectForKey:@"share_id"]];
    NSLog(@"他们都在拼改成你可能也喜欢点击");
    ProductInfoViewController *pvc = [[ProductInfoViewController alloc] init];
    pvc.productId = strid;
    [self.viewController.navigationController pushViewController:pvc animated:YES];
}
    
    
#pragma mark - 现货
-(void)xianhuoAction:(UIGestureRecognizer *)gesture
{
    NSDictionary *dictemp = arrxianhuoData[gesture.view.tag];
    //    NSDictionary *dic = [dictemp objectForKey:@"goods_message"];
    NSString *strid = [NSString stringWithFormat:@"%@",[dictemp objectForKey:@"share_id"]];
    ProductInfoViewController *pvc = [[ProductInfoViewController alloc] init];
    pvc.productId = strid;
    [self.viewController.navigationController pushViewController:pvc animated:YES];
}


#pragma mark - banaer 设置
- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index
{
    if (arrbannerData.count>index) {
        [[MDB_UserDefault defaultInstance]setViewImageWithURL:[NSURL URLWithString:[NSString nullToString:arrbannerData[index][@"imgurl"]]] placeholder:[UIImage imageNamed:@"Active.jpg"] UIimageview:imageView];
    }
}
- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index
{
    NSLog(@"banner点击");
//    [MobClick event:@"daigou_banner"];
    NSDictionary *bannerInfoDict = arrbannerData[index];
    if ([[NSString nullToString:bannerInfoDict[@"linkType"]] isEqualToString:@"0"]) {
        SVModalWebViewController  *svweb=[[SVModalWebViewController alloc] initWithAddress:[NSString nullToString:bannerInfoDict[@"link"]]];
        svweb.modalTransitionStyle=UIModalTransitionStylePartialCurl;
        [self.viewController presentViewController:svweb animated:NO completion:nil];
    }else if([[NSString nullToString:bannerInfoDict[@"linkType"]] isEqualToString:@"1"]){
        ProductInfoViewController *productInfoVc = [[ProductInfoViewController alloc] init];
        productInfoVc.productId = [NSString nullToString:bannerInfoDict[@"linkId"]];
        [self.viewController.navigationController pushViewController:productInfoVc animated:YES];
    }else if([[NSString nullToString:bannerInfoDict[@"linkType"]] isEqualToString:@"2"]){
        OriginalDetailViewController *shareContVc = [[OriginalDetailViewController alloc] initWithOriginalID:[NSString stringWithFormat:@"%@",bannerInfoDict[@"linkId"]]];
        [self.viewController.navigationController pushViewController:shareContVc animated:YES];
    }
    
    
    
}

#pragma mark - 我的订单
-(void)myorderAction
{
    if (![MDB_UserDefault getIsLogin]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请登录后再试"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"登录",@"取消", nil];
        [alertView setTag:110];
        [alertView show];
        return;
    }
    
    MyOrderMainViewController *mvc = [[MyOrderMainViewController alloc] init];
    
    [self.viewController.navigationController pushViewController:mvc animated:YES];
}

#pragma mark - UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0 && alertView.tag == 110) {
        VKLoginViewController *vkVc = [[VKLoginViewController alloc] init];
        [self.viewController.navigationController pushViewController:vkVc animated:YES];
    }
}

#pragma mark - UITableView

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y<flastscroll)
    {
        [_btzhiding setBottom:self.height-60];
    }
    else
    {
        [_btzhiding setBottom:self.height+60];
    }
    flastscroll = scrollView.contentOffset.y;
    
    
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(_btdaohang.hidden==YES)
    {
        
        [kjdhview sousuoAction];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrListData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strcell = @"DaiGouHomeTableViewCell";
    DaiGouHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strcell];
    if(!cell)
    {
        cell = [[DaiGouHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strcell];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.model = arrListData[indexPath.row];
    cell.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DaiGouHomeListModel *model = arrListData[indexPath.row];
    
    ProductInfoViewController *pvc = [[ProductInfoViewController alloc] init];
    pvc.productId = model.share_id;
    [self.viewController.navigationController pushViewController:pvc animated:YES];
    
    
    
    NSMutableArray *arrbldj = [[NSUserDefaults standardUserDefaults] objectForKey:@"baoliaoyidianji"];
    NSMutableArray *arrtemp = [NSMutableArray new];
    [arrtemp addObjectsFromArray:arrbldj];
    BOOL isbool = [arrtemp containsObject: [NSString stringWithFormat:@"%@", model.share_id]];
    if(isbool==NO)
    {
        if(arrtemp.count>=200)
        {
            [arrtemp removeLastObject];
        }
        
        [arrtemp insertObject:[NSString stringWithFormat:@"%@",model.share_id] atIndex:0];
        
    }
    [[NSUserDefaults standardUserDefaults] setObject:arrtemp forKey:@"baoliaoyidianji"];
    [tableView reloadData];
    
}
////加入购物车
-(void)DaiGouHomeTableViewCellAddGouWuChe:(DaiGouHomeListModel *)model
{
    strdaigaouid = model.dgID;
    if(model.isspiderorder.integerValue == 1)
    {
        
        if ([MDB_UserDefault getIsLogin] == NO)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"请登录后再试"
                                                               delegate:self
                                                      cancelButtonTitle:Nil
                                                      otherButtonTitles:@"登录",@"取消", nil];
            [alertView setTag:110];
            [alertView show];
            return;
        }
        NSMutableDictionary *dicinfo = [NSMutableDictionary new];
        [dicinfo setObject:model.dgID forKey:@"id"];
        [dicinfo setObject:model.image forKey:@"image"];
        [dicinfo setObject:model.title forKey:@"title"];
        
        SelectColorAndSizeView *svc = [[SelectColorAndSizeView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, kMainScreenH) andvalue:dicinfo andtype:0];
        [svc setDelegate:self];
        [self.window addSubview:svc];
        [svc showView];
        ggView = svc;
    }
    else
    {
        [self gouwucheView:strdaigaouid andgoodsdetailid:@"" andnum:@"1"];
        
        
    }
    
    
}

#pragma mark - SelectColorAndSizeViewDelegate
///添加购物车
-(void)addGouWuChe:(NSString *)strid andnum:(NSString *)strnum;
{
    [self gouwucheView:strdaigaouid andgoodsdetailid:strid andnum:strnum];
}

-(void)dealloc
{
    [_timer invalidate];
}

@end
