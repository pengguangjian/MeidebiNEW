//
//  DailyLottoViewController.m
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/8/28.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "DailyLottoViewController.h"
#import "DailyLottoSubjectView.h"
#import "LottoRecordViewController.h"
#import "AddressListViewController.h"
#import "DailyLottoDataController.h"
#import "WelfareHomeDataController.h"
#import "MDB_UserDefault.h"
#import "VKLoginViewController.h"
#import "LottoRuleViewController.h"
@interface DailyLottoViewController ()
<
DailyLottoSubjectViewDelegate
>
@property (nonatomic, strong) DailyLottoSubjectView *subjectView;
@property (nonatomic, strong) DailyLottoDataController *dataController;
@end

@implementation DailyLottoViewController

#pragma mark - def

#pragma mark - override
- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = @"幸运抽奖";
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

#pragma mark - private method
- (void)setupSubviews{
    [self setNavRightBtn];
    _subjectView = [DailyLottoSubjectView new];
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

- (void)setNavRightBtn{
    UIButton* btnright = [UIButton buttonWithType:UIButtonTypeCustom];
    btnright.frame = CGRectMake(0,0,70,44);
    btnright.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [btnright setTitleColor:[UIColor colorWithHexString:@"#BE6E34"] forState:UIControlStateNormal];
    [btnright setTitle:@"抽奖规则" forState:UIControlStateNormal];
    [btnright setImage:[UIImage imageNamed:@"lotto_guid"] forState:UIControlStateNormal];
    [btnright setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnright setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [btnright addTarget:self action:@selector(respondsToNavRightBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnright];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)loadData{
    [self loadLottoListData:YES];
    if ([MDB_UserDefault getIsLogin]) {
        [self.dataController requestPersonalDataWithInView:nil callback:^(NSError *error, BOOL state, NSString *describle) {
            if (state) {
                [_subjectView bindCurrentCionsDataWithModel:self.dataController.resultDict];
            }
        }];
    }
}

- (void)loadLottoListData:(BOOL)show{
    [self.dataController requestLottoListDataWithInView:show == YES ? self.view: nil callback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            [_subjectView bindLottoListDataWithModel:self.dataController.resultDict];
        }
    }];
}

#pragma mark - events
- (void)respondsToNavRightBtnEvent:(UIButton *)sender{
    LottoRuleViewController *vc = [[LottoRuleViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - DailyLottoSubjectViewDelegate
- (void)lottoSubjectViewDidClickRecordBtn{
    if ([MDB_UserDefault getIsLogin]) {
        LottoRecordViewController *recoreVC = [[LottoRecordViewController alloc] init];
        [self.navigationController pushViewController:recoreVC animated:YES];
    }else{
        [self lottoSubjectViewToLogin];
    }
}

- (void)lottoSubjectViewDidClickAddressBtn{
    if ([MDB_UserDefault getIsLogin]) {
        AddressListViewController *addressVc = [[AddressListViewController alloc] init];
        [self.navigationController pushViewController:addressVc animated:YES];
    }else{
        [self lottoSubjectViewToLogin];
    }
}

- (void)lottoSubjectViewDidClickDoLotto{
    [self.dataController requestDoLottoDataWithInView:self.view callback:^(NSError *error, BOOL state, NSString *describle) {
        _subjectView.userInteractionEnabled = YES;
        if (!state) {
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
        }else{
            [_subjectView bindLottoResultDataWithModel:self.dataController.lottoResultDict];
        }
        [self loadLottoListData:NO];

    }];
}

- (void)lottoSubjectViewToLogin{
    VKLoginViewController *loginVc = [[VKLoginViewController alloc] init];
    [self.navigationController pushViewController:loginVc animated:YES];
}

#pragma mark - getter / setter
- (DailyLottoDataController *)dataController{
    if (!_dataController) {
        _dataController = [[DailyLottoDataController alloc] init];
    }
    return _dataController;
}

@end
