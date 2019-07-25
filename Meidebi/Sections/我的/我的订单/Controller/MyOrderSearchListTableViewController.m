//
//  MyOrderSearchListTableViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/4/16.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import "MyOrderSearchListTableViewController.h"

#import "MyOrderTableViewCell.h"

#import "OrderDetaileViewController.h"

#import "MyOrderMainDataController.h"

#import "MDB_UserDefault.h"

#import "OrderRefundViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>

#import <MJRefresh.h>
#import "MDBEmptyView.h"

#import "UIImage+Extensions.h"

#import "OrderRefundViewController.h"

#import "OrderLogisticsViewController.h"

#import "DaiGouZhiFuViewController.h"
#import "Qqshare.h"

@interface MyOrderSearchListTableViewController ()<UIAlertViewDelegate,UIActionSheetDelegate>
{
    
    NSMutableArray *arrdata;
    
    MyOrderMainDataController *dataControl;
    
    int ipage;
    
    
    NSString *strcellSelectID;
    int innumshare2 ;
    
    BOOL isotherEdit;
    
}
@property (nonatomic, strong) MDBEmptyView *emptyView;

@end

@implementation MyOrderSearchListTableViewController
-(id)initWithStyle:(UITableViewStyle)style
{
    if(self = [super initWithStyle:UITableViewStyleGrouped])
    {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索结果";
    [self setNavBarBackBtn];
    
    innumshare2 = 1;
    ipage = 1;
    [self setdatacontrol];
    [self loadData];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ipage = 1;
        [self loadData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        ipage++;
        [self loadData];
    }];
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    
}

- (void)setNavBarBackBtn{
    
    UIButton* btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame = CGRectMake(0,0,44,44);
    [btnLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_click.png"] forState:UIControlStateHighlighted];
    [btnLeft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnLeft addTarget:self action:@selector(doClickBackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
//    UIButton* btnright1 = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
//    [btnright1 setImage:[UIImage imageNamed:@"daigousuosuohui"] forState:UIControlStateNormal];
//    [btnright1 setImage:[UIImage imageNamed:@"daigousuosuohui"] forState:UIControlStateHighlighted];
//    [btnright1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
//    [btnright1 addTarget:self action:@selector(rightanvAction) forControlEvents:UIControlEventTouchUpInside];
//    [btnright1 setTag:2];
//    UIBarButtonItem* rightBarButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:btnright1];
//    
//    self.navigationItem.rightBarButtonItems = @[rightBarButtonItem1];
}

-(void)doClickBackAction
{
    if(isotherEdit)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"orderlistchange"];
    }
    NSArray *arrvc = self.navigationController.viewControllers;
    if(arrvc.count>2)
    {
        UIViewController *vc = arrvc[arrvc.count-3];
        [self.navigationController popToViewController:vc animated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

//-(void)rightanvAction
//{
//    if(isotherEdit)
//    {
//        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"orderlistchange"];
//    }
//    [self.navigationController popViewControllerAnimated:YES];
//}



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"++++");
    if(arrdata!= nil)
    {
        
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"orderlistchange"] isEqualToString:@"1"])
        {
            isotherEdit = YES;
            ipage = 1;
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"orderlistchange"];
            [self loadData];
        }
    }
}

