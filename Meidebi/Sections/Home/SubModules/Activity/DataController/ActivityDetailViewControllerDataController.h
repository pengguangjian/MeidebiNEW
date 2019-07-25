//
//  ActivityDetailViewControllerDataController.h
//  Meidebi
//
//  Created by fishmi on 2017/5/25.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareModel.h"

@interface ActivityDetailViewControllerDataController : NSObject

@property (nonatomic, strong) NSDictionary *requestActivityDetailResults;
@property (nonatomic, strong) NSString *activityId;
@property (nonatomic, strong, readonly) ShareModel *resultShareInfo;
@property (nonatomic, assign, readonly) BOOL isSuccessZan;
@property (nonatomic, assign, readonly) BOOL isSuccessShou;
@property (nonatomic, assign, readonly) BOOL resportStatue;
@property (nonatomic, strong) NSDictionary *dict;

- (void)requestActivityDetailDataWithInView:(UIView *)view
                                   callback:(completeCallback)callback;

- (void)requestActivityShareDataWithJoinID:(NSString *)joinID
                                  callback:(completeCallback)callback;

- (void)requestZanDataWithInView:(UIView *)view
                     Commodityid:(NSString *)commodityid
                        callback:(completeCallback)callback;

- (void)requestShouDataWithInView:(UIView *)view
                      Commodityid:(NSString *)commodityid
                         callback:(completeCallback)callback;
- (void)requestAddFollwDataWithInView:(UIView *)view
                               userid:(NSString *)userid
                             callback:(completeCallback)callback;
@end
