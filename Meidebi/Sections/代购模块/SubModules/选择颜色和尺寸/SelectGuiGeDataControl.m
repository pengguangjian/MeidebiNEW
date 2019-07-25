//
//  SelectGuiGeDataControl.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/11/15.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "SelectGuiGeDataControl.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"

@interface SelectGuiGeDataControl ()

@property (nonatomic , retain) NSURLSessionTask *task;

@end

@implementation SelectGuiGeDataControl

// 获取规格数据
- (void)requestGuiGeAllDataLine:(NSDictionary *)dicpush
                         InView:(UIView *)view
                       Callback:(completeCallback)callback
{
    
//    __block NSDictionary *dicpushtemp = dicpush;
    _task = [HTTPManager sendGETRequestUrlToService:DaiGouAllGuiGeUrl withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        _task = nil;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
//            NSData *datat = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
//            NSString *errorStr = [[NSString alloc] initWithData:datat encoding:NSUTF8StringEncoding];
//
//            NSDictionary *dictemp = dicpushtemp;
//
//            NSString *strtmep = @"1";
            
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                if([[dicAll objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
                {
                    _resultDict=[dicAll objectForKey:@"data"];
                    state = YES;
                }
                else
                {
                    _resultDict = nil;
                    state = NO;
                }
                
            }
            else
            {
                _resultDict = nil;
                state = NO;
            }
        }
        callback(error,state,describle);
    }];
    
}

// 获取对应具体规格数据
- (void)requestGuiGeItemDataLine:(NSDictionary *)dicpush
                          InView:(UIView *)view
                        Callback:(completeCallback)callback
{
    _task = [HTTPManager sendGETRequestUrlToService:DaiGouItemGuiGeUrl withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        _task = nil;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                if([[dicAll objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
                {
                    _resultItemDict=[dicAll objectForKey:@"data"];
                    state = YES;
                }
                else
                {
                    _resultItemDict = nil;
                    state = NO;
                }
                
            }
            else
            {
                _resultItemDict = nil;
                state = NO;
            }
        }
        callback(error,state,describle);
        
    }];
    
}

-(void)cancleRequest
{
    if(_task)
    {
        [_task cancel];
    }
    
}

@end
