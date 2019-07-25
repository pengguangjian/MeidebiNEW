//
//  RemarkDatacontroller.h
//  Meidebi
//
//  Created by mdb-admin on 2017/2/8.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,RemarkType) {
    RemarkTypeNormal = 1,
    RemarkTypeShare,            //晒单
    RemarkTypeCoupon,           //优惠券
    RemarkTypeCommentAwards = 4,    //评论有奖
    RemarkTypeAccumulate = 5       //积攒
};

@interface RemarkHomeDatacontroller : NSObject

@property (nonatomic, readonly, strong) NSArray *resultArray;
@property (nonatomic, readonly, strong) NSDictionary *resultDict;
@property (nonatomic,  strong) NSArray *resultAtDict;

// 获取评论数据
- (void)requestRemarkDataWithType:(RemarkType)type
                           linkid:(NSString *)linkid
                           InView:(UIView *)view
                         callback:(completeCallback)Callback;

- (void)nextPageDataWithCallback:(completeCallback)callback;
- (void)lastNewPageDataWithCallback:(completeCallback)callback;

- (void)requestRemarkPriseDataWithType:(RemarkType)type
                             CommentID:(NSString *)commentid
                                InView:(UIView *)view
                              callback:(completeCallback)Callback;


- (void)requestComfireRemarkDataWithParameters:(NSDictionary *)parameters
                                        InView:(UIView *)view
                                      callback:(completeCallback)Callback;


- (void)requestHandleRemarkDataWithParameters:(NSDictionary *)parameters
                                        InView:(UIView *)view
                                      callback:(completeCallback)Callback;

- (void)requestImageTokenDataImageCount:(NSInteger)images
                             InView:(UIView *)view
                           callback:(completeCallback)Callback;

///@快捷查询
- (void)requestAtData:(NSString *)strvalue
                               callback:(completeCallback)Callback;

@end
