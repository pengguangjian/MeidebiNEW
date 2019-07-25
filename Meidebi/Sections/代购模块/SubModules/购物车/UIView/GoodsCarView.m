//
//  GoodsCarView.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/8/29.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "GoodsCarView.h"

#import "MDB_UserDefault.h"

#import "GoodsCarSuperModel.h"
#import "GoodsGarModel.h"

#import "GoodsCarTableViewCell.h"

#import "GoodsCarDataViewController.h"

#import "DaiGouXiaDanViewController.h"

#import "ProductInfoViewController.h"

#import <MJRefresh.h>

#import "SelectColorAndSizeView.h"

@interface GoodsCarView ()<UITableViewDelegate,UITableViewDataSource,GoodsCarTableViewCellDelegate,SelectColorAndSizeViewDelegate>
{
    UITableView *tabview;
    UIView *viewbottom;
    UIView *viewEditBottom;
    
    UILabel *lballSelectprice;
    
    GoodsCarDataViewController *datacontrol;
    ///列表数据
    NSMutableArray *arrlistData;
    
    ///没得数据显示
    UIView *viewnotmessage;
    
    
    UIButton *btallselect;
    
    SelectColorAndSizeView *svcGuige;
    
    BOOL isListEdit;
    
}


@end

@implementation GoodsCarView

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
        [self drawUI];
        
        [self drawnotmessageui];
        
        datacontrol = [[GoodsCarDataViewController alloc] init];
        [self dataMessage];
    }
    return self;
}

-(void)drawUI
{
    ///正常的底部
    viewbottom = [[UIView alloc] init];
    [viewbottom setBackgroundColor:RGB(247, 247, 247)];
    [self addSubview:viewbottom];
    [viewbottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.offset(50*kScale);
        make.bottom.equalTo(self.mas_bottom);
    }];
    [self drawbottomui];
    
    ///编辑的底部
    viewEditBottom = [[UIView alloc] init];
    [viewEditBottom setBackgroundColor:RGB(247, 247, 247)];
    [viewEditBottom setHidden:YES];
    [self addSubview:viewEditBottom];
    [viewEditBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.offset(50*kScale);
        make.bottom.equalTo(self.mas_bottom);
    }];
    [self drawEditBottomui];
    
    tabview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self addSubview:tabview];
    [tabview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(viewbottom.mas_top);
    }];
    [tabview setDelegate:self];
    [tabview setDataSource:self];
    [tabview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tabview.estimatedRowHeight = 0;
    tabview.estimatedSectionHeaderHeight = 0;
    tabview.estimatedSectionFooterHeight = 0;
    tabview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if(isListEdit==NO)
        {
            [self dataMessage];
        }
        else
        {
            [tabview.mj_header endRefreshing];
        }
    }];
    
    
}