-(void)setdatacontrol
{
    if(dataControl==nil)
    {
        dataControl = [[MyOrderMainDataController alloc] init];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrdata.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MyOrderMainModel *model = arrdata[section];
    return model.goodsinfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *strcell = @"MyOrderTableViewCell";
    MyOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strcell];
    if(!cell)
    {
        cell = [[MyOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strcell];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    MyOrderMainModel *model = arrdata[indexPath.section];
    
    @try
    {
        cell.model = model.goodsinfo[indexPath.row];
    }
    @catch (NSException *exc)
    {
        
    }
    @finally
    {
        
    }
    
    
    if(indexPath.row>=model.goodsinfo.count-1)
    {
        cell.islast=YES;
    }
    else
    {
        cell.islast=NO;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    MyOrderMainModel *model = arrdata[section];
    if(model.daigoutype.integerValue == 2)
    {
        return 140;
    }
    else
    {
        return 100;
    }
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 40)];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    MyOrderMainModel *model = arrdata[section];
    
    UILabel *lbshop = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kMainScreenW-150, 40)];
    [lbshop setTextColor:RadMenuColor];
    [lbshop setTextAlignment:NSTextAlignmentLeft];
    [lbshop setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbshop];
    [lbshop setText:model.name];
    
    UILabel *lbstate = [[UILabel alloc] initWithFrame:CGRectMake(view.width-110, 0, 100, lbshop.height)];
    [lbstate setTextColor:RGB(153,153,153)];
    [lbstate setTextAlignment:NSTextAlignmentRight];
    [lbstate setFont:[UIFont systemFontOfSize:13]];
    [view addSubview:lbstate];
    if([model.status intValue] == 0)
    {
        [lbstate setText:@"待付款"];
    }
    else if([model.status intValue] == 1)
    {
        [lbstate setText:@"未成团"];
    }
    else if([model.status intValue] == 2)
    {
        [lbstate setText:@"待下单"];
    }
    else if([model.status intValue] == 3)
    {
        [lbstate setText:@"待发货"];
    }
    else if([model.status intValue] == 4)
    {
        [lbstate setText:@"已发货"];
    }
    else if([model.status intValue] == 5)
    {
        [lbstate setText:@"已完成"];
    }
    else if([model.status intValue] == 10)
    {
        [lbstate setText:@"已取消"];
    }
    
    
    UIView *viewline0 = [[UIView alloc] initWithFrame:CGRectMake(0, lbstate.bottom, view.width, 1)];
    [viewline0 setBackgroundColor:RGB(236,236,236)];
    [view addSubview:viewline0];
    
    return view;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    MyOrderMainModel *model = arrdata[section];
    float ftemp = 0.0;
    if(model.daigoutype.integerValue == 2)
    {
        ftemp = 140;
    }
    else
    {
        ftemp = 100;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, ftemp)];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    
    
    UILabel *lbmessage = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, view.width-20, 40)];
    [lbmessage setTextColor:RGB(153,153,153)];
    [lbmessage setTextAlignment:NSTextAlignmentLeft];
    [lbmessage setNumberOfLines:2];
    [lbmessage setFont:[UIFont systemFontOfSize:13]];
    [view addSubview:lbmessage];
    int itemp = 0;
    for(MyOrderGoodsModel *modeltemp in model.goodsinfo)
    {
        itemp+=modeltemp.num.intValue;
    }
    [lbmessage setText:[NSString stringWithFormat:@"共计%d件商品，合计￥%@",itemp,model.totalprice]];
    
    
    
    UIButton *btleft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [btleft.layer setMasksToBounds:YES];
    [btleft.layer setCornerRadius:2];
    [btleft.layer setBorderColor:RGB(187,187,187).CGColor];
    [btleft.layer setBorderWidth:1];
    [btleft setTitle:@"" forState:UIControlStateNormal];
    [btleft setTitleColor:RGB(102,102,102) forState:UIControlStateNormal];
    [btleft.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:btleft];
    [btleft setTag:section];
    [btleft addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btright = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [btright.layer setMasksToBounds:YES];
    [btright.layer setCornerRadius:2];
    [btright.layer setBorderColor:RGB(187,187,187).CGColor];
    [btright.layer setBorderWidth:1];
    [btright setTitle:@"" forState:UIControlStateNormal];
    [btright setTitleColor:RGB(102,102,102) forState:UIControlStateNormal];
    [btright.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [btright setTag:section];
    [view addSubview:btright];
    [btright addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if(model.daigoutype.integerValue == 2)
    {
        
        /////
        float fleft = 10;
        for(int i = 0 ; i < model.userimg.count; i++)
        {
            if(i>=4)break;
            UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24*kScale, 24*kScale)];
            [imgv setLeft:10+(imgv.width+2)*i];
            [imgv.layer setMasksToBounds:YES];
            [imgv.layer setCornerRadius:imgv.height/2.0];
            [imgv setCenterY:20];
            fleft = imgv.right;
            [[MDB_UserDefault defaultInstance] setViewWithImage:imgv url:model.userimg[i]];
            [view addSubview:imgv];
        }
        
        UILabel *lblitpeople = [[UILabel alloc] initWithFrame:CGRectMake(fleft+5, 5, 150, 30)];
        [lblitpeople setTextColor:RGB(243,93,0)];
        [lblitpeople setTextAlignment:NSTextAlignmentLeft];
        [lblitpeople setFont:[UIFont systemFontOfSize:12]];
        [view addSubview:lblitpeople];
        [lblitpeople setText:[NSString stringWithFormat:@""]];
        if ([model.status intValue] > 0)
        {
            if(model.remain_pindannum.intValue > 0)
            {
                [lblitpeople setText:[NSString stringWithFormat:@"差%@件",model.remain_pindannum]];
            }
            
        }
        [lbmessage setTop:40];
        
        if([model.status intValue] == 0)
        {
            [btright setFrame:CGRectMake(0, lbmessage.bottom, 66, 30)];
            [btright setTitle:@"立即付款" forState:UIControlStateNormal];
            [btright setRight:view.width-10];
            
            [btleft setFrame:CGRectMake(0, btright.top, 66, btright.height)];
            [btleft setTitle:@"取消订单" forState:UIControlStateNormal];
            [btleft setRight:btright.left-10];
        }
        else if ([model.status intValue] == 1)
        {
            [btright setFrame:CGRectMake(0, lbmessage.bottom, 66, 30)];
            [btright setTitle:@"邀请好友" forState:UIControlStateNormal];
            [btright setRight:view.width-10];
            
            [btleft setFrame:CGRectMake(0, btright.top, 66, 0)];
            [btleft setTitle:@"" forState:UIControlStateNormal];
            [btleft setRight:btright.left-10];
        }
        else if([model.status intValue] == 4)
        {
            [btright setFrame:CGRectMake(0, lbmessage.bottom, 66, 30)];
            [btright setTitle:@"确认收货" forState:UIControlStateNormal];
            [btright setRight:view.width-10];
            
            [btleft setFrame:CGRectMake(0, btright.top, 66, btright.height)];
            [btleft setTitle:@"查看物流" forState:UIControlStateNormal];
            [btleft setRight:btright.left-10];
        }
        else if([model.status intValue] == 10)
        {
            [btright setFrame:CGRectMake(0, lbmessage.bottom, 66, 30)];
            [btright setTitle:@"删除订单" forState:UIControlStateNormal];
            [btright setRight:view.width-10];
            
            [btleft setFrame:CGRectMake(0, btright.top, 66, 0)];
            [btleft setTitle:@"" forState:UIControlStateNormal];
            [btleft setRight:btright.left-10];
        }
        else
        {
            [btright setFrame:CGRectMake(0, lbmessage.bottom, 66, 30)];
            [btright setTitle:@"查看详情" forState:UIControlStateNormal];
            [btright setRight:view.width-10];
            
            [btleft setFrame:CGRectMake(0, btright.top, 66, 0)];
            [btleft setTitle:@"" forState:UIControlStateNormal];
            [btleft setRight:btright.left-10];
        }
        
        
    }
    else
    {
        if([model.status intValue] == 0)
        {
            [btright setFrame:CGRectMake(0, lbmessage.bottom, 66, 30)];
            [btright setTitle:@"立即付款" forState:UIControlStateNormal];
            [btright setRight:view.width-10];
            
            [btleft setFrame:CGRectMake(0, btright.top, 66, btright.height)];
            [btleft setTitle:@"取消订单" forState:UIControlStateNormal];
            [btleft setRight:btright.left-10];
        }
        else if([model.status intValue] == 2)
        {
            [btright setFrame:CGRectMake(0, lbmessage.bottom, 66, 30)];
            [btright setTitle:@"查看详情" forState:UIControlStateNormal];
            [btright setRight:view.width-10];
            
            [btleft setFrame:CGRectMake(0, btright.top, 66, 0)];
            [btleft setTitle:@"" forState:UIControlStateNormal];
            [btleft setRight:btright.left-10];
        }
        else if([model.status intValue] == 4)
        {
            [btright setFrame:CGRectMake(0, lbmessage.bottom, 66, 30)];
            [btright setTitle:@"确认收货" forState:UIControlStateNormal];
            [btright setRight:view.width-10];
            
            [btleft setFrame:CGRectMake(0, btright.top, 66, btright.height)];
            [btleft setTitle:@"查看物流" forState:UIControlStateNormal];
            [btleft setRight:btright.left-10];
        }
        else if([model.status intValue] == 10)
        {
            [btright setFrame:CGRectMake(0, lbmessage.bottom, 66, 30)];
            [btright setTitle:@"删除订单" forState:UIControlStateNormal];
            [btright setRight:view.width-10];
            
            [btleft setFrame:CGRectMake(0, btright.top, 66, 0)];
            [btleft setTitle:@"" forState:UIControlStateNormal];
            [btleft setRight:btright.left-10];
        }
        else
        {
            
            [btright setFrame:CGRectMake(0, lbmessage.bottom, 66, 30)];
            [btright setTitle:@"查看详情" forState:UIControlStateNormal];
            [btright setRight:view.width-10];
            
            [btleft setFrame:CGRectMake(0, btright.top, 66, 0)];
            [btleft setTitle:@"" forState:UIControlStateNormal];
            [btleft setRight:btright.left-10];
        }
    }
    
    UILabel *lbtuikuanstate = [[UILabel alloc] initWithFrame:CGRectZero];
    [lbtuikuanstate setTextColor:RGB(243,93,0)];
    [lbtuikuanstate setTextAlignment:NSTextAlignmentRight];
    [lbtuikuanstate setFont:[UIFont systemFontOfSize:10]];
    [view addSubview:lbtuikuanstate];
    [lbtuikuanstate setFrame:CGRectMake(0, btright.bottom, 100, 15)];
    [lbtuikuanstate setRight:view.width-10];
    [lbtuikuanstate setHidden:NO];
    [lbtuikuanstate setText:@""];
    if(model.refundstatus.intValue == 0)
    {///0无退款
        [lbtuikuanstate setHidden:YES];
        [lbtuikuanstate setText:@""];
    }
    else if(model.refundstatus.intValue == 1)
    {//1标记退款（待退款）
        [lbtuikuanstate setText:@"待退款"];
    }
    else if(model.refundstatus.intValue == 2)
    {///2退款中(预留，计划任务退款则用)
        [lbtuikuanstate setText:@"退款中"];
    }
    else if(model.refundstatus.intValue == 3)
    {//3退款成功
        [lbtuikuanstate setText:@"退款成功"];
    }
    else if(model.refundstatus.intValue == 4)
    {///4退款失败
        //            [lbtuikuanstate setText:@"退款失败"];
        [lbtuikuanstate setText:@"退款中"];
    }
    ///部分退款信息
    if([NSString nullToString:model.re_status].length>0)
    {
        [lbtuikuanstate setHidden:NO];
        [lbtuikuanstate setText:model.re_status];
    }
    ///订单异常信息
    if([NSString nullToString:model.accident_xpln].length>0)
    {
        [lbtuikuanstate setHidden:NO];
        [lbtuikuanstate setText:@"订单异常"];///model.accident_xpln
    }
    
    UIView *viewline1 = [[UIView alloc] initWithFrame:CGRectZero];
    [viewline1 setBackgroundColor:RGB(236,236,236)];
    [view addSubview:viewline1];
    [viewline1 setFrame:CGRectMake(0, view.height-10, view.width, 10)];
    [view addSubview:viewline1];
    
    return view;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyOrderMainModel *model = arrdata[indexPath.section];
    OrderDetaileViewController *ovc = [[OrderDetaileViewController alloc] init];
    ovc.strid = model.did;
    ovc.strorderno = model.orderon;
    [self.navigationController pushViewController:ovc animated:YES];
    
}
#pragma mark - 0立即付款 1邀请好友 4确认收货 10删除订单
-(void)rightAction:(UIButton *)sender
{
    MyOrderMainModel *_model = arrdata[sender.tag];
    switch (_model.status.intValue) {
        case 0:
        {
            DaiGouZhiFuViewController *dvc = [[DaiGouZhiFuViewController alloc] init];
            dvc.strorderid = _model.orderon;
            dvc.strgoodsid = _model.goods_id;
            dvc.strdid = _model.did;
            dvc.strprice = _model.totalprice;
            [self.navigationController pushViewController:dvc animated:YES];
        }
            break;
        case 1:
        {
            [self cellRefAction:@"1" andorderid:_model.did];
        }
            break;
        case 4:
        {
            [self cellRefAction:@"4" andorderid:_model.did];
        }
            break;
        case 10:
        {
            [self cellRefAction:@"10" andorderid:_model.did];
        }
            break;
        default:
        {
            OrderDetaileViewController *ovc = [[OrderDetaileViewController alloc] init];
            ovc.strid = _model.did;
            [self.navigationController pushViewController:ovc animated:YES];
        }
            break;
    }
    
}

