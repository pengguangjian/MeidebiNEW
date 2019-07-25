//
//  HomeDataController.m
//  Meidebi
//
//  Created by mdb-admin on 2017/5/12.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "HomeDataController.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"
//#import <AdSupport/AdSupport.h>
typedef NS_ENUM(NSInteger, DragDirection) {
    DragDirectionUp,
    DragDirectionDown
};
@interface HomeDataController ()

@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic, strong) NSArray *requestBannerResults;
@property (nonatomic, strong) NSDictionary *resultDict;
@property (nonatomic, assign) NSInteger page;

@end

@implementation HomeDataController

- (void)requestBannerDataWithCallback:(completeCallback)callback{
    
    [HTTPManager sendGETRequestUrlToService:URL_showactive withParametersDictionry:nil view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
            _requestBannerResults=[MDB_UserDefault getActive];
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                NSArray *arr=[dicAll objectForKey:@"data"];
                if (arr&&arr.count>0) {
                    _requestBannerResults = arr;
                    [MDB_UserDefault setActive:arr];
                    state = YES;
                }
            }
        }
        callback(error,state,describle);
    }];
    
}

- (void)requestHomeDataInView:(UIView *)view
                     Callback:(completeCallback)callback{
    [HTTPManager sendGETRequestUrlToService:URL_HomeUrl withParametersDictionry:nil view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                NSDictionary *dict=[dicAll objectForKey:@"data"];
                if (dict) {
                    _resultDict = dict;
                    state = YES;
                }
            }
        }
        callback(error,state,describle);
    }];
}


////首页分类名称
- (void)requestHomeItemsDataInView:(UIView *)view
                          Callback:(completeCallback)callback
{
    NSDictionary *dicpush = @{@"v":@"2"};//1
    [HTTPManager sendRequestUrlToService:Home_Items_URL withParametersDictionry:dicpush view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                if ([dicAll[@"data"] isKindOfClass:[NSArray class]]) {
                    _resultItemsDict = dicAll[@"data"];
                    state = YES;
                }
            }
        }
        callback(error,state,describle);
    }];
    
}

- (void)requestSearchKeywordWithCallback:(completeCallback)callback{
    [HTTPManager sendRequestUrlToService:URL_searchkeyword withParametersDictionry:nil view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                if ([dicAll[@"data"] isKindOfClass:[NSString class]]) {
                    _resultHotSearchStr = [NSString nullToString:dicAll[@"data"]];
                    state = YES;
                }
            }
        }
        callback(error,state,describle);
    }];
}

- (void)requestUploadingIdfa{
//    NSDictionary *parameters = @{@"uniquetoken":[NSString nullToString:[ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString],
//                                 @"umengtoken":[NSString nullToString:[MDB_UserDefault getUmengDeviceToken]],
//                                 @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
//    [HTTPManager sendRequestUrlToService:URL_idfa withParametersDictionry:parameters view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
//    }];
}


//新消息
- (void)requestLoadNewsWithCallback:(completeCallback)callback{
    if ([MDB_UserDefault getIsLogin]) {
        NSDictionary *dic=@{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                            @"type":@"1"
                            };
        
        [HTTPManager sendRequestUrlToService:URL_usercenter withParametersDictionry:dic view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
            BOOL state = NO;
            NSString *describle = @"网络错误！";
            if (responceObjct){
                NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
                NSDictionary *dicAll=[str JSONValue];
                if ([[dicAll objectForKey:@"status"]intValue] == 1) {
                    NSDictionary *dict=[dicAll objectForKey:@"data"];
                    if (dict) {
                        _resultDict = dict;
                        state = YES;
                    }
                }else{
                    describle = dicAll[@"info"];
                }
            }
            callback(error,state,describle);
        }];
    }
}


#pragma mark -  足迹列表
- (void)requestMainTranisListCallback:(completeCallback)callback{
    _page = 1;
    [self loadDataWithDirection:DragDirectionDown callback:callback];
}

- (void)lastNewPageDataWithCallback:(completeCallback)callback{
    _page = 1;
    [self loadDataWithDirection:DragDirectionDown callback:callback];
}

- (void)nextPageDataWithCallback:(completeCallback)callback{
    _page += 1;
    [self loadDataWithDirection:DragDirectionUp callback:callback];
}
- (void)loadDataWithDirection:(DragDirection)direction callback:(completeCallback)callback{
    
    NSDictionary *parameters=@{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                               @"p":[NSString stringWithFormat:@"%@",@(_page)],
                               @"limit":@"20"};
    [HTTPManager sendGETRequestUrlToService:URL_Maintrends
                    withParametersDictionry:parameters
                                       view:nil
                             completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
                                 BOOL state = NO;
                                 NSString *describle = @"";
                                 if (responceObjct==nil) {
                                     describle = @"网络错误";
                                 }else{
                                     NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
                                     NSDictionary *dicAll=[str JSONValue];
                                     describle = dicAll[@"info"];
                                     if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                                         NSArray *subjects = dicAll[@"data"];
                                         if ([subjects isKindOfClass:[NSDictionary class]] || [subjects isKindOfClass:[NSString class]] || [subjects isKindOfClass:[NSNull class]]){
                                             describle = @"未查到相关数据";
                                             callback(nil,state,describle);
                                             return;
                                         };
                                         state = YES;
                                         if (direction == DragDirectionDown) {
                                             _requestResults=subjects.mutableCopy;
                                         }else{
                                             NSMutableArray *muta=[[NSMutableArray alloc]initWithArray:_requestResults];
                                             for (NSDictionary *dict in subjects) {
                                                 [muta addObject:dict];
                                             }
                                             _requestResults=[[NSArray arrayWithArray:muta] mutableCopy];
                                         }
                                     }
                                 }
                                 callback(error,state,describle);
                             }];
    
}


@end
