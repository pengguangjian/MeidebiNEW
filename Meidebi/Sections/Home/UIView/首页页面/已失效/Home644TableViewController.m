//
//  Home644TableViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/6/27.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "Home644TableViewController.h"
#import "ContentCell.h"
#import "MDB_UserDefault.h"
#import <MJRefresh/MJRefresh.h>
#import "GMDCircleLoader.h"

#import "JingXuanYuanChuangTableViewCell.h"

static NSString *cellIdentifier = @"cellhome";
static NSString *cellIdentifier1 = @"cell1home";

@interface Home644TableViewController ()
{
    float flasty;
    
    ///分页数据
    int inowpage;
    
    ///精选需要用到的 记录上次原创的
    NSString *strold_artice;
    
    BOOL isjiazai;
    
}
@property (nonatomic, strong) Home644DataController *dataController;
@property (nonatomic, strong) GMDCircleLoader *hudView;
@property (nonatomic, assign) NSInteger lastContentOffset;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *topSectionContairView;
@property (nonatomic, assign) CGFloat dynamicHight;
@property (nonatomic, assign) NSInteger scorllDownSum;
@property (nonatomic, assign) NSInteger scorllUpSum;
//@property (nonatomic, strong) UIButton *btzhiding;



///列表数据
@property (nonatomic, strong) NSMutableArray *arrListData;

@end

@implementation Home644TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (!_dataController) {
        _dataController = [[Home644DataController alloc] init];
    }
    strold_artice = @"";
    inowpage = 1;
    
//    [self.tableView setScrollEnabled:NO];
    
    
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(self.topView.height, 0, 0, 0);
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.topView.height)];
    self.tableView.tableHeaderView = tableHeaderView;
    
    
    flasty = 0.0;
    
    [self setExtraCellLineHidden:self.tableView];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    
//    _btzhiding = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50*kScale, 50*kScale)];
//    [_btzhiding.layer setMasksToBounds:YES];
//    [_btzhiding.layer setCornerRadius:_btzhiding.height/2.0];
//    [_btzhiding setRight:self.view.width-10];
//    [_btzhiding setBottom:self.view.height+60];
//    [_btzhiding setImage:[UIImage imageNamed:@"zhiding_list"] forState:UIControlStateNormal];
//    [_btzhiding setBackgroundColor:RGB(248, 248, 248)];
//    [self.view addSubview:_btzhiding];
//    [_btzhiding addTarget:self action:@selector(topScrollAction) forControlEvents:UIControlEventTouchUpInside];
    
    if([_itemtype isEqualToString:@"0"])
    {
        [self loadListData];
    }
    else
    {
        [self loadListData];
    }
    
    
}

-(void)loadFirstListData
{
//    if(_arrListData.count == 0)
//    {
//        [self loadListData];
//    }
    NSLog(@"123");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)scrollTop{
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

- (void)reloadTableViewDataSource{

    inowpage = 1;
    [self loadListData];
    
}

- (void)footReloadTableViewDateSource{

    inowpage++;
    [self loadListData];
}

-(void)loadListData
{
    
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    NSString *strurl = @"";
    
    [dicpush setObject:[NSString stringWithFormat:@"%d",inowpage] forKey:@"page"];
    if(isjiazai == NO && inowpage == 1)
    {
        isjiazai = YES;
        if([_itemtype isEqualToString:@"0"])
        {
            [dicpush setObject:[NSString stringWithFormat:@"%d",10] forKey:@"pagesize"];
        }
        else
        {
            [dicpush setObject:[NSString stringWithFormat:@"%d",5] forKey:@"pagesize"];
        }
        
        
    }
    else
    {
        [dicpush setObject:[NSString stringWithFormat:@"%d",20] forKey:@"pagesize"];
    }
    
    UIView *viewtemp = nil;
    
    if([_itemtype isEqualToString:@"0"])
    {///精选
        
        [dicpush setObject:strold_artice forKey:@"old_artice"];
        strurl = Home_JingXuan_URL;
        
        if(_arrListData.count<1)
        {
            NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"V2-Main-choiceness"];
            
            NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            _arrListData = [NSMutableArray new];
            ///数据处理
            if([[dicAll objectForKey:@"linklist"] isKindOfClass:[NSArray class]])
            {
                NSArray *arrtemp = [dicAll objectForKey:@"linklist"];
                for(NSDictionary *dictemp in arrtemp)
                {
                    
                    Article *model = [[Article alloc] initWithDictionary:dictemp];
                    [_arrListData addObject:model];
                }
            }
            
            
            [self.tableView reloadData];
        }
        
        
        
        if(_arrListData.count<1)
        {
            viewtemp = self.view.superview.viewController.view;
        }
        else
        {
            viewtemp = nil;
        }
    }
    else
    {
        [dicpush setObject:[NSString stringWithFormat:@"%@",_itemtype] forKey:@"type"];
        
        strurl = Home_OtherItem_URL;
        
        viewtemp = self.view.superview.viewController.view;
        
    }
    
    
    [self.dataController requestHomeItemsDataInView:viewtemp url:strurl parter:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
       
        if(state)
        {
            if(inowpage == 1)
            {
                _arrListData = [NSMutableArray new];
            }
            
            
            if([_itemtype isEqualToString:@"0"])
            {///精选
                
                if([[dicpush objectForKey:@"page"] intValue] == 1)
                {
                    if(self.dataController.resultListDict)
                    {
                        [[NSUserDefaults standardUserDefaults] setObject:[NSJSONSerialization dataWithJSONObject:self.dataController.resultListDict options:NSJSONWritingPrettyPrinted error:nil] forKey:@"V2-Main-choiceness"];
                    }
                    
                }
                
                strold_artice = [NSString nullToString:[self.dataController.resultListDict objectForKey:@"old_artice"]];
                
                
                
            }
            
            ///数据处理
            if([[self.dataController.resultListDict objectForKey:@"linklist"] isKindOfClass:[NSArray class]])
            {
                NSArray *arrtemp = [self.dataController.resultListDict objectForKey:@"linklist"];
                for(NSDictionary *dictemp in arrtemp)
                {
                    
                    Article *model = [[Article alloc] initWithDictionary:dictemp];
                    [_arrListData addObject:model];
                }
            }
            
            
            [self.tableView reloadData];
            
        }
        else
        {
            if(inowpage==1)
            {
                [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
            }
        }
        
//        if([[dicpush objectForKey:@"page"] isEqualToString:@"1"])
//        {
//            [self.delegate refHeaderEndAction];
//        }
//        else
//        {
//            [self.delegate refFooterEndAction];
//        }
    }];
    
    
}

