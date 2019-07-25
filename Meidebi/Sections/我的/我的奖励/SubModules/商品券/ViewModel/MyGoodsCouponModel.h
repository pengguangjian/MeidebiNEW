//
//  MyGoodsCouponModel.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/12/28.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyGoodsCouponModel : NSObject
////优惠多少钱
@property (nonatomic , retain) NSString *denomination;
////
@property (nonatomic , retain) NSString *did;
////是否过期
@property (nonatomic , retain) NSString *istimeout;
////
@property (nonatomic , retain) NSString *name;
////
@property (nonatomic , retain) NSString *type;
////
@property (nonatomic , retain) NSString *use_endtime;
////
@property (nonatomic , retain) NSString *use_starttime;
////满多少使用
@property (nonatomic , retain) NSString *usecondition;
///
@property (nonatomic , retain) NSString *state;
///是否选中
@property (nonatomic , assign) BOOL isselect;

+(MyGoodsCouponModel *)dicValueChangeModelValue:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
