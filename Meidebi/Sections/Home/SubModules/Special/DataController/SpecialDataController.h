//
//  SpecialDataController.h
//  Meidebi
//
//  Created by leecool on 2017/6/4.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareModel.h"
@interface SpecialDataController : NSObject

@property (nonatomic, strong, readonly) ShareModel *resultShareInfo;
@property (nonatomic, strong, readonly) NSArray *requestResults;
@property (nonatomic, strong, readonly) NSDictionary *resultDict;
@property (nonatomic, assign, readonly) BOOL isSuccessZan;
@property (nonatomic, assign, readonly) BOOL isSuccessShou;
@property (nonatomic, assign, readonly) BOOL resportStatue;

// 专题推荐列表
- (void)requestSpecialListInView:(UIView *)view
                            type:(NSString *)type
                        callback:(completeCallback)callback;
- (void)lastNewPageDataWithCallback:(completeCallback)callback;
- (void)nextPageDataWithCallback:(completeCallback)callback;

// 专题推荐详情
- (void)requestSpecialInfoDataWithID:(NSString *)specialID
                              inView:(UIView *)view
                            callback:(completeCallback)callback;

// 点赞
- (void)requestZanDataWithInView:(UIView *)view
                     specialID:(NSString *)specialID
                        callback:(completeCallback)callback;

- (void)requestShouDataWithInView:(UIView *)view
                        specialID:(NSString *)specialID
                         linkType:(NSString *)linkType
                         callback:(completeCallback)callback;

- (void)requestShareDataWithSpecialID:(NSString *)specialID
                             callback:(completeCallback)callback;

@end
