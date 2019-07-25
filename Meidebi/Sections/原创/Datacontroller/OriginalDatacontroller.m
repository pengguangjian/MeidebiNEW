//
//  OriginalDatacontroller.m
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/25.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "OriginalDatacontroller.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"
#import "FMDBHelper.h"
typedef NS_ENUM(NSInteger, DragDirection) {
    DragDirectionUp,
    DragDirectionDown
};
@interface OriginalDatacontroller ()
@property (nonatomic, strong) UIView *targetView;
@property (nonatomic, strong) NSString *tagName;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSString *hotState;
@property (nonatomic, assign) TKTopicType type;
@property (nonatomic, assign) TopicSortStyle sortStyle;
@end

@implementation OriginalDatacontroller

- (void)requestOriginalIndexDataCallback:(completeCallback)callback{
    NSDictionary *parameters=@{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [HTTPManager sendGETRequestUrlToService:URL_ShowdanIndex
                    withParametersDictionry:parameters
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

- (void)requestOriginalShareWithID:(NSString *)originalID
                          callback:(completeCallback)callback{
    NSDictionary *dicr=@{@"id":[NSString nullToString:originalID],
                         @"type":@"2",
                         @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [HTTPManager sendGETRequestUrlToService:URL_getshare withParametersDictionry:dicr view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        NSString *describle = @"网络错误！";
        BOOL state = NO;
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dictResult=[str JSONValue];
            NSInteger status = [dictResult[@"status"] integerValue];
            describle = dictResult[@"info"];
            if (status == 1) {
                if ([dictResult objectForKey:@"data"]) {
                    _resultShareDict = dictResult[@"data"];
                    state = YES;
                }
            }
        }
        callback(error,state,describle);
    }];
}

- (void)requestOriginalDetailWithID:(NSString *)originalID
                         targetView:(UIView *)view
                           callback:(completeCallback)callback{
    NSDictionary *parameters=@{
                               @"id":[NSString nullToString:originalID],
                               @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]
                               };
    [HTTPManager sendGETRequestUrlToService:URL_ShowdanDetail
                    withParametersDictionry:parameters
                                       view:view
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

- (void)requestOriginalLinkWithOriginalID:(NSString *)originalID
                               targetView:(UIView *)targetView
                                 callback:(completeCallback)callback{
    NSDictionary *parameters=@{@"id":[NSString nullToString:originalID],
                               @"votes":@"1",
                               @"userid":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                               @"type":@"3"};
    [HTTPManager  sendRequestUrlToService:URL_prace
                  withParametersDictionry:parameters
                                     view:targetView
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

- (void)requestOriginalCollectWithOriginalID:(NSString *)originalID
                                  targetView:(UIView *)targetView
                                    callback:(completeCallback)callback{
    NSDictionary *parameters=@{@"id":[NSString nullToString:originalID],
                               @"fetype":@"4",
                               @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [HTTPManager sendRequestUrlToService:URL_favorite
                  withParametersDictionry:parameters
                                     view:targetView
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
                                           _resultStr = dictResult[@"data"];
                                           state = YES;
                                       }
                                   }
                               }
                               callback(error,state,describle);
                           }];
    
}


- (void)requestOriginalListTargetView:(UIView *)view
                             callback:(completeCallback)callback{
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
    
    NSDictionary *parameters=@{@"p":[NSString stringWithFormat:@"%@",@(_page)],
                               @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                               @"limit":@"20"};
    [HTTPManager sendGETRequestUrlToService:URL_showdanlist
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
                                             _results=subjects.mutableCopy;
                                         }else{
                                             NSMutableArray *muta=[[NSMutableArray alloc]initWithArray:_results];
                                             for (NSDictionary *dict in subjects) {
                                                 [muta addObject:dict];
                                             }
                                             _results=[[NSArray arrayWithArray:muta] mutableCopy];
                                         }
                                     }
                                 }
                                 callback(error,state,describle);
                             }];
    
}


- (void)requestOriginalListWithTagName:(NSString *)tagName
                            targetView:(UIView *)targetView
                              callback:(completeCallback)callback{
    _targetView = targetView;
    _tagName = tagName;
    _page = 1;
    [self loadOriginalDataWithTagNameDirection:DragDirectionDown callback:callback];

}
- (void)lastOriginalPageDataWithCallback:(completeCallback)callback{
    _targetView = nil;
    _page = 1;
    [self loadOriginalDataWithTagNameDirection:DragDirectionDown callback:callback];
}
- (void)nextOriginalPageDataWithCallback:(completeCallback)callback{
    _targetView = nil;
    _page += 1;
    [self loadOriginalDataWithTagNameDirection:DragDirectionUp callback:callback];
}

