//
//  ShopMainTableViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/18.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "ShopMainTableViewController.h"

#import "DaiGouHomeTableViewCell.h"

#import "ShopMainDataController.h"

#import <MJRefresh.h>

#import "ProductInfoViewController.h"

#import "MDBEmptyView.h"

#import "MDB_UserDefault.h"
#import "VKLoginViewController.h"
#import "SelectColorAndSizeView.h"

@interface ShopMainTableViewController ()<DaiGouHomeTableViewCellDelegate,UIAlertViewDelegate,SelectColorAndSizeViewDelegate>
{
    ShopMainDataController *dataControl;
    int ipage;
    
    NSMutableArray *arrlistData;
    
    ///代购商品id
    NSString *strdaigaouid;
    
    
    SelectColorAndSizeView *ggView;
    
    
}
@property (nonatomic, strong) MDBEmptyView *emptyView;

@end

@implementation ShopMainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(_strshopname == nil)
    {
        _strshopname = @"店铺";
    }
    self.title = _strshopname;
    [self setSubview];
    
    dataControl = [[ShopMainDataController alloc] init];
    ipage = 1;
    arrlistData = [NSMutableArray new];
    [self bindData];
    
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
    [dataControl requestDGHomeListDataInView:self.view Line:ipage site_id:_strshopid Callback:^(NSError *error, BOOL state, NSString *describle) {
        if(ipage==1)
        {
            [arrlistData removeAllObjects];
        }
        if(dataControl.arrListData.count>0)
        {
            for(NSDictionary *dic in dataControl.arrListData)
            {
                [arrlistData addObject:[DaiGouHomeListModel viewModelWithSubject:dic]];
            }
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if(arrlistData.count>0)
        {
            [self.emptyView setHidden:YES];
        }
        else
        {
            [self.emptyView setHidden:NO];
        }
    }];
    
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrlistData.count;
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
    cell.model = arrlistData[indexPath.row];
    cell.ishidden = YES;
    [cell setDelegate:self];
    
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
    NSLog(@"列表点击");
    
    NSMutableArray *arrbldj = [[NSUserDefaults standardUserDefaults] objectForKey:@"baoliaoyidianji"];
    NSMutableArray *arrtemps = [NSMutableArray new];
    [arrtemps addObjectsFromArray:arrbldj];
    BOOL isbool = [arrtemps containsObject: [NSString stringWithFormat:@"%@", model.share_id]];
    if(isbool==NO)
    {
        if(arrtemps.count>=200)
        {
            [arrtemps removeLastObject];
        }
        
        [arrtemps insertObject:[NSString stringWithFormat:@"%@",model.share_id] atIndex:0];
        
    }
    [[NSUserDefaults standardUserDefaults] setObject:arrtemps forKey:@"baoliaoyidianji"];
    [tableView reloadData];
    
    
}

-(void)DaiGouHomeTableViewCellAddGouWuChe:(DaiGouHomeListModel *)model
{
    
    strdaigaouid = model.dgID;
    if(model.isspiderorder.integerValue==1)
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
        [self.view.window addSubview:svc];
        [svc showView];
        ggView = svc;
    }
    else
    {
        [self gouwucheView:strdaigaouid andgoodsdetailid:@"" andnum:@"1"];
    }
    //    [self gouwucheView:model.dgID];
    
    
    
}


#pragma mark - SelectColorAndSizeViewDelegate
///添加购物车
-(void)addGouWuChe:(NSString *)strid andnum:(NSString *)strnum;
{
    [self gouwucheView:strdaigaouid andgoodsdetailid:strid andnum:strnum];
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
    
    [dataControl requestAddBuCarDataLine:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
        if(state)
        {
            [ggView dismisAction];
            //动画
//            UIImageView *imgvtemp = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//            [imgvtemp setImage:[UIImage imageNamed:@"addgouwuche_remu"]];
//            [imgvtemp setCenter:CGPointMake(self.view.width/2.0, self.view.height/2.0)];
//            [self.view addSubview:imgvtemp];
//            [UIView animateWithDuration:0.5 animations:^{
//                [imgvtemp setWidth:1];
//                [imgvtemp setHeight:1];
//                [imgvtemp setTop:10];
//                [imgvtemp setRight:self.view.width-20];
//                
//                
//            } completion:^(BOOL finished) {
//                [imgvtemp removeFromSuperview];
//                
//            }];
            [MDB_UserDefault showNotifyHUDwithtext:@"购物车添加成功" inView:self.view.window];
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view.window];
        }
    }];
    
    
}
/*
-(void)gouwucheView:(NSString *)strid
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
    
    if(strid==nil)return;
    
    NSDictionary *dicpush = @{@"id":strid,@"num":@"1",@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    
    [dataControl requestAddBuCarDataLine:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
        if(state)
        {
            //动画
            UIImageView *imgvtemp = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
            [imgvtemp setImage:[UIImage imageNamed:@"addgouwuche_remu"]];
            [imgvtemp setCenter:CGPointMake(self.view.width/2.0, self.view.height/2.0)];
            [self.view.window addSubview:imgvtemp];
            [UIView animateWithDuration:0.5 animations:^{
                [imgvtemp setWidth:1];
                [imgvtemp setHeight:1];
                [imgvtemp setTop:10];
                [imgvtemp setRight:self.view.width-20];
                
                
            } completion:^(BOOL finished) {
                [imgvtemp removeFromSuperview];
                
            }];
            
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view.window];
        }
    }];
    
    
}
*/

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

#pragma mark - UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0 && alertView.tag == 110) {
        VKLoginViewController *vkVc = [[VKLoginViewController alloc] init];
        [self.navigationController pushViewController:vkVc animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
