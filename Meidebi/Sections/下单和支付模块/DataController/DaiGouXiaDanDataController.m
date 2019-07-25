//
//  DaiGouXiaDanDataController.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/18.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "DaiGouXiaDanDataController.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"


#import <Qiniu/QiniuSDK.h>

#import "GMDCircleLoader.h"

#import "TKQiniuHelper.h"

@implementation DaiGouXiaDanDataController

// DaiGouXiaDanDataController
- (void)requestDGHomeDataInView:(UIView *)view
                        dicpush:(NSDictionary *)dicpush
                       Callback:(completeCallback)callback
{
    [HTTPManager sendGETRequestUrlToService:DaiGouXiaDanViewUrl withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
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
                    _dicValue = dict;
                    state = YES;
                }
            }
        }
        callback(error,state,describle);
    }];
}

// 获取运费数据
- (void)requestExpressDataInView:(UIView *)view
                         dicpush:(NSDictionary *)dicpush
                        Callback:(completeCallback)callback
{
    NSString *strurl = @"";
    if([[dicpush objectForKey:@"num"] intValue]>0)
    {
        strurl = DaiGouXiaDanExpressViewUrl;
    }
    else
    {
        strurl = DaiGouXiaDanExpressViewUrl1;
    }
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
                NSArray *arrdic=[dicAll objectForKey:@"data"];
                if (arrdic) {
                    _arrExrequest = (NSMutableArray *)arrdic;
                    state = YES;
                }
            }
        }
        callback(error,state,describle);
    }];
}

// 获取身份证数据
- (void)requestUserInfoDataInView:(UIView *)view
                          dicpush:(NSDictionary *)dicpush
                         Callback:(completeCallback)callback
{
    
    [HTTPManager sendGETRequestUrlToService:DaiGouXiaDanUserInfoViewUrl withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
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
                    _dicUserInfo = dict;
                    state = YES;
                }
            }
        }
        callback(error,state,describle);
    }];
    
}

///七牛上传图片
- (void)requestqiniuImageDataInView:(UIView *)view
                            dicpush:(NSArray *)arrpushimage
                           Callback:(completeCallback)callback
{
    if (view) {
        [GMDCircleLoader setOnView:view withTitle:nil animated:YES];
    }
    
    NSDictionary *pramr=@{@"count":[NSString stringWithFormat:@"%@",@(arrpushimage.count)],
                          @"type":@"idcard",
                          @"ext":@"png",
                          @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    ///
    [HTTPManager sendRequestUrlToService:URL_uploadtoken withParametersDictionry:pramr view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        __block BOOL state0 = NO;
        __block NSString *describle = @"";
        if (responceObjct!=nil){
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            NSDictionary *dictoken = [dicAll objectForKey:@"data"];
            [[TKQiniuHelper currentHelper] uploadImageToQNWithTokens:dictoken images:arrpushimage callback:^(BOOL state, NSArray *urls) {
                if(view)
                {
                    [GMDCircleLoader hideFromView:view animated:YES];
                }
                if(state)
                {
                    state0 = YES;
                    _arrqiniu = urls;
                    callback(error,state0,describle);
                }
                else
                {
                    describle = @"身份证上传失败";
                   callback(error,state0,describle);
                }
                
            }];
            
        }else{
            if(view)
            {
                [GMDCircleLoader hideFromView:view animated:YES];
            }
            describle = @"网络错误";
            callback(error,state0,describle);
            
        }
        
    }];
     
    
}

///下单
-(void)requestXiaDanDataInView:(UIView *)view
                       dicpush:(NSDictionary *)dicpush
                      Callback:(completeCallback)callback
{
    NSString *strurl = @"";
    if([[dicpush objectForKey:@"num"] intValue]>0)
    {
        strurl = DaiGouXiaDanGetOrderViewUrl;
    }
    else
    {
        strurl = DaiGouXiaDanGetOrderViewUrl1;
    }
    
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
                NSDictionary *dict=[dicAll objectForKey:@"data"];
                if (dict) {
                    _dicXiaDan = dict;
                    state = YES;
                }
            }
        }
        callback(error,state,describle);
    }];
    
}


@end
