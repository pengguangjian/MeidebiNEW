//
//  BrokeShareDataController.h
//  Meidebi
//
//  Created by mdb-admin on 16/7/28.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrokeShareDataController : NSObject

@property (nonatomic, strong, readonly) NSString *resultMessage;
@property (nonatomic, strong, readonly) NSDictionary *requestBrokeInfoResults;
@property (nonatomic, strong, readonly) NSArray *requestCateResults;

//获取爆料URL的商品信息
- (void)requestGetShareInfoDataWithLink:(NSString *)link
                                   type:(NSString *)type
                                 InView:(UIView *)view
                               callback:(completeCallback)Callback;


/**
 *  获取分类
 *
 *  @param view     view
 *  @param Callback block
 */
- (void)requestGetCateDataWithInView:(UIView *)view
                            callback:(completeCallback)Callback;

/**
 *  爆料接口
 *
 *  @param infoDict broke info
 *  @param view     super view
 *  @param Callback block
 */
- (void)requestSubmitBrokeWithInfo:(NSDictionary *)infoDict
                            InView:(UIView *)view
                            callback:(completeCallback)Callback;
@end
