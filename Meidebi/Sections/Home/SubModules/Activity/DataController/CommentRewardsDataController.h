//
//  CommentRewardsDataController.h
//  Meidebi
//
//  Created by fishmi on 2017/5/25.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Qqshare;
@interface CommentRewardsDataController : NSObject

@property (nonatomic, strong) NSDictionary *requestCommentRewardsDataControllerResults;
@property(nonatomic,strong)NSString *activityId;
@property (nonatomic, strong, readonly) Qqshare *resultShareInfo;
@property (nonatomic, assign, readonly) BOOL isSuccessZan;
@property (nonatomic, assign, readonly) BOOL isSuccessShou;
@property (nonatomic, assign, readonly) BOOL resportStatue;




- (void)requestCommentRewardsDataInView: (UIView *)view WithCallback:(completeCallback)callback;

- (void)requestShareSubjectDataWithCommodityid:(NSString *)commodityid
                                        inView:(UIView *)view
                                      callback:(completeCallback)callback;

- (void)requestShouDataWithInView:(UIView *)view
                      Commodityid:(NSString *)commodityid
                         callback:(completeCallback)callback;
- (void)requestZanDataWithInView:(UIView *)view
                     Commodityid:(NSString *)commodityid
                        callback:(completeCallback)callback;
@end

