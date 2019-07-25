//
//  MyhouseTableView.m
//  Meidebi
//
//  Created by 杜非 on 15/2/10.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import "MyhouseTableView.h"
#import "MDB_UserDefault.h"
#import "HTTPManager.h"
#import "MyhouseTableViewCell.h"
#import <MJRefresh/MJRefresh.h>

@implementation MyhouseTableView{
    int  _p;
    float  _ScrowContentOffSet;
}

@synthesize arrData=_arrData;
@synthesize reloading=_reloading;
@synthesize foodReloading=_foodReloading;
@synthesize delegate=_delegate;
@synthesize ftype=_ftype;

-(id)initWithFrame:(CGRect)frame delegate:(id)delegat ftype:(NSInteger)ftype{
    if (self) {
        self=[super initWithFrame:frame];
    }
    UIView *vies=[[UIView alloc]initWithFrame:CGRectMake(0, 80, 20, 20)];
    [self addSubview:vies];
    _delegate=delegat;
    _p=1;
    _ScrowContentOffSet=0.0f;
    _ftype=ftype;
    //（默认ipad主页面）1 主页面 2 签到页面 3 推送设置（暂时屏蔽） 4 收藏页面 5退出登录（移动端清楚缓存）
    //（type＝4时 ，可增加参数ftype，limit，page，ftype为收藏类型，如收藏的单品 ftype为1，ftype默认为1，page默认1，limit默认10）（ftype 1 单品  4 晒单 5 券交易 2 活动 3 优惠券）
    NSDictionary *dic=@{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                        @"type":@"4",
                        @"limit":@"20",
                        @"page":@"1",
                        @"ftype":[NSString stringWithFormat:@"%@",@(_ftype)]
                        };
    [HTTPManager  sendRequestUrlToService:URL_usercenter withParametersDictionry:dic view:self.superview completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct==nil) {
            
            
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            
            NSDictionary *dicAll=[str JSONValue];
         
            if ([[dicAll objectForKey:@"status"] intValue] == 1) {
                id arrdic=[dicAll objectForKey:@"data"];
                if ([arrdic isKindOfClass:[NSArray class]]) {
                   // DFManagedObjectModel *manageModel=[MDB_UserDefault currentCoreDataManager];
                    NSMutableArray *muta=[[NSMutableArray alloc]init];
                    if (_ftype==1) {
                        for (NSDictionary *dicmanage in arrdic) {
                            myhousejuancel *junacl=[[myhousejuancel alloc]initWithdic:dicmanage];
                            [muta addObject:junacl];
                        }
                    }else if (_ftype==4){
                        for (NSDictionary *dicmanage in arrdic) {
                            myhousejuancel *junacl=[[myhousejuancel alloc]initWithdic:dicmanage];
                            [muta addObject:junacl];
                        }
                    }else if(_ftype==5){
                        
                        for (NSDictionary *dicmanage in arrdic) {
                            myhousejuancel *junacl=[[myhousejuancel alloc]initWithdic:dicmanage];
                            [muta addObject:junacl];
                        }
                    }else if(_ftype==6){
                        
                        for (NSDictionary *dicmanage in arrdic) {
                            myhousejuancel *junacl=[[myhousejuancel alloc]initWithdic:dicmanage];
                            [muta addObject:junacl];
                        }
                    }
                    
                    _arrData=[NSMutableArray arrayWithArray:muta];
                }
                
                
            }
            if (_arrData.count>0) {
                _p++;
                _tableview=[[UITableView alloc]init];
                [_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
                _tableview.delegate=self;
                _tableview.dataSource=self;
                _tableview.estimatedRowHeight = 0;
                _tableview.estimatedSectionFooterHeight = 0;
                _tableview.estimatedSectionHeaderHeight = 0;
                _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                    [self reloadTableViewDataSource];
                }];
                _tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                    [self footReloadTableViewDateSource];
                }];
                [self addSubview:_tableview];
                [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self);
                }];
            }else{
                [self setTitle];
            }
        }
    }];
    return self;
}

-(void)setTitle{
    UILabel *las=[[UILabel alloc]initWithFrame:CGRectMake(kMainScreenW/2.0-70.0, kMainScreenH/2.0-40.0, 140.0, 20.0)];
    las.textAlignment=NSTextAlignmentCenter;
    las.text=@"当前没有收藏";
    [self addSubview:las];
}

