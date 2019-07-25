//
//  Home644DataController.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/7/2.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Home644DataController : NSObject

@property (nonatomic, strong) NSString *strjinxuan;
@property (nonatomic, strong, readonly) NSDictionary *resultListDict;
@property (nonatomic, strong) NSArray *arrListqwyh;

@property (nonatomic, strong) NSDictionary *resultJDDict;
@property (nonatomic, strong) NSArray *resultJDListDict;


////列表数据
- (void)requestHomeItemsDataInView:(UIView *)view
                               url:(NSString *)strurl
                            parter:(NSMutableDictionary *)parter
                          Callback:(completeCallback)callback;

////全网优惠列表数据
- (void)requestHomeItemsQWYHDataInView:(UIView *)view
                               url:(NSString *)strurl
                            parter:(NSMutableDictionary *)parter
                          Callback:(completeCallback)callback;


////京东列表数据
- (void)requestHomeItemsJDDataInView:(UIView *)view
                               url:(NSString *)strurl
                            parter:(NSMutableDictionary *)parter
                          Callback:(completeCallback)callback;

@end
