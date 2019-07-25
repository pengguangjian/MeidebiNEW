//
//  DailyLottoDataController.m
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/8/28.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "DailyLottoDataController.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"
typedef NS_ENUM(NSInteger, DragDirection) {
    DragDirectionUp,
    DragDirectionDown
};
@interface DailyLottoDataController ()

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UIView *targetView;

@end

@implementation DailyLottoDataController

- (void)requestPersonalDataWithInView:(UIView *)view callback:(completeCallback)callback{
    NSDictionary *dic=@{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                        @"type":@"1"
                        };
    [HTTPManager sendRequestUrlToService:URL_usercenter withParametersDictionry:dic view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        
        NSString *describle = @"网络错误！";
        BOOL state = NO;
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dictResult=[str JSONValue];
            NSInteger status = [dictResult[@"status"] integerValue];
            describle = dictResult[@"info"];
            if (status == 1) {
                if ([dictResult objectForKey:@"data"]) {
                    _resultDict = dictResult[@"data"];
                    state = YES;
                }
            }
        }
        callback(error,state,describle);
    }];

}
- (void)requestDoLottoDataWithInView:(UIView *)view callback:(completeCallback)callback{
    NSDictionary *parameters=@{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [HTTPManager sendRequestUrlToService:URL_LotteryDolottery
                 withParametersDictionry:parameters
                                    view:view
                          completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
                              NSString *describle = @"网络错误！";
                              BOOL state = NO;
                              if (responceObjct) {
                                  _lottoResultDict = nil;
                                  NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
                                  NSDictionary *dictResult=[str JSONValue];
                                  NSInteger status = [dictResult[@"status"] integerValue];
                                  describle = dictResult[@"info"];
                                  if (status == 1) {
                                      if ([dictResult objectForKey:@"data"]) {
                                          _lottoResultDict = dictResult[@"data"];
                                          state = YES;
                                      }
                                  }
                              }
                              callback(error,state,describle);

    }];

}

- (void)requestLottoListDataWithInView:(UIView *)view callback:(completeCallback)callback{
    NSDictionary *parameters=@{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [HTTPManager sendGETRequestUrlToService:URL_LotteryList
                 withParametersDictionry:parameters
                                    view:view
                          completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
                              NSString *describle = @"网络错误！";
                              BOOL state = NO;
                              if (responceObjct) {
                                  _resultDict = nil;
                                  NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
                                  NSDictionary *dictResult=[str JSONValue];
                                  NSInteger status = [dictResult[@"status"] integerValue];
                                  describle = dictResult[@"info"];
                                  if (status == 1) {
                                      if ([dictResult objectForKey:@"data"]) {
                                          _resultDict = dictResult[@"data"];
                                          state = YES;
                                      }
                                  }
                              }
                              callback(error,state,describle);

    }];

}


- (void)requestLottoRecordListDataWithInView:(UIView *)view callback:(completeCallback)callback{
    
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
    NSDictionary *parameters=@{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                               @"p":[NSString stringWithFormat:@"%@",@(_page)],
                               @"limit":@"20"};
    [HTTPManager sendGETRequestUrlToService:URL_LotteryRecord
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