#pragma mark -0取消订单 4查看物流
-(void)leftAction:(UIButton *)sender
{
    MyOrderMainModel *_model = arrdata[sender.tag];
    if(_model.status.intValue == 0)
    {
        
        [self cellRefAction:@"0" andorderid:_model.did];
        
    }
    else if (_model.status.intValue == 4)
    {
        OrderLogisticsViewController *ovc = [[OrderLogisticsViewController alloc] init];
        ovc.strorder_id = _model.did;
        [self.navigationController pushViewController:ovc animated:YES];
    }
    
    
}
- (void)setSpecialType:(NSString *)specialType{
    _specialType = specialType;
    [self.tableView reloadData];
    ipage = 1;
//    [self loadData];
}

-(void)loadData
{
    [self setdatacontrol];
    NSDictionary *dicpush = @{@"page":[NSNumber numberWithInt:ipage],
                              @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                              @"type":@"",
                              @"keywords":[NSString nullToString:_keywords]
                              };
    
    
    [dataControl requestDGHomeDataInView:self.view.window dicpush:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
        NSLog(@"%@",dataControl.arrrequest);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if(ipage==1)
        {
            arrdata = [NSMutableArray new];
        }
        
        for(NSDictionary *dic in dataControl.arrrequest)
        {
            [arrdata addObject:[MyOrderMainModel binddata:dic]];
        }
        [self.tableView reloadData];
        if(arrdata.count>0)
        {
            [self.emptyView setHidden:YES];
        }
        else{
            [self.emptyView setHidden:NO];
        }
    }];
    
}