-(void)drawnotmessageui
{
    viewnotmessage = [[UIView alloc] init];
    [viewnotmessage setBackgroundColor:[UIColor whiteColor]];
    [viewnotmessage setHidden:YES];
    [self addSubview:viewnotmessage];
    [viewnotmessage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.mas_equalTo(self);
    }];
    
    UIImageView *imgv = [[UIImageView alloc] init];
    [viewnotmessage addSubview:imgv];
    [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.size.sizeOffset(CGSizeMake(70*kScale, 70*kScale));
        make.centerX.equalTo(viewnotmessage.mas_centerX);
        make.top.offset(90*kScale);
    }];
    [imgv setImage:[UIImage imageNamed:@"gouwuchemeideshangping"]];
    
    
    
    UILabel *lbnoto = [[UILabel alloc] init];
    [viewnotmessage addSubview:lbnoto];
    [lbnoto mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(viewnotmessage);
        make.top.equalTo(imgv.mas_bottom).offset(50);
    }];
    [lbnoto setText:@"购物车还是空空的呢"];
    [lbnoto setTextColor:RGB(143, 143, 143)];
    [lbnoto setTextAlignment:NSTextAlignmentCenter];
    [lbnoto setFont:[UIFont systemFontOfSize:15]];
    
    
    
    
    UIButton *btnomo = [[UIButton alloc] init];
    [viewnotmessage addSubview:btnomo];
    [btnomo mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.size.sizeOffset(CGSizeMake(150*kScale, 45*kScale));
        make.centerX.equalTo(viewnotmessage.mas_centerX);
        make.top.equalTo(lbnoto.mas_bottom).offset(90);
        
    }];
    [btnomo setTitle:@"现在去逛逛" forState:UIControlStateNormal];
    [btnomo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnomo.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [btnomo setBackgroundColor:RadMenuColor];
    [btnomo.layer setMasksToBounds:YES];
    [btnomo.layer setCornerRadius:45*kScale/2.0];
    [btnomo addTarget:self action:@selector(gouBuyAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
}

-(void)gouBuyAction
{
    [self.viewController.navigationController popViewControllerAnimated:YES];
}

-(void)drawbottomui
{
    UILabel *lball = [[UILabel alloc] init];
    [viewbottom addSubview:lball];
    [lball mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(10);
        make.top.offset(0);
        make.bottom.equalTo(viewbottom);
    }];
    [lball setText:@"总计："];
    [lball setTextColor:RGB(30, 30, 30)];
    [lball setTextAlignment:NSTextAlignmentLeft];
    [lball setFont:[UIFont systemFontOfSize:14]];
    
    UILabel *lballprice = [[UILabel alloc] init];
    [viewbottom addSubview:lballprice];
    [lballprice mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(lball.mas_right);
        make.top.offset(0);
        make.bottom.equalTo(viewbottom);
    }];
    [lballprice setText:@"￥546.64"];
    [lballprice setTextColor:RadMenuColor];
    [lballprice setTextAlignment:NSTextAlignmentLeft];
    [lballprice setFont:[UIFont systemFontOfSize:14]];
    lballSelectprice = lballprice;
    
    
    
    UIButton *btjiesuan = [[UIButton alloc] init];
    [btjiesuan setBackgroundColor:RadMenuColor];
    [viewbottom addSubview:btjiesuan];
    [btjiesuan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(110*kScale);
        make.top.offset(0);
        make.bottom.right.equalTo(viewbottom);
        
    }];
    [btjiesuan setTitle:@"去结算" forState:UIControlStateNormal];
    [btjiesuan setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btjiesuan.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [btjiesuan addTarget:self action:@selector(jiesuanAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *viewline = [[UIView alloc] init];
    [viewline setBackgroundColor:RGB(209, 209, 209)];
    [viewbottom addSubview:viewline];
    [viewline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(viewbottom);
        make.height.offset(1);
    }];
    
    
}

-(void)drawEditBottomui
{
    btallselect = [[UIButton alloc] init];
    [viewEditBottom addSubview:btallselect];
    [btallselect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(100*kScale);
        make.left.offset(10);
        make.bottom.top.equalTo(viewEditBottom);
        
    }];
    [btallselect setTitle:@"全选" forState:UIControlStateNormal];
    [btallselect setTitleColor:RGB(30, 30, 30) forState:UIControlStateNormal];
    [btallselect.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btallselect setImage:[UIImage imageNamed:@"yuan_select_no"] forState:UIControlStateNormal];
    [btallselect setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [btallselect addTarget:self action:@selector(selectAllAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btdel = [[UIButton alloc] init];
    [btdel setBackgroundColor:[UIColor whiteColor]];
    [viewEditBottom addSubview:btdel];
    [btdel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.offset(8);
        make.bottom.equalTo(viewEditBottom).offset(-8);
        make.width.offset(90*kScale);
        make.right.equalTo(viewEditBottom).offset(-10);
    }];
    [btdel.layer setMasksToBounds:YES];
    [btdel.layer setCornerRadius:(50*kScale-16)/2.0];
    [btdel.layer setBorderColor:RadMenuColor.CGColor];
    [btdel.layer setBorderWidth:1];
    [btdel setTitleColor:RadMenuColor forState:UIControlStateNormal];
    [btdel setTitle:@"删除" forState:UIControlStateNormal];
    [btdel.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [btdel addTarget:self action:@selector(delListAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *viewline = [[UIView alloc] init];
    [viewline setBackgroundColor:RGB(209, 209, 209)];
    [viewbottom addSubview:viewline];
    [viewline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(viewbottom);
        make.height.offset(1);
    }];
    
    
}

///编辑和完成编辑
-(void)iseditAction:(BOOL)isedit
{
    isListEdit = isedit;
    if(isedit)
    {
        [viewbottom setHidden:YES];
        [viewEditBottom setHidden:NO];
        [btallselect setImage:[UIImage imageNamed:@"yuan_select_no"] forState:UIControlStateNormal];
    }
    else
    {
        [viewbottom setHidden:NO];
        [viewEditBottom setHidden:YES];
    }
    for(GoodsCarSuperModel *model in arrlistData)
    {
        for(GoodsGarModel *model1 in model.arrlist)
        {
            model1.isEdit = isedit;
            model1.isEditSelect = NO;
        }
        
    }
    [tabview reloadData];
    
}

-(void)dataMessage
{
    
    NSDictionary *dicpush = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    
    [datacontrol requestBuCarListDataLine:dicpush view:self Callback:^(NSError *error, BOOL state, NSString *describle) {
        [tabview.mj_header endRefreshing];
       arrlistData = [NSMutableArray new];
        if(state)
        {
            
            if([datacontrol.arrreqList isKindOfClass:[NSArray class]])
            {
                
                for(NSDictionary *dictemp in datacontrol.arrreqList)
                {
                    GoodsCarSuperModel *model = [GoodsCarSuperModel viewModelDic:dictemp];
                    [arrlistData addObject:model];
                    
                }
                
            }
            
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self];
        }
        
        if(arrlistData.count>0)
        {
            [viewnotmessage setHidden:YES];
            
            [self.delegate goodsListcount:YES];
        }
        else
        {
            [viewnotmessage setHidden:NO];
            
            [self.delegate goodsListcount:NO];
            
        }
        
        [tabview reloadData];
        [self judgeAllPrice];
    }];
    
}


#pragma strtemp - 全选
-(void)selectAllAction
{
    BOOL isquanxianl = NO;
    for(GoodsCarSuperModel *model in arrlistData)
    {
        
        for(GoodsGarModel *model1 in model.arrlist)
        {
            if(model1.isEditSelect == NO)
            {
                isquanxianl = YES;
                break;
            }
        }
        
    }
    
    if(isquanxianl)
    {
        for(GoodsCarSuperModel *model in arrlistData)
        {
            
            for(GoodsGarModel *model1 in model.arrlist)
            {
                model1.isEditSelect=YES;
            }
            
        }
        
        [btallselect setImage:[UIImage imageNamed:@"yuan_select_yes"] forState:UIControlStateNormal];
    }
    else
    {
        for(GoodsCarSuperModel *model in arrlistData)
        {
            
            for(GoodsGarModel *model1 in model.arrlist)
            {
                model1.isEditSelect=NO;
            }
            
        }
        
        [btallselect setImage:[UIImage imageNamed:@"yuan_select_no"] forState:UIControlStateNormal];
    }
    
    
    
    [tabview reloadData];
    
    
}

#pragma mark - 删除列表
-(void)delListAction
{
    NSString *strtemp = @"";
    for(GoodsCarSuperModel *model in arrlistData)
    {
        
        for(GoodsGarModel *model1 in model.arrlist)
        {
            if(model1.isEditSelect==YES)
            {
                if(strtemp.length>0)
                {
                    strtemp = [NSString stringWithFormat:@"%@,%@",strtemp,model1.did];
                }
                else
                {
                    strtemp = [NSString stringWithFormat:@"%@",model1.did];
                }
                
            }
        }
        
    }
    if(strtemp.length<1)
    {
        [MDB_UserDefault showNotifyHUDwithtext:@"请选择商品" inView:self];
        return;
    }
    
    [self removegoods:strtemp];
}

#pragma mark - 去结算
-(void)jiesuanAction
{
    
    [MobClick event:@"dggouwuchexiadan" label:@"代购购物车提交订单"];
    
    NSDictionary *dicpush = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [datacontrol requestBuCarListJieSuanDataLine:dicpush view:self Callback:^(NSError *error, BOOL state, NSString *describle) {
       
        if(state)
        {
            DaiGouXiaDanViewController *dvc = [[DaiGouXiaDanViewController alloc] init];
            dvc.dicvalue = datacontrol.dicJieSuan;
            dvc.strid = @"";
            dvc.strpindan_id = @"";
            dvc.iscanyupintuan = NO;
            dvc.iseditnumber = NO;
            [self.viewController.navigationController pushViewController:dvc animated:YES];
            
            
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self];
        }
        
        
    }];
    
//    DaiGouXiaDanViewController
    
}


#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrlistData.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    GoodsCarSuperModel *model = arrlistData[section];
    return model.arrlist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strcell = @"GoodsCarTableViewCell111";
    GoodsCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strcell];
    if(!cell)
    {
        cell = [[GoodsCarTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strcell];
        
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setDelegate:self];
    
    GoodsCarSuperModel *model = arrlistData[indexPath.section];
    
    cell.model = model.arrlist[indexPath.row];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 50)];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    float fleft = 10;
    GoodsCarSuperModel *model = arrlistData[section];
    UILabel *lbzhiyou = [[UILabel alloc] initWithFrame:CGRectMake(10, 17, 45, 17)];
    [lbzhiyou setText:@"直邮"];
    [lbzhiyou setTextColor:RGB(230,56,47)];
    [lbzhiyou setTextAlignment:NSTextAlignmentCenter];
    [lbzhiyou setFont:[UIFont systemFontOfSize:13]];
    [lbzhiyou.layer setMasksToBounds:YES];
    [lbzhiyou.layer setCornerRadius:2];
    [lbzhiyou.layer setBorderColor:RGB(230,56,47).CGColor];
    [lbzhiyou.layer setBorderWidth:1];
    [lbzhiyou sizeToFit];
    [lbzhiyou setHeight:17];
    [lbzhiyou setWidth:lbzhiyou.width+6];
    [view addSubview:lbzhiyou];
