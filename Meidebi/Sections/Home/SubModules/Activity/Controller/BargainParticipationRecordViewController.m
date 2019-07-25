//
//  BargainParticipationRecordViewController.m
//  Meidebi
//
//  Created by leecool on 2017/10/17.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "BargainParticipationRecordViewController.h"
#import "BargainItemTableViewCell.h"
#import "BargainActivityDataController.h"
#import "MDBEmptyView.h"
#import "BargainActivityViewModel.h"
#import "BargainActivityDetailViewController.h"
static NSString * const kTableViewCellIdentifier = @"cell";
@interface BargainParticipationRecordViewController ()
@property (nonatomic, strong) NSArray *records;
@property (nonatomic, strong) NSString *activityID;
@property (nonatomic, strong) BargainActivityDataController *datacontroller;
@property (nonatomic, strong) MDBEmptyView *emptyView;

@end

@implementation BargainParticipationRecordViewController
- (instancetype)initWithBargainActivityID:(NSString *)activityID{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _activityID = activityID;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"参与纪录";
    [self.tableView registerClass:[BargainItemTableViewCell class]
           forCellReuseIdentifier:kTableViewCellIdentifier];
    self.tableView.tableFooterView = [UIView new];
    [self loadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData{
    [self.datacontroller requestParticipationRecordActivityWithTargetView:self.view
                                                               activityID:_activityID
                                                                 callback:^(NSError *error, BOOL state, NSString *describle) {
        _records = self.datacontroller.requestResults;
        if (_records.count > 0) {
            self.emptyView.hidden = YES;
            [self renderSubjectView];
        }else{
            self.emptyView.hidden = NO;
        }
    }];
}

- (void)renderSubjectView{
    NSMutableArray *models = [NSMutableArray array];
    for (NSDictionary *dict in self.datacontroller.requestResults) {
        BargainParticipationViewModel *model = [BargainParticipationViewModel viewModelWithSubject:dict];
        if (model) {
            [models addObject:model];
        }
    }
    _records = models.mutableCopy;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _records.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BargainItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier];
    [cell bindParticiptationDataWithModel:_records[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BargainActivityDetailViewController *vc = [[BargainActivityDetailViewController alloc] initWithBargainItemID:[_records[indexPath.row] commodityID]];
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
