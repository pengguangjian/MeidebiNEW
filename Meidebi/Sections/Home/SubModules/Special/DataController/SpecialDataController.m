//
//  SpecialDataController.m
//  Meidebi
//
//  Created by leecool on 2017/6/4.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "SpecialDataController.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"
typedef NS_ENUM(NSInteger, DragDirection) {
    DragDirectionUp,
    DragDirectionDown
};
@interface SpecialDataController ()

@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic, strong) NSDictionary *resultDict;
@property (nonatomic, assign) BOOL isSuccessZan;
@property (nonatomic, assign) BOOL isSuccessShou;
@property (nonatomic, assign) BOOL resportStatue;
@property (nonatomic, strong) UIView *targetView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSString *type;
@end

@implementation SpecialDataController

- (void)requestAllSpecialListInView:(UIView *)view
                           callback:(completeCallback)callback{
    [HTTPManager sendGETRequestUrlToService:URL_MainSpecials withParametersDictionry:nil view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
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

- (void)requestSpecialInfoDataWithID:(NSString *)specialID
                              inView:(UIView *)view
                            callback:(completeCallback)callback{
    NSDictionary *parmarter = @{@"id":[NSString nullToString:specialID],
                                @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]
                                };
    [HTTPManager sendGETRequestUrlToService:URL_SpecialDetail withParametersDictionry:parmarter view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
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

- (void)requestZanDataWithInView:(UIView *)view
                       specialID:(NSString *)specialID
                        callback:(completeCallback)callback{
    NSString *userkey=[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken];
    NSDictionary *dicURL=@{@"id":[NSString nullToString:specialID],
                           @"votes":@"1",
                           @"userid":userkey,
                           @"type":@"4"};
    [HTTPManager sendRequestUrlToService:URL_prace withParametersDictionry:dicURL view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        NSString *describle = @"";
        BOOL state = NO;
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dic=[str JSONValue];
            if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]] isEqualToString:@"VOTES_SUCCESS"]&&[[dic objectForKey:@"status"] integerValue] == 1) {
                _isSuccessZan = YES;
                [MDB_UserDefault showNotifyHUDwithtext:@"投票成功" inView:view];
            }else if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]] isEqualToString:@"YOUR_ARE_VOTEED"]){
                _isSuccessZan = NO;
                [MDB_UserDefault showNotifyHUDwithtext:@"你已经投过票了" inView:view];
            }
            state = YES;
            describle = dic[@"info"];
        }
        callback(error,state,describle);
    }];
    
}

- (void)requestShouDataWithInView:(UIView *)view
                        specialID:(NSString *)specialID
                         linkType:(NSString *)linkType
                         callback:(completeCallback)callback{
    NSDictionary *dicURL=@{@"id":[NSString nullToString:specialID],
                           @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                           @"fetype":linkType};
    [HTTPManager sendRequestUrlToService:URL_favorite withParametersDictionry:dicURL view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        NSString *describle = @"";
        BOOL state = NO;
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dic=[str JSONValue];
            if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]] isEqualToString:@"GET_DATA_SUCCESS"]&&[[dic objectForKey:@"status"] integerValue]) {
                if ([[dic objectForKey:@"data"]isKindOfClass:[NSString class]]) {
                    if ([[dic objectForKey:@"data"]isEqualToString:@"取消收藏成功！"]) {
                        _isSuccessShou = NO;
                    }else{
                        _isSuccessShou = YES;
                    }
                }
            }else if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]] isEqualToString:@"YOUR_ARE_VOTEED"]){
            }
            state = YES;
            describle = dic[@"info"];
        }
        callback(error,state,describle);
    }];
}

- (void)requestShareDataWithSpecialID:(NSString *)specialID
                             callback:(completeCallback)callback{
    NSDictionary *parameters = @{
                                 @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                                 @"id":[NSString nullToString:specialID],
                                 };
    [HTTPManager sendRequestUrlToService:URL_SpecialShare
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
                                  if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                                      NSDictionary *dic=[dicAll objectForKey:@"data"];
                                      if (dic) {
                                          _resultShareInfo = [ShareModel modelWithDict:dic];
                                          state = YES;
                                      }
                                      
                                  }
                              }
                              callback(error,state,describle);
                          }];
}

// 专题推荐列表
- (void)requestSpecialListInView:(UIView *)view
                            type:(NSString *)type
                        callback:(completeCallback)callback{
    _type = type;
    _targetView = view;
    _page = 1;
    [self loadDataWithDirection:DragDirectionDown callback:callback];
}

- (void)lastNewPageDataWithCallback:(completeCallback)callback{
    _targetView = nil;
    _page = 1;
    [self loadDataWithDirection:DragDirectionDown callback:callback];
}

- (void)nextPageDataWithCallback:(completeCallback)callback{
    _targetView = nil;
    _page += 1;
    [self loadDataWithDirection:DragDirectionUp callback:callback];
}
- (void)loadDataWithDirection:(DragDirection)direction callback:(completeCallback)callback{
    
    NSDictionary *parameters=@{@"category":[NSString nullToString:_type],
                               @"p":[NSString stringWithFormat:@"%@",@(_page)],
                               @"limit":@"20"};
    [HTTPManager sendGETRequestUrlToService:URL_SpecialList
                    withParametersDictionry:parameters
                                       view:_targetView
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
