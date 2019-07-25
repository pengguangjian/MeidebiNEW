//
//  CheapOrOutsideViewController.m
//  Meidebi
//
//  Created by mdb-admin on 16/5/5.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "CheapOrOutsideViewController.h"
#import "CheapOrOutsideSubjectsView.h"
#import "CheapOrOutsideDataController.h"
#import "CheapOrOutsideSubjectsViewModel.h"
#import "ProductInfoViewController.h"
#import <MJRefresh/MJRefresh.h>
@interface CheapOrOutsideViewController ()
<
CheapOrOutsideSubjectsViewDelgate
>

@property (nonatomic, strong) CheapOrOutsideSubjectsView *subjectView;
@property (nonatomic, strong) CheapOrOutsideDataController *dataController;
@property (nonatomic, assign) RequestType requstType;
@end

@implementation CheapOrOutsideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self fetchSubjectData];
}

- (void)setupSubviews{
     _subjectView = [CheapOrOutsideSubjectsView new];
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
    [_subjectView setUserInteractionEnabled:NO];
}

- (void)fetchSubjectData{
    [self.dataController requestSubjectDataWithType:_requstType
                                             InView:self.subjectView
                                           callback:^(NSError *error, BOOL state, NSString *describle) {
        if (!error) {
            [self renderSubjectView];
        }
        [_subjectView setUserInteractionEnabled:YES];
    }];
}

- (void)renderSubjectView{
    CheapOrOutsideSubjectsViewModel *viewModel = [CheapOrOutsideSubjectsViewModel viewModelWithSubjects:self.dataController.requestResults];
    [_subjectView bindDataWithViewModel:viewModel];
    
}

#pragma mark - CheapOrOutsideSubjectsViewDelgate
- (void)subjectsView:(CheapOrOutsideSubjectsView *)view didPressCellWithCommodity:(Commodity *)aCommodity{
    ProductInfoViewController *productInfoVc = [[ProductInfoViewController alloc] init];
    productInfoVc.theObject = aCommodity;
    [self.navigationController pushViewController:productInfoVc animated:YES];
}
- (void)subjectsViewWithPullupTableview{
    [self.dataController nextPageDataWithCallback:^(NSError *error, BOOL state, NSString *describle) {
        if (!error) {
            [self renderSubjectView];
        }
    }];
}

- (void)subjectsViewWithPullDownTableview{
    [self.dataController lastNewPageDataWithCallback:^(NSError *error, BOOL state, NSString *describle) {
        if (!error) {
            [self renderSubjectView];
        }
    }];
}


#pragma mark - setters and getters
- (void)setType:(NSString *)type{
    _type = type;
    if ([_type isEqualToString:@"1"]) {
        self.title = @"海淘直邮";
        _requstType = RequestTypeHaitao;
    }else if([_type isEqualToString:@"2"]){
        self.title = @"白菜价";
        _requstType = RequestTypeBaicai;

    }else if([_type isEqualToString:@"3"]){
        self.title = @"优惠券直播";
        _requstType = RequestTypeCouponLive;
    }
    
}

- (CheapOrOutsideDataController *)dataController{
    if (!_dataController) {
        _dataController = [[CheapOrOutsideDataController alloc] init];
    }
    return _dataController;
}
@end