- (void)loadOriginalDataWithTagNameDirection:(DragDirection)direction callback:(completeCallback)callback{
    
    NSDictionary *parameters=@{@"tagName":[NSString nullToString:_tagName],
                               @"p":[NSString stringWithFormat:@"%@",@(_page)],
                               @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                               @"limit":@"20"};
    [HTTPManager sendGETRequestUrlToService:URL_ShowdanByTag
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
                                             _results=subjects.mutableCopy;
                                         }else{
                                             NSMutableArray *muta=[[NSMutableArray alloc]initWithArray:_results];
                                             for (NSDictionary *dict in subjects) {
                                                 [muta addObject:dict];
                                             }
                                             _results=[[NSArray arrayWithArray:muta] mutableCopy];
                                         }
                                     }
                                 }
                                 callback(error,state,describle);
                             }];
    
}

- (void)requestUploadImageToken:(NSInteger)pictureCount
                     targetView:(UIView *)targetView
                       callback:(completeCallback)callback{
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
                _resultDict = dicAll[@"data"];
            }else{
                describle = dicAll[@"info"];
            }
        }else{
            describle = @"网络错误";
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
                _resultDict = dicAll[@"data"];
            }else{
                describle = dicAll[@"info"];
            }
        }else{
            describle = @"网络错误";
        }
        callback(error,state,describle);
    }];
    
    
}

- (void)requestPosteTopicWithType:(TKTopicType)type
                            title:(NSString *)title
                          content:(NSString *)content
                           images:(NSString *)images
                         draft_id:(NSString *)draft_id
                         is_video:(NSString *)is_video
                         videourl:(NSString *)videourl
                         callback:(completeCallback)callback{
    NSDictionary *params = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                             @"content":[NSString nullToString:content],
                             @"title":[NSString nullToString:title],
                             @"classify":[NSString stringWithFormat:@"%@",@(type)],
                             @"images":[NSString nullToString:images],
                             @"draft_id":[NSString nullToString:draft_id],
                             @"video_type":[NSString nullToString:is_video],
                             @"video":[NSString nullToString:videourl]
                             };
    [HTTPManager sendRequestUrlToService:URL_TopicPost
                withParametersDictionry:params
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
                                             describle = dictResult[@"data"];
                                             state = YES;
                                         }
                                     }
                                 }
                                 callback(error,state,describle);
                             }];
    
}


- (void)requestTopicListWithType:(TKTopicType)type
                       sortStyle:(TopicSortStyle)sortStyle
                        callback:(completeCallback)callback{
    _type = type;
    _sortStyle = sortStyle;
    self.page = 1;
    [self statusDataWithDirection:DragDirectionDown Callback:callback];
}

- (void)requestLastPageTopicDataCallback:(completeCallback)callback{
    self.page = 1;
    [self statusDataWithDirection:DragDirectionDown Callback:callback];
}

- (void)requestNextPageTopicDataCallback:(completeCallback)callback{
    self.page += 1;
    [self statusDataWithDirection:DragDirectionUp Callback:callback];
}

- (void)statusDataWithDirection:(DragDirection)direction Callback:(completeCallback)callback{
    NSDictionary *params = @{@"p":[NSString stringWithFormat:@"%@",@(self.page)],
                             @"limit":@"20",
                             @"classify":[NSString stringWithFormat:@"%@",@(_type)],
                             @"sort":[NSString stringWithFormat:@"%@",@(_sortStyle)]
                             };
    [HTTPManager sendGETRequestUrlToService:URL_TopicCategrayList
                    withParametersDictionry:params
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
                                         if ([dicAll[@"data"] isKindOfClass:[NSDictionary class]]) {
                                             _postingsCount = [NSString stringWithFormat:@"%@",dicAll[@"data"][@"s_count"]];
                                             _commentCount = [NSString stringWithFormat:@"%@",dicAll[@"data"][@"c_count"]];
                                             NSArray *subjects = dicAll[@"data"][@"list"];
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
                                                     [muta addObject:dict];
                                                 }
                                                 _results=[[NSArray arrayWithArray:muta] mutableCopy];
                                             }
                                         }
                                     }
                                 }
                                 callback(error,state,describle);
                             }];
}


///保存草稿
- (void)requestPosteTopicWithValue:(NSMutableDictionary *)dicpush
                        targetView:(UIView *)targetView
                          callback:(completeCallback)callback
{
    
    [HTTPManager sendRequestUrlToService:URL_TopicCategraycaogaoSave
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
                                         _diccaogao = [dicAll objectForKey:@"data"];
                                         state = YES;
                                     }
                                 }
                                 callback(error,state,describle);
                             }];
}


///获取草稿
- (void)requestGetCaoGaoWithValue:(NSMutableDictionary *)dicpush
                       targetView:(UIView *)targetView
                         callback:(completeCallback)callback
{
    
    
    [HTTPManager sendRequestUrlToService:URL_TopicCategraycaogaoGet
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
                                      _dicgetcaogao = [dicAll objectForKey:@"data"];
                                      state = YES;
                                  }
                              }
                              callback(error,state,describle);
                          }];
}


///删除草稿
-(void)requestRemoveCaoGaoValue:(NSMutableDictionary *)dicpush
                       callback:(completeCallback)callback
{
    
    
    [HTTPManager sendRequestUrlToService:URL_TopicCategraycaogaoRemove
                 withParametersDictionry:dicpush
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
                                      
                                      state = YES;
                                  }
                              }
                              callback(error,state,describle);
                          }];
    
}

@end
