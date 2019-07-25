//
//  MyCouponsTableView.m
//  Meidebi
//  我的优惠券
//  Created by 杜非 on 15/2/12.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import "MyCouponsTableView.h"
#import "MDB_UserDefault.h"
#import "MyCouponsTableViewCell.h"
#import "HTTPManager.h"
#import "Juancle.h"
@implementation MyCouponsTableView{
    
    NSInteger  _p;
    float _ScrowContentOffSet;
    BOOL _tbool;
}
@synthesize arrData=_arrData;
@synthesize reloading=_reloading;
@synthesize foodReloading=_foodReloading;

@synthesize delegate=_delegate;
-(id)initWithFrame:(CGRect)frame delegate:(id)delegate istimeOut:(BOOL)tbool{
    if (self) {
        self=[super initWithFrame:frame];
    }
    UIView *vies=[[UIView alloc]initWithFrame:CGRectMake(0, 80, 20, 20)];
    [self addSubview:vies];
    _p=1;
    _delegate=delegate;
    _tbool=tbool;
    _ScrowContentOffSet=0.0f;
    NSDictionary *dic=@{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                        @"limit":@"20",
                        @"page":@"1",
                        @"istimeout":[NSString stringWithFormat:@"%@",@(_tbool)]
                        };
    _arrData=[[NSMutableArray alloc]init];
    [HTTPManager sendRequestUrlToService:URL_mycoupon withParametersDictionry:dic view:self.superview completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct==nil) {
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[dicAll objectForKey:@"info"]isEqualToString:@"GET_DATA_SUCCESS"]) {
                _p=2;
                id arrs=[NSMutableArray arrayWithArray:[dicAll objectForKey:@"data"]];
                if ([arrs isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dais in arrs) {
                        if ([[dais objectForKey:@"timeout"] boolValue]==_tbool) {
                            [_arrData addObject:dais];
                        }
                    }
                }
                if (_arrData.count>0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _tableview=[[UITableView alloc]init];
                        [self addSubview:_tableview];
                        [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.edges.equalTo(self);
                        }];
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
                    });
                }else{
                    [self setTitle];
                }
            }
        }
    }];
    return self;
    
}
-(void)setTitle{
    UILabel *las=[[UILabel alloc]initWithFrame:CGRectMake(kMainScreenW/2.0-70.0, kMainScreenH/2.0-40.0, 140.0, 20.0)];
    las.textAlignment=NSTextAlignmentCenter;
    las.text=@"暂时没有数据";
    [self addSubview:las];
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
    MyCouponsTableViewCell *cell = [self setCellWithBool:NO indexPath:indexPath tableview:tableView];
cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(MyCouponsTableViewCell *)setCellWithBool:(BOOL)boolCell indexPath:(NSIndexPath *)indexPath tableview:(UITableView *)tableView{
    if (_arrData.count>indexPath.row) {
    NSDictionary *dicS=_arrData[indexPath.row];
    static NSString *CellIdentifier = @"Cell";
    MyCouponsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"MyCouponsTableViewCell" owner:self options:nil];
        for (id obj in nib) {
            if ([obj isKindOfClass:[MyCouponsTableViewCell class]]) {
                cell=(MyCouponsTableViewCell *)obj;
            }
        }
    }
     cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [[MDB_UserDefault defaultInstance]setViewWithImage:cell.headImv url:[dicS objectForKey:@"imgUrl"]];
    if (![[dicS objectForKey:@"title"] isKindOfClass:[NSNull class]]) {
    cell.titleLabel.text=[NSString stringWithFormat:@"%@",[dicS objectForKey:@"title"]];
    }
    if (![[dicS objectForKey:@"card"] isKindOfClass:[NSNull class]]) {
    cell.codeLabel.text=[NSString stringWithFormat:@"%@",[dicS objectForKey:@"card"]];
    }
    cell.timestarLabel.text=[MDB_UserDefault strTimefromData:[[dicS objectForKey:@"usestart"] integerValue] dataFormat:nil];
    cell.timeendLabel.text=[MDB_UserDefault strTimefromData:[[dicS objectForKey:@"useend"] integerValue] dataFormat:nil];
    if (![[dicS objectForKey:@"pass"] isKindOfClass:[NSNull class]]) {
    cell.passLabel.text=[[dicS objectForKey:@"pass"]isEqualToString:@""]?@"无密码":[dicS objectForKey:@"pass"];
    }
    if (![[dicS objectForKey:@"timeout"] isKindOfClass:[NSNull class]]) {
    if ( [[dicS objectForKey:@"timeout"]isEqualToString:@"1"]) {
        cell.isuseLabel.text=@"过期";
        [cell.userView setBackgroundColor:RGB(220.0, 220.0, 220.0)];
    }else{
        cell.isuseLabel.text=@"复制券码";
        cell.isuseLabel.numberOfLines=2;
        [cell.userView setBackgroundColor:RadMenuColor];
    }
    }
    return cell;
    }else{
        return nil;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCouponsTableViewCell *cell=(MyCouponsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = cell.codeLabel.text;
    if ([cell.isuseLabel.text isEqualToString:@"过期"]) {
        
    }else{
    [_delegate tableViewSelecte:nil];
    }
}
//改变行的高度（实现主个代理方法后 rowHeight 设定的高度无效）
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 117.0;
}
#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
    NSDictionary *dic=@{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                        @"limit":@"20",
                        @"page":@"1",
                        @"istimeout":[NSString stringWithFormat:@"%@",@(_tbool)]
                        };
    
    _reloading =YES;
    [HTTPManager  sendRequestUrlToService:URL_mycoupon withParametersDictionry:dic view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct==nil) {
          //  [self doneLoadingTableViewData];
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
             if ([[dicAll objectForKey:@"info"]isEqualToString:@"GET_DATA_SUCCESS"]) {
                 _p=2;
                 id arrs=[NSMutableArray arrayWithArray:[dicAll objectForKey:@"data"]];
                 if ([arrs isKindOfClass:[NSArray class]]) {
                     if ([arrs count] > 0){
                         [_arrData removeAllObjects];
                         for (NSDictionary *dais in arrs) {
                             if ([[dais objectForKey:@"timeout"] boolValue]==_tbool) {
                                 [_arrData addObject:dais];
                             }
                         }
                     }
                 }
           
             }
             [self doneLoadingTableViewData];
        }
    }];
}
-(void)footReloadTableViewDateSource{
    _foodReloading=YES;
    NSDictionary *dic=@{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                        @"limit":@"20",
                        @"page":[NSString stringWithFormat:@"%@",@(_p)],
                        @"istimeout":[NSString stringWithFormat:@"%@",@(_tbool)]
                        };
    [HTTPManager  sendRequestUrlToService:URL_mycoupon withParametersDictionry:dic view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct==nil) {
            [self doneFootLoadingTableViewData];
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[dicAll objectForKey:@"info"]isEqualToString:@"GET_DATA_SUCCESS"]) {
                    _p++;
                 id arrs=[NSMutableArray arrayWithArray:[dicAll objectForKey:@"data"]];
                if ([arrs isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dais in arrs) {
                        if ([[dais objectForKey:@"timeout"] boolValue]==_tbool) {
                            BOOL arrbool=YES;
                            for (NSDictionary *dicAis in _arrData) {
                                if ([[dicAis objectForKey:@"id"] intValue]==[[dais objectForKey:@"id"] intValue]) {
                                    arrbool=NO;
                                }
                            }
                            if (arrbool) {
                                [_arrData addObject:dais];
                            }
                            
                        }
                    }
                }
                     
                 
                }
            [self doneFootLoadingTableViewData];
            
        }
    }];
    
}
- (void)doneLoadingTableViewData{
    
    //  model should call this when its done loading
    _reloading = NO;
    [_tableview reloadData];
    [_tableview.mj_header endRefreshing];
}

-(void)doneFootLoadingTableViewData{
    _foodReloading=NO;
    [_tableview reloadData];
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
