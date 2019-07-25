//
//  PersonalShareViewController.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/20.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "PersonalShareViewController.h"
#import "PersonalShareTableViewCell.h"
#import "PersonalInfoIndexDataController.h"
#import <MJRefresh/MJRefresh.h>
#import "MDBEmptyView.h"
static NSString * const kTableViewCellIdentifier = @"cell";

@interface PersonalShareViewController ()

@property (nonatomic, strong) PersonalInfoIndexDataController *dataController;
@property (nonatomic, strong) MDBEmptyView *emptyView;
@property (nonatomic, strong) NSArray *shares;
@property (nonatomic, strong) NSString *userid;
@end

@implementation PersonalShareViewController

- (instancetype)initWithUserID:(NSString *)userid{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _userid = userid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[PersonalShareTableViewCell class]
           forCellReuseIdentifier:kTableViewCellIdentifier];
    [self tableViewAddRefersh];
    [self loadData];
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
    [self.dataController requestMyShareListDataWithInView:nil userid:_userid callback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            [self renderBrokeNewsDataWithDown:NO];
        }
    }];
}

- (void)footReloadTableViewDateSource{
    [self.dataController myShareListLastNewPageDataWithCallback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            [self renderBrokeNewsDataWithDown:YES];
        }
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)renderBrokeNewsDataWithDown:(BOOL)isDown{
    NSMutableArray *models = [NSMutableArray arrayWithArray:_shares];
    if (!isDown) [models removeAllObjects];
    for (NSDictionary * dict in self.dataController.requestResults) {
        PersonalShareViewModel *model = [PersonalShareViewModel viewModelWithSubject:dict];
        BOOL isSave=YES;
        for (PersonalShareViewModel *share in _shares) {
            if ([share.artid isEqualToString:model.artid]) {
                isSave=NO;
                break;
            }
        }
        if (isSave && model) [models addObject:model];
    }
    _shares = models.mutableCopy;
    [self.tableView reloadData];
    if (!isDown) {
        if (_shares.count > 0) {
            self.emptyView.hidden = YES;
        }else{
            self.emptyView.hidden = NO;
        }
    }
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _shares.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonalShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier];
    [cell bindDataWithModel:_shares[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kMainScreenW * 0.755;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(personalShareVCDidClickCellWithShaiDanID:)]) {
        [self.delegate personalShareVCDidClickCellWithShaiDanID:[(PersonalShareViewModel *)_shares[indexPath.row] artid]];
    }
}

#pragma mark - setters and getters
- (PersonalInfoIndexDataController *)dataController{
    if (!_dataController) {
        _dataController = [[PersonalInfoIndexDataController alloc] init];
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
