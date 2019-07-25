//
//  ShareDataController.h
//  Meidebi
//
//  Created by losaic on 16/8/2.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void(^completionCallback)(NSError *error);

@interface ShareDataController : NSObject

@property (nonatomic, strong, readonly) NSString *resultMessage;
@property (nonatomic, strong, readonly) NSDictionary *requestBrokeInfoResults;
@property (nonatomic, strong, readonly) NSArray *requestCateResults;

//获取爆料URL的商品信息
- (void)requestGetShareInfoDataWithLink:(NSString *)link
                                 InView:(UIView *)view
                               callback:(completionCallback)Callback;


/**
 *  获取分类
 *
 *  @param view     view
 *  @param Callback block
 */
- (void)requestGetCateDataWithInView:(UIView *)view
                            callback:(completionCallback)Callback;

/**
 *  爆料接口
 *
 *  @param infoDict broke info
 *  @param view     super view
 *  @param Callback block
 */
- (void)requestSubmitBrokeWithInfo:(NSDictionary *)infoDict
                            InView:(UIView *)view
                          callback:(completionCallback)Callback;
@end
