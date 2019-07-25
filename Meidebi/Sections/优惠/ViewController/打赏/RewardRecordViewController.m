//
//  RewardRecordViewController.m
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/7.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "RewardRecordViewController.h"
#import "RewardDataController.h"
#import "RewardRecordTableViewCell.h"
#import "MDB_UserDefault.h"
#import "PersonalInfoIndexViewController.h"
static NSString * const kTableViewCellIdentifier = @"cell";
@interface RewardRecordViewController ()
<
RewardRecordTableViewCellDelegate
>
@property (nonatomic, strong) NSString *commitID;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSArray *rewardLogs;
@property (nonatomic, strong) RewardDataController *datacontroller;
@end

@implementation RewardRecordViewController

#pragma mark - def

#pragma mark - override
- (instancetype)initWithCommodityID:(NSString *)commodityID type:(RewardLogType)type{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _type = [NSString stringWithFormat:@"%@",@(type)];
        _commitID = commodityID;
    }
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"打赏记录";
    [self setupSubviews];
    [self loadData];
}

#pragma mark - private method
- (void)setupSubviews{
    self.tableView.separatorColor = [UIColor colorWithHexString:@"#E2E2E2"];
    [self.tableView registerClass:[RewardRecordTableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
    self.tableView.tableFooterView = [UIView new];
    
}

- (void)loadData{
    [self.datacontroller requestRewardDetailListWithInView:self.view
                                               commodityid:_commitID
                                                      type:_type
                                                  callback:^(NSError *error, BOOL state, NSString *describle) {
                                                      if(state){
                                                          _rewardLogs = self.datacontroller.results;
                                                          [self.tableView reloadData];
                                                      }else{
                                                          [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
                                                      }
    }];
}

#pragma mark - events


#pragma mark - UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _rewardLogs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RewardRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier];
    [cell bindDataWithModel:_rewardLogs[indexPath.row]];
    cell.delegate = self;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

#pragma mark - RewardRecordTableViewCellDelegate
- (void)tableViewCellDidSelctAvater:(RewardRecordTableViewCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    PersonalInfoIndexViewController *vc = [[PersonalInfoIndexViewController alloc] initWithUserID:[NSString nullToString:_rewardLogs[indexPath.row][@"id"]]];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - getter / setter
- (RewardDataController *)datacontroller{
    if (!_datacontroller) {
        _datacontroller = [[RewardDataController alloc] init];
    }
    return _datacontroller;
}
@end
