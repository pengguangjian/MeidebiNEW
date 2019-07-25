//
//  JiangJiaZhiBoTableViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/3/25.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import "JiangJiaZhiBoTableViewController.h"

#import "JiangJiaZhiBoTableViewCell.h"

#import <MJRefresh.h>

#import "JiangJiaZhiBoController.h"

#import "MDBEmptyView.h"

@interface JiangJiaZhiBoTableViewController ()
{
    NSMutableArray *arrdata;
    JiangJiaZhiBoController *dataControl;
    NSInteger ipage;
    
    ///是否显示数据没得了的提示
    BOOL isshowm;
    
}
@property (nonatomic, strong) MDBEmptyView *emptyView;

@end

@implementation JiangJiaZhiBoTableViewController
-(id)initWithStyle:(UITableViewStyle)style
{
    if(self = [super initWithStyle:UITableViewStyleGrouped])
    {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    ipage = 1;
    dataControl = [[JiangJiaZhiBoController alloc] init];
    
    [self emptyView];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //    self.tableView.estimatedRowHeight = 0;
    //    self.tableView.estimatedSectionFooterHeight = 0;
    //    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ipage = 1;
        isshowm = NO;
        [self loadData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        ipage+=1;
        [self loadData];
    }];
    
    [self loadData];
}

-(void)loadData
{
    NSDictionary *dicpush = @{@"p":[NSNumber numberWithInteger:ipage]};
    if(_isvery)
    {
        dicpush = @{@"p":[NSNumber numberWithInteger:ipage],@"order":@"reduction"};
    }
    [dataControl requestJiangJiaZhiBoDataInView:self.view value:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
        if([self.tableView.mj_header isRefreshing])
        {
            [self.tableView.mj_header endRefreshing];
        }
        if([self.tableView.mj_footer isRefreshing])
        {
            [self.tableView.mj_footer endRefreshing];
        }
        
        if(ipage==1)
        {
            arrdata = [NSMutableArray new];
        }
        if(state)
        {
            for(NSDictionary *dic in dataControl.requestResults)
            {
                JiangJiaZhiBoModel *model  = [[JiangJiaZhiBoModel alloc] initValue:dic];
                [arrdata addObject:model];
            }
            
        }
        
        if(arrdata.count>0 && dataControl.requestResults.count == 0)
        {
            isshowm = YES;
        }
        [_emptyView setHidden:YES];
        if(arrdata.count==0)
        {
            [_emptyView setHidden:NO];
        }
        
        
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrdata.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *strcell = @"JiangJiaZhiBoTableViewCell";
    
    JiangJiaZhiBoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strcell];
    if(!cell)
    {
        cell = [[JiangJiaZhiBoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strcell];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.model = arrdata[indexPath.row];
    return cell;
}

//改变行的高度（实现主个代理方法后 rowHeight 设定的高度无效）
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 125.0f;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(isshowm)
    {
        return 50;
    }
    else
    {
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 50)];
    [view setBackgroundColor:[UIColor whiteColor]];
    if(isshowm)
    {
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.width, view.height)];
        [lb setText:@"没有更多数据"];
        [lb setTextColor:RGB(90, 90, 90)];
        [lb setTextAlignment:NSTextAlignmentCenter];
        [lb setFont:[UIFont systemFontOfSize:14]];
        [view addSubview:lb];
        return view;
    }
    else
    {
        [view setHeight:1];
        return view;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 0.1)];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JiangJiaZhiBoModel *model = arrdata[indexPath.row];
    [self.delegate selectItem:model.did];
    model.isSelected = YES;
    
    NSMutableArray *arrbldj = [[NSUserDefaults standardUserDefaults] objectForKey:@"baoliaoyidianji"];
    NSMutableArray *arrtemp = [NSMutableArray new];
    [arrtemp addObjectsFromArray:arrbldj];
    BOOL isbool = [arrtemp containsObject: [NSString stringWithFormat:@"%@", model.did]];
    if(isbool==NO)
    {
        if(arrtemp.count>=200)
        {
            [arrtemp removeLastObject];
        }
        
        [arrtemp insertObject:[NSString stringWithFormat:@"%@",model.did] atIndex:0];
        
    }
    [[NSUserDefaults standardUserDefaults] setObject:arrtemp forKey:@"baoliaoyidianji"];
    [tableView reloadData];
}

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


@end
