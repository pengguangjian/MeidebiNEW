//
//  ShareCreationDataController.m
//  Meidebi
//
//  Created by mdb-admin on 2016/10/31.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "ShareCreationDataController.h"
#import "MDB_UserDefault.h"
#import "HTTPManager.h"

@interface ShareCreationDataController ()

@property (nonatomic, strong) NSDictionary *resultDict;
@property (nonatomic, strong) NSArray *results;

@end

@implementation ShareCreationDataController

- (void)requestWelfareShareDataWithView:(UIView *)view callback:(completeCallback)callback{
    NSDictionary *parameters = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [HTTPManager sendGETRequestUrlToService:URL_welfareShare withParametersDictionry:parameters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dictResult=[str JSONValue];
            NSString *info = [NSString stringWithFormat:@"%d",[[dictResult objectForKey:@"status"] intValue]];
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

- (void)requestWelfareShareSuccessCallback:(completeCallback)callback{
    NSDictionary *parameters = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [HTTPManager sendGETRequestUrlToService:URL_shareblock withParametersDictionry:parameters view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dictResult=[str JSONValue];
            NSString *info = [NSString stringWithFormat:@"%d",[[dictResult objectForKey:@"status"] intValue]];
            if ([info isEqualToString:@"1"]) {
                state = YES;
            }else{
                describle = dictResult[@"info"];
            }
        }
        if (callback) {
            callback(error,state,describle);
        }
    }];
}

@end
