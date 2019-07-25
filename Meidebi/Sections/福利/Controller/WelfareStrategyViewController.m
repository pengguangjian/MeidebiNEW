//
//  WelfareStrategyViewController.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/26.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "WelfareStrategyViewController.h"
#import "WelfareHomeDataController.h"
 @interface WelfareStrategyViewController ()
<
WelfareStrategySubjectViewDelegate
>
@property (nonatomic, strong) WelfareHomeDataController *dataController;
@property (nonatomic, strong) WelfareStrategySubjectView *subjectView;

@end

@implementation WelfareStrategyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self loadDataShowView:_subjectView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupSubviews{
    _subjectView = [WelfareStrategySubjectView new];
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

- (void)loadDataShowView:(UIView *)view{
    [self.dataController requestWelfareAdvertiseDataWithView:nil callback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            [_subjectView bindAdDataWithModel:self.dataController.resultDict];
        }
        else{
            [_subjectView bindAdDataWithModel:nil];
        }
    }];
    [self.dataController requestWelfareRaidersDataWithView:view callback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            [_subjectView bindDynamicWithModel:self.dataController.resultDict];
        }
    }];
}

#pragma mark - WelfareStrategySubjectViewDelegate
- (void)welfareStrategyCollectionViewDidSelectCellWithType:(WelfareStrategyJumpType)type{
    if ([self.delegate respondsToSelector:@selector(welfareStrategyViewControllerDidSelectCellWithType:)]) {
        [self.delegate welfareStrategyViewControllerDidSelectCellWithType:type];
    }
}

- (void)welfareStrategyCollectionViewDidClickMyWelfareBtn{
    if ([self.delegate respondsToSelector:@selector(welfareStrategyViewControllerDidClickMyWelfareBtn)]) {
        [self.delegate welfareStrategyViewControllerDidClickMyWelfareBtn];
    }
}

- (void)welfareStrategyCollectionViewRefreshHeader{
    [self loadDataShowView:_subjectView];
}

- (void)welfareStrategyCollectionViewDidClickMyWelfareAd:(NSDictionary *)adInfo{
    if ([self.delegate respondsToSelector:@selector(welfareStrategyViewControllerDidClickMyWelfareAd:)]) {
        [self.delegate welfareStrategyViewControllerDidClickMyWelfareAd:adInfo
         ];
         }
}

#pragma mark - setters and getters
- (WelfareHomeDataController *)dataController{
    if (!_dataController) {
        _dataController = [[WelfareHomeDataController alloc] init];
    }
    return _dataController;
}

@end
