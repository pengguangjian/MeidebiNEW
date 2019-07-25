//
//  FindeCouponResultViewController.m
//  Meidebi
//
//  Created by mdb-admin on 2017/7/10.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "FindeCouponResultViewController.h"
#import "MDB_UserDefault.h"
#import "FindCouponResultSubjectView.h"
#import <AlibcTradeSDK/AlibcTradeSDK/AlibcTradeSDK.h>
#import "CouponSearchNavTitleView.h"
@interface FindeCouponResultViewController ()
<
FindCouponResultSubjectViewDelegate,
CouponSearchNavTitleViewDelegate
>
@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, strong) FindCouponResultSubjectView *subjectView;
@property (nonatomic, strong) CouponSearchNavTitleView *navTitleView;
@end

@implementation FindeCouponResultViewController

- (instancetype)initWithSearchKeyword:(NSString *)keyword{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _keyword = keyword;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupSubviews{
    self.navigationItem.titleView = [self titleView];
    _subjectView = [FindCouponResultSubjectView new];
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
    _subjectView.searhKeyword = _keyword;
    _subjectView.delegate = self;
}

- (UIView *)titleView{
    _navTitleView =[[CouponSearchNavTitleView alloc] initWithFrame:self.navigationController.navigationBar.bounds];
    [_navTitleView setBackgroundColor:self.navigationController.view.backgroundColor];
    _navTitleView.delegate = self;
    _navTitleView.textFieldPlaceholder = _keyword;
    return _navTitleView;
}

#pragma mark - CouponSearchNavTitleViewDelegate
- (void)searchNavTitleViewDidRespondsSearch:(NSString *)searchKey{
    if (searchKey.length<=0) {
        [MDB_UserDefault showNotifyHUDwithtext:@"搜索内容不能为空！" inView:self.view];
        return;
    }
    _subjectView.searhKeyword = searchKey;
}


#pragma mark - FindCouponResultSubjectViewDelegate
- (void)subjectViewDidClickDrawBtnWithUrl:(NSString *)url{
    id<AlibcTradePage> page = [AlibcTradePageFactory page:url];
    id<AlibcTradeService> service = [AlibcTradeSDK sharedInstance].tradeService;
    AlibcTradeShowParams *showParams = [[AlibcTradeShowParams alloc] init];
    showParams.openType = AlibcOpenTypeNative;
    [service show:showParams.isNeedPush ? self.navigationController : self
             page:page
       showParams:showParams
      taoKeParams:nil
       trackParam:nil
    tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
    } tradeProcessFailedCallback:^(NSError * _Nullable error) {
    }];
}

- (void)subjectViewDidScroll{
    [_navTitleView textFieldResignFirstResponder];
}

@end
