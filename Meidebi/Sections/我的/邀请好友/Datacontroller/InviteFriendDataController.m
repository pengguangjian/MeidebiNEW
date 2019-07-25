//
//  InviteFriendDataController.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/22.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "InviteFriendDataController.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"
@implementation InviteFriendDataController

- (void)requestInviteFriendDataInView:(UIView *)view
                             Callback:(completeCallback)callback{
    NSDictionary *parmarter = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [HTTPManager sendGETRequestUrlToService:URL_Invitation withParametersDictionry:parmarter view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"网络错误!";
        if (responceObjct){
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                NSDictionary *dict=[dicAll objectForKey:@"data"];
                if (dict) {
                    _resultDict = dict;
                    state = YES;
                }
            }
        }
        callback(error,state,describle);
    }];

}

- (void)requestInviteFriendListDataInView:(UIView *)view
                                    order:(NSString *)order
                                 Callback:(completeCallback)callback{
    
    NSDictionary *parmarter = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                                @"order":[NSString nullToString:order]};
    [HTTPManager sendGETRequestUrlToService:URL_InvitationList withParametersDictionry:parmarter view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"网络错误!";
        if (responceObjct){
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                NSArray *arr=[dicAll objectForKey:@"data"];
                if (arr) {
                    _requestResults = arr;
                    state = YES;
                }
            }
        }
        callback(error,state,describle);
    }];
    

}

@end
