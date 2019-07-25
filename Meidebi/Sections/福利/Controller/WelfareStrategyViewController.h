//
//  WelfareStrategyViewController.h
//  Meidebi
//
//  Created by mdb-admin on 2017/6/26.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "RootViewController.h"
#import "WelfareStrategySubjectView.h"
@protocol WelfareStrategyViewControllerDelegate <NSObject>

@optional - (void)welfareStrategyViewControllerDidSelectCellWithType:(WelfareStrategyJumpType)type;
@optional - (void)welfareStrategyViewControllerDidClickMyWelfareBtn;
@optional - (void)welfareStrategyViewControllerDidClickMyWelfareAd:(NSDictionary *)adInfo;

@end

@interface WelfareStrategyViewController : RootViewController

@property (nonatomic, weak) id<WelfareStrategyViewControllerDelegate> delegate;

@end
