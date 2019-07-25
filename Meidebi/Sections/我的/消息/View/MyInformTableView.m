//
//  MyInformTableView.m
//  Meidebi
//
//  Created by 杜非 on 15/2/11.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import "MyInformTableView.h"
#import "MDB_UserDefault.h"
#import "MyInformTableViewCell.h"
#import "HTTPManager.h"
#import <MJRefresh/MJRefresh.h>
#import "MyInformTableHeadView.h"
#import <UIImageView+WebCache.h>

#import "MyInformMessageDataController.h"

@interface MyInformTableView ()<MyInformTableHeadViewDelegate>
@property (nonatomic ,weak) MyInformTableHeadView *headView;
@property (nonatomic ,assign) BOOL isRemind;
@property (nonatomic ,assign) BOOL isZanRemind;
@property (nonatomic ,assign) BOOL isOrderRemind;
@property (nonatomic , retain) MyInformMessageDataController *datacontrol;
@end

static NSString *const cellID = @"MyInformTableViewCell";
@implementation MyInformTableView{
    
    NSInteger  _p;
    float _ScrowContentOffSet;
    
    
    UIView *viewbottom;
    UIButton *btalldu;
    UIButton *btdel;
    
}
@synthesize arrData=_arrData;
@synthesize reloading=_reloading;
@synthesize foodReloading=_foodReloading;

@synthesize delegate=_delegate;
-(id)initWithFrame:(CGRect)frame{
    if (self) {
        self=[super initWithFrame:frame];
    }
    _p=1;
    _ScrowContentOffSet=0.0f;
    NSDictionary *dica=@{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                         @"p":@"1"};
    _arrData=[[NSMutableArray alloc]init];
    [HTTPManager sendGETRequestUrlToService:URL_mymessage withParametersDictionry:dica view:self completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct==nil) {
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[NSString nullToString:[dicAll objectForKey:@"status"]] isEqualToString:@"1"]) {
                id arrs=[dicAll objectForKey:@"data"];
                if ([arrs isKindOfClass:[NSArray class]]){
                    for(NSDictionary *dic in arrs)
                    {
                        [_arrData addObject:[MyInformMainModel dicvalueChange:dic]];
                    }
                }
                
                _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
                _tableview.delegate=self;
                _tableview.dataSource=self;
                _tableview.separatorColor = [UIColor colorWithHexString:@"#E2E2E2"];
                [_tableview registerClass:[MyInformTableViewCell class] forCellReuseIdentifier:cellID];
                [self setExtraCellLineHidden:_tableview];
                
                _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                    [self reloadTableViewDataSource];
                }];
                
                if (_arrData.count >0) {
                    _p++;
                    _tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                        [self footReloadTableViewDateSource];
                    }];
                }
                [self addSubview:_tableview];
                MyInformTableHeadView *headView = [[MyInformTableHeadView alloc] init];
                headView.frame = CGRectMake(0, 0, kMainScreenW, (96*2) *kScale);
                headView.delegate = self;
                _tableview.tableHeaderView = headView;
                _headView = headView;
                [_headView reamrkRemindViewShow:!_isRemind];
                [_headView zanRemindViewShow:!_isZanRemind];
                ///我的订单消息提示
                [_headView orderRemindViewShow:!_isOrderRemind];
                
             }else{
                    [self setTitle];
                }
        }
    }];
    
    
    
    [self drawbottomView];
    
    
    return self;
    
}

