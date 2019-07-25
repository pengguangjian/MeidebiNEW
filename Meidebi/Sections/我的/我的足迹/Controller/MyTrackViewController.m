//
//  MyTrackViewController.m
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/8.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "MyTrackViewController.h"
#import "MyTrackSubjectView.h"
#import "MyTrackDataController.h"
#import "MDB_UserDefault.h"
#import "GMDCircleLoader.h"
#import "OriginalDetailViewController.h"
#import "ProductInfoViewController.h"
@interface MyTrackViewController ()
<
MyTrackSubjectViewDelegate
>
@property (nonatomic, strong) MyTrackDataController *datacontroller;
@property (nonatomic, strong) MyTrackSubjectView *subjectView;
@property (nonatomic, assign) NSInteger currentLoadNumber;
@end

@implementation MyTrackViewController

#pragma mark - def

#pragma mark - override
- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"足迹";
    [self setupSubviews];
    [self loadData];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _currentLoadNumber = 0;
}

#pragma mark - private method
- (void)setupSubviews{
    _subjectView = [MyTrackSubjectView new];
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
    [GMDCircleLoader setOnView:self.view withTitle:nil animated:YES];
    [self.datacontroller requestMyTrackBannerCallback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            [_subjectView bindBannerDataWithModel:self.datacontroller.resultDict];
        }
        _currentLoadNumber += 1;
        if (_currentLoadNumber == 2) {
            [GMDCircleLoader hideFromView:self.view animated:YES];
        }
    }];
    [self.datacontroller requestMyTrackListCallback:^(NSError *error, BOOL state, NSString *describle) {
        if (!state) {
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
        }
        [self renderSubjectView];
        _currentLoadNumber += 1;
        if (_currentLoadNumber == 2) {
            [GMDCircleLoader hideFromView:self.view animated:YES];
        }
    }];
}

- (void)renderSubjectView{
    NSMutableArray *models = [NSMutableArray array];
    for (NSDictionary *dict in self.datacontroller.results) {
        TrackViewModel *viewModel = [TrackViewModel viewModelWithSubject:dict];
        if (viewModel) {
            [models addObject:viewModel];
        }
    }
    [_subjectView bindTrackDataWithModel:models.mutableCopy];
}

- (void)updateDataWithSubjectView{
    NSMutableArray *models = [NSMutableArray array];
    for (NSDictionary *dict in self.datacontroller.results) {
        TrackViewModel *viewModel = [TrackViewModel viewModelWithSubject:dict];
        if (viewModel) {
            [models addObject:viewModel];
        }
    }
    [_subjectView updateTrackDataWithModel:models.mutableCopy];
}

#pragma mark - events

#pragma mark - MyTrackSubjectViewDelegate
- (void)lastPage{
    [self.datacontroller lastNewPageDataWithCallback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            [self updateDataWithSubjectView];
        }else{
            [_subjectView updateTrackDataWithModel:nil];
        }
    }];
}

- (void)nextPage{
    [self.datacontroller nextPageDataWithCallback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            [self updateDataWithSubjectView];
        }else{
            [_subjectView updateTrackDataWithModel:nil];
        }
    }];
}

- (void)tableViewCellSelectShowdanRow:(NSString *)showdanID{
    OriginalDetailViewController *vc = [[OriginalDetailViewController alloc] initWithOriginalID:showdanID];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableViewCellSelectDiscountRow:(NSString *)discountID{
    ProductInfoViewController *vc = [[ProductInfoViewController alloc] init];
    vc.productId = discountID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)bannerTableViewCellSelectDiscountRow:(NSString *)discountID{
    ProductInfoViewController *vc = [[ProductInfoViewController alloc] init];
    vc.productId = discountID;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - getter / setter
- (MyTrackDataController *)datacontroller{
    if (!_datacontroller) {
        _datacontroller = [[MyTrackDataController alloc] init];
    }
    return _datacontroller;
}
@end
