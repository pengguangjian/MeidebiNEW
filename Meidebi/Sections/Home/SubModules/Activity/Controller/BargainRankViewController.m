//
//  BargainRankViewController.m
//  Meidebi
//
//  Created by leecool on 2017/10/17.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "BargainRankViewController.h"
#import "BargainRankSubjectView.h"
#import "BargainActivityDataController.h"
#import "PersonalInfoIndexViewController.h"
@interface BargainRankViewController ()
<
BargainRankSubjectViewDelegate
>
@property (nonatomic, strong) BargainRankSubjectView *subjectView;
@property (nonatomic, strong) NSString *itemID;
@property (nonatomic, strong) BargainActivityDataController *datacontroller;

@end

@implementation BargainRankViewController
- (instancetype)initWithBargainItemID:(NSString *)itemID{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _itemID = itemID;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"排行榜top10";
    _subjectView = [BargainRankSubjectView new];
    [self.view addSubview:_subjectView];
    [_subjectView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }
    }];
    _subjectView.delegate = self;
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData{
    [self.datacontroller requestBargainRankActivityWithID:_itemID
                                                targetView:self.view
                                                  callback:^(NSError *error, BOOL state, NSString *describle) {
                                                      [_subjectView bindDataWithModel:self.datacontroller.requestResults];
                                                  }];
}

#pragma mark - BargainRankSubjectViewDelegate
- (void)detailSubjectViewDidCickAvaterViewWithUserid:(NSString *)userid{
    PersonalInfoIndexViewController *vc = [[PersonalInfoIndexViewController alloc] initWithUserID:userid];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - setters and getters
- (BargainActivityDataController *)datacontroller{
    if (!_datacontroller) {
        _datacontroller = [[BargainActivityDataController alloc] init];
    }
    return _datacontroller;
}


@end
