//
//  WoGuanZhuTableViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/3/26.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import "WoGuanZhuTableViewController.h"
#import <MJRefresh.h>
#import "MDB_UserDefault.h"
#import "WoGuanZhuGoodsTableViewCell.h"

#import "WoGuangZhuShopTableViewCell.h"
#import "WoGuanZhuBiaoQianTableViewCell.h"
#import "WoGuanZhuPeopleTableViewCell.h"
#import "WoGuanZhuDataController.h"
#import "JiangJiaTongZhiModel.h"
#import "MDBEmptyView.h"

#import "ProductInfoViewController.h"
#import "PersonalInfoIndexViewController.h"

#import "SearchMainViewController.h"
#import "WoGuanZhuBiaoQianSearchListTableViewController.h"

@interface WoGuanZhuTableViewController ()<UIAlertViewDelegate,WoGuanZhuDelegate>
{
    WoGuanZhuDataController *datacontrol;
    int ipage;
    NSMutableArray *arrdata;
    
    id modelinfo;
    
}
@property (nonatomic, strong) MDBEmptyView *emptyView;

@end

@implementation WoGuanZhuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ipage = 1;
    
    datacontrol = [WoGuanZhuDataController new];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ipage = 1;
        [self loadData];
    }];
    if(_specialType.intValue==0)
    {
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            ipage++;
            [self loadData];
        }];
    }
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self loadData];
    
    [self emptyView];
    
}

-(void)loadData
{
    NSDictionary *dicpush = @{@"page":[NSNumber numberWithInt:ipage],
                              @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]
                              };
    NSString *strurl = @"";
    if(_specialType.integerValue == 0)
    {
        strurl = URL_AddFollow_links;
    }
    else if (_specialType.integerValue == 1)
    {
        strurl = URL_FollowSitesList;
    }
    else if (_specialType.integerValue == 2)
    {
        strurl = URL_FollowTagsList;
    }
    else if (_specialType.integerValue == 3)
    {
        strurl = URL_FollowList;
    }
    
    
    
    [datacontrol requestWoGuanZhuDataInView:self.view url:strurl dicpush:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if(state)
        {
            NSMutableArray *muta=[[NSMutableArray alloc]init];
            if(_specialType.integerValue == 0)
            {
                for (NSDictionary *dicmanage in datacontrol.arrrequest) {
                    JiangJiaTongZhiModel *junacl=[[JiangJiaTongZhiModel alloc]initWithdic:dicmanage];
                    [muta addObject:junacl];
                }
            }
            else if (_specialType.integerValue == 1)
            {
                for (NSDictionary *dicmanage in datacontrol.arrrequest) {
                    WoGuanZhuShopAndBiaoModel *junacl=[[WoGuanZhuShopAndBiaoModel alloc]initWithdic:dicmanage];
                    [muta addObject:junacl];
                }
            }
            else if (_specialType.integerValue == 2)
            {
                for (NSDictionary *dicmanage in datacontrol.arrrequest) {
                    WoGuanZhuShopAndBiaoModel *junacl=[[WoGuanZhuShopAndBiaoModel alloc]initWithdic:dicmanage];
                    [muta addObject:junacl];
                }
            }
            else if (_specialType.integerValue == 3)
            {
                for (NSDictionary *dicmanage in datacontrol.arrrequest) {
                    WoGuanZhuPeopleModel *junacl=[[WoGuanZhuPeopleModel alloc]initWithdic:dicmanage];
                    [muta addObject:junacl];
                }
            }
            
            if(ipage==1)
            {
                arrdata = [NSMutableArray new];
            }
            
            [arrdata addObjectsFromArray:muta];
            
        }
        
        if(arrdata.count>0)
        {
            [self.tableView reloadData];
            [_emptyView setHidden:YES];
        }
        else
        {
            [_emptyView setHidden:NO];
            NSString *strmessage = [NSString nullToString:describle];
            [MDB_UserDefault showNotifyHUDwithtext:strmessage inView:self.view];
        }
        
        [self.tableView reloadData];
        
    }];
    
}