-(void)drawbottomView
{
    viewbottom = [[UIView alloc] init];
    [viewbottom setBackgroundColor:RGB(247, 247, 247)];
    [viewbottom setHidden:YES];
    [self addSubview:viewbottom];
    [viewbottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.offset(50);
    }];
    
    
    btalldu = [[UIButton alloc] init];
    [btalldu setTitle:@"全部已读" forState:UIControlStateNormal];
    [btalldu setTitleColor:RGB(50, 50, 50) forState:UIControlStateNormal];
    [btalldu.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [viewbottom addSubview:btalldu];
    [btalldu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(35);
        make.top.offset(10);
        make.height.offset(30);
        make.width.offset(90);
    }];
    [btalldu addTarget:self action:@selector(allduAction) forControlEvents:UIControlEventTouchUpInside];
    [btalldu.layer setMasksToBounds:YES];
    [btalldu.layer setCornerRadius:15];
    [btalldu.layer setBorderColor:RGB(236, 236, 236).CGColor];
    [btalldu.layer setBorderWidth:1];
    
    btdel = [[UIButton alloc] init];
    [btdel setTitle:@"删除" forState:UIControlStateNormal];
    [btdel setTitleColor:RGB(225, 225, 225) forState:UIControlStateNormal];
    [btdel.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [viewbottom addSubview:btdel];
    [btdel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewbottom.mas_right).offset(-25);
        make.top.equalTo(btalldu.mas_top);
        make.height.equalTo(btalldu.mas_height);
        make.width.offset(70);
    }];
    [btdel addTarget:self action:@selector(selectdelAction) forControlEvents:UIControlEventTouchUpInside];
    [btdel.layer setMasksToBounds:YES];
    [btdel.layer setCornerRadius:15];
    [btdel.layer setBorderColor:RGB(236, 236, 236).CGColor];
    [btdel.layer setBorderWidth:1];
}

-(void)setTitle{
    UILabel *las=[[UILabel alloc]initWithFrame:CGRectMake(kMainScreenW/2.0-70.0, kMainScreenH/2.0-40.0, 140.0, 20.0)];
    las.textAlignment=NSTextAlignmentCenter;
    las.text=@"当前没有消息";
    [self addSubview:las];
}

- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(void)editAction
{
    for(MyInformMainModel *model in _arrData)
    {
        model.isselect = NO;
    }
    [_tableview reloadData];
    [btdel setTitleColor:RGB(225, 225, 225) forState:UIControlStateNormal];
    [btalldu setTitleColor:RGB(50, 50, 50) forState:UIControlStateNormal];
    
    if(_isedit)
    {
        [UIView animateWithDuration:0.3 animations:^{
            [_tableview setHeight:self.frame.size.height-50];
        } completion:^(BOOL finished) {
            
        }];
        
        [viewbottom setHidden:NO];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            [_tableview setHeight:self.frame.size.height];
        } completion:^(BOOL finished) {
            
        }];
        
        [viewbottom setHidden:YES];
    }
    
    
}

