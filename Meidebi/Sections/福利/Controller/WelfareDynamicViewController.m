//
//  WelfareDynamicViewController.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/26.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "WelfareDynamicViewController.h"
#import "WelfareDynamicSubjectView.h"
#import "WelfareHomeDataController.h"
#import "PersonalInfoIndexViewController.h"
@interface WelfareDynamicViewController ()
<
WelfareDynamicSubjectViewDelegate
>
@property (nonatomic, strong) WelfareHomeDataController *dataController;
@property (nonatomic, strong) WelfareDynamicSubjectView *subjectView;

@end

@implementation WelfareDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self loadDataShowView:_subjectView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupSubviews{
    _subjectView = [WelfareDynamicSubjectView new];
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
    [self.dataController requestWelfareDynamicDataWithView:view callback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            [_subjectView bindDynamicWithModel:self.dataController.resultArray];
        }
    }];
    [self.dataController requestWelfareAdvertiseDataWithView:nil callback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            [_subjectView bindAdDataWithModel:self.dataController.resultDict];
        }
    }];
}

#pragma mark - WelfareDynamicSubjectViewDelegate
- (void)welfareDynamicSubjectViewDidRefreshHeader{
    [self loadDataShowView:nil];
}

- (void)welfareDynamicSubjectViewDidClickAvater:(NSString *)userid{
    if ([self.delegate respondsToSelector:@selector(welfareDynamicViewControllerDidClickAvater:)]) {
        [self.delegate welfareDynamicViewControllerDidClickAvater:userid];
    }
}

- (void)welfareDynamicSubjectViewDidClickAd:(NSDictionary *)adInfo{
    if ([self.delegate respondsToSelector:@selector(welfareDynamicViewControllerDidClickAd:)]) {
        [self.delegate welfareDynamicViewControllerDidClickAd:adInfo];
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
