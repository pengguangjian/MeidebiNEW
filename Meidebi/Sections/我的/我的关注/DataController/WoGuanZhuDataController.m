//
//  WoGuanZhuDataController.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/4/1.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import "WoGuanZhuDataController.h"
#import "HTTPManager.h"


@implementation WoGuanZhuDataController

- (void)requestWoGuanZhuDataInView:(UIView *)view
                               url:(NSString *)url
                           dicpush:(NSDictionary *)dicpush
                          Callback:(completeCallback)callback
{
    
    [HTTPManager sendGETRequestUrlToService:url withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
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
                    NSArray *arrtemt=[dicAll objectForKey:@"data"];
                    if (arrtemt) {
                        _arrrequest = arrtemt;
                        state = YES;
                    }
                }
                
            }
        }
        callback(error,state,describle);
    }];
    
}

///关注和取消关注
- (void)requestWoGuanZhuIsCancleDataInView:(UIView *)view
                                       url:(NSString *)url
                                   dicpush:(NSDictionary *)dicpush
                                  Callback:(completeCallback)callback
{
    
    [HTTPManager sendRequestUrlToService:url withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                state = YES;
            }
        }
        callback(error,state,describle);
    }];
}

///w标签详情列表获取
- (void)requestWoGuanZhuBiaoQianSListDataInView:(UIView *)view
                                            url:(NSString *)url
                                        dicpush:(NSDictionary *)dicpush
                                       Callback:(completeCallback)callback
{
    
    [HTTPManager sendGETRequestUrlToService:url withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                if([[[dicAll objectForKey:@"data"] objectForKey:@"tag"] isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *dictag = [[dicAll objectForKey:@"data"] objectForKey:@"tag"];
                    _followed = [NSString nullToString:[dictag objectForKey:@"followed"]];
                    _boaqianid = [NSString nullToString:[dictag objectForKey:@"id"]];
                }
                
                if([[[dicAll objectForKey:@"data"] objectForKey:@"linklist"] isKindOfClass:[NSArray class]])
                {
                    NSArray *arrtemt=[[dicAll objectForKey:@"data"] objectForKey:@"linklist"];
                    if (arrtemt) {
                        _arrbqrequest = arrtemt;
                        state = YES;
                    }
                }
                
            }
        }
        callback(error,state,describle);
    }];
    
}

@end
