//
//  WelfareHomeDataController.m
//  Meidebi
//
//  Created by mdb-admin on 2016/10/31.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "WelfareHomeDataController.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"

typedef NS_ENUM(NSInteger, DragDirection) {
    DragDirectionUp,
    DragDirectionDown
};

@interface WelfareHomeDataController ()

@property (nonatomic, strong) NSDictionary *resultDict;
@property (nonatomic, strong) NSMutableArray *resultArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) UIView *subView;

@end

@implementation WelfareHomeDataController

- (instancetype)init{
    self = [super init];
    if (self) {
        _page = 1;
        _resultArray = [NSMutableArray array];
    }
    return self;
}
- (void)requestDosignDataWithView:(UIView *)view
                         callback:(completeCallback)callback{
   
    NSDictionary *parameters = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [HTTPManager sendRequestUrlToService:URL_dosign_new withParametersDictionry:parameters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dictResult=[str JSONValue];
            NSString* info = [NSString stringWithFormat:@"%d",[[dictResult objectForKey:@"status"] intValue]];
            if ([info isEqualToString:@"1"]) {
                _resultDict = dictResult[@"data"];
                state = YES;
            }else{
                describle = dictResult[@"info"];
            }
        }
        callback(error,state,describle);
    }];
}

- (void)requestAttendanceInfoDataWithView:(UIView *)view
                                 callback:(completeCallback)callback{
    
    NSDictionary *parameters = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [HTTPManager sendRequestUrlToService:URL_signInfo withParametersDictionry:parameters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dictResult=[str JSONValue];
            NSString* info = [NSString stringWithFormat:@"%d",[[dictResult objectForKey:@"status"] intValue]];
            if ([info isEqualToString:@"1"]) {
                _resultDict = dictResult[@"data"];
                state = YES;
            }else{
                describle = dictResult[@"info"];
            }
        }
        callback(error,state,describle);
    }];
}


- (void)requestGiftInfoDataWithView:(UIView *)view
                               type:(NSString *)type
                           callback:(completeCallback)callback{
    _subView = view;
    _page = 1;
    _type = type;
    [_resultArray removeAllObjects];
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
    
    NSDictionary *parameters = @{@"type":[NSString nullToString:_type],
                                 @"p":[NSString stringWithFormat:@"%@",@(_page)]};
    [HTTPManager sendGETRequestUrlToService:URL_welfarePresent withParametersDictionry:parameters view:_subView completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dictResult=[str JSONValue];
            NSString* info = [NSString stringWithFormat:@"%d",[[dictResult objectForKey:@"status"] intValue]];
            if ([info isEqualToString:@"1"]) {
                NSArray *subjects = dictResult[@"data"][@"linklist"];
                if (![subjects isKindOfClass:[NSDictionary class]] && ![subjects isKindOfClass:[NSNull class]]){
                    state = YES;
                    if (direction == DragDirectionDown) {
                        self.resultArray = subjects.mutableCopy;
                    }else{
                        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.resultArray];
                        [tempArray addObjectsFromArray:subjects];
                        self.resultArray = tempArray;
                    }
                }
                state = YES;
            }else{
                describle = dictResult[@"info"];
            }
        }
        callback(error,state,describle);
    }];
    
}


- (void)requestGiftExchangeDataWithView:(UIView *)view
                                 giftID:(NSString *)giftID
                                   type:(NSString *)type
                               userInfo:(NSString *)userInfo
                           present_type:(NSString *)present_type
                               callback:(completeCallback)callback{
    
    NSDictionary *parameters = @{@"devicetoken":[NSString nullToString:[MDB_UserDefault getUmengDeviceToken]],
                                 @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                                 @"id":[NSString nullToString:giftID],
                                 @"type":[NSString nullToString:type],
                                 @"address_id":[NSString nullToString:userInfo],
                                 @"present_type":[NSString nullToString:present_type]};
    if([type isEqualToString:@"coupon"])
    {
        parameters = @{@"devicetoken":[NSString nullToString:[MDB_UserDefault getUmengDeviceToken]],
                       @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                       @"id":[NSString nullToString:giftID],
                       @"type":[NSString nullToString:type],
                       @"info":[NSString nullToString:userInfo],
                       @"present_type":[NSString nullToString:present_type]};
    }
    
    
    [HTTPManager sendRequestUrlToService:URL_giftExchange withParametersDictionry:parameters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dictResult=[str JSONValue];
            NSString* info = [NSString stringWithFormat:@"%d",[[dictResult objectForKey:@"status"] intValue]];
            if ([info isEqualToString:@"1"]) {
                describle = dictResult[@"info"];
                state = YES;
            }else{
                describle = dictResult[@"info"];
            }
        }
        callback(error,state,describle);
    }];
}

