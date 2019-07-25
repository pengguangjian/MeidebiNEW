//
//  NewsTableView.m
//  Meidebi
//
//  Created by 杜非 on 15/2/9.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import "NewsTableView.h"
#import "MDB_UserDefault.h"
#import "NewsTableviewCell.h"
#import "HTTPManager.h"

@implementation NewsTableView{
    int  _p;
    float  _ScrowContentOffSet;
}

@synthesize arrData=_arrData;
@synthesize reloading=_reloading;
@synthesize foodReloading=_foodReloading;
@synthesize delegate=_delegate;

-(id)initWithFrame:(CGRect)frame delegate:(id)delegat{
    if (self) {
        self=[super initWithFrame:frame];
    }
    _arrData=[[NSMutableArray alloc]init];
    UIView *vies=[[UIView alloc]initWithFrame:CGRectMake(0, 80, 20, 20)];
    [self addSubview:vies];
    _delegate=delegat;
    _p=1;
    _ScrowContentOffSet=0.0f;
    NSDictionary *dic=@{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],@"page":@"1",@"limit":@"10"};
    [HTTPManager sendGETRequestUrlToService:URL_mylink withParametersDictionry:dic view:self completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct==nil) {
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            
            NSDictionary *dicAll=[str JSONValue];
            
            if ([[dicAll objectForKey:@"info"]isEqualToString:@"GET_DATA_SUCCESS"]) {
                id arrdic=[dicAll objectForKey:@"data"];
                if ([arrdic isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dicmanage in arrdic) {
                        myBorkeNews *borkeNew=[[myBorkeNews alloc]init];
                        [borkeNew objectWithDictionary:dicmanage];
                        [_arrData addObject:borkeNew];
                    }
                }
            }
            if (_arrData.count>0) {
                _p++;
                _tableview=[[UITableView alloc]init];
                [_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
                _tableview.delegate=self;
                _tableview.dataSource=self;
                _tableview.estimatedRowHeight = 0;
                _tableview.estimatedSectionHeaderHeight = 0;
                _tableview.estimatedSectionFooterHeight = 0;
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
    
//    [HTTPManager  sendRequestUrlToService:URL_mylink withParametersDictionry:dic view:self completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
//        if (responceObjct==nil) {
//        }else{
//            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
//
//            NSDictionary *dicAll=[str JSONValue];
//
//            if ([[dicAll objectForKey:@"info"]isEqualToString:@"GET_DATA_SUCCESS"]) {
//                id arrdic=[dicAll objectForKey:@"data"];
//                if ([arrdic isKindOfClass:[NSArray class]]) {
//                    for (NSDictionary *dicmanage in arrdic) {
//                        myBorkeNews *borkeNew=[[myBorkeNews alloc]init];
//                        [borkeNew objectWithDictionary:dicmanage];
//                        [_arrData addObject:borkeNew];
//                    }
//                }
//            }
//            if (_arrData.count>0) {
//                _p++;
//                _tableview=[[UITableView alloc]init];
//                [_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//                _tableview.delegate=self;
//                _tableview.dataSource=self;
//                _tableview.estimatedRowHeight = 0;
//                _tableview.estimatedSectionHeaderHeight = 0;
//                _tableview.estimatedSectionFooterHeight = 0;
//                _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//                    [self reloadTableViewDataSource];
//                }];
//                _tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//                    [self footReloadTableViewDateSource];
//                }];
//                [self addSubview:_tableview];
//                [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.edges.equalTo(self);
//                }];
//            }else{
//                [self setTitle];
//            }
//        }
//    }];
    
    
    return self;
}

-(void)setTitle{
    UILabel *las=[[UILabel alloc]initWithFrame:CGRectMake(kMainScreenW/2.0-70.0, kMainScreenH/2.0-40.0, 140.0, 20.0)];
    las.textAlignment=NSTextAlignmentCenter;
    las.text=@"当前没有爆料";
    [self addSubview:las];
}

-(void)footReloadTableViewDateSource{
    _foodReloading=YES;
    NSDictionary *dic=@{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],@"page":[NSString stringWithFormat:@"%i",_p],@"limit":@"10"};
    [HTTPManager  sendGETRequestUrlToService:URL_mylink withParametersDictionry:dic view:self completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct==nil) {
            
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[dicAll objectForKey:@"status"]intValue]) {
                _p++;
                id arrdic=[dicAll objectForKey:@"data"];
                if ([arrdic isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dicmanage in arrdic) {
                        myBorkeNews *borkeNew=[[myBorkeNews alloc]init];
                        [borkeNew objectWithDictionary:dicmanage];
                        BOOL isSave=YES;
                        for (myBorkeNews * myborke in _arrData) {
                            if ([myborke.artid isEqualToNumber:borkeNew.artid]) {
                                isSave=NO;
                            }
                        }
                        if (isSave) {
                          [_arrData addObject:borkeNew];
                        }
                    }
                }
            }
            [self doneFootLoadingTableViewData];
        }
    }];
    
}
- (void)reloadTableViewDataSource{
    _reloading=YES;
    NSDictionary *dic=@{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],@"page":@"1",@"limit":@"10"};
    [HTTPManager  sendGETRequestUrlToService:URL_mylink withParametersDictionry:dic view:self completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct==nil) {

        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[dicAll objectForKey:@"status"]intValue]) {
                _p=2;
                id arrdic=[dicAll objectForKey:@"data"];
                if ([arrdic isKindOfClass:[NSArray class]]) {
                    [_arrData removeAllObjects];
                    for (NSDictionary *dicmanage in arrdic) {
                        myBorkeNews *borkeNew=[[myBorkeNews alloc]init];
                        [borkeNew objectWithDictionary:dicmanage];
                        [_arrData addObject:borkeNew];
                    }
                }
            }
             [self doneLoadingTableViewData];
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
    
    NewsTableviewCell *cell = [self setCellWithindexPath:indexPath tableview:tableView];
    return cell;
    
}
-(NewsTableviewCell *)setCellWithindexPath:(NSIndexPath *)indexPath tableview:(UITableView *)tableView{
    myBorkeNews *myborkeNews=[_arrData objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"ShareCell";
    
    NewsTableviewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"NewsTableviewCell" owner:self options:nil];
        for (id obj in nib) {
            if ([obj isKindOfClass:[NewsTableviewCell class]]) {
                cell=(NewsTableviewCell *)obj;
            }
        }
    }
    [[MDB_UserDefault defaultInstance] setViewWithImage:cell.headImv url:myborkeNews.image];
    cell.titleLabel.text=myborkeNews.title;
    if (myborkeNews.linktype.integerValue == 2 && ![@"" isEqualToString:[NSString nullToString:myborkeNews.prodescription]]) {
        cell.moneyLabel.text = myborkeNews.prodescription;
    }else{
        cell.moneyLabel.text=[NSString stringWithFormat:@"¥%@",myborkeNews.price];
    }
    cell.marketLabel.text=myborkeNews.sitename;
    cell.timeLabel.text=[MDB_UserDefault strTimefromDatas:myborkeNews.createtime dataFormat:nil];
    cell.stateLabel.text=[NSString nullToString:myborkeNews.statustext];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if(myborkeNews.ishot.integerValue == 1 || myborkeNews.isagthot.integerValue == 1)
    {
        [cell.jingLabel setHidden:NO];
    }
    else
    {
        [cell.jingLabel setHidden:YES];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_delegate tableViewSelecte:_arrData[indexPath.row]];
    
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
    
    return 145.0f;
    
}
#pragma mark -
#pragma mark Data Source Loading / Reloading Methods


- (void)doneLoadingTableViewData{
    
    //  model should call this when its done loading
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
