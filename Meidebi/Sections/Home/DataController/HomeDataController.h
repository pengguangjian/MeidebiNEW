//
//  HomeDataController.h
//  Meidebi
//
//  Created by mdb-admin on 2017/5/12.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeDataController : NSObject

@property (nonatomic, strong, readonly) NSArray *requestResults;
@property (nonatomic, strong, readonly) NSArray *requestBannerResults;
@property (nonatomic, strong, readonly) NSDictionary *resultDict;
@property (nonatomic, strong, readonly) NSString *resultHotSearchStr;
@property (nonatomic, strong, readonly) NSArray *resultItemsDict;

// 获取banner数据
- (void)requestBannerDataWithCallback:(completeCallback)callback;

// 获取首页数据
- (void)requestHomeDataInView:(UIView *)view
                     Callback:(completeCallback)callback;

////首页分类名称
- (void)requestHomeItemsDataInView:(UIView *)view
                     Callback:(completeCallback)callback;

// 获取热搜词
- (void)requestSearchKeywordWithCallback:(completeCallback)callback;
// 获取新消息
- (void)requestLoadNewsWithCallback:(completeCallback)callback;
// 上传idfa
- (void)requestUploadingIdfa;

// 关注动态
- (void)requestMainTranisListCallback:(completeCallback)callback;
- (void)lastNewPageDataWithCallback:(completeCallback)callback;
- (void)nextPageDataWithCallback:(completeCallback)callback;
@end
