//
//  ProductInfoDataController.h
//  Meidebi
//
//  Created by mdb-admin on 16/4/28.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Qqshare;

@interface ProductInfoDataController : NSObject

@property (nonatomic, strong, readonly) NSDictionary *resultDict;
@property (nonatomic, strong, readonly) Qqshare *resultShareInfo;
@property (nonatomic, assign, readonly) BOOL isSuccessZan;
@property (nonatomic, assign, readonly) BOOL isSuccessShou;
@property (nonatomic, assign, readonly) BOOL resportStatue;
///代购下单数据
@property (nonatomic , retain) NSDictionary *dicValue;
///关注商品
@property (nonatomic , retain) NSDictionary *guanzhushangpingValue;

///关注商品
@property (nonatomic , retain) NSArray *qiukaituanValue;

- (void)requestSubjectDataWithInView:(UIView *)view
                         commodityid:(NSString *)commodityid
                            callback:(completeCallback)Callback;

- (void)requestShareSubjectDataWithCommodityid:(NSString *)commodityid
                                        inView:(UIView *)view
                                      callback:(completeCallback)callback;

- (void)requestByInfoSubjectDataWithCommodityid:(NSString *)commodityid
                                           type:(NSString *)type
                                         inView:(UIView *)view
                                       callback:(completeCallback)callback;

- (void)requestShareRecordDataWithUrl:(NSString *)url
                             callback:(completeCallback)callback;
// 点赞
- (void)requestZanDataWithInView:(UIView *)view
                     Commodityid:(NSString *)commodityid
                        callback:(completeCallback)callback;

- (void)requestShouDataWithInView:(UIView *)view
                      Commodityid:(NSString *)commodityid
                         linkType:(NSString *)linkType
                         callback:(completeCallback)callback;

// 举报
- (void)requestResportDataWithInView:(UIView *)view
                           productid:(NSString *)productid
                            callback:(completeCallback)callback;

// 关注
- (void)requestAddFollwDataWithInView:(UIView *)view
                               userid:(NSString *)userid
                             callback:(completeCallback)callback;


// 获取下单数据
- (void)requestDGHomeDataInView:(UIView *)view
                        dicpush:(NSDictionary *)dicpush
                       Callback:(completeCallback)callback;

///举报
-(void)requestJuBaoHomeDataInView:(UIView *)view
                       dicpush:(NSDictionary *)dicpush
                      Callback:(completeCallback)callback;

///求开团
-(void)requestQiukaiTuanHomeDataInView:(UIView *)view
                          dicpush:(NSDictionary *)dicpush
                         Callback:(completeCallback)callback;

///加入购物车
- (void)requestAddBuCarDataLine:(NSDictionary *)dicpush
                       Callback:(completeCallback)callback;

/// 关注爆料商品
- (void)requestguanzhushangpingDataWithInView:(UIView *)view
                               value:(NSDictionary *)dicpush
                             callback:(completeCallback)callback;

/// 求开团获取同款商品
- (void)requestgQiuKiaTuanItemsDataWithInView:(UIView *)view
                                        value:(NSDictionary *)dicpush
                                     callback:(completeCallback)callback;

@end
