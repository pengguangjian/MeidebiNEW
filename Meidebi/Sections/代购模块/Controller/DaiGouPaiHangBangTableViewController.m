//
//  DaiGouPaiHangBangTableViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/4/16.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import "DaiGouPaiHangBangTableViewController.h"
#import <MJRefresh.h>

#import "ProductInfoViewController.h"

#import "MDB_UserDefault.h"

#import "VKLoginViewController.h"

#import "SelectColorAndSizeView.h"

#import "MDBEmptyView.h"

#import "DaiGouPaiHangBangTableViewCell.h"

#import "JinRiPinDanListDataController.h"

#import "GoodsCarViewController.h"

@interface DaiGouPaiHangBangTableViewController ()<DaiGouHomeTableViewCellDelegate,SelectColorAndSizeViewDelegate>
{
    JinRiPinDanListDataController *dataControl;
    int ipage;
    
    NSMutableArray *arrlistData;
    
    
    NSString *strlasttimetitle;
    
    SelectColorAndSizeView *ggView;
    NSString *strdaigaouid;
}
@property (nonatomic , retain)MDBEmptyView *emptyView;
@end

@implementation DaiGouPaiHangBangTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"排行榜";
    [self setSubview];
    dataControl = [[JinRiPinDanListDataController alloc] init];
    ipage = 1;
    arrlistData = [NSMutableArray new];
    [self bindData];
    
    [self emptyView];
    
}

-(void)setSubview
{
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ipage = 1;
        [self bindData];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        ipage++;
        [self bindData];
        
    }];
}

-(void)bindData
{
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:[NSString stringWithFormat:@"%d",ipage] forKey:@"page"];
    [dataControl requestdgpaihangbangInView:self.view pushvalue:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
        
        if(ipage==1)
        {
            arrlistData = [NSMutableArray new];
        }
        if(dataControl.arrdgpaihangbangData.count>0)
        {
            for(NSDictionary *dic in dataControl.arrdgpaihangbangData)
            {
                DaiGouHomeListModel *model = [DaiGouHomeListModel viewModelWithSubject:dic];
                [arrlistData addObject:model];
                
            }
        }
        
        if(arrlistData.count>0)
        {
            [_emptyView setHidden:YES];
        }
        else
        {
            [_emptyView setHidden:NO];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
    
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrlistData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *strcell = @"DaiGouPaiHangBangTableViewCell";
    DaiGouPaiHangBangTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strcell];
    if(!cell)
    {
        cell = [[DaiGouPaiHangBangTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strcell];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.model = arrlistData[indexPath.row];
    cell.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    DaiGouHomeListModel *model = arrlistData[indexPath.row];
    ProductInfoViewController *pvc = [[ProductInfoViewController alloc] init];
    pvc.productId = model.share_id;
    [self.navigationController pushViewController:pvc animated:YES];
    NSLog(@"点击");
    
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

-(void)DaiGouHomeTableViewCellAddGouWuChe:(DaiGouHomeListModel *)model
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
    
    if(model.dgID==nil)return;
    
    strdaigaouid = model.dgID;
    
    if(model.isspiderorder.integerValue==1)
    {
        NSMutableDictionary *dicinfo = [NSMutableDictionary new];
        [dicinfo setObject:model.dgID forKey:@"id"];
        [dicinfo setObject:model.image forKey:@"image"];
        [dicinfo setObject:model.title forKey:@"title"];
        
        SelectColorAndSizeView *svc = [[SelectColorAndSizeView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, kMainScreenH) andvalue:dicinfo andtype:0];
        [svc setDelegate:self];
        [self.view.window addSubview:svc];
        [svc showView];
        ggView = svc;
    }
    else
    {
        [self addGouWuChe:@"" andnum:@"1"];
    }
    
    
    
    
    
}
#pragma mark - SelectColorAndSizeViewDelegate
///购买商品
-(void)buyGoods:(NSString *)strid andnum:(NSString *)strnum
{
}
///修改购物车规格
-(void)changeGouWuChe:(NSString *)strid andcartid:(NSString *)strcartid
{
}
///添加购物车
-(void)addGouWuChe:(NSString *)strid andnum:(NSString *)strnum;
{
    [MobClick event:@"dgliebiaojiagouwuche" label:@"代购列表加购物车"];
    NSDictionary *dicpush = @{@"id":strdaigaouid,@"num":strnum,@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],@"goodsdetailid":strid};
    
    [dataControl requestAddBuCarDataLine:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
        if(state)
        {
            [ggView dismisAction];
            [MDB_UserDefault showNotifyHUDwithtext:@"购物车添加成功" inView:self.view.window];
            
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view.window];
        }
    }];
}


#pragma mark - UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0 && alertView.tag == 110) {
        VKLoginViewController *vkVc = [[VKLoginViewController alloc] init];
        [self.navigationController pushViewController:vkVc animated:YES];
    }
}



- (MDBEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[MDBEmptyView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, kMainScreenH-50)];
        [self.view addSubview:_emptyView];
        _emptyView.remindStr = @"暂无相关数据哦～";
        _emptyView.hidden = YES;
    }
    return _emptyView;
}


@end
