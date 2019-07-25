//
//  JinRiPinDanListViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/29.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "JinRiPinDanListViewController.h"

#import "JinRiPinDanListTableViewCell.h"

#import "JinRiPinDanListDataController.h"

#import <MJRefresh.h>

#import "ProductInfoViewController.h"

#import "MDB_UserDefault.h"

#import "VKLoginViewController.h"

#import "SelectColorAndSizeView.h"

#import "MDBEmptyView.h"



@interface JinRiPinDanListViewController ()<JinRiPinDanListTableViewCellDelegate,SelectColorAndSizeViewDelegate>
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

@implementation JinRiPinDanListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"今日拼单";
    [self setSubview];
    dataControl = [[JinRiPinDanListDataController alloc] init];
    ipage = 1;
    arrlistData = [NSMutableArray new];
    [self bindData];
    
    [self emptyView];
    [MobClick event:@"dgjinripindan" label:@"代购频道今日拼单"];
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
    [dataControl requestDGHomeListDataInView:self.view Line:ipage Callback:^(NSError *error, BOOL state, NSString *describle) {
        
        
        if(ipage==1)
        {
            strlasttimetitle = nil;
            [arrlistData removeAllObjects];
        }
        if(dataControl.arrListData.count>0)
        {
            for(NSDictionary *dic in dataControl.arrListData)
            {
                JinRiPinDanListMainModel *model = [JinRiPinDanListMainModel viewModelWithSubject:dic];
                if(strlasttimetitle == nil)
                {
                    strlasttimetitle = model.strtitletime;
                    NSMutableDictionary *dictemp = [NSMutableDictionary new];
                    [dictemp setObject:strlasttimetitle forKey:@"name"];
                    NSMutableArray *arrtemp = [NSMutableArray new];
                    if([model.strshare_id intValue] > 0)
                    {
                        [arrtemp addObject:model];
                    }
                    
                    [dictemp setObject:arrtemp forKey:@"value"];
                    if(arrtemp.count>0)
                    {
                        [arrlistData addObject:dictemp];
                    }
                    else
                    {
                        strlasttimetitle = nil;
                    }
                }
                else
                {
                    if([model.strtitletime isEqualToString:strlasttimetitle])
                    {
                        NSMutableDictionary *dictemp = arrlistData.lastObject;
                        NSMutableArray *arrtemp = [dictemp objectForKey:@"value"];
                        if([model.strshare_id intValue] > 0)
                        {
                            [arrtemp addObject:model];
                        }
                        [dictemp setObject:arrtemp forKey:@"value"];
                    }
                    else
                    {
                        strlasttimetitle = model.strtitletime;
                        NSMutableDictionary *dictemp = [NSMutableDictionary new];
                        [dictemp setObject:strlasttimetitle forKey:@"name"];
                        NSMutableArray *arrtemp = [NSMutableArray new];
                        if([model.strshare_id intValue] > 0)
                        {
                            [arrtemp addObject:model];
                        }
                        [dictemp setObject:arrtemp forKey:@"value"];
                        if(arrtemp.count>0)
                        {
                            [arrlistData addObject:dictemp];
                        }
                        else
                        {
                            strlasttimetitle = nil;
                        }
                    }
                    
                }
            }
        }
        
//        NSMutableArray *arrdata = [NSMutableArray new];
//        for(NSDictionary *dic in arrlistData)
//        {
//            NSMutableArray *arrtemp = [dic objectForKey:@"value"];
//            if(arrtemp.count != 0)
//            {
//                [arrdata addObject:dic];
//            }
//        }
//        arrlistData = nil;
//        
//        arrlistData = arrdata;
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if(arrlistData.count==0)
        {
            [_emptyView setHidden:NO];
        }
        else
        {
            [_emptyView setHidden:YES];
        }
    }];
    
    
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrlistData.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dictemp = arrlistData[section];
    NSMutableArray *arrtemp = [dictemp objectForKey:@"value"];
    return arrtemp.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *strcell = @"JinRiPinDanListTableViewCell";
    JinRiPinDanListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strcell];
    if(!cell)
    {
        cell = [[JinRiPinDanListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strcell];
    }
    [cell setDelegate:self];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSDictionary *dictemp = arrlistData[indexPath.section];
    NSMutableArray *arrtemp = [dictemp objectForKey:@"value"];
    cell.model = arrtemp[indexPath.row];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 40;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 40)];
    [view setBackgroundColor:[UIColor whiteColor]];
    NSDictionary *dictemp = arrlistData[section];
    UILabel *lbleft = [[UILabel alloc] initWithFrame:CGRectMake(20, 0,100, view.height)];
    [lbleft setText:[dictemp objectForKey:@"name"]];
    [lbleft setTextColor:RGB(243,93,0)];
    [lbleft setTextAlignment:NSTextAlignmentLeft];
    [lbleft setFont:[UIFont systemFontOfSize:12]];
    [lbleft sizeToFit];
    [lbleft setHeight:view.height];
    [view addSubview:lbleft];
    
    UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(0, lbleft.bottom-1, view.width, 1)];
    [viewline setBackgroundColor:RGB(226,226,226)];
    [view addSubview:viewline];
    
    UIView *viewline1 = [[UIView alloc] initWithFrame:CGRectMake(10, lbleft.bottom-1.5, lbleft.width+20, 1.5)];
    [viewline1 setBackgroundColor:RGB(243,93,0)];
    [view addSubview:viewline1];
    
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictemp = arrlistData[indexPath.section];
    NSMutableArray *arrtemp = [dictemp objectForKey:@"value"];
    
    JinRiPinDanListMainModel *model = arrtemp[indexPath.row];
    ProductInfoViewController *pvc = [[ProductInfoViewController alloc] init];
    pvc.productId = model.strshare_id;
    [self.navigationController pushViewController:pvc animated:YES];
    NSLog(@"点击");
    
    NSMutableArray *arrbldj = [[NSUserDefaults standardUserDefaults] objectForKey:@"baoliaoyidianji"];
    NSMutableArray *arrtemps = [NSMutableArray new];
    [arrtemps addObjectsFromArray:arrbldj];
    BOOL isbool = [arrtemps containsObject: [NSString stringWithFormat:@"%@", model.strshare_id]];
    if(isbool==NO)
    {
        if(arrtemps.count>=200)
        {
            [arrtemps removeLastObject];
        }
        
        [arrtemps insertObject:[NSString stringWithFormat:@"%@",model.strshare_id] atIndex:0];
        
    }
    [[NSUserDefaults standardUserDefaults] setObject:arrtemps forKey:@"baoliaoyidianji"];
    [tableView reloadData];
    
    
}

#pragma mark - JinRiPinDanListTableViewDelegate
-(void)JinRiPinDanListTableViewCellAddByCar:(JinRiPinDanListMainModel *)model
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
    
    if(model.strid==nil)return;
    
    strdaigaouid = model.strid;
    
    if(model.isspiderorder.integerValue==1)
    {
        NSMutableDictionary *dicinfo = [NSMutableDictionary new];
        [dicinfo setObject:model.strid forKey:@"id"];
        [dicinfo setObject:model.strimage forKey:@"image"];
        [dicinfo setObject:model.strtitle forKey:@"title"];
        
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
            //动画
//            UIImageView *imgvtemp = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//            [imgvtemp setImage:[UIImage imageNamed:@"addgouwuche_remu"]];
//            [imgvtemp setCenter:CGPointMake(self.view.width/2.0, self.view.height/2.0)];
//            [self.view.window addSubview:imgvtemp];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
