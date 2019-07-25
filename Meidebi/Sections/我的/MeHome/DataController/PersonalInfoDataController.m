//
//  PersonalInfoDataController.m
//  Meidebi
//
//  Created by fishmi on 2017/6/22.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "PersonalInfoDataController.h"
#import "MDB_UserDefault.h"
#import "HTTPManager.h"
typedef NS_ENUM(NSInteger, DragDirection) {
    DragDirectionUp,
    DragDirectionDown
};
@interface PersonalInfoDataController ()
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UIView *targetView;

@end

@implementation PersonalInfoDataController

- (void)requestPersonalInfoDataInView: (UIView *)view WithCallback:(completeCallback)callback{
    //    _activityId = [NSString stringWithFormat:@"12"];
    NSDictionary *parameters = @{@"userkey" : [NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    
    [HTTPManager sendRequestUrlToService:URL_User_index withParametersDictionry:parameters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
            
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                NSDictionary *dic=[dicAll objectForKey:@"data"];
                if (dic&&dic.count>0) {
                    _results = dic;
                    
                    state = YES;
                }else{
                    describle = [dicAll objectForKey:@"info"];
                }
                
            }
        }
        callback(error,state,describle);
    }];
    
}


- (void)requestPersonalNickNameInView: (UIView *)view nickName:(NSString *)nickName WithCallback:(completeCallback)callback{
    //    _activityId = [NSString stringWithFormat:@"12"];
    NSDictionary *parameters = @{@"userkey" : [NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],@"nickname" : [NSString nullToString:nickName]};
    
    [HTTPManager sendRequestUrlToService:URL_nickName withParametersDictionry:parameters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
            
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                state = YES;
                
            }else{
                describle = [dicAll objectForKey:@"info"];
            }
        }
        callback(error,state,describle);
    }];
    
}

- (void)requestPersonalSexInView: (UIView *)view sex:(NSString *)sex WithCallback:(completeCallback)callback{
    //    _activityId = [NSString stringWithFormat:@"12"];
    
    NSDictionary *parameters = @{@"userkey" : [NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                                 @"sex" : [NSString nullToString:sex]};
    
    [HTTPManager sendRequestUrlToService:URL_sex withParametersDictionry:parameters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
            
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                state = YES;
            }else{
                describle = [dicAll objectForKey:@"info"];
            }
            
        }
        callback(error,state,describle);
    }];
    
}

- (void)requestPersonalBirth_dayInView: (UIView *)view birth_day:(NSString *)birth_day WithCallback:(completeCallback)callback{

    NSDictionary *parameters = @{@"userkey" : [NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                                 @"birth_day" : [NSString nullToString:birth_day]};
    
    [HTTPManager sendRequestUrlToService:URL_birth withParametersDictionry:parameters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
            
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                state = YES;
            }else{
                describle = [dicAll objectForKey:@"info"];
            }
        }
        callback(error,state,describle);
    }];
    
}

- (void)requestPersonalAlipayInView: (UIView *)view alipay:(NSString *)alipay WithCallback:(completeCallback)callback{
    
    NSDictionary *parameters = @{@"userkey" : [NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                                 @"my_alipay" : [NSString nullToString:alipay]};
    
    [HTTPManager sendRequestUrlToService:URL_alipay withParametersDictionry:parameters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
            
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                state = YES;
            }else{
                describle = [dicAll objectForKey:@"info"];
            }
        }
        callback(error,state,describle);
    }];
    
}

- (void)requestNewsDeleteInView:(UIView *)view newsid:(NSString *)newsid callback:(completeCallback)callback{
    NSDictionary *parameters = @{@"userkey" : [NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                                 @"id" : [NSString nullToString:newsid]};
    [HTTPManager sendRequestUrlToService:URL_DelMessage withParametersDictionry:parameters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                state = YES;
            }
            describle = [dicAll objectForKey:@"info"];
        }
        callback(error,state,describle);
    }];

}

#pragma mark -  收到的赞
- (void)requestNewsMyZanInView:(UIView *)view callback:(completeCallback)callback{
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
    [HTTPManager sendGETRequestUrlToService:URL_Usernotice
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
                                             _resultArr=subjects.mutableCopy;
                                         }else{
                                             NSMutableArray *muta=[[NSMutableArray alloc]initWithArray:_resultArr];
                                             for (NSDictionary *dict in subjects) {
                                                 [muta addObject:dict];
                                             }
                                             _resultArr=[[NSArray arrayWithArray:muta] mutableCopy];
                                         }
                                     }
                                 }
                                 callback(error,state,describle);
                             }];
    
}

@end