///判断在编辑状态下是否有选中的
-(BOOL)isselectitem
{
    if(_isedit==NO)return NO;
    
    BOOL isyouselect = NO;
    for(MyInformMainModel *model in _arrData)
    {
        if(model.isselect)
        {
            isyouselect = YES;
            break;
        }
    }
    return isyouselect;
}
#pragma mark - 全部已读
-(void)allduAction
{
    if([self isselectitem])
    {
        return;
    }
    if(_datacontrol == nil)
    {
        _datacontrol = [MyInformMessageDataController new];
    }
    NSString *strtoken = [NSString nullToString:[MDB_UserDefault defaultInstance].usertoken];
    NSDictionary *parameters=@{@"userkey":strtoken,@"id":@"all",@"msg_type":@"system"};
    
    [_datacontrol requestMyInformReadMessageInView:self dicpush:parameters Callback:^(NSError *error, BOOL state, NSString *describle) {
        if(state)
        {
            for(MyInformMainModel *model in _arrData)
            {
                model.isread = @"1";
            }
            [_tableview reloadData];
            
            _isedit = NO;
            [self editAction];
            [self.delegate iseditchange];
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self];
        }
        
    }];
    
    
}
#pragma mark - 删除选中
-(void)selectdelAction
{
    if([self isselectitem] == NO)
    {
        return;
    }
    NSString *strtemp = @"";
    NSMutableArray *arrtemp = [NSMutableArray new];
    for(MyInformMainModel *model in _arrData)
    {
        if(model.isselect)
        {
            if(strtemp.length <1)
            {
                strtemp = [NSString stringWithFormat:@"%@",model.did];
            }
            else
            {
                strtemp = [NSString stringWithFormat:@"%@,%@",strtemp,model.did];
            }
            [arrtemp addObject:model];
            
        }
    }
    if(_datacontrol == nil)
    {
        _datacontrol = [MyInformMessageDataController new];
    }
    
    
    NSDictionary *parameters = @{@"userkey" : [NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                                 @"id" : strtemp};
    [_datacontrol requestMyInformDelMessageInView:self dicpush:parameters Callback:^(NSError *error, BOOL state, NSString *describle) {
        if(state)
        {
            [_arrData removeObjectsInArray:arrtemp];
            [_tableview reloadData];
            [self.delegate iseditchange];
            _isedit = NO;
            [self editAction];
            if(_arrData.count<20)
            {
                _p+=1;
                [self footReloadTableViewDateSource];
            }
            
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self];
        }
        
    }];
    
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (_arrData&&_arrData.count>0) {
        return 1;
    }else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    MyInformTableViewCell *cell = [self setCellWithBool:NO indexPath:indexPath tableview:tableView];
    MyInformTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    cell.isedit = _isedit;
    
    cell.model = _arrData[indexPath.row];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 调整Separator位置
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(_isedit)
    {
        return NO;
    }
    else
    {
        return YES;
    }
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle ==UITableViewCellEditingStyleDelete) {
        NSMutableArray *arrayOfRows = [NSMutableArray arrayWithArray:_arrData];
        if (indexPath.row<[arrayOfRows count]) {
            if ([self.delegate respondsToSelector:@selector(tableViewDidDeleteRowWithNewsID:didComplete:)]) {
                __weak __typeof__(self) weakself = self;
                MyInformMainModel *model = _arrData[indexPath.row];
                [self.delegate tableViewDidDeleteRowWithNewsID:[NSString nullToString:model.did] didComplete:^(BOOL state) {
                    if (state) {
                        __strong __typeof__(weakself) strongself = weakself;
                        [arrayOfRows removeObjectAtIndex:indexPath.row];
                        strongself.arrData = arrayOfRows.mutableCopy;
                        @try
                        {
                            if(arrayOfRows.count>0)
                            {
                                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                            }
                            else
                            {
                                [tableView reloadData];
                                
                                 [self reloadTableViewDataSource];
                                
                            }
                            
                        }
                        @catch(NSException *exc)
                        {
                            
                        }
                        @finally
                        {
                            
                        }
                        
                    }else{
                        @try
                        {
                            if(arrayOfRows.count>0)
                            {
                                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
                            }
                            else
                            {
                                [tableView reloadData];
                            }
                            
                        }
                        @catch(NSException *exc)
                        {
                            
                        }
                        @finally
                        {
                            
                        }
                        
                    }
                }];
            }
          
        }
    }
        
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyInformMainModel *model = _arrData[indexPath.row];
    if(_isedit)
    {
        if(model.isselect)
        {
            model.isselect = NO;
        }
        else
        {
            model.isselect = YES;
        }
        BOOL isyou = [self isselectitem];
        if(isyou)
        {
            [btalldu setTitleColor:RGB(225, 225, 225) forState:UIControlStateNormal];
            [btdel setTitleColor:RGB(50, 50, 50) forState:UIControlStateNormal];
        }
        else
        {
            [btdel setTitleColor:RGB(225, 225, 225) forState:UIControlStateNormal];
            [btalldu setTitleColor:RGB(50, 50, 50) forState:UIControlStateNormal];
        }
        [tableView reloadData];
    }
    else
    {
        MyInformTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.textL.textColor = [UIColor colorWithHexString:@"#666666"];
        if ([self.delegate respondsToSelector:@selector(clickToMyInformDetailViewControllerWithDataDic:)]) {
            [self.delegate clickToMyInformDetailViewControllerWithDataDic:model];
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 106 *kScale;
}

#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
    
    _reloading=YES;
    NSDictionary *dica=@{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                         @"p":@"1"};
    [HTTPManager  sendRequestUrlToService:URL_mymessage withParametersDictionry:dica view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct==nil) {
            [self doneLoadingTableViewData];
            
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
        
            if ([[NSString nullToString:[dicAll objectForKey:@"status"]] isEqualToString:@"1"]){
                id arrs=[dicAll objectForKey:@"data"];
                if ([arrs isKindOfClass:[NSArray class]]){
                    NSArray *arrl=(NSArray *)arrs;
                    [_arrData removeAllObjects];
                    
                    for(NSDictionary *dic in arrl)
                    {
                        [_arrData addObject:[MyInformMainModel dicvalueChange:dic]];
                    }
                }
            }
            _p=2;
            [self doneLoadingTableViewData];
//            [self readmessage];
        }
    }];
    
}
/*
-(void)readmessage{
    NSString *strl = @"";
    for (NSDictionary *dic in _arrData) {
        if ([dic[@"isread"] isEqualToString:@"0"]) {
            strl=[strl stringByAppendingString:[NSString stringWithFormat:@",%@",[dic objectForKey:@"id"]]];
        }
    }
    
    
    if (strl) {
        NSString *strtoken = [NSString nullToString:[MDB_UserDefault defaultInstance].usertoken];
        NSDictionary *dica=@{@"userkey":strtoken,@"id":strl};
       [HTTPManager sendRequestUrlToService:URL_readmessage withParametersDictionry:dica view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
            if (responceObjct==nil) {
              
            }else{
                NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
                NSDictionary *dicAll=[str JSONValue];
                if ([[dicAll objectForKey:@"info"]isEqualToString:@"GET_DATA_SUCCESS"]) {
                    [MDB_UserDefault setMessage:NO];
                }
            }
   }];

    }
}

 */

