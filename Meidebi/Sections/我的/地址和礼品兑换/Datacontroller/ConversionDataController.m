//
//  ConversionDataController.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/22.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "ConversionDataController.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"

typedef NS_ENUM(NSInteger, DragDirection) {
    DragDirectionUp,
    DragDirectionDown
};

@interface ConversionDataController ()

@property (nonatomic, strong) NSDictionary *resultDict;
@property (nonatomic, strong) NSMutableArray *resultArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) UIView *subView;

@end

@implementation ConversionDataController

- (void)requestAttendanceInfoDataWithView:(UIView *)view
                                 callback:(completeCallback)callback{
    
    NSDictionary *parameters = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken], @"type":@"1"};
    
    ///URL_signInfo
    [HTTPManager sendRequestUrlToService:URL_usercenter withParametersDictionry:parameters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
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
                                 @"p":[NSString stringWithFormat:@"%@",@(_page)],
                                 @"new_type":@"1"};
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
                           present_type:(NSNumber *)present_type
                               callback:(completeCallback)callback{
    
    NSDictionary *parameters = @{@"devicetoken":[NSString nullToString:[MDB_UserDefault getUmengDeviceToken]],
                                 @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                                 @"id":[NSString nullToString:giftID],
                                 @"type":[NSString nullToString:type],
                                 @"address_id":[NSString nullToString:userInfo],
                                 @"present_type":[NSString nullToString:present_type]
                                 };
    
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


@end
