//
//  AddressEditDataController.m
//  Meidebi
//
//  Created by mdb-admin on 2016/11/3.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "AddressEditDataController.h"
#import "MDB_UserDefault.h"
#import "HTTPManager.h"

@interface AddressEditDataController ()

@property (nonatomic, strong) NSDictionary *resultDict;

@end

@implementation AddressEditDataController

- (void)requestAcquireAddressInView:(UIView *)view
                           callback:(completeCallback)callback{

    NSDictionary *parameters = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [HTTPManager sendGETRequestUrlToService:URL_addresslist withParametersDictionry:parameters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dictResult=[str JSONValue];
            NSString *info = [NSString stringWithFormat:@"%d",[[dictResult objectForKey:@"status"] intValue]];
            if ([info isEqualToString:@"1"]) {
                if ([dictResult[@"data"] isKindOfClass:[NSDictionary class]]) {
                    _resultDict = dictResult[@"data"];
                }
                state = YES;
            }
            describle = dictResult[@"info"];
        }
        callback(error,state,describle);
    }];

}

// 获取地址
- (void)requestAcquireAddressInView1:(UIView *)view
                            callback:(completeCallback)callback
{
    
    NSDictionary *parameters = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [HTTPManager sendGETRequestUrlToService:URL_addresslist1 withParametersDictionry:parameters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dictResult=[str JSONValue];
            NSString *info = [NSString stringWithFormat:@"%d",[[dictResult objectForKey:@"status"] intValue]];
            if ([info isEqualToString:@"1"]) {
                if ([dictResult[@"data"] isKindOfClass:[NSArray class]]) {
                    _arrlist = dictResult[@"data"];
                }
                state = YES;
            }
            else
            {
                _arrlist = nil;
                state = NO;
            }
            describle = dictResult[@"info"];
        }
        callback(error,state,describle);
    }];
}

- (void)requestDeleteAddressInView:(UIView *)view
                         addressID:(NSString *)addressID
                          callback:(completeCallback)callback{
    
    NSDictionary *parameters = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                                 @"address_id":addressID};
    [HTTPManager sendGETRequestUrlToService:URL_addressdele withParametersDictionry:parameters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dictResult=[str JSONValue];
            NSString* info = [NSString stringWithFormat:@"%d",[[dictResult objectForKey:@"status"] intValue]];
            if ([info isEqualToString:@"1"]) {
                state = YES;
                _resultDict = nil;
            }else{
                describle = dictResult[@"info"];
            }
        }
        callback(error,state,describle);
    }];
}

- (void)requestSaveAddressWithParameters:(NSDictionary *)address
                                  inView:(UIView *)view
                                callback:(completeCallback)callback{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:address];
    [parameters setObject:[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken] forKey:@"userkey"];
    [HTTPManager sendGETRequestUrlToService:URL_addresssave
                    withParametersDictionry:parameters.mutableCopy
                                       view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dictResult=[str JSONValue];
            NSString* info = [NSString stringWithFormat:@"%d",[[dictResult objectForKey:@"status"] intValue]];
            if ([info isEqualToString:@"1"]) {
                state = YES;
            }else{
                describle = dictResult[@"info"];
            }
        }
        callback(error,state,describle);
    }];

}

///设置默认地址
- (void)requestNomoAddressWithParameters:(NSString *)addressID
                                  inView:(UIView *)view
                                callback:(completeCallback)callback
{
    
    NSDictionary *dicpus = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],@"addr_id":addressID};
    [HTTPManager sendRequestUrlToService:URL_addressnomo
                    withParametersDictionry:dicpus
                                       view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
                                           BOOL state = NO;
                                           NSString *describle = @"";
                                           if (responceObjct) {
                                               NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
                                               NSDictionary *dictResult=[str JSONValue];
                                               NSString* info = [NSString stringWithFormat:@"%d",[[dictResult objectForKey:@"status"] intValue]];
                                               if ([info isEqualToString:@"1"]) {
                                                   state = YES;
                                               }else{
                                                   describle = dictResult[@"info"];
                                               }
                                           }
                                           callback(error,state,describle);
                                       }];
}

@end
