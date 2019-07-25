//
//  WoGuanZhuDataController.h
//  Meidebi
//
//  Created by mdb-losaic on 2019/4/1.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WoGuanZhuDataController : NSObject

@property (nonatomic , retain) NSArray *arrrequest;
///是否关注
@property (nonatomic , retain) NSString *followed;
///标签
@property (nonatomic , retain) NSString *boaqianid;

@property (nonatomic , retain) NSArray *arrbqrequest;

- (void)requestWoGuanZhuDataInView:(UIView *)view
                               url:(NSString *)url
                        dicpush:(NSDictionary *)dicpush
                       Callback:(completeCallback)callback;


///关注和取消关注
- (void)requestWoGuanZhuIsCancleDataInView:(UIView *)view
                               url:(NSString *)url
                           dicpush:(NSDictionary *)dicpush
                          Callback:(completeCallback)callback;

///w标签详情列表获取
- (void)requestWoGuanZhuBiaoQianSListDataInView:(UIView *)view
                                       url:(NSString *)url
                                   dicpush:(NSDictionary *)dicpush
                                  Callback:(completeCallback)callback;
@end

NS_ASSUME_NONNULL_END
