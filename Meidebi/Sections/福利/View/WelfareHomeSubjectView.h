//
//  WelfareHomeSubjectView.h
//  Meidebi
//
//  Created by mdb-admin on 2016/10/24.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WelfareStrategyViewController.h"
@protocol WelfareHomeSubjectViewDelegate <NSObject>

@optional - (void)welfareHomeSubjectViewDidSelectCellWithType:(WelfareStrategyJumpType)type;
@optional - (void)welfareHomeSubjectViewDidClickMyWelfareBtn;
@optional - (void)welfareHomeSubjectViewDidClickAvater:(NSString *)userid;
@optional - (void)welfareHomeSubjectViewDidClickAd:(NSDictionary *)adInfo;
@optional - (void)welfareHomeSubjectViewDidNAv:(UIView *)navTitleView;

@optional - (void)welfareHomeSubjectViewConversionCouponWithID:(NSString *)couponID;
@optional - (void)welfareHomeSubjectViewReferCopperRule;
@optional - (void)welfareHomeSubjectViewDidSelectWaresWithItemId:(NSString *)waresId
                                                       waresType:(NSString *)type
                                                          haveto:(NSString *)haveto;
@optional - (void)welfareHomeSubjectViewReferLogisticsAddress:(void (^)(void))complete;
@optional - (void)welfareHomeSubjectViewJumpLoginVc;
@end

@interface WelfareHomeSubjectView : UIView

@property (nonatomic, weak) id<WelfareHomeSubjectViewDelegate> delegate;
@property (nonatomic, copy) void(^didComplete)(UIView *navTitleView);
- (instancetype)initWithCurrentNavigationController:(UINavigationController *)nav;
- (void)bindAttendenceDataWithModel:(NSDictionary *)model;
- (void)bindWaresDataWithModel:(NSArray *)model;
- (void)update;
@end
