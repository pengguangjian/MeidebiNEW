//
//  MyTrackDataController.m
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/8.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "MyTrackDataController.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"

typedef NS_ENUM(NSInteger, DragDirection) {
    DragDirectionUp,
    DragDirectionDown
};
@interface MyTrackDataController ()
@property (nonatomic, assign) NSInteger page;
@end
@implementation MyTrackDataController

- (void)requestMyTrackBannerCallback:(completeCallback)callback{
    
    NSDictionary *parameter = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [HTTPManager sendGETRequestUrlToService:URL_Userfootprintinfo
                 withParametersDictionry:parameter
                                    view:nil
                          completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
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

#pragma mark -  足迹列表
- (void)requestMyTrackListCallback:(completeCallback)callback{
    _page = 1;
    [self loadDataWithDirection:DragDirectionDown callback:callback];
}

- (void)lastNewPageDataWithCallback:(completeCallback)callback{
    _page = 1;
    [self loadDataWithDirection:DragDirectionDown callback:callback];
}

- (void)nextPageDataWithCallback:(completeCallback)callback{
    _page += 1;
    [self loadDataWithDirection:DragDirectionUp callback:callback];
}
- (void)loadDataWithDirection:(DragDirection)direction callback:(completeCallback)callback{
    
    NSDictionary *parameters=@{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                               @"p":[NSString stringWithFormat:@"%@",@(_page)],
                               @"limit":@"10"};
    [HTTPManager sendGETRequestUrlToService:URL_Userfootprint
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
                                             _results=subjects.mutableCopy;
                                         }else{
                                             NSMutableArray *muta=[[NSMutableArray alloc]initWithArray:_results];
                                             for (NSDictionary *dict in subjects) {
                                                 BOOL isyou = NO;
                                                 NSDictionary *dictemp;
                                                 for(NSDictionary *dict0 in muta)
                                                 {
                                                     if([[dict objectForKey:@"time"] isEqualToString:[dict0 objectForKey:@"time"]])
                                                        {
                                                            isyou = YES;
                                                            dictemp = dict0;
                                                            break;
                                                        }
                                                 }
                                                 if(isyou)
                                                 {
                                                     NSMutableDictionary *dicnow = [dictemp mutableCopy];
                                                     NSArray *arr = [dictemp objectForKey:@"event"];
                                                     NSArray *arr0 = [dict objectForKey:@"event"];
                                                     NSMutableArray *arrnow = [NSMutableArray arrayWithArray:arr];
                                                     [arrnow addObjectsFromArray:arr0];
                                                     [muta removeObject:dictemp];
                                                     [dicnow setObject:arrnow forKey:@"event"];
                                                     [muta addObject:dicnow];
                                                     
                                                 }
                                                 else
                                                 {
                                                     [muta addObject:dict];
                                                 }
                                                 
                                             }
                                             _results=[[NSArray arrayWithArray:muta] mutableCopy];
                                         }
                                     }
                                 }
                                 callback(error,state,describle);
                             }];
    
}

@end