#pragma mark - 关注和取消关注
-(void)guanzhuAction:(id)value
{
    BOOL iscancle = NO;
    modelinfo = value;
    if(_specialType.integerValue == 0)
    {
        JiangJiaTongZhiModel *model = modelinfo;
        iscancle = model.iscancle;
    }
    else if(_specialType.integerValue == 1)
    {
        WoGuanZhuShopAndBiaoModel *model = modelinfo;
        iscancle = model.iscancle;
    }
    else if(_specialType.integerValue == 2)
    {
        WoGuanZhuShopAndBiaoModel *model = modelinfo;
        iscancle = model.iscancle;
    }
    else if(_specialType.integerValue == 3)
    {
        WoGuanZhuPeopleModel *model = modelinfo;
        iscancle = model.iscancle;
    }
    if(iscancle)
    {
        [self dataguanzhu];
    }
    else
    {
        NSString *strmessage = @"";
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"woguanzhudequxiaotanchuang"] integerValue] !=1)
        {
            strmessage = @"取消关注后，将不再推送降价通知哦";
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"woguanzhudequxiaotanchuang"];
        }
        else
        {
            strmessage = @"是否取消关注";
        }
        
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:strmessage delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alter show];
        
    }
    
    
}

-(void)dataguanzhu
{
    NSString *strurl = @"";
    NSDictionary *parmaters;
    if(_specialType.integerValue == 0)
    {
        JiangJiaTongZhiModel *model = modelinfo;
        strurl = URL_AddFollow_link;
        parmaters = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],@"share_id":model.did,@"status":[NSNumber numberWithBool:model.iscancle]};
    }
    else if(_specialType.integerValue == 1)
    {
        WoGuanZhuShopAndBiaoModel *model = modelinfo;
        
        if(model.iscancle)
        {
            strurl = URL_FollowAddList;
        }
        else
        {
            strurl = URL_FollowDelList;
        }
        
        
        
        parmaters = @{@"id":[NSString nullToString:model.did],
                      @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                      @"type":@"site"
                      };
    }
    else if(_specialType.integerValue == 2)
    {
        WoGuanZhuShopAndBiaoModel *model = modelinfo;
        if(model.iscancle)
        {
            strurl = URL_FollowAddList;
        }
        else
        {
            strurl = URL_FollowDelList;
        }
        
        parmaters = @{@"id":[NSString nullToString:model.did],
                      @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                      @"type":@"tag"
                      };
    }
    else if(_specialType.integerValue == 3)
    {
        WoGuanZhuPeopleModel *model = modelinfo;
        if(model.iscancle)
        {
            strurl = URL_AddFollow;
        }
        else
        {
            strurl = URL_CancelFollow;
        }
        parmaters = @{@"userid":[NSString nullToString:model.did],
                      @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
        
    }
    [datacontrol requestWoGuanZhuIsCancleDataInView:self.view url:strurl dicpush:parmaters Callback:^(NSError *error, BOOL state, NSString *describle) {
        if(state)
        {
            if(_specialType.integerValue == 0)
            {
                JiangJiaTongZhiModel *model = modelinfo;
                if(model.iscancle)
                {
                    model.iscancle = NO;
                }
                else
                {
                    model.iscancle = YES;
                }
                
            }
            else if(_specialType.integerValue == 1)
            {
                WoGuanZhuShopAndBiaoModel *model = modelinfo;
                if(model.iscancle)
                {
                    model.iscancle = NO;
                }
                else
                {
                    model.iscancle = YES;
                }
            }
            else if(_specialType.integerValue == 2)
            {
                WoGuanZhuShopAndBiaoModel *model = modelinfo;
                if(model.iscancle)
                {
                    model.iscancle = NO;
                }
                else
                {
                    model.iscancle = YES;
                }
            }
            else if(_specialType.integerValue == 3)
            {
                WoGuanZhuPeopleModel *model = modelinfo;
                if(model.iscancle)
                {
                    model.iscancle = NO;
                }
                else
                {
                    model.iscancle = YES;
                }
            }
            [self.tableView reloadData];
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
        }
    }];
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        
        [self dataguanzhu];
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrdata.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_specialType.integerValue == 0)
    {
        static NSString *strcell = @"WoGuanZhuGoodsTableViewCell";
        WoGuanZhuGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strcell];
        if(!cell)
        {
            cell = [[WoGuanZhuGoodsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strcell];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.model = arrdata[indexPath.row];
        [cell setDelegate:self];
        return cell;
    }
    else if(_specialType.integerValue == 1)
    {
        static NSString *strcell = @"WoGuangZhuShopTableViewCell";
        WoGuangZhuShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strcell];
        if(!cell)
        {
            cell = [[WoGuangZhuShopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strcell];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setDelegate:self];
        cell.model = arrdata[indexPath.row];
        
        return cell;
    }
    else if(_specialType.integerValue == 2)
    {
        static NSString *strcell = @"WoGuanZhuBiaoQianTableViewCell";
        WoGuanZhuBiaoQianTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strcell];
        if(!cell)
        {
            cell = [[WoGuanZhuBiaoQianTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strcell];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setDelegate:self];
        cell.model = arrdata[indexPath.row];
        return cell;
    }
    else if(_specialType.integerValue == 3)
    {
        static NSString *strcell = @"WoGuanZhuPeopleTableViewCell";
        WoGuanZhuPeopleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strcell];
        if(!cell)
        {
            cell = [[WoGuanZhuPeopleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strcell];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.model = arrdata[indexPath.row];
        [cell setDelegate:self];
        
        return cell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_specialType.integerValue == 0)
    {
        return 120;
    }
    else if(_specialType.integerValue == 1)
    {
         return 125;
    }
    else if(_specialType.integerValue == 2)
    {
         return 80;
    }
    else if(_specialType.integerValue == 3)
    {
         return 100;
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_specialType.integerValue == 0)
    {
        JiangJiaTongZhiModel *share=[arrdata objectAtIndex:indexPath.row];
        ProductInfoViewController *productInfoVc = [[ProductInfoViewController alloc] init];
        productInfoVc.productId = [NSString stringWithFormat:@"%@",share.did];
        [self.view.superview.viewController.navigationController pushViewController:productInfoVc animated:YES];
    }
    else if(_specialType.integerValue == 1)
    {
        WoGuanZhuShopAndBiaoModel *model = arrdata[indexPath.row];
        NSMutableArray *arrtemp = [NSMutableArray new];
        NSDictionary *dictemp = @{@"dependentPathRow":@"0",@"dependentPathSection":@"1",@"itemID":model.did,@"itemName":model.name};
        [arrtemp addObject:dictemp];
        SearchMainViewController *pvc = [[SearchMainViewController alloc] init];
        pvc.searchContents = arrtemp;
        [self.view.superview.viewController.navigationController pushViewController:pvc animated:YES];
    }
    else if(_specialType.integerValue == 2)
    {
        WoGuanZhuShopAndBiaoModel *model = arrdata[indexPath.row];
        WoGuanZhuBiaoQianSearchListTableViewController *pvc = [[WoGuanZhuBiaoQianSearchListTableViewController alloc] init];
        pvc.seourl = model.seourl;
        pvc.strtitle = model.name;
        [self.view.superview.viewController.navigationController pushViewController:pvc animated:YES];
    }
    else if(_specialType.integerValue == 3)
    {
        WoGuanZhuPeopleModel *model = arrdata[indexPath.row];
        PersonalInfoIndexViewController *pvc = [[PersonalInfoIndexViewController alloc] initWithUserID:model.did];
        [self.view.superview.viewController.navigationController pushViewController:pvc animated:YES];
    }
}

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
