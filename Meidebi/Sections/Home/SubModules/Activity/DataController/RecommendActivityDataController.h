//
//  RecommendActivityDataController.h
//  Meidebi
//
//  Created by fishmi on 2017/5/18.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendActivityDataController : NSObject

@property (nonatomic, strong, readonly) NSDictionary *requestRecommendActivityResults;
@property (nonatomic ,strong) NSString *recommendId;


// 获取banner数据
- (void)latestDataInView :(UIView *)view WithCallback:(completeCallback)callback;
- (void)hotDataInView :(UIView *)view WithCallback:(completeCallback)callback;
- (void)nextPageDataInView :(UIView *)view WithCallback:(completeCallback)callback;
- (void)requestRecommendListDataInView :(UIView *)view WithCallback:(completeCallback)callback;
- (void)requestRecommendHeadViewDataInView :(UIView *)view WithCallback:(completeCallback)callback;
@end