-(void)footReloadTableViewDateSource{
    _foodReloading=YES;
    NSDictionary *dica=@{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                         @"p":[NSString stringWithFormat:@"%@",@(_p)],
                         @"devicetoken":[NSString nullToString:[MDB_UserDefault getUmengDeviceToken]]};

    [HTTPManager sendRequestUrlToService:URL_mymessage withParametersDictionry:dica view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct==nil) {
            [self doneFootLoadingTableViewData];
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[NSString nullToString:[dicAll objectForKey:@"status"]] isEqualToString:@"1"]){
                id arrs=[dicAll objectForKey:@"data"];
                if ([arrs isKindOfClass:[NSArray class]]){
                    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.arrData];
                    
                    for(NSDictionary *dic in arrs)
                    {
                        [tempArray addObject:[MyInformMainModel dicvalueChange:dic]];
                    }
                    
                    self.arrData = tempArray;
                    _p++;
                }
            }
            [self doneFootLoadingTableViewData];
//            [self readmessage];
        }
    }];
}

- (void)doneLoadingTableViewData{
    
    //  model should call this when its done loading
    [_tableview reloadData];
    [_tableview.mj_header endRefreshing];
}

-(void)doneFootLoadingTableViewData{
    [_tableview reloadData];
    [_tableview.mj_footer endRefreshing];

}

//#pragma mark -
//#pragma mark UIScrollViewDelegate Methods
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    _ScrowContentOffSet=scrollView.contentOffset.y;
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    
//    _ScrowContentOffSet=scrollView.contentOffset.y;
//    
//}
//

#pragma mark - MyInformTableHeadViewDelegate
- (void)tableHeaderViewDidClickItemWithType:(HeaderViewClickControlType)type{
    [_headView reamrkRemindViewShow:YES];
    if (type == HeaderViewClickControlTypeCallMe) {
        if ([self.delegate respondsToSelector:@selector(tableViewClickCallMe)]) {
            [self.delegate tableViewClickCallMe];
        }
    }else if (type == HeaderViewClickControlTypeRemark) {
        if ([self.delegate respondsToSelector:@selector(tableViewClickRemark)]) {
            [self.delegate tableViewClickRemark];
        }
    }else if (type == HeaderViewClickControlTypeZan) {
        if ([self.delegate respondsToSelector:@selector(tableViewClickZan)]) {
            [self.delegate tableViewClickZan];
        }
    }else if (type == HeaderViewClickControlTypeOrder) {
        if ([self.delegate respondsToSelector:@selector(tableViewClickOrder)]) {
            [self.delegate tableViewClickOrder];
        }
    }
}



- (void)remindVIsShow: (BOOL) isRemind{
    _isRemind = isRemind;
}

- (void)zanRemindVIsShow:(BOOL)isRemind{
    _isZanRemind = isRemind;
}

- (void)orderRemindVIsShow: (BOOL) isRemind
{
    _isOrderRemind = isRemind;
    if(_headView)
    {
        [_headView orderRemindViewShow:!_isOrderRemind];
    }
    
}

@end
