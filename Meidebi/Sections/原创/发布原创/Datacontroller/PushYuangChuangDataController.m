//
//  PushYuangChuangDataController.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/9/11.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "PushYuangChuangDataController.h"
#import "HTTPManager.h"

#import "MDB_UserDefault.h"

@implementation PushYuangChuangDataController

- (void)requestOriginalDetailWithID:(NSDictionary *)dicpush
                         targetView:(UIView *)view
                           callback:(completeCallback)callback
{
    [HTTPManager sendGETRequestUrlToService:URL_LinkGoodsMessage
                 withParametersDictionry:dicpush
                                    view:view
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
                                      _diclinkValue = [dicAll objectForKey:@"data"];
                                      state = YES;
                                  }
                              }
                              callback(error,state,describle);
                          }];
}


////获取视频上传token
- (void)requestUploadMovieToken:(NSString *)ext
                     targetView:(UIView *)targetView
                       callback:(completeCallback)callback
{
    NSDictionary *pramr=@{@"ext":ext,
                          @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [HTTPManager sendRequestUrlToService:URL_movieuploadtoken withParametersDictionry:pramr view:targetView completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct!=nil){
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[dicAll objectForKey:@"status"]intValue] == 1) {
                state = YES;
                _dicMovieToken = dicAll[@"data"];
            }else{
                describle = dicAll[@"info"];
            }
        }else{
            describle = @"网络错误";
        }
        callback(error,state,describle);
    }];
    
    
}


////获取图片上传token
- (void)requestUploadImageToken:(NSInteger)pictureCount
                     targetView:(UIView *)targetView
                       callback:(completeCallback)callback
{
    
    NSDictionary *pramr=@{@"count":[NSString stringWithFormat:@"%@",@(pictureCount)],
                          @"type":@"2",
                          @"ext":@"png",
                          @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [HTTPManager sendRequestUrlToService:URL_uploadtoken withParametersDictionry:pramr view:targetView completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct!=nil){
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[dicAll objectForKey:@"status"]intValue] == 1) {
                state = YES;
                _dicImageToken = dicAll[@"data"];
            }else{
                describle = dicAll[@"info"];
            }
        }else{
            describle = @"网络错误";
        }
        callback(error,state,describle);
    }];
    
}


////保存草稿
- (void)requestUploadCaoGaoValue:(NSDictionary *)dicpush
                      targetView:(UIView *)targetView
                        callback:(completeCallback)callback
{
    
    [HTTPManager sendRequestUrlToService:URL_TopicCategraycaogaoSave3
                    withParametersDictionry:dicpush
                                       view:targetView
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
                                         _dicCaoGaoValue = [dicAll objectForKey:@"data"];
                                         state = YES;
                                     }
                                 }
                                 callback(error,state,describle);
                             }];
    
    
}


////获取草稿
- (void)requestGetCaoGaoValue:(NSDictionary *)dicpush
                   targetView:(UIView *)targetView
                     callback:(completeCallback)callback
{
    
    [HTTPManager sendRequestUrlToService:URL_TopicCategraycaogaoGet3
                 withParametersDictionry:dicpush
                                    view:targetView
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
                                      _dicnomoCaoGaoValue = [dicAll objectForKey:@"data"];
                                      state = YES;
                                  }
                              }
                              callback(error,state,describle);
                          }];
    
}


@end
