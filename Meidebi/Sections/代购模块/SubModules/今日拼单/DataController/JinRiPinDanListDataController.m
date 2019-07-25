//
//  JinRiPinDanListDataController.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/17.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "JinRiPinDanListDataController.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"

@implementation JinRiPinDanListDataController

// 获取列表数据
- (void)requestDGHomeListDataInView:(UIView *)view
                               Line:(int)page
                           Callback:(completeCallback)callback
{
    NSDictionary *dicpush = @{@"page":[NSNumber numberWithInt:page]};
    [HTTPManager sendRequestUrlToService:MainDaiGouPinDanListUrl withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([[NSString nullToString:dicAll[@"status"]] isEqualToString:@"1"]) {
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


// 获取分类列表数据
- (void)requestDGHomeListDataInView:(UIView *)view
                          pushvalue:(NSDictionary *)dicpush
                             andurl:(NSString *)strurl
                              ipost:(int)ipost
                           Callback:(completeCallback)callback
{
    if(ipost==1)
    {
        [HTTPManager sendRequestUrlToService:strurl withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
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
    else
    {
        [HTTPManager sendGETRequestUrlToService:strurl withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
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
    
    
}


///代购排行榜
- (void)requestdgpaihangbangInView:(UIView *)view
                         pushvalue:(NSDictionary *)dicpush
                          Callback:(completeCallback)callback
{
    
    [HTTPManager sendRequestUrlToService:DaiGoupaihangbangListUrl withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
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
                    _arrdgpaihangbangData=[dicAll objectForKey:@"data"];
                    state = YES;
                }
                else
                {
                    _arrdgpaihangbangData = nil;
                    state = NO;
                }
                
            }
            else
            {
                _arrdgpaihangbangData = nil;
                state = NO;
            }
        }
        callback(error,state,describle);
    }];
    
}

@end