-(void)settabvheight
{
    
    
    float ftemp = BOUNDS_WIDTH*0.4+80;
    int itemp = 0;
    if([_itemtype isEqualToString:@"0"])
    {
        for(Article *model in _arrListData)
        {
            if(model.state.intValue == 1)
            {
                itemp++;
            }
        }
    }
    
    _fviewheight = (_arrListData.count-itemp)*125+ftemp*itemp;
//    [self.delegate tabViewHeightChangeViewTag:self.view.tag andvalue:_fviewheight];
//    [self.tableView setHeight:_fviewheight];
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        float ftemp = BOUNDS_WIDTH*0.4+80;
//        int itemp = 0;
//        for(Article *model in _arrListData)
//        {
//            if(model.state.intValue == 1)
//            {
//                itemp++;
//            }
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            _fviewheight = (_arrListData.count-itemp)*125+ftemp*itemp;
//            [self.delegate tabViewHeightChangeViewTag:self.view.tag andvalue:_fviewheight];
//            [self.tableView setHeight:_fviewheight];
//        });
//    });
}

#pragma mark - UITableView Datasource

-(void)scrollDidScrollValue:(float)fvalue
{
//    float ftemp = fvalue-kMainScreenW*0.45-kTopHeight;
//    if(ftemp<0)
//    {
//        ftemp = 0;
//    }
//    [self.tableView setContentOffset:CGPointMake(0, ftemp)];
//    [self.tableView setContentOffset:CGPointMake(0, 0)];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [self.delegate tabViewScrollValue:scrollView.contentOffset.y];
    
//    CGFloat placeHolderHeight = self.topView.height - self.topView.itemHeight;
//    
//    CGFloat offsetY = scrollView.contentOffset.y;
//    
//    if (offsetY >= 0 && offsetY <= placeHolderHeight) {
//        self.topView.y = -offsetY;
//    }
//    else if (offsetY > placeHolderHeight) {
//        self.topView.y = - placeHolderHeight;
//    }
//    else if (offsetY <0) {
//        self.topView.y =  - offsetY;
//    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    [self settabvheight];
    
    return _arrListData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Article *model = _arrListData[indexPath.row];
    if([model.state intValue] == 1)
    {///:原创数据
        JingXuanYuanChuangTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        
        if(!cell)
        {
            cell = [[JingXuanYuanChuangTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier1];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.model = model;
        
        return cell;
    }
    else
    {
        ContentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(!cell)
        {
            cell = [[ContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell fetchCellData:model];
        
        return cell;
    }
}


#pragma mark - UITableView Delegate methods


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row>_arrListData.count-1) return;
    Article *model = _arrListData[indexPath.row];
    model.isSelected = YES;
    [self.delegate tableViewSelecte:_arrListData[indexPath.row]];
    [tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Article *model = _arrListData[indexPath.row];
    if([model.state intValue] == 1)
    {///:原创数据
        return BOUNDS_WIDTH*0.4+80;
    }
    return 125;
}

#pragma mark - UIScorllViewDelegate
//-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    _lastContentOffset = scrollView.contentOffset.y;
//}
//
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    //向上滚动
//    if (scrollView.contentOffset.y<_lastContentOffset)
//    {   _scorllDownSum = 0;
//        _scorllUpSum ++;
//        if ([self.delegate respondsToSelector:@selector(tableViewScrollDirectionUp)] && _scorllUpSum == 1) {
//            [self.delegate tableViewScrollDirectionUp];
//        }
//    }else if (scrollView.contentOffset.y>_lastContentOffset){
//        _scorllDownSum ++;
//        _scorllUpSum = 0;
//        //向下滚动
//        if ([self.delegate respondsToSelector:@selector(tableViewScrollDirectionDown)] && _scorllDownSum == 1) {
//            [self.delegate tableViewScrollDirectionDown];
//        }
//    }
//
//}

#pragma mark - getter and setters

- (Home644DataController *)dataController{
    if (!_dataController) {
        _dataController = [[Home644DataController alloc] init];
    }
    return _dataController;
}
- (CGFloat)dynamicHight{
    if (!_dynamicHight) {
        _dynamicHight = CGRectGetWidth(self.view.frame)*0.34;
    }
    return _dynamicHight;
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if(scrollView.contentOffset.y<flasty)
//    {
//        //        [UIView animateWithDuration:0.3 animations:^{
//        //            [_btzhiding setBottom:scrollView.contentOffset.y+scrollView.height-80];
//        //        }];
//        [_btzhiding setBottom:scrollView.contentOffset.y+scrollView.height-60];
//    }
//    else
//    {
//        [_btzhiding setBottom:scrollView.contentOffset.y+scrollView.height+60];
//    }
//
//
//    flasty = scrollView.contentOffset.y;
//}

-(void)topScrollAction
{
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

@end
