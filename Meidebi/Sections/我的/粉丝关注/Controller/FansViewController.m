//
//  FansViewController.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/19.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "FansViewController.h"
#import "ContactDataController.h"
#import "FansSubjectView.h"
#import "MDB_UserDefault.h"
#import "PersonalInfoIndexViewController.h"
@interface FansViewController ()
<
FansSubjectViewDelegate
>
@property (nonatomic, strong) FansSubjectView *subjectView;
@property (nonatomic, strong) ContactDataController *dataController;

@end

@implementation FansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"粉丝";
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupSubviews{
    _subjectView = [FansSubjectView new];
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
    [self.dataController requestFansListInView:_subjectView Callback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            [self renderSubjectView];
        }else{
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:_subjectView];
        }
    }];
}

- (void)renderSubjectView{
    NSMutableArray *models = [NSMutableArray array];
    for (NSDictionary *dict in self.dataController.requestResults) {
        ContactViewModel *model = [ContactViewModel viewModelWithSubject:dict];
        if (model) [models addObject:model];
    }
    [_subjectView bindDataWithModel:models.mutableCopy];
}

#pragma mark - FansSubjectViewDelegate
- (void)fansSubjectViewDidClickAddFollowWithFollowID:(NSString *)userID
                                         didComplete:(void (^)(void))complete{
    [self.dataController requestAddFollwDataWithInView:_subjectView userid:userID callback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            complete();
        }else{
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:_subjectView];
        }
    }];
}

- (void)imageViewClickedWithUserId:(NSString *)userid{
    if ([@"" isEqualToString:userid]) return;
    PersonalInfoIndexViewController *personalInfoIndexVc = [[PersonalInfoIndexViewController alloc] initWithUserID:userid];
    [self.navigationController pushViewController:personalInfoIndexVc animated:YES];
}

#pragma mark - setters and getters
- (ContactDataController *)dataController{
    if (!_dataController) {
        _dataController = [[ContactDataController alloc] init];
    }
    return _dataController;
}

@end
