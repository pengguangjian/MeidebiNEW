//
//  PersonalBrokeNewsViewController.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/20.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "PersonalBrokeNewsViewController.h"
#import "PersonalBrokeNewsTableViewCell.h"
#import "PersonalInfoIndexDataController.h"
#import <MJRefresh/MJRefresh.h>
#import "MDBEmptyView.h"
static NSString * const kTableViewCellIdentifier = @"cell";

@interface PersonalBrokeNewsViewController ()

@property (nonatomic, strong) PersonalInfoIndexDataController *dataController;
@property (nonatomic, strong) NSArray *brokeNews;
@property (nonatomic, strong) MDBEmptyView *emptyView;
@property (nonatomic, strong) NSString *userid;
@end

@implementation PersonalBrokeNewsViewController

- (instancetype)initWithUserID:(NSString *)userid{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _userid = userid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[PersonalBrokeNewsTableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
    [self loadData];
    [self tableViewAddRefersh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)tableViewAddRefersh{
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self footReloadTableViewDateSource];
    }];
}

- (void)loadData{
    [self.dataController requestMyBrokeListDataWithInView:nil userid:_userid callback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            [self renderBrokeNewsDataWithDown:NO];
        }
    }];
}

- (void)footReloadTableViewDateSource{
    [self.dataController myBrokeListNextPageDataWithCallback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            [self renderBrokeNewsDataWithDown:YES];
        }
        [self.tableView.mj_footer endRefreshing];
    }];
}


- (void)renderBrokeNewsDataWithDown:(BOOL)isDown{
    NSMutableArray *models = [NSMutableArray arrayWithArray:_brokeNews];
    if (!isDown) [models removeAllObjects];
    for (NSDictionary * dict in self.dataController.requestResults) {
        PersonalBrokeNewsViewModel *model = [PersonalBrokeNewsViewModel viewModelWithSubject:dict];
        BOOL isSave=YES;
        for (PersonalBrokeNewsViewModel *broke in _brokeNews) {
            if ([broke.artid isEqualToString:model.artid]) {
                isSave=NO;
                break;
            }
        }
        if (isSave && model) [models addObject:model];
    }
    _brokeNews = models.mutableCopy;
    [self.tableView reloadData];
    
    if (!isDown) {
        if (_brokeNews.count > 0) {
            self.emptyView.hidden = YES;
        }else{
            self.emptyView.hidden = NO;
        }
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _brokeNews.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonalBrokeNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier];
    [cell bindDataWithModel:_brokeNews[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(personalBrokeNewsVCDidClickCellWithBrokeID:)]) {
        [self.delegate personalBrokeNewsVCDidClickCellWithBrokeID:[(PersonalBrokeNewsViewModel *)_brokeNews[indexPath.row] artid]];
    }
}

#pragma mark - setters and getters
- (PersonalInfoIndexDataController *)dataController{
    if (!_dataController) {
        _dataController  = [[PersonalInfoIndexDataController alloc] init];
    }
    return _dataController;
}

- (MDBEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[MDBEmptyView alloc] initWithFrame:CGRectMake(0, 50, kMainScreenW, 200)];
        [self.view addSubview:_emptyView];
        _emptyView.remindStr = @"没有查到相关数据";
    }
    return _emptyView;
}

@end