-(void)footReloadTableViewDateSource{
    _foodReloading=YES;
    NSDictionary *dic=@{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                        @"type":@"4",
                        @"limit":@"20",
                        @"page":[NSString stringWithFormat:@"%i",_p],
                        @"ftype":[NSString stringWithFormat:@"%@",@(_ftype)]
                        };
    [HTTPManager  sendRequestUrlToService:URL_usercenter withParametersDictionry:dic view:self completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct==nil) {
            [self doneLoadingTableViewData];
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[dicAll objectForKey:@"status"] intValue] == 1) {
                id arrdic=[dicAll objectForKey:@"data"];
                if ([arrdic isKindOfClass:[NSArray class]]) {
                    _p++;
                    NSMutableArray *muta=[[NSMutableArray alloc]init];
                    if (_ftype==1) {
                        for (NSDictionary *dicmanage in arrdic) {
                            myhousejuancel *junacl=[[myhousejuancel alloc]initWithdic:dicmanage];
                            [muta addObject:junacl];
                        }
                    }else if (_ftype==4){
                        for (NSDictionary *dicmanage in arrdic) {
                            myhousejuancel *junacl=[[myhousejuancel alloc]initWithdic:dicmanage];
                            [muta addObject:junacl];
                        }
                    }else if(_ftype==5){
                        for (NSDictionary *dicmanage in arrdic) {
                            myhousejuancel *junacl=[[myhousejuancel alloc]initWithdic:dicmanage];
                            [muta addObject:junacl];
                        }
                    }else if(_ftype==6){
                        for (NSDictionary *dicmanage in arrdic) {
                            myhousejuancel *junacl=[[myhousejuancel alloc]initWithdic:dicmanage];
                            [muta addObject:junacl];
                        }
                    }
                    for (myhousejuancel *myhous in muta) {
                        bool myhoseBool=YES;
                        for (myhousejuancel *myharr in _arrData) {
                            if ([myharr.juanid isEqualToString:myhous.juanid]) {
                                myhoseBool=NO;
                            }
                        }
                        if (myhoseBool) {
                            [_arrData addObject:myhous];
                        }
                    }
                    [self doneFootLoadingTableViewData];
                }
            }
        }
    }];
}
-(void)reloadTableViewDataSource{
    _reloading=YES;
    NSDictionary *dic=@{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                        @"type":@"4",
                        @"limit":@"20",
                        @"page":@"1",
                        @"ftype":[NSString stringWithFormat:@"%@",@(_ftype)]
                        };
    [HTTPManager  sendRequestUrlToService:URL_usercenter withParametersDictionry:dic view:self completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct==nil) {
            [self doneLoadingTableViewData];
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            [_arrData removeAllObjects];
            if ([[dicAll objectForKey:@"status"] intValue] == 1) {
                id arrdic=[dicAll objectForKey:@"data"];
                if ([arrdic isKindOfClass:[NSArray class]]) {
                    _p=2;
                    // DFManagedObjectModel *manageModel=[MDB_UserDefault currentCoreDataManager];
                    NSMutableArray *muta=[[NSMutableArray alloc]init];
                    if (_ftype==1) {
                        for (NSDictionary *dicmanage in arrdic) {
                            myhousejuancel *junacl=[[myhousejuancel alloc]initWithdic:dicmanage];
                            [muta addObject:junacl];
                        }
                    }else if (_ftype==4){
                        for (NSDictionary *dicmanage in arrdic) {
                            myhousejuancel *junacl=[[myhousejuancel alloc]initWithdic:dicmanage];
                            [muta addObject:junacl];
                        }
                    }else if(_ftype==5){
                        for (NSDictionary *dicmanage in arrdic) {
                            myhousejuancel *junacl=[[myhousejuancel alloc]initWithdic:dicmanage];
                            [muta addObject:junacl];
                        }
                    }else if(_ftype==6){
                        for (NSDictionary *dicmanage in arrdic) {
                            myhousejuancel *junacl=[[myhousejuancel alloc]initWithdic:dicmanage];
                            [muta addObject:junacl];
                        }
                    }
                    [_arrData addObjectsFromArray:muta];
                     [self doneLoadingTableViewData];
                }
            }
        }
    }];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyhouseTableViewCell *cell = [self setCellWithindexPath:indexPath tableview:tableView];
    return cell;
    
}
-(MyhouseTableViewCell *)setCellWithindexPath:(NSIndexPath *)indexPath tableview:(UITableView *)tableView{
   
    
    static NSString *CellIdentifier = @"ShareCell";
    
    MyhouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"MyhouseTableViewCell" owner:self options:nil];
        for (id obj in nib) {
            if ([obj isKindOfClass:[MyhouseTableViewCell class]]) {
                cell=(MyhouseTableViewCell *)obj;
            }
        }
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (_ftype==1) {
        [cell.youhuipriceLabel setTextColor:RadMenuColor];
        myhousejuancel *share=[_arrData objectAtIndex:indexPath.row];
        [[MDB_UserDefault defaultInstance] setViewWithImage:cell.headImv url:share.strImgUrl];
        if (![share.strUp isKindOfClass:[NSNull class]]) {
            cell.priceLabel.text=@"";
            cell.titleLabel.text = [NSString stringWithFormat:@"%@",share.strUp];
        }
        cell.timeLabel.text=@"";
        if (![share.strDown isKindOfClass:[NSNull class]]) {
            cell.youhuipriceLabel.text=[NSString stringWithFormat:@"%@",share.strDown];
        }
        if ([share.statue isEqualToString:@"1"]) {
            cell.pastDateImageView.hidden = NO;
        }else{
            cell.pastDateImageView.hidden = YES;
        }
        
    }else if (_ftype==4){//晒单
        myhousejuancel *share=[_arrData objectAtIndex:indexPath.row];
        [[MDB_UserDefault defaultInstance] setViewWithImage:cell.headImv url:share.strImgUrl];
        cell.priceLabel.text=@"";
        if (![share.strUp isKindOfClass:[NSNull class]]) {
        cell.titleLabel.text=@"";
        cell.titlejuzhongLabel.text = [NSString stringWithFormat:@"%@",share.strUp];
        }
        if (![share.strDown isKindOfClass:[NSNull class]]) {
        cell.timeLabel.text=@"";
        }
        if ([share.statue isEqualToString:@"1"]) {
            cell.pastDateImageView.hidden = NO;
        }else{
            cell.pastDateImageView.hidden = YES;
        }
    }else if (_ftype==5){//卷交易
        myhousejuancel *share=[_arrData objectAtIndex:indexPath.row];
        [[MDB_UserDefault defaultInstance] setViewWithImage:cell.headImv url:share.strImgUrl];
        if (![share.strUp isKindOfClass:[NSNull class]]) {
            cell.titlejuzhongLabel.text=share.strUp;
            cell.titleLabel.text = @"";
        }
        if (![share.strDown isKindOfClass:[NSNull class]]) {
            [cell.youhuipriceLabel setTextColor:RadMenuColor];
            cell.timeLabel.text = @"";
            cell.priceLabel.text = @"";
            
        }
        if ([share.statue isEqualToString:@"1"]) {
            cell.pastDateImageView.hidden = NO;
        }else{
            cell.pastDateImageView.hidden = YES;
        }
    }else if (_ftype==6){//专题
        myhousejuancel *share=[_arrData objectAtIndex:indexPath.row];
        [[MDB_UserDefault defaultInstance] setViewWithImage:cell.headImv url:share.strImgUrl];
        if (![share.strUp isKindOfClass:[NSNull class]]) {
            cell.titleLabel.text=share.strUp;
        }
        cell.timeLabel.hidden = YES;
        cell.priceLabel.hidden = YES;
        if ([share.statue isEqualToString:@"1"]) {
            cell.pastDateImageView.hidden = NO;
        }else{
            cell.pastDateImageView.hidden = YES;
        }
    }

    
   
   
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [_delegate tableViewSelecte:_arrData[indexPath.row] ftype:_ftype];
    
}
-(void)setCellWithURL:(NSString *)URL cell:(UIImageView *)imgeV boos:(BOOL)bools{
    if (bools) {
        [[MDB_UserDefault defaultInstance] setViewWithImage:imgeV url:URL options:SDWebImageHighPriority];
    }else{
        [[MDB_UserDefault defaultInstance] setViewWithImage:imgeV url:URL];
    }
    
}
//改变行的高度（实现主个代理方法后 rowHeight 设定的高度无效）
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 86.0f;
    
}
#pragma mark -
#pragma mark Data Source Loading / Reloading Methods


- (void)doneLoadingTableViewData{
    _reloading = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableview reloadData];
    });
    [_tableview.mj_header endRefreshing];
}

-(void)doneFootLoadingTableViewData{
    _foodReloading=NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableview reloadData];
    });
    [_tableview.mj_footer endRefreshing];
 
}
#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _ScrowContentOffSet=scrollView.contentOffset.y;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    _ScrowContentOffSet=scrollView.contentOffset.y;
    
}

@end
