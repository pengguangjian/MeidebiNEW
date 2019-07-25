//
//  WoGuanZhuBiaoQianSearchListTableViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/4/1.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import "WoGuanZhuBiaoQianSearchListTableViewController.h"
#import <MJRefresh.h>
#import "MDBEmptyView.h"
#import "ContentCell.h"
#import "ProductInfoViewController.h"
#import "WoGuanZhuDataController.h"
#import "MDB_UserDefault.h"
#import "VKLoginViewController.h"
@interface WoGuanZhuBiaoQianSearchListTableViewController ()<UIAlertViewDelegate>
{
    WoGuanZhuDataController *datacontrol;
    
    NSMutableArray *arrdata;
    int ipage;
    
    ///是否要刷新列表
    BOOL isloadlist;
    
    BOOL isguanzhu;
}
@property (nonatomic, strong) MDBEmptyView *emptyView;
@end

@implementation WoGuanZhuBiaoQianSearchListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _strtitle;
    ipage = 1;
    datacontrol = [WoGuanZhuDataController new];
//    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
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
    [self loadData];
    [self emptyView];
    [self setExtraCellLineHidden:self.tableView];
    
    [self setNavBarBackBtn];
    [self setrightButton:NO];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(isloadlist)
    {
        [self loadData];
        isloadlist = NO;
    }
}

- (void)setNavBarBackBtn{
    
    UIButton* btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
    btnLeft.frame = CGRectMake(0,0,44,44);
    [btnLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_click.png"] forState:UIControlStateHighlighted];
    [btnLeft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnLeft addTarget:self action:@selector(doClickBackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
}

-(void)setrightButton:(BOOL)isselect
{
    UIButton* btnRight = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor
    [btnRight.titleLabel setFont:[UIFont systemFontOfSize:14]];
    if(isselect)
    {
//        [btnRight setImage:[UIImage imageNamed:@"guanzhubaoliao_yes"] forState:UIControlStateNormal];
//        [btnRight setImage:[UIImage imageNamed:@"guanzhubaoliao_yes"] forState:UIControlStateHighlighted];
        [btnRight setTitle:@"已关注" forState:UIControlStateNormal];
        [btnRight setTitleColor:RGB(200, 200, 200) forState:UIControlStateNormal];
    }
    else
    {
//        [btnRight setImage:[UIImage imageNamed:@"guanzhubaoliao_no"] forState:UIControlStateNormal];
//        [btnRight setImage:[UIImage imageNamed:@"guanzhubaoliao_yes"] forState:UIControlStateHighlighted];
        [btnRight setTitle:@"+关注" forState:UIControlStateNormal];
        [btnRight setTitleColor:RadMenuColor forState:UIControlStateNormal];
    }
    
    [btnRight setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnRight addTarget:self action:@selector(doClickrightAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}


-(void)doClickBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)doClickrightAction
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
    
    NSString *strurl = @"";
    if(isguanzhu==NO)
    {
        strurl = URL_FollowAddList;
    }
    else
    {
        strurl = URL_FollowDelList;
        return;
    }
    if([NSString nullToString:datacontrol.boaqianid].length==0)
    {
        return;
    }
    NSDictionary *parmaters = @{@"id":[NSString nullToString:datacontrol.boaqianid],
                  @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                  @"type":@"tag"
                  };
    [datacontrol requestWoGuanZhuIsCancleDataInView:self.view url:strurl dicpush:parmaters Callback:^(NSError *error, BOOL state, NSString *describle) {
        if(state)
        {
            if(isguanzhu)
            {
                isguanzhu = NO;
            }
            else
            {
                isguanzhu = YES;
            }
            [self setrightButton:isguanzhu];
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
        }
    }];
    
}

-(void)loadData
{
    NSDictionary *dicpush = @{@"p":[NSNumber numberWithInt:ipage],
                              @"seourl":[NSString nullToString:_seourl],
                              @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]
                              };
    [datacontrol requestWoGuanZhuBiaoQianSListDataInView:self.view url:URL_FollowTagList dicpush:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if(state)
        {
            NSMutableArray *muta=[[NSMutableArray alloc]init];
            for (NSDictionary *dicmanage in datacontrol.arrbqrequest) {
                Article *junacl=[[Article alloc]initWithDictionary:dicmanage];
                [muta addObject:junacl];
            }
            if(ipage==1)
            {
                arrdata = [NSMutableArray new];
                isguanzhu = datacontrol.followed.boolValue;
                [self setrightButton:datacontrol.followed.boolValue];
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
            if([strmessage length] == 0)
            {
                strmessage = @"没找到数据~";
            }
            
            [MDB_UserDefault showNotifyHUDwithtext:strmessage inView:self.view];
        }
        
        [self.tableView reloadData];
    }];
    
}

//去掉cell中多余的线
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrdata.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *strcell = @"WoGuanZhuGoodsssTableViewCell";
    ContentCell *cell = [tableView dequeueReusableCellWithIdentifier:strcell];
    if(!cell)
    {
        cell = [[ContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strcell];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    Article *model = arrdata[indexPath.row];
    [cell fetchCellData:model];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 125;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Article *model = arrdata[indexPath.row];
    ProductInfoViewController *pvc = [[ProductInfoViewController alloc] init];
    pvc.theObject = model;
    [self.navigationController pushViewController:pvc animated:YES];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        VKLoginViewController* theViewController= [[VKLoginViewController alloc] init];
        [self.navigationController pushViewController:theViewController animated:YES ];
        isloadlist = YES;
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
