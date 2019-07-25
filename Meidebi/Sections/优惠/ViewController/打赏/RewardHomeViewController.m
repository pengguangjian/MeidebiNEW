//
//  RewardHomeViewController.m
//  Meidebi
//  打赏
//  Created by ZlJ_losaic on 2017/9/4.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "RewardHomeViewController.h"
#import "RewardHomeSubjectView.h"
#import "WelfareHomeDataController.h"
#import "RewardDataController.h"
#import "MDB_UserDefault.h"
@interface RewardHomeViewController ()
<
RewardHomeSubjectViewDelegate
>
@property (nonatomic, strong) NSString *commitID;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) RewardHomeSubjectView *subjectView;
@property (nonatomic, strong) WelfareHomeDataController *welfareDatacontroller;
@property (nonatomic, strong) RewardDataController *datacontroller;
@end

@implementation RewardHomeViewController

#pragma mark - def

#pragma mark - override

- (instancetype)initWithCommodityID:(NSString *)commodityID type:(RewardType)type{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _type = [NSString stringWithFormat:@"%@",@(type)];
        _commitID = commodityID;
    }
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
     self.title = @"打赏";
    [self setupSubviews];
    [self loadData];
}

#pragma mark - private method
- (void)setupSubviews{
    _subjectView = [RewardHomeSubjectView new];
    [self.view addSubview:_subjectView];
    [_subjectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
    _subjectView.delegate = self;
    _subjectView.type = _type;
}

- (void)loadData{
    [self.welfareDatacontroller requestAttendanceInfoDataWithView:self.view
                                                         callback:^(NSError *error, BOOL state, NSString *describle) {
                                                             if (state) {
                                                                 [_subjectView bindDataWithModel:self.welfareDatacontroller.resultDict];
                                                             }
    }];
}


#pragma mark - RewardHomeSubjectViewDelegate
- (void)rewardSubjectViewSubmitRewardWithContent:(NSString *)content amount:(NSString *)amount{
    [self.datacontroller requestSubmitRewardDataWithInView:self.view
                                               commodityid:_commitID
                                                      type:_type
                                                   content:content
                                                    amount:amount
                                                  callback:^(NSError *error, BOOL state, NSString *describle) {
                                                      if (state) {
                                                          [MDB_UserDefault showNotifyHUDwithtext:@"打赏成功！感谢您的支持" inView:self.view];
                                                          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                              [self.navigationController popViewControllerAnimated:YES];
                                                          });
                                                      }else{
                                                          [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
                                                      }
    }];
}

#pragma mark - getter / setter
- (RewardDataController *)datacontroller{
    if (!_datacontroller) {
        _datacontroller = [[RewardDataController alloc] init];
    }
    return _datacontroller;
}

- (WelfareHomeDataController *)welfareDatacontroller{
    if (!_welfareDatacontroller) {
        _welfareDatacontroller = [[WelfareHomeDataController alloc] init];
    }
    return _welfareDatacontroller;
}

@end