- (void)requestGiftExchangeRecordDataWithView:(UIView *)view
                                     callback:(completeCallback)callback{
    
    NSDictionary *parameters = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [HTTPManager sendGETRequestUrlToService:URL_recordExchange withParametersDictionry:parameters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dictResult=[str JSONValue];
            NSString* info = [NSString stringWithFormat:@"%d",[[dictResult objectForKey:@"status"] intValue]];
            if ([info isEqualToString:@"1"]) {
                _resultDict = dictResult[@"data"];
                state = YES;
            }else{
                describle = dictResult[@"info"];
            }
        }
        callback(error,state,describle);
    }];
}

- (void)requestExchangeAttendanceGiftInView:(UIView *)view
                                      phone:(NSString *)phone
                                   callback:(completeCallback)callback{
    NSDictionary *parameters = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                                 @"phone":[NSString nullToString:phone]};
    [HTTPManager sendRequestUrlToService:URL_sign30n withParametersDictionry:parameters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dictResult=[str JSONValue];
            NSString* info = [NSString stringWithFormat:@"%d",[[dictResult objectForKey:@"status"] intValue]];
            if ([info isEqualToString:@"1"]) {
                _resultDict = dictResult[@"data"];
                state = YES;
            }else{
                describle = dictResult[@"info"];
            }
        }
        callback(error,state,describle);
    }];

}


// 悬浮通知和广告
- (void)requestWelfareAdvertiseDataWithView:(UIView *)view
                                   callback:(completeCallback)callback{
    NSDictionary *parameters = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [HTTPManager sendRequestUrlToService:URL_WelfareAdvertise withParametersDictionry:parameters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dictResult=[str JSONValue];
            NSString* info = [NSString stringWithFormat:@"%d",[[dictResult objectForKey:@"status"] intValue]];
            if ([info isEqualToString:@"1"]) {
                _resultDict = dictResult[@"data"];
                state = YES;
            }else{
                describle = dictResult[@"info"];
            }
        }
        callback(error,state,describle);
    }];

}

// 福利-动态
- (void)requestWelfareDynamicDataWithView:(UIView *)view
                                 callback:(completeCallback)callback{
    NSDictionary *parameters = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [HTTPManager sendRequestUrlToService:URL_WelfareDynamic withParametersDictionry:parameters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dictResult=[str JSONValue];
            NSString* info = [NSString stringWithFormat:@"%d",[[dictResult objectForKey:@"status"] intValue]];
            if ([info isEqualToString:@"1"]) {
                _resultArray = dictResult[@"data"];
                state = YES;
            }else{
                describle = dictResult[@"info"];
            }
        }
        callback(error,state,describle);
    }];

}

// 福利-攻略
- (void)requestWelfareRaidersDataWithView:(UIView *)view
                                 callback:(completeCallback)callback{
    NSDictionary *parameters = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [HTTPManager sendRequestUrlToService:URL_WelfareRaiders withParametersDictionry:parameters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dictResult=[str JSONValue];
            NSString* info = [NSString stringWithFormat:@"%d",[[dictResult objectForKey:@"status"] intValue]];
            if ([info isEqualToString:@"1"]) {
                _resultDict = dictResult[@"data"];
                state = YES;
            }else{
                describle = dictResult[@"info"];
            }
        }
        callback(error,state,describle);
    }];
    
}

// 福利-我领取的福利
- (void)requestMyWelfareDataWithView:(UIView *)view
                            callback:(completeCallback)callback{
    NSDictionary *parameters = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [HTTPManager sendRequestUrlToService:URL_WelfareMyWelfare withParametersDictionry:parameters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dictResult=[str JSONValue];
            NSString* info = [NSString stringWithFormat:@"%d",[[dictResult objectForKey:@"status"] intValue]];
            if ([info isEqualToString:@"1"]) {
                _resultDict = dictResult[@"data"];
                state = YES;
            }else{
                describle = dictResult[@"info"];
            }
        }
        callback(error,state,describle);
    }];
    
}


@end
