//
//  YuanChuanSearchTableViewController.m
//  Meidebi
//  原创关键词搜索列表
//  Created by mdb-losaic on 2018/5/22.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "YuanChuanSearchTableViewController.h"

#import <MJRefresh.h>

#import "TKExploreTableViewCell.h"

#import "YYPhotoGroupView.h"
//#import "YYPhotoGroupItem.h"
#import "OriginalDetailViewController.h"

#import "PersonalInfoIndexViewController.h"

#import "HTTPManager.h"

#import "MDB_UserDefault.h"

@interface YuanChuanSearchTableViewController ()<TKExploreTableViewCellDelegate>
{
    int ipage;
    NSMutableArray *arrdata;
    
    BOOL isKeywordsList;
}

@property (nonatomic, strong) NSArray *topics;

@end

@implementation YuanChuanSearchTableViewController

-(id)initWithStyle:(UITableViewStyle)style
{
    style = UITableViewStyleGrouped;
    if(self = [super initWithStyle:style])
    {
        
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if(_strkeywords==nil)
    {
        _strkeywords = @"";
    }
    self.title = [NSString stringWithFormat:@"关于“%@”",_strkeywords];
    ipage = 1;
    
    
    
    [self.tableView registerClass:[TKExploreTableViewCell class] forCellReuseIdentifier:@"yuanhuangsousuo"];
    self.tableView.separatorColor = [UIColor colorWithHexString:@"#E6E6E6"];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ipage = 1;
        [self loadData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if(isKeywordsList==NO)
        {
            ipage++;
            [self loadData];
        }
        else
        {
            [self.tableView.mj_footer endRefreshing];
        }
    }];

    ////加载数据
    [self loadData];
    
}

-(void)loadData
{
    NSDictionary *dicpush=@{
                               @"page":[NSString stringWithFormat:@"%@",@(ipage)],
                               @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                               @"word":_strkeywords,
                               @"pageSize":@"20"};
    
    [HTTPManager sendRequestUrlToService:URL_showdanSearchlist withParametersDictionry:dicpush view:self.view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                
                if([[dicAll objectForKey:@"data"] isKindOfClass:[NSArray class]])
                {
                    NSArray *subjects = dicAll[@"data"];
                    if(ipage == 1)
                    {
                        arrdata = [NSMutableArray new];
                    }
                    for(NSDictionary *dic in subjects)
                    {
                        [arrdata addObject:[TKTopicListViewModel viewModelWithSubject:dic]];
                    }
                    [self bindeTopicData:arrdata];
                    
                    
                    isKeywordsList = NO;
                    if([describle isEqualToString:@"暂无数据"] && ipage == 1)
                    {
                        isKeywordsList = YES;
                    }
                    
                    
                }
                else
                {
                    if(describle==nil)describle = @"";
                    [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
                }
            }
            else
            {
                if(describle==nil)describle = @"";
                [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
            }
        }
        [self.tableView reloadData];
    }];
    
    
    
}


- (void)bindeTopicData:(NSArray *)topics{
    if(topics == nil)
    {
        return;
    }
    if (topics.count <= 0) return;
    NSMutableArray *temps = [NSMutableArray array];
    for (TKTopicListViewModel *model in topics) {
        TKTopicItemLayout *layout = [[TKTopicItemLayout alloc] initWithTopics:model];
        if (layout) {
            [temps addObject:layout];
        }
    }
    _topics = temps.mutableCopy;
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

#pragma mark - UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *strcell = @"yuanhuangsousuo";
    TKExploreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strcell];
    [cell setLayout:_topics[indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [(TKTopicItemLayout *)_topics[indexPath.row] height];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(isKeywordsList==YES)
    {
        return 182;
    }
    return 0.1;
    
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 0)];
    [view setClipsToBounds:YES];
    [view setBackgroundColor:[UIColor whiteColor]];
    if(isKeywordsList==YES)
    {
        [view setHeight:182];
    }
    else
    {
        [view setHeight:0.1];
    }
    
    UILabel *lbnomo = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.width, 110)];
    [lbnomo setText:@"暂无相关原创哦"];
    [lbnomo setTextColor:RGB(102,102,102)];
    [lbnomo setTextAlignment:NSTextAlignmentCenter];
    [lbnomo setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbnomo];
    
    UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(0, lbnomo.bottom, view.width, 8)];
    [viewline setBackgroundColor:RGB(243,243,243)];
    [view addSubview:viewline];
    
    
    UIView *viewlinecenter = [[UIView alloc] initWithFrame:CGRectMake(0, lbnomo.bottom, view.width, 1)];
    [viewlinecenter setBackgroundColor:RGB(183,183,183)];
    [view addSubview:viewlinecenter];
    
    UILabel *lbcenter = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.width, 110)];
    [lbcenter setText:@"热门原创"];
    [lbcenter setTextColor:RGB(51,51,51)];
    [lbcenter setTextAlignment:NSTextAlignmentCenter];
    [lbcenter setFont:[UIFont systemFontOfSize:12]];
    [lbcenter sizeToFit];
    [lbcenter setWidth:lbcenter.width+20];
    [lbcenter setBackgroundColor:[UIColor whiteColor]];
    [lbcenter setCenter:CGPointMake(view.width/2.0, viewline.bottom+30)];
    [view addSubview:lbcenter];
    
    [viewlinecenter setWidth:lbcenter.width+60];
    [viewlinecenter setCenter:lbcenter.center];
    
    
    UIView *viewlinebottom = [[UIView alloc] initWithFrame:CGRectMake(0, lbcenter.bottom+25, view.width, 1)];
    [viewlinebottom setBackgroundColor:RGB(243,243,243)];
    [view addSubview:viewlinebottom];
    
    
    return view;;
}

#pragma mark - Table View Delegate methods
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

#pragma mark - TKExploreTableViewCellDelegate
- (void)cellDidClick:(TKExploreTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSString *topicID = [[_topics[indexPath.row] topic] topicID];
    
    ///
    OriginalDetailViewController *vc = [[OriginalDetailViewController alloc] initWithOriginalID:topicID];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
- (void)cell:(TKExploreTableViewCell *)cell didClickImageAtIndex:(NSInteger)index
{
    if (!cell.statusView.layout.topic.topicID) return;
    UIView *fromView = nil;
    NSMutableArray *items = [NSMutableArray new];
    TKTopicListViewModel *topic = cell.statusView.layout.topic;
    NSArray *pics = topic.images;
    for (NSUInteger i = 0, max = pics.count; i < max; i++) {
        if (i >= cell.statusView.picViews.count) continue;
        UIView *imgView = cell.statusView.picViews[i];
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        item.thumbView = imgView;
        item.largeImageURL = [NSURL URLWithString:[NSString nullToString:pics[i]]];
        //        item.largeImageSize = CGSizeMake(meta.width, meta.height);
        [items addObject:item];
        if (i == index) {
            fromView = imgView;
        }
    }
    YYPhotoGroupView *photoGroupView = [[YYPhotoGroupView alloc] initWithGroupItems:items];
    
    [photoGroupView presentFromImageView:fromView
                             toContainer:self.tabBarController.view
                                animated:YES
                              completion:nil];
    
}
/// 点击了用户
- (void)cell:(TKExploreTableViewCell *)cell didClickUser:(NSString *)userid
{
    if (TKTopicTypeSpitslot == cell.statusView.layout.topic.topicType) return;
    
    if (userid.length <= 0) return;
    PersonalInfoIndexViewController *personalInfoVc = [[PersonalInfoIndexViewController alloc] initWithUserID:userid];
    [self.navigationController pushViewController:personalInfoVc animated:YES];
    
}

@end