//    if([model.transfertype intValue] == 2)
//    {
//        fleft = lbzhiyou.right+10;
//        [lbzhiyou setHidden:NO];
//    }
//    else
//    {
//        fleft = 10;
//        [lbzhiyou setHidden:YES];
//    }
    
    fleft = 10;
    [lbzhiyou setHidden:YES];
    
    UILabel *lbshop = [[UILabel alloc] initWithFrame:CGRectMake(fleft, lbzhiyou.top, view.width-fleft-10, lbzhiyou.height)];
    [lbshop setText:model.strshopname];
    [lbshop setTextColor:RadMenuColor];
    [lbshop setTextAlignment:NSTextAlignmentLeft];
    [lbshop setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbshop];
    
    UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(0, view.height-1, view.width, 1)];
    [viewline setBackgroundColor:RGB(231,231,231)];
    [view addSubview:viewline];
    
    
    return view;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 10)];
    [view setBackgroundColor:RGB(241, 241, 241)];
    
    return view;
}

////
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return YES;
}
// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
    
}
// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        GoodsCarSuperModel *model0 = arrlistData[indexPath.section];
        GoodsGarModel *model = model0.arrlist[indexPath.row];
        
        [self removegoods:model.did];
        
        
    }
    
}
// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
    
}
    

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsCarSuperModel *model0 = arrlistData[indexPath.section];
    GoodsGarModel *model = model0.arrlist[indexPath.row];
    ProductInfoViewController *pvc = [[ProductInfoViewController alloc] init];
    pvc.productId = model.share_id;
    [self.viewController.navigationController pushViewController:pvc animated:YES];
}

