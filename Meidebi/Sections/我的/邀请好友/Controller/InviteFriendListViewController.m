//
//  InviteFriendListViewController.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/22.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "InviteFriendListViewController.h"
#import "InviteFriendListSubjectView.h"
#import "InviteFriendDataController.h"
#import "MDB_UserDefault.h"
@interface InviteFriendListViewController ()
<
InviteFriendListSubjectViewDelegate
>
@property (nonatomic, strong) InviteFriendListSubjectView *subjectView;
@property (nonatomic, strong) InviteFriendDataController *dataController;
@end

@implementation InviteFriendListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请明细";
    [self setupSubviews];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupSubviews{
    _subjectView = [InviteFriendListSubjectView new];
    [self.view addSubview:_subjectView];
    [_subjectView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }
    }];
    _subjectView.delegate = self;
}

- (void)loadData{
    [self.dataController requestInviteFriendListDataInView:_subjectView order:nil Callback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            [_subjectView bindDataWithModels:self.dataController.requestResults];
            if (self.dataController.requestResults.count <= 0) {
//                [MDB_UserDefault showNotifyHUDwithtext:describle inView:_subjectView];
            }
        }else{
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:_subjectView];
        }
    }];
}

#pragma mark - InviteFriendListSubjectViewDelegate
- (void)inviteFriendListSubjectViewAscendingReveal{
    [self.dataController requestInviteFriendListDataInView:_subjectView order:@"asc" Callback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            [_subjectView bindDataWithModels:self.dataController.requestResults];
            if (self.dataController.requestResults.count <= 0) {
//                [MDB_UserDefault showNotifyHUDwithtext:describle inView:_subjectView];
            }
        }else{
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:_subjectView];
        }
    }];
}

- (void)inviteFriendListSubjectViewDescendingReveal{
    [self loadData];
}

#pragma mark - setters and getters
- (InviteFriendDataController *)dataController{
    if (!_dataController) {
        _dataController = [[InviteFriendDataController alloc] init];
    }
    return _dataController;
}
@end