-(void)cellRefAction:(NSString *)strtype andorderid:(NSString *)strid
{
    strcellSelectID = strid;
    if(strtype.intValue == 0)
    {
        if(dataControl.arrcancleReason == nil)
        {
            
            [dataControl requestCancleOrderReasonDataInView:self.view.window dicpush:@{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]} Callback:^(NSError *error, BOOL state, NSString *describle) {
                
                if(state)
                {
                    NSLog(@"%@",dataControl.arrcancleReason);
                    UIActionSheet *ashat = [[UIActionSheet alloc] initWithTitle:@"取消订单原因" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
                    for(NSDictionary *dic in dataControl.arrcancleReason)
                    {
                        [ashat addButtonWithTitle:[NSString nullToString:[dic objectForKey:@"content"]]];
                    }
                    [ashat addButtonWithTitle:@"其他"];
                    [ashat showInView:self.view];
                }
                else
                {
                    [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view.window];
                }
                
            }];
        }
        else
        {
            UIActionSheet *ashat = [[UIActionSheet alloc] initWithTitle:@"取消订单原因" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
            for(NSDictionary *dic in dataControl.arrcancleReason)
            {
                [ashat addButtonWithTitle:[dic objectForKey:@"content"]];
            }
            [ashat addButtonWithTitle:@"其他"];
            [ashat showInView:self.view];
            
        }
        
        
    }
    else if (strtype.intValue == 1)
    {///邀请好友
        //1、创建分享参数（必要）
        
        MyOrderMainModel *model;
        MyOrderGoodsModel *modelgoods;
        for(MyOrderMainModel *teo in arrdata)
        {
            if([teo.did isEqualToString:strid])
            {
                model = teo;
                break;
            }
        }
        if(model==nil)
        {
            return;
        }
        
        @try
        {
            modelgoods = model.goodsinfo[0];
        }
        @catch (NSException *exc)
        {
            
        }
        @finally
        {
            
        }
        if(modelgoods==nil)return;
        
        if(model.share_id)
        {
            [dataControl requestShareSubjectDataWithCommodityid:model.share_id inView:self.view callback:^(NSError *error, BOOL state, NSString *describle) {
                Qqshare *share = dataControl.resultShareInfo;
                if (share)
                {
                    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
                    [[MDB_UserDefault defaultInstance] setViewWithImage:imgv url:modelgoods.image];
                    
                    
                    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                    
                    UIImage *images=[imgv.image imageByScalingProportionallyToSize:CGSizeMake(120.0, 120.0)];
                    if(images==nil)
                    {
                        images=[UIImage imageNamed:@"pucdNot.png"];
                    }
                    
                    imgv = nil;
                    
                    
                    NSArray* imageArray = images==nil?@[]:@[images];
                    
                    NSString *strtitle = [NSString stringWithFormat:@"代购价￥%@，%@",modelgoods.spprice, modelgoods.title];
                    
                    NSString *strcontent = [NSString nullToString:[NSString stringWithFormat:@"代购价￥%@", modelgoods.spprice]];
                    if(model.userimg > 0)
                    {
                        strcontent = [NSString nullToString:[NSString stringWithFormat:@"还差%@件成团", model.remain_pindannum]];
                        strtitle = [NSString stringWithFormat:@"拼单价￥%@，%@",modelgoods.spprice, modelgoods.title];
                    }
                    
                    [shareParams SSDKSetupShareParamsByText:strcontent
                                                     images:imageArray
                                                        url:[NSURL URLWithString:model.link]
                                                      title:strtitle
                                                       type:SSDKContentTypeAuto];
                    
                    NSString *strimageurl =modelgoods.image;
                    if(strimageurl.length>6)
                    {
                        [shareParams SSDKSetupSinaWeiboShareParamsByText:strcontent title:nil image:strimageurl url:[NSURL URLWithString:model.link] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
                    }
                    else
                    {
                        [shareParams SSDKSetupSinaWeiboShareParamsByText:strcontent title:nil image:images url:[NSURL URLWithString:model.link] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
                    }
                    
                    
                    NSString *shareWeChatTitle = strtitle;
                    [shareParams SSDKSetupWeChatParamsByText:strcontent title:shareWeChatTitle url:[NSURL URLWithString:model.link] thumbImage:nil image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
                    
                    if(share.applet_url.length>6)
                    {
                        
                        if([[MDB_UserDefault defaultInstance] imagediskImageExistsForURL:share.image])
                        {
                            images = [[MDB_UserDefault defaultInstance] getImageExistsForURL:share.image];
                        }
                        else
                        {
                            images = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:share.image]]];
                            [[MDB_UserDefault defaultInstance] setSaveImageToCache:images forURL:[NSURL URLWithString:share.image]];
                        }
                        
                        
                        images=[images imageByScalingProportionallyToSize:CGSizeMake(images.size.width, images.size.width/4*3)];//
                        if(UIImagePNGRepresentation(images).length>36720)
                        {
                            images=[images imageByScalingProportionallyToSize:CGSizeMake(images.size.width*0.8, images.size.height*0.8)];
                        }
                        ////小程序分享  需要判断是否需要分享小程序
                        [shareParams SSDKSetupWeChatParamsByTitle:shareWeChatTitle description:share.qqsharecontent webpageUrl:[NSURL URLWithString:share.url] path:share.applet_url thumbImage:images userName:WXXiaoChengXuID forPlatformSubType:SSDKPlatformSubTypeWechatSession];
                    }
                    
                    //2、分享
                    [ShareSDK showShareActionSheet:self.view
                                             items:nil
                                       shareParams:shareParams
                               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                                   //                           [self.dataController requestShareRecordDataWithUrl:share.url callback:^(NSError *error, BOOL state, NSString *describle) {
                                   //                           }];
                                   NSLog(@"sdfasdf");
                               }];
                }
                else
                {
                    if(innumshare2==1)
                    {
                        [self cellRefAction:strtype andorderid:strid];
                        innumshare2=2;
                    }
                    
                }
                
            }];
        }
        
    }
    else if (strtype.intValue == 4)
    {///4确认收货
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确定收货" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alter.tag = 102;
        [alter show];
        
        
    }
    else if (strtype.intValue == 10)
    {///10删除订单
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否要删除该订单" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alter.tag = 103;
        [alter show];
    }
}

