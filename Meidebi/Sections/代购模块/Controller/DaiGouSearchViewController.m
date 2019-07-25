//
//  DaiGouSearchViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/8/20.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "DaiGouSearchViewController.h"

#import <MJRefresh.h>

#import "DaiGouHomeTableViewCell.h"


#import "ProductInfoViewController.h"

#import "DaiGouHomeDataController.h"

#import "MDB_UserDefault.h"

#import "VKLoginViewController.h"

#import "MDBEmptyView.h"

#import "SelectColorAndSizeView.h"

#import "SearchHotKeyDaiGouView.h"

#import "SearchHomeViewDataController.h"

@interface DaiGouSearchViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,DaiGouHomeTableViewCellDelegate,UIAlertViewDelegate,SelectColorAndSizeViewDelegate,SearchHotKeyDaiGouViewDelegate>
{
    UIView *viewtitle;
    UITextField *fieldsearch;
    
    UITableView *tabView;
    
    int ipage;
    
    NSMutableArray *arrListData;
    
    DaiGouHomeDataController *datacontrol;
    
    ///代购商品id
    NSString *strdaigaouid;
    
    
    SelectColorAndSizeView *ggView;
    
    SearchHotKeyDaiGouView *searchkeyView;
    
    SearchHomeViewDataController *_dataControl;
}

@property (nonatomic, strong) MDBEmptyView *emptyView;

@end

@implementation DaiGouSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setsearchtitle];
    ipage = 1;
    
    
    
    datacontrol = [[DaiGouHomeDataController alloc] init];
    
    
    tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight, BOUNDS_WIDTH, BOUNDS_HEIGHT-kTopHeight)];
    [tabView setDelegate:self];
    [tabView setDataSource:self];
    [tabView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tabView];
    tabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ipage = 1;
        [self bindListData];
    }];
    tabView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        ipage++;
        [self bindListData];
        
    }];
    [self emptyView];
    
    searchkeyView = [[SearchHotKeyDaiGouView alloc] initWithFrame:CGRectMake(0, kTopHeight, BOUNDS_WIDTH, BOUNDS_HEIGHT-kTopHeight)];
    [searchkeyView setDelegate:self];
    [self.view addSubview:searchkeyView];
    
    
    
     _dataControl = [[SearchHomeViewDataController alloc] init];
     NSDictionary *dicpush = @{@"key":@"dg_search_hot"};
     [_dataControl requestSearchHomeViewDataWithView:nil pushValue:dicpush callback:^(NSError *error, BOOL state, NSString *describle) {
         if(state)
         {
             [searchkeyView updateHotKeyValue:_dataControl.arrkeys];
         }
     }];
     
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [viewtitle setHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [viewtitle setHidden:YES];
    [fieldsearch resignFirstResponder];
}

-(void)setsearchtitle
{
    viewtitle = [[UIView alloc]initWithFrame:CGRectMake(50, 5, self.view.width-70, 34)];
    [viewtitle setBackgroundColor:RGB(233, 233, 233)];
    [viewtitle.layer setMasksToBounds:YES];
    [viewtitle.layer setCornerRadius:viewtitle.height/2.0];
    [self.navigationController.navigationBar addSubview:viewtitle];
    
    fieldsearch = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, viewtitle.width-30, viewtitle.height)];
    [fieldsearch setText:@""];
    [fieldsearch setPlaceholder:@"搜一下看看~"];
    [fieldsearch setTextColor:RGB(30, 30, 30)];
    [fieldsearch setTextAlignment:NSTextAlignmentLeft];
    [fieldsearch setFont:[UIFont systemFontOfSize:14]];
    [fieldsearch setReturnKeyType:UIReturnKeySearch];
    [fieldsearch setDelegate:self];
    [viewtitle addSubview:fieldsearch];
    [fieldsearch becomeFirstResponder];
}

#pragma mark - UITextField

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [searchkeyView setHidden:NO];
    
    
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [searchkeyView setHidden:YES];
    return YES;
}
//searchkeyView

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@"\n"])
    {
        NSLog(@"开始搜索");
        [fieldsearch resignFirstResponder];
        [MobClick event:@"dgsousuo" label:@"代购频道搜索"];
        [self bindListData];
        
        
        return NO;
    }
    return YES;
}



-(void)bindListData
{
    if([fieldsearch.text stringByReplacingOccurrencesOfString:@" " withString:@""].length<1)
    {
        [tabView.mj_header endRefreshing];
        [tabView.mj_footer endRefreshing];
        return;
    }
    
    NSDictionary *dicpush = @{@"kw":fieldsearch.text,@"page":[NSString stringWithFormat:@"%d",ipage]};
    
    [datacontrol requestDGSearchListDataLine:dicpush InView:self.view Callback:^(NSError *error, BOOL state, NSString *describle) {
       
        if(ipage==1)
        {
            arrListData = [NSMutableArray new];
        }
        if(state)
        {
            if(datacontrol.arrListData.count>0)
            {
                for(NSDictionary *dic in datacontrol.arrListData)
                {
                    [arrListData addObject:[DaiGouHomeListModel viewModelWithSubject:dic]];
                }
            }
            
        }
        [tabView reloadData];
        [tabView.mj_header endRefreshing];
        [tabView.mj_footer endRefreshing];
        
        if(arrListData.count<1)
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
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [fieldsearch resignFirstResponder];
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
    [cell setDelegate:self];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DaiGouHomeListModel *model = arrListData[indexPath.row];

    ProductInfoViewController *pvc = [[ProductInfoViewController alloc] init];
    pvc.productId = model.share_id;
    [self.navigationController pushViewController:pvc animated:YES];

    NSLog(@"列表点击");
}

////加入购物车
-(void)DaiGouHomeTableViewCellAddGouWuChe:(DaiGouHomeListModel *)model
{
    
    
    strdaigaouid = model.dgID;
    //    [self gouwucheView:model.dgID];
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
    
    [datacontrol requestAddBuCarDataLine:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
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

///购买商品
-(void)buyGoods:(NSString *)strid andnum:(NSString *)strnum
{
    
}
///修改购物车规格
-(void)changeGouWuChe:(NSString *)strid andcartid:(NSString *)strcartid
{
    
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


#pragma mark - searchHotKeyDaiGouViewDelegate
- (void)searchHotKeyDaiGouViewSubjectView:(SearchHotKeyDaiGouView *)subjectView
                didSelectSearchHistoryStr:(NSString *)historyStr
{
    [fieldsearch setText:historyStr];
    [fieldsearch resignFirstResponder];
    [MobClick event:@"dgsousuo" label:@"代购频道搜索"];
    [self bindListData];
    
}
-(void)keyboarddismisss
{
    [fieldsearch resignFirstResponder];
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
