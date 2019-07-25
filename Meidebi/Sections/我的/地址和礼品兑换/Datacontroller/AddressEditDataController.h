//
//  AddressEditDataController.h
//  Meidebi
//
//  Created by mdb-admin on 2016/11/3.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressEditDataController : NSObject

@property (nonatomic, readonly, strong) NSDictionary *resultDict;

@property (nonatomic , retain) NSArray *arrlist;

// 获取地址
- (void)requestAcquireAddressInView:(UIView *)view
                           callback:(completeCallback)callback;
// 获取地址
- (void)requestAcquireAddressInView1:(UIView *)view
                           callback:(completeCallback)callback;

// 删除地址
- (void)requestDeleteAddressInView:(UIView *)view
                         addressID:(NSString *)addressID
                          callback:(completeCallback)callback;

// 保存地址
- (void)requestSaveAddressWithParameters:(NSDictionary *)address
                                  inView:(UIView *)view
                                callback:(completeCallback)callback;

///设置默认地址
- (void)requestNomoAddressWithParameters:(NSString *)addressID
                                  inView:(UIView *)view
                                callback:(completeCallback)callback;


@end
