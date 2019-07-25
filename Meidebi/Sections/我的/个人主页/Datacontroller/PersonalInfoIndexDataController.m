//
//  PersonalDataController.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/20.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "PersonalInfoIndexDataController.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"
typedef NS_ENUM(NSInteger, DragDirection) {
    DragDirectionUp,
    DragDirectionDown
};

@interface PersonalInfoIndexDataController ()

@property (nonatomic, assign) NSInteger brokeNewsPage;
@property (nonatomic, assign) NSInteger sharePage;
@property (nonatomic, strong) NSString *userid;

@end

@implementation PersonalInfoIndexDataController

- (void)requestPersonalInfoInView:(UIView *)view
                           userid:(NSString *)userid
                         callback:(completeCallback)callback{
    NSDictionary *parmaters = @{@"userid":[NSString nullToString:userid],
                                @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [HTTPManager sendRequestUrlToService:URL_PersonalHomePage withParametersDictionry:parmaters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
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

#pragma mark - My Broke News
- (void)requestMyBrokeListDataWithInView:(UIView *)view
                                  userid:(NSString *)userid
                                callback:(completeCallback)Callback{
    _brokeNewsPage = 1;
    _userid = userid;
    [self loadMyBrokeDataWithDirection:DragDirectionDown callback:Callback];
}

- (void)myBrokeListLastNewPageDataWithCallback:(completeCallback)callback{
    _brokeNewsPage = 1;
    [self loadMyBrokeDataWithDirection:DragDirectionDown callback:callback];
}

- (void)myBrokeListNextPageDataWithCallback:(completeCallback)callback{
    _brokeNewsPage += 1;
    [self loadMyBrokeDataWithDirection:DragDirectionUp callback:callback];
}

- (void)loadMyBrokeDataWithDirection:(DragDirection)direction callback:(completeCallback)callback{
    
    NSDictionary *dic=@{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                        @"userid":[NSString nullToString:_userid],
                        @"p":[NSString stringWithFormat:@"%@",@(_brokeNewsPage)],
                        @"limit":@"20"};
    [HTTPManager sendRequestUrlToService:URL_PersonalBrokes withParametersDictionry:dic view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            BOOL state = NO;
            NSString *describle = @"网络错误！";
            if (responceObjct==nil) {
                callback(error,state,describle);
            }else{
                describle = dicAll[@"info"];
                if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                    NSArray *subjects = dicAll[@"data"];
                    if ([subjects isKindOfClass:[NSDictionary class]] || [subjects isKindOfClass:[NSString class]] || [subjects isKindOfClass:[NSNull class]]){
                        describle = @"未查到相关数据";
                        callback(nil,state,describle);
                        return;
                    };
                    state = YES;
                    _requestResults = subjects;
                    callback(nil,state,describle);
                }else{
                    callback(error,state,describle);
                }
            }
        }
    }];

}

#pragma mark - My Share
- (void)requestMyShareListDataWithInView:(UIView *)view
                                  userid:(NSString *)userid
                                callback:(completeCallback)Callback{
    _sharePage = 1;
    _userid = userid;
    [self myShareListNextPageDataWithCallback:Callback];
}
- (void)myShareListNextPageDataWithCallback:(completeCallback)callback{
    _sharePage = 1;
    [self loadMyShareDataWithDirection:DragDirectionDown callback:callback];

}
- (void)myShareListLastNewPageDataWithCallback:(completeCallback)callback{
    _sharePage += 1;
    [self loadMyShareDataWithDirection:DragDirectionDown callback:callback];
}

- (void)loadMyShareDataWithDirection:(DragDirection)direction callback:(completeCallback)callback{
    
    NSDictionary *dic=@{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                        @"userid":[NSString nullToString:_userid],
                        @"p":[NSString stringWithFormat:@"%@",@(_brokeNewsPage)],
                        @"limit":@"20"};
    [HTTPManager sendRequestUrlToService:URL_PersonalShowdans withParametersDictionry:dic view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            BOOL state = NO;
            NSString *describle = @"网络错误！";
            if (responceObjct==nil) {
                callback(error,state,describle);
            }else{
                describle = dicAll[@"info"];
                if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                    NSArray *subjects = dicAll[@"data"];
                    if ([subjects isKindOfClass:[NSDictionary class]] || [subjects isKindOfClass:[NSString class]] || [subjects isKindOfClass:[NSNull class]]){
                        describle = @"未查到相关数据";
                        callback(nil,state,describle);
                        return;
                    };
                    state = YES;
                    _requestResults = subjects;
                    callback(nil,state,describle);
                }else{
                    callback(error,state,describle);
                }
            }
        }
    }];
    
}


@end
