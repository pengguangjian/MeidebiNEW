//
//  BargainRecordViewController.m
//  Meidebi
//
//  Created by leecool on 2017/10/16.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "BargainRecordViewController.h"
#import "BargainRecordTableViewCell.h"
#import "BargainActivityDataController.h"
#import "MDBEmptyView.h"
#import "PersonalInfoIndexViewController.h"
static NSString * const kTableViewCellIdentifier = @"cell";

@interface BargainRecordViewController ()
<
BargainRecordTableViewCellDelegate
>
@property (nonatomic, strong) NSString *itemID;
@property (nonatomic, strong) NSArray *records;
@property (nonatomic, strong) BargainActivityDataController *datacontroller;
@property (nonatomic, strong) MDBEmptyView *emptyView;
@end

@implementation BargainRecordViewController
- (instancetype)initWithBargainItemID:(NSString *)itemID{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _itemID = itemID;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"砍价记录";
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[BargainRecordTableViewCell class]
           forCellReuseIdentifier:kTableViewCellIdentifier];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData{
    [self.datacontroller requestBargainRecorActivityWithID:_itemID
                                                targetView:self.view
                                                  callback:^(NSError *error, BOOL state, NSString *describle) {
                                                      _records = self.datacontroller.requestResults;
                                                      if (_records.count > 0) {
                                                          self.emptyView.hidden = YES;
                                                          [self.tableView reloadData];
                                                      }else{
                                                          self.emptyView.hidden = NO;
                                                      }
    }];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BargainRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier];
    [cell bindDataWithModel:_records[indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 71;
}

#pragma mark - BargainRecordTableViewCellDelegate
- (void)tableViewCellDidCickAvaterViewWithCell:(BargainRecordTableViewCell *)cell{
    NSIndexPath *indePath = [self.tableView indexPathForCell:cell];
    PersonalInfoIndexViewController *vc = [[PersonalInfoIndexViewController alloc] initWithUserID:[NSString nullToString:_records[indePath.row][@"user_id"]]];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - setters and getters
- (BargainActivityDataController *)datacontroller{
    if (!_datacontroller) {
        _datacontroller = [[BargainActivityDataController alloc] init];
    }
    return _datacontroller;
}

- (MDBEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[MDBEmptyView alloc] initWithFrame:CGRectMake(0, kTopHeight, kMainScreenW, kMainScreenH-kTopHeight)];
        [self.view addSubview:_emptyView];
        _emptyView.remindStr = @"暂时还没有数据哦～";
        _emptyView.hidden = YES;
    }
    return _emptyView;
}

@end
