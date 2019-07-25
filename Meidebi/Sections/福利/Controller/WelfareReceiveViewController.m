//
//  WelfareReceiveViewController.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/27.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "WelfareReceiveViewController.h"
#import "WelfareReceiveSubjectView.h"
#import "ConversionViewController.h"
#import "WelfareHomeDataController.h"
@interface WelfareReceiveViewController ()
<
WelfareReceiveSubjectViewDelegate
>
@property (nonatomic, strong) WelfareReceiveSubjectView *subjectView;
@property (nonatomic, strong) WelfareHomeDataController *dataController;
@end

@implementation WelfareReceiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我领取的福利";
    [self setupSubviews];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupSubviews{
    _subjectView = [WelfareReceiveSubjectView new];
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
    [self.dataController requestMyWelfareDataWithView:_subjectView callback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            [_subjectView bindDataWithModel:self.dataController.resultDict];
        }
    }];
}

#pragma mark - WelfareReceiveSubjectViewDelegate
- (void)welfareReceiveSubjectViewDidClickConversionBtn{
    ConversionViewController *conversionVC = [[ConversionViewController alloc] init];
    [self.navigationController pushViewController:conversionVC animated:YES];
}


#pragma mark - setters and getters
- (WelfareHomeDataController *)dataController{
    if (!_dataController) {
        _dataController = [[WelfareHomeDataController alloc] init];
    }
    return _dataController;
}
@end
