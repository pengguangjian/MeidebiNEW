//
//  DaiGouHomeDataController.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/17.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "DaiGouHomeDataController.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"

@implementation DaiGouHomeDataController
// 获取代购首页数据
- (void)requestDGHomeDataInView:(UIView *)view
                       Callback:(completeCallback)callback
{
    
    [HTTPManager sendRequestUrlToService:MainDaiGouHomeUrl withParametersDictionry:nil view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
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

// 获取代购首页列表数据
- (void)requestDGHomeListDataLine:(int)page
                           lastid:(NSString *)strlastid
                         Callback:(completeCallback)callback
{
    NSDictionary *dicpush = @{@"page":[NSNumber numberWithInt:page],@"lastid":strlastid};
    [HTTPManager sendRequestUrlToService:MainDaiGouHomeListUrl withParametersDictionry:dicpush view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                if([[dicAll objectForKey:@"data"] isKindOfClass:[NSArray class]])
                {
                    _arrListData=[dicAll objectForKey:@"data"];
                    state = YES;
                }
                else
                {
                    _arrListData = nil;
                    state = NO;
                }
                
            }
            else
            {
                _arrListData = nil;
                state = NO;
            }
        }
        callback(error,state,describle);
    }];
}


///加入购物车
- (void)requestAddBuCarDataLine:(NSDictionary *)dicpush
                       Callback:(completeCallback)callback
{
    
    [HTTPManager sendRequestUrlToService:MainDaiGouHomeAddByCarUrl withParametersDictionry:dicpush view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([NSString nullToString:dicAll[@"status"]].intValue == 1) {
                state = YES;
            }
            
        }
        callback(error,state,describle);
    }];
    
}

// 获取搜索数据
- (void)requestDGSearchListDataLine:(NSDictionary *)dicpush
                             InView:(UIView *)view
                           Callback:(completeCallback)callback
{
    
    [HTTPManager sendGETRequestUrlToService:MainDaiGouSearchListUrl withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                if([[dicAll objectForKey:@"data"] isKindOfClass:[NSArray class]])
                {
                    _arrListData=[dicAll objectForKey:@"data"];
                    state = YES;
                }
                else
                {
                    _arrListData = nil;
                    state = NO;
                }
                
            }
            else
            {
                _arrListData = nil;
                state = NO;
            }
        }
        callback(error,state,describle);
    }];
}

@end
