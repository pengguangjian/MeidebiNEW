//
//  CouponResultViewController.h
//  Meidebi
//
//  Created by mdb-admin on 2017/7/10.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "RootViewController.h"

@protocol CouponResultViewControllerDelegate <NSObject>

@optional - (void)couponResultViewDidClickDrawCouponBtnWithUrl:(NSString *)url;
@optional - (void)couponResultViewControllerDidScroll;

@end

@interface CouponResultViewController : RootViewController
@property (nonatomic, weak) id<CouponResultViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *keyword;

@end
