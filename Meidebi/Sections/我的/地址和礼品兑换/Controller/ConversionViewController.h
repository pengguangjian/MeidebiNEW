//
//  ConversionViewController.h
//  Meidebi
//
//  Created by mdb-admin on 2017/6/22.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "RootViewController.h"

@protocol ConversionViewControllerDelegate <NSObject>
@optional - (void)conversionCouponWithID:(NSString *)couponID;
@optional - (void)welfareHomeSubjectViewReferCopperRule;
@optional - (void)welfareHomeSubjectViewDidSelectWaresWithItemId:(NSString *)waresId
                                                       waresType:(NSString *)type
                                                          haveto:(NSString *)haveto;
@optional - (void)welfareHomeSubjectViewReferLogisticsAddress:(void (^)(void))complete;
@optional - (void)jumpLoginVc;

@end

@interface ConversionViewController : RootViewController
@property (nonatomic, weak) id<ConversionViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL isSubViewController;
@end
