//
//  WelfareStrategySubjectView.h
//  Meidebi
//
//  Created by mdb-admin on 2017/6/27.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WelfareStrategyJumpType) {
    WelfareStrategyJumpTypeRegister = 100,   // 注册
    WelfareStrategyJumpTypePhoneAuthentication, //绑定手机
    WelfareStrategyJumpTypePerfectInfo, // 完善个人资料
    WelfareStrategyJumpTypeBoundOtherAccout,    // 绑定QQ/sina
    WelfareStrategyJumpTypeSubscribe,   // 订阅
    WelfareStrategyJumpTypeInvite,   // 邀请好友
    WelfareStrategyJumpTypeAttendance,   // 签到
    WelfareStrategyJumpTypeBroke,   // 爆料
    WelfareStrategyJumpTypeShaidan,   // 晒单
};

@protocol WelfareStrategySubjectViewDelegate <NSObject>

@optional - (void)welfareStrategyCollectionViewDidSelectCellWithType:(WelfareStrategyJumpType)type;
@optional - (void)welfareStrategyCollectionViewDidClickMyWelfareBtn;
@optional - (void)welfareStrategyCollectionViewRefreshHeader;
@optional - (void)welfareStrategyCollectionViewDidClickMyWelfareAd:(NSDictionary *)adInfo;

@end

@interface WelfareStrategySubjectView : UIView

@property (nonatomic, weak) id<WelfareStrategySubjectViewDelegate> delegate;

- (void)bindAdDataWithModel:(NSDictionary *)dict;
- (void)bindDynamicWithModel:(NSDictionary *)model;

@end
