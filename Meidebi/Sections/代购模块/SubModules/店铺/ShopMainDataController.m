//
//  ShopMainDataController.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/18.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "ShopMainDataController.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"

@implementation ShopMainDataController

// 获取列表数据
- (void)requestDGHomeListDataInView:(UIView *)view
                               Line:(int)page
                            site_id:(NSString *)strsiteid
                           Callback:(completeCallback)callback
{
    NSDictionary *dicpush = @{@"page":[NSNumber numberWithInt:page],@"site_id":strsiteid};
    [HTTPManager sendRequestUrlToService:MainDaiGouShopGoodsListUrl withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
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
        }
        callback(error,state,describle);
    }];
//    [HTTPManager sendGETRequestUrlToService:MainDaiGouShopGoodsListUrl withParametersDictionry:dicpush view:view completeHandle:^(AFHTTPRequestOperation *opration, id responceObjct, NSError *error) {
//        BOOL state = NO;
//        NSString *describle = @"";
//        if (responceObjct==nil) {
//            describle = @"网络错误";
//        }else{
//            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
//            NSDictionary *dicAll=[str JSONValue];
//            describle = dicAll[@"info"];
//            if ([[NSString nullToString:dicAll[@"status"]] isEqualToString:@"1"]) {
//                if([[dicAll objectForKey:@"data"] isKindOfClass:[NSArray class]])
//                {
//                    _arrListData=[dicAll objectForKey:@"data"];
//                    state = YES;
//                }
//                else
//                {
//                    _arrListData = nil;
//                    state = NO;
//                }
//
//            }
//        }
//        callback(error,state,describle);
//    }];
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

@end
