//
//  RemarkDatacontroller.m
//  Meidebi
//
//  Created by mdb-admin on 2017/2/8.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "RemarkHomeDatacontroller.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"

typedef NS_ENUM(NSInteger, DragDirection) {
    DragDirectionUp,
    DragDirectionDown
};

@interface RemarkHomeDatacontroller ()

@property (nonatomic, assign) RemarkType type;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSString *linkid;
@property (nonatomic, strong) UIView *subjectView;
@property (nonatomic, strong) NSArray *resultArray;
@property (nonatomic, strong) NSDictionary *resultDict;

@end

@implementation RemarkHomeDatacontroller

- (void)requestRemarkDataWithType:(RemarkType)type
                           linkid:(NSString *)linkid
                           InView:(UIView *)view
                         callback:(completeCallback)Callback{
    _type = type;
    _linkid = linkid;
    _subjectView = view;
    _page = 1;
    [self loadDataWithDirection:DragDirectionDown callback:Callback];

}

- (void)lastNewPageDataWithCallback:(completeCallback)callback{
    _subjectView = nil;
    _page = 1;
    [self loadDataWithDirection:DragDirectionDown callback:callback];
}

- (void)nextPageDataWithCallback:(completeCallback)callback{
    _subjectView = nil;
    _page+=1;
    [self loadDataWithDirection:DragDirectionUp callback:callback];
}

- (void)loadDataWithDirection:(DragDirection)direction callback:(completeCallback)callback{
     NSDictionary *dica=@{@"linkid":[NSString nullToString:_linkid],
                          @"type":[NSString stringWithFormat:@"%@",@(_type)],
                          @"p":[NSString stringWithFormat:@"%@",@(_page)]};
    
    [HTTPManager sendRequestUrlToService:URL_comlist withParametersDictionry:dica view:_subjectView completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            
            if ([[dicAll objectForKey:@"status"]intValue] == 1) {
                NSMutableArray *arrs=[NSMutableArray arrayWithArray:[dicAll objectForKey:@"data"]];
                if (arrs&&arrs.count>0) {
                    if (direction == DragDirectionDown) {
                        _resultArray = [arrs mutableCopy];
                    }else{
                        NSMutableArray *array = [NSMutableArray arrayWithArray:_resultArray];
                        [array addObjectsFromArray:arrs];
                        _resultArray = array.mutableCopy;
                    }
                }
                state = YES;
            }else{
                describle = dicAll[@"info"];
            }
        }else{
            describle = @"网络错误";
        }
        callback(error,state,describle);
    }];
}

- (void)requestRemarkPriseDataWithType:(RemarkType)type
                             CommentID:(NSString *)commentid
                                InView:(UIView *)view
                              callback:(completeCallback)Callback{

    NSDictionary *pramr=@{@"id":[NSString stringWithFormat:@"%@",commentid],
                          @"type":[NSString stringWithFormat:@"%@",@(_type)],
                          @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    
    [HTTPManager sendRequestUrlToService:URL_commentvote withParametersDictionry:pramr view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct!=nil){
            
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            
            if ([[dicAll objectForKey:@"status"]intValue] == 1) {
                state = YES;
            }else{
                describle = @"赞失败";
            }
        }else{
            describle = @"网络错误";
        }
        Callback(error,state,describle);
    }];
}

- (void)requestComfireRemarkDataWithParameters:(NSDictionary *)parameters
                                        InView:(UIView *)view
                                      callback:(completeCallback)Callback{
//    NSDictionary *pramr=@{@"id":[NSString stringWithFormat:@"%@",commentid],
//                          @"type":[NSString stringWithFormat:@"%@",@(_type)],
//                          @"userkey":[MDB_UserDefault defaultInstance].usertoken};
    
    [HTTPManager sendRequestUrlToService:URL_commindex withParametersDictionry:parameters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct!=nil){
            
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            
            if ([[dicAll objectForKey:@"status"]intValue] == 1) {
                state = YES;
            }else{
                describle = dicAll[@"info"];
            }
        }else{
            describle = @"网络错误";
        }
        Callback(error,state,describle);
    }];
    
}

- (void)requestHandleRemarkDataWithParameters:(NSDictionary *)parameters
                                       InView:(UIView *)view callback:(completeCallback)Callback{
    [HTTPManager sendRequestUrlToService:URL_commindex
                 withParametersDictionry:parameters
                                    view:view
                          completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
                              BOOL state = NO;
                              NSString *describle = @"";
                              if (responceObjct!=nil){
                                  
                                  NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
                                  NSDictionary *dicAll=[str JSONValue];
                                  
                                  if ([[dicAll objectForKey:@"status"]intValue] == 1) {
                                      state = YES;
                                  }else{
                                      describle = dicAll[@"info"];
                                  }
                              }else{
                                  describle = @"网络错误";
                              }
                              Callback(error,state,describle);
    }];
}

- (void)requestImageTokenDataImageCount:(NSInteger)images
                                 InView:(UIView *)view
                               callback:(completeCallback)Callback{
    
    NSDictionary *pramr=@{@"count":[NSString stringWithFormat:@"%@",@(images)],
                          @"type":@"1",
                          @"ext":@"png",
                          @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    
    [HTTPManager sendRequestUrlToService:URL_uploadtoken withParametersDictionry:pramr view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
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
        Callback(error,state,describle);
    }];

}

///@快捷查询
- (void)requestAtData:(NSString *)strvalue
             callback:(completeCallback)Callback
{
    NSDictionary *pramr=@{@"name":strvalue,
                          @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]
                          };
    [HTTPManager sendRequestUrlToService:AtUserUrl withParametersDictionry:pramr view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct!=nil){
            
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            
            if ([[dicAll objectForKey:@"status"]intValue] == 1&& [dicAll[@"data"] isKindOfClass:[NSArray class]]) {
                @try {
                    state = YES;
                    _resultAtDict = dicAll[@"data"];
                    
                    
//                    NSLog(@"%@++++%@",strvalue,dicAll);
                } @catch (NSException *exception) {
                    
                } @finally {
                    
                }
                
                
            }else{
                describle = dicAll[@"info"];
            }
        }else{
            describle = @"网络错误";
        }
        Callback(error,state,describle);
        
    }];
    
}

@end