////删除商品
-(void)removegoods:(NSString *)strid
{
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken] forKey:@"userkey"];
    [dicpush setObject:strid forKey:@"cartids"];
    [dicpush setObject:@"0" forKey:@"num"];
    
    GoodsCarDataViewController *datacontrol = [[GoodsCarDataViewController alloc] init];
    [datacontrol requestBuCarListItemEditDataLine:dicpush view:self Callback:^(NSError *error, BOOL state, NSString *describle) {
        if(state)
        {
            [self dataMessage];
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.viewController.view];
        }
    }];
}

#pragma mark - GoodsCarTableViewCellDelegate
///选中了某一个
-(void)selectActionItem:(GoodsGarModel *)model;
{
    if(model.isEdit==NO)
    {
        NSMutableDictionary *dicpush = [NSMutableDictionary new];
        [dicpush setObject:[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken] forKey:@"userkey"];
        [dicpush setObject:model.did forKey:@"cartid"];
        if(model.isSelect)
        {
            [dicpush setObject:@"1" forKey:@"ischecked"];
        }
        else
        {
            [dicpush setObject:@"0" forKey:@"ischecked"];
        }
        
        
        [datacontrol requestBuCarListItemSelectDataLine:dicpush view:nil Callback:^(NSError *error, BOOL state, NSString *describle) {
            if(state)
            {
                
                [self judgeAllPrice];
            }
            else
            {
                [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.viewController.view];
            }
        }];
        
        
    }
    else
    {
        [self selectAllJudge];
    }
}