#pragma mark - UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if((alertView.tag == 101))
    {
        if(buttonIndex  == 1)
        {
            UITextField *fieldReason = [alertView textFieldAtIndex:0];
            
            NSDictionary *dicpush = @{@"reason":fieldReason.text,
                                      @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                                      @"order_id":strcellSelectID
                                      };
            [dataControl requestCancleOrderDataInView:self.view dicpush:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
                if(state)
                {
                    [self loadData];
                    isotherEdit = YES;
                }
                [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
                
            }];
        }
        
    }
    else if (alertView.tag == 102)
    {
        if(buttonIndex  == 1)
        {
            NSDictionary *dicpush = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                                      @"order_id":strcellSelectID
                                      };
            [dataControl requestShouHuoOrderDataInView:self.view dicpush:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
                if(state)
                {
                    MyOrderMainModel *model;
                    for(MyOrderMainModel *teo in arrdata)
                    {
                        if([teo.did isEqualToString:strcellSelectID])
                        {
                            model = teo;
                            model.status = @"5";
                            break;
                        }
                    }
                    [self.tableView reloadData];
                    isotherEdit = YES;
                    [self loadData];
                }
                [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
            }];
        }
        
    }
    else if (alertView.tag == 103)
    {
        if(buttonIndex  == 1)
        {
            NSDictionary *dicpush = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                                      @"order_id":strcellSelectID
                                      };
            
            [dataControl requestDelOrderDataInView:self.view dicpush:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
                
                if(state)
                {
                    [self loadData];
                    isotherEdit = YES;
                }
                else
                {
                    [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
                }
                
            }];
        }
    }
    
}


#pragma mark - UIActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)return;
    if(buttonIndex == dataControl.arrcancleReason.count+1)
    {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"取消订单原因" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alter.alertViewStyle = UIAlertViewStylePlainTextInput;
        alter.tag = 101;
        [alter show];
        
    }
    else
    {
        NSDictionary *dic = dataControl.arrcancleReason[buttonIndex-1];
        NSDictionary *dicpush = @{@"reason":[dic objectForKey:@"content"],
                                  @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                                  @"order_id":strcellSelectID
                                  };
        [dataControl requestCancleOrderDataInView:self.view.window dicpush:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
            if(state)
            {
                [self loadData];
                isotherEdit = YES;
            }
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view.window];
            
        }];
    }
}

#pragma mark - getter / setter

- (MDBEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[MDBEmptyView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, kMainScreenH-50)];
        [self.tableView addSubview:_emptyView];
        _emptyView.remindStr = @"暂时还没有数据哦～";
        _emptyView.hidden = YES;
    }
    return _emptyView;
}
 

@end
