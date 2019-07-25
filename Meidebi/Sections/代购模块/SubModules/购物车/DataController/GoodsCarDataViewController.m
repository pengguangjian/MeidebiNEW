//
//  GoodsCarDataViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/9/29.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "GoodsCarDataViewController.h"
#import "HTTPManager.h"

@implementation GoodsCarDataViewController

///购物车列表
- (void)requestBuCarListDataLine:(NSDictionary *)dicpush
                            view:(UIView *)view
                        Callback:(completeCallback)callback
{
    
    [HTTPManager sendRequestUrlToService:MainDaiGouHomeByCarListUrl withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
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
                    _arrreqList=[dicAll objectForKey:@"data"];
                    state = YES;
                }
                else
                {
                    _arrreqList = nil;
                    state = NO;
                }
                
            }
            else
            {
                _arrreqList = nil;
                state = NO;
            }
        }
        callback(error,state,describle);
    }];
    
}

///编辑商品数量 或删除
- (void)requestBuCarListItemEditDataLine:(NSDictionary *)dicpush
                                    view:(UIView *)view
                                Callback:(completeCallback)callback
{
    
    [HTTPManager sendRequestUrlToService:MainDaiGouHomeByCarListItemEditUrl withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
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

///选中|取消选中商品
- (void)requestBuCarListItemSelectDataLine:(NSDictionary *)dicpush
                                      view:(UIView *)view
                                  Callback:(completeCallback)callback
{
    
    [HTTPManager sendRequestUrlToService:MainDaiGouHomeByCarListItemSelectUrl withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
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

////去结算
- (void)requestBuCarListJieSuanDataLine:(NSDictionary *)dicpush
                                   view:(UIView *)view
                               Callback:(completeCallback)callback
{
    [HTTPManager sendRequestUrlToService:MainDaiGouHomeByCarListJieSuanUrl withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                
                _dicJieSuan = [dicAll objectForKey:@"data"];
                
                state = YES;
            }
            
        }
        callback(error,state,describle);
    }];
    
}

////修改规格
- (void)requestBuCarListChangeItemGuiGeDataLine:(NSDictionary *)dicpush
                                           view:(UIView *)view
                                       Callback:(completeCallback)callback
{
    
    [HTTPManager sendRequestUrlToService:MainDaiGouHomeByCarListChangeItemGuiGeUrl withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
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

@end
