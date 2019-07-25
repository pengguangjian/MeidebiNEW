//
//  BrokeHomeViewController.m
//  Meidebi
//
//  Created by mdb-admin on 16/7/27.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "BrokeHomeViewController.h"
#import "BrokeHomeSubjectView.h"
#import "BrokeInfoViewController.h"
#import "BrokeShareDataController.h"
#import "BrokeAlertView.h"
#import "MDB_UserDefault.h"
#import "VKLoginViewController.h"
#import "BrokeHelpViewController.h"
static NSString * const kInspectPasteboardNotification = @"inspectPasteboardNotification";

@interface BrokeHomeViewController ()
<
BrokeHomeSubjectViewDelegate,
BrokeAlertViewDelegate
>
@property (nonatomic, strong) BrokeShareDataController *datacontroller;
@property (nonatomic, strong) BrokeHomeSubjectView *subjectView;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *type;
@end

@implementation BrokeHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我要爆料";
    [self setNavRightBtn];
    _subjectView = [BrokeHomeSubjectView new];
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inspectPasteboard) name:kInspectPasteboardNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kInspectPasteboardNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setNavRightBtn{
    UIButton* btnright = [UIButton buttonWithType:UIButtonTypeCustom];
    btnright.frame = CGRectMake(0,0,44,44);
    btnright.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [btnright setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btnright setTitle:@"帮助" forState:UIControlStateNormal];
    [btnright setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnright addTarget:self action:@selector(respondsToNavRightBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnright];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)respondsToNavRightBtnEvent:(UIButton *)sender{
    BrokeHelpViewController *vc = [[BrokeHelpViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadBrokeInfoDataWithLink:(NSString *)link{
    NSString *type = @"";
    if (_type.integerValue == 1) {
        type = @"2";
    }
    _link = link;
    [self.datacontroller requestGetShareInfoDataWithLink:link type:type InView:_subjectView callback:^(NSError *error, BOOL state, NSString *describle) {
        
        if ([NSString nullToString:self.datacontroller.resultMessage].length > 0) {
            [MDB_UserDefault showNotifyHUDwithtext:self.datacontroller.resultMessage inView:_subjectView];
        }else{
            if ([[NSString stringWithFormat:@"%@",[NSString nullToString:self.datacontroller.requestBrokeInfoResults[@"resubmit"]]] isEqualToString:@"1"]) {
                BrokeAlertView *alertView = [[BrokeAlertView alloc] init];
                alertView.delegate = self;
                [alertView showAlert];
            }else{
                [self intoBrokeInfoVc];
            }
        }
    }];
}

- (void)intoBrokeInfoVc{
    BrokeType aType;
    if (_type.integerValue == 1) {
        aType = BrokeTypeActivity;
    }else{
        aType = BrokeTypeSimply;
    }
    BrokeInfoViewController *brokeInfoVc = [[BrokeInfoViewController alloc] initWithType:aType];
    brokeInfoVc.brokeInfoDict = self.datacontroller.requestBrokeInfoResults;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:brokeInfoVc animated:YES];
}

- (void)inspectPasteboard{
    [self.view endEditing:YES];
    [_subjectView inspectPasteboard];
}
#pragma mark - BrokeHomeSubjectViewDelegate
- (void)brokeHomeSubjectView:(BrokeHomeSubjectView *)subView
didPressEnsureBtnWithBrokeLink:(NSString *)link
                        type:(NSString *)type{
    _type = type;
    [self loadBrokeInfoDataWithLink:link];
}

- (void)brokeHomeSubjectViewIntoLoginVc{
    VKLoginViewController *theViewController= [[VKLoginViewController alloc] init];
    [self.navigationController pushViewController:theViewController animated:NO];
}

#pragma mark - BrokeAlertViewDelegate
- (void)brokeAlertViewDidPressEnsureBtnWithAlertView:(BrokeAlertView *)alertView{
    [self intoBrokeInfoVc];
}

#pragma mark - getter and setter
- (BrokeShareDataController *)datacontroller{
    if (!_datacontroller) {
        _datacontroller = [[BrokeShareDataController alloc] init];
    }
    return _datacontroller;
}
@end
