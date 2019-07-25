//
//  ConversionViewController.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/22.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "ConversionViewController.h"
#import "ExchangeRecordViewController.h"
#import "ConversionSubjectView.h"
#import "ConversionDataController.h"
#import "VolumeContentViewController.h"
#import "TaskRuleViewController.h"
#import "AddressListViewController.h"
#import "VKLoginViewController.h"
@interface ConversionViewController ()
<
ConversionSubjectViewDelegate,
AddressListViewControllerDelegate,
AddressListSelectViewControllerDelegate
>
@property (nonatomic, strong) ConversionSubjectView *subjectView;
@property (nonatomic, strong) ConversionDataController *dataController;
@end

@implementation ConversionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"礼品兑换";
    [self setupSubviews];
    [self setupNavRightBtn];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData{
    [self.dataController requestAttendanceInfoDataWithView:_subjectView callback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            [_subjectView bindDataWithModel:self.dataController.resultDict];
        }
    }];
}

- (void)setupSubviews{
    _subjectView = [ConversionSubjectView new];
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

- (void)setupNavRightBtn{
    UIButton* btnright = [UIButton buttonWithType:UIButtonTypeCustom];
    btnright.frame = CGRectMake(0,0,70,44);
    btnright.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [btnright setTitleColor:[UIColor colorWithHexString:@"#BE6E34"] forState:UIControlStateNormal];
    [btnright setTitle:@"兑换历史" forState:UIControlStateNormal];
    [btnright setImage:[UIImage imageNamed:@"conversion_ record"] forState:UIControlStateNormal];
    [btnright addTarget:self action:@selector(respondsToRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btnright setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnright setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnright];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)respondsToRightBtn:(UIButton *)sender{
    ExchangeRecordViewController *recordVc = [[ExchangeRecordViewController alloc] init];
    [self.navigationController pushViewController:recordVc animated:YES];
}

#pragma mark - ConversionSubjectViewDelegate
- (void)conversionCouponWithID:(NSString *)couponID{
    if (_isSubViewController) {
        if ([self.delegate respondsToSelector:@selector(conversionCouponWithID:)]) {
            [self.delegate conversionCouponWithID:couponID];
        }
    }else{
        VolumeContentViewController *ductViewC = [[VolumeContentViewController alloc] init];
        ductViewC.juancleid = couponID.integerValue;
        [self.navigationController pushViewController:ductViewC animated:YES];
    }
}

- (void)conversionMaterialWaresWithInfo:(NSDictionary *)infoDict
                                success:(void (^)(NSString *describle))success
                                failure:(void (^)(NSString *describle))failure{
    [self.dataController requestGiftExchangeDataWithView:_subjectView
                                                  giftID:infoDict[@"id"]
                                                    type:infoDict[@"type"]
                                                userInfo:infoDict[@"info"]
                                            present_type:infoDict[@"present_type"]
                                                callback:^(NSError *error, BOOL state, NSString *describle) {
                                                    if (state) {
                                                        if (success) success([NSString nullToString:describle]);
                                                    }else{
                                                        if(failure) failure([NSString nullToString:describle]);
                                                    }
                                                }];
}

- (void)welfareHomeSubjectViewReferCopperRule{
    if (_isSubViewController) {
        if ([self.delegate respondsToSelector:@selector(welfareHomeSubjectViewReferCopperRule)]) {
            [self.delegate welfareHomeSubjectViewReferCopperRule];
        }
    }else{
        TaskRuleViewController *ruleVc = [[TaskRuleViewController alloc] init];
        [self.navigationController pushViewController:ruleVc animated:YES];
    }
}

- (void)welfareHomeSubjectView:(ConversionSubjectView *)subjectView
      didSelectWaresWithItemId:(NSString *)waresId
                     waresType:(NSString *)type
                        haveto:(NSString *)haveto
                  present_type:(NSString *)present_type{
    if (_isSubViewController) {
        if ([self.delegate respondsToSelector:@selector(welfareHomeSubjectViewDidSelectWaresWithItemId:waresType:haveto:)]) {
            [self.delegate welfareHomeSubjectViewDidSelectWaresWithItemId:waresId waresType:type haveto:haveto];
        }
    }else{
        VolumeContentViewController *ductViewC = [[VolumeContentViewController alloc] init];
        ductViewC.juancleid = waresId.integerValue;
        if ([type isEqualToString:@"coupon"]) {
            ductViewC.type = waresTypeCoupon;
        }else{
            ductViewC.type = waresTypeMaterial;
        }
        ductViewC.haveto = haveto;
        ductViewC.present_type = present_type.intValue;
        [self.navigationController pushViewController:ductViewC animated:YES];
    }
}

- (void)welfareHomeSubjectViewReferLogisticsAddress{
    if (_isSubViewController) {
        if ([self.delegate respondsToSelector:@selector(welfareHomeSubjectViewReferLogisticsAddress:)]) {
            [self.delegate welfareHomeSubjectViewReferLogisticsAddress:^{
                [_subjectView showLastAlertView];
            }];
        }
    }else{
        AddressListViewController *addressListVc = [[AddressListViewController alloc] init];
        addressListVc.delegate = self;
        addressListVc.delegateitem = self;
        [self.navigationController pushViewController:addressListVc animated:YES];
    }
}

- (void)jumpLoginVc{
    if (_isSubViewController) {
        if ([self.delegate respondsToSelector:@selector(jumpLoginVc)]) {
            [self.delegate jumpLoginVc];
        }
    }else{
        VKLoginViewController* theViewController= [[VKLoginViewController alloc] init];
        [self.navigationController pushViewController:theViewController animated:YES ];
    }
}

#pragma mark - AddressListViewControllerDelegate
- (void)afreshConversionAlertView{
    [_subjectView showLastAlertView];
}

-(void)addressSelectItem:(id)value
{
    
    [_subjectView showLastAlertViewAddress:value];
    
}
///删除item
-(void)addressDelItem:(id)value
{
    
    
}

#pragma mark - setters and getters
- (ConversionDataController *)dataController{
    if (!_dataController) {
        _dataController = [[ConversionDataController alloc] init];
    }
    return _dataController;
}

@end
