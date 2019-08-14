//
//  MyAccountDataController.h
//  Meidebi
//
//  Created by mdb-losaic on 2019/8/12.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyAccountDataController : NSObject
@property (nonatomic, retain) NSDictionary *dicresult;

@property (nonatomic, retain) NSDictionary *dictixian;

@property (nonatomic, retain) NSDictionary *dicLastTixian;

// 帐户余额
- (void)requestDGAccountYEInfoDataInView:(UIView *)view
                             dicpush:(NSDictionary *)dicpush
                            Callback:(completeCallback)callback;


// 申请提现
- (void)requestTiXianActionDataInView:(UIView *)view
                                 dicpush:(NSDictionary *)dicpush
                                Callback:(completeCallback)callback;

// 上次提现账号等信息
- (void)requestLastTiXianActionDataInView:(UIView *)view
                              dicpush:(NSDictionary *)dicpush
                             Callback:(completeCallback)callback;

@end

NS_ASSUME_NONNULL_END