-(void)itemNumChange
{
   [self judgeAllPrice];
}

-(void)judgeAllPrice
{
    float ftemp = 0.0;
    for(GoodsCarSuperModel *model in arrlistData)
    {
        
        for(GoodsGarModel *model1 in model.arrlist)
        {
           if(model1.isSelect == YES&&model1.isendtime==NO)
           {
               ftemp+=model1.price.floatValue*model1.num.integerValue;
               NSInteger inum = model1.num.integerValue-1;
               if(inum<0)
               {
                   inum = 0;
               }
               if(inum>=model1.arrincidentals.count-1)
               {
                   inum = model1.arrincidentals.count-1;
               }
               
               GoodsGarincidentalsModel *modeltemp = model1.arrincidentals[inum];
            ftemp+=modeltemp.tariff.floatValue+modeltemp.transfermoney.floatValue+modeltemp.hpostage.floatValue+modeltemp.directmailmoney.floatValue;
               
           }
            if(model1.isSelect == YES&&model1.isendtime==YES)
            {
                if(model1.isEdit==NO)
                {
                    NSMutableDictionary *dicpush = [NSMutableDictionary new];
                    [dicpush setObject:[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken] forKey:@"userkey"];
                    [dicpush setObject:model1.did forKey:@"cartid"];
                    [dicpush setObject:@"0" forKey:@"ischecked"];
                    
                    
                    [datacontrol requestBuCarListItemSelectDataLine:dicpush view:nil Callback:^(NSError *error, BOOL state, NSString *describle) {
                        if(state)
                        {
                            model1.isSelect = NO;
//                            [self judgeAllPrice];
                        }
                        else
                        {
//                            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.viewController.view];
                        }
                    }];
                    
                    
                }
            }
        }
        
    }
    
    [lballSelectprice setText:[NSString stringWithFormat:@"￥%.2lf",ftemp]];
    
}

////修改某一个规格
-(void)changeGuiGeItem:(GoodsGarModel *)model
{
    
    NSLog(@"dsfasdfa");
    NSMutableDictionary *dicinfo = [NSMutableDictionary new];
    [dicinfo setObject:model.goods_id forKey:@"id"];
    [dicinfo setObject:model.did forKey:@"cartid"];
    [dicinfo setObject:model.image forKey:@"image"];
    [dicinfo setObject:model.title forKey:@"title"];
    
    svcGuige = [[SelectColorAndSizeView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, kMainScreenH) andvalue:dicinfo andtype:3];
    [svcGuige setDelegate:self];
    [self.window addSubview:svcGuige];
    [svcGuige showView];
}

///修改购物车规格
-(void)changeGouWuChe:(NSString *)strid andcartid:(NSString *)strcartid
{
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken] forKey:@"userkey"];
    [dicpush setObject:@"1" forKey:@"devicetype"];
    [dicpush setObject:strid forKey:@"goodsdetailid"];
    [dicpush setObject:strcartid forKey:@"cartid"];
    
    [datacontrol requestBuCarListChangeItemGuiGeDataLine:dicpush view:self.window Callback:^(NSError *error, BOOL state, NSString *describle) {
       [svcGuige dismisAction];
        if(state)
        {
            [MDB_UserDefault showNotifyHUDwithtext:@"规格修改成功" inView:self.window];
            [self dataMessage];
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.window];
        }
    }];
    
    
}

#pragma strtemp - 全选
-(void)selectAllJudge
{
    BOOL isquanxianl = NO;
    for(GoodsCarSuperModel *model in arrlistData)
    {
        
        for(GoodsGarModel *model1 in model.arrlist)
        {
            if(model1.isEditSelect == NO)
            {
                isquanxianl = YES;
                break;
            }
        }
        
    }
    
    if(isquanxianl)
    {
        [btallselect setImage:[UIImage imageNamed:@"yuan_select_no"] forState:UIControlStateNormal];
        
    }
    else
    {
        
        [btallselect setImage:[UIImage imageNamed:@"yuan_select_yes"] forState:UIControlStateNormal];
    }
    
    
}


@end
