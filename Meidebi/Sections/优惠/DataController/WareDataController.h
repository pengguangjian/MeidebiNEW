//
//  WareDataController.h
//  Meidebi
//
//  Created by mdb-admin on 16/5/30.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,WaresTableVcType){
    WaresTableVcUnknown,
    WaresTableVcSearch
};

typedef NS_ENUM(NSInteger, WareRequestType) {
    WareRequestTypeEssence,   // 精华
    WareRequestTypeNew        // 最新
};

typedef NS_ENUM(NSInteger, WareType) {
    WareTypeAll,         //全部
    WareTypeTianMao,     //猫实惠
    WareTypeHaiTao,      //海淘
    WareTypeGuoNei,      //国内
    WareTypeJingXuan,    //精选
    WareTypeZhiYou,      //直邮
    WareType9BaoYou      //9.9包邮
};

@interface WareDataController : NSObject

@property (nonatomic, strong, readonly) NSArray *requestResults;
@property (nonatomic, strong, readonly) NSArray *requestBannerResults;
///关注商城需要的参数
@property (nonatomic, strong) NSString *followed;
@property (nonatomic, strong) NSString *did;
// 获取本地缓存
- (void)requestCacheWithCallback:(completeCallback)callback;

// 获取banner数据
- (void)requestBannerDataWithCallback:(completeCallback)callback;

// 获取商品数据
- (void)requestSubjectDataWithType:(WareRequestType)type
                  WaresTableVcType:(WaresTableVcType)tableType
                          wareType:(WareType)wareType
                              cats:(NSString *)cats
                            siteid:(NSString *)siteid
                            InView:(UIView *)view
                          callback:(completeCallback)Callback;

- (void)nextPageDataWithCallback:(completeCallback)callback;
- (void)lastNewPageDataWithCallback:(completeCallback)callback;
@end
