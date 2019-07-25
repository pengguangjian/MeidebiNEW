//
//  SignInDataController.m
//  Meidebi
//
//  Created by fishmi on 2017/5/25.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "SignInDataController.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"

@implementation SignInDataController


- (void)requestSignInHeadInfoDataControllerInView: (UIView *)view DataWithCallback:(completeCallback)callback{
    
    NSDictionary *para = @{@"userkey" : [NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    
    [HTTPManager sendRequestUrlToService:URL_signInfo withParametersDictionry:para view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
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
                    _headInfoResults = dic;

                    state = YES;
                }
            }else{
                describle = [dicAll objectForKey:@"info"];
            }
        }
        callback(error,state,describle);
    }];
    
}

- (void)requestSignInDoSignDataControllerInView: (UIView *)view DataWithCallback:(completeCallback)callback{
    
    NSDictionary *para = @{@"userkey" : [NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    
    [HTTPManager sendRequestUrlToService:URL_dosign_new withParametersDictionry:para view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
//                _headInfoResults = dic;
                
                state = YES;
                NSDictionary *dic=[dicAll objectForKey:@"data"];
                if (dic&&dic.count>0) {
                    _headInfoResults = dic;
//
//                    state = YES;
                }
            }else{
                describle = [dicAll objectForKey:@"info"];
            }
        }
        callback(error,state,describle);
    }];
    
}

- (void)requestSignInListDataControllerDataWithCallback:(completeCallback)callback{
    
    [HTTPManager sendRequestUrlToService:URL_guessLike withParametersDictionry:nil view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
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
                    _listResults = dic;
                    
                    state = YES;
                }
            }else{
                describle = [dicAll objectForKey:@"info"];
            }
        }
        callback(error,state,describle);
    }];
    
}

- (void)requestSignInShareDataCallback:(completeCallback)callback{
    NSDictionary *para = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                           @"type":@"sign"};
    [HTTPManager sendRequestUrlToService:URL_SiginShare withParametersDictionry:para view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                NSDictionary *dic=dicAll[@"data"];
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    _shareResultsDict = dic;
                    state = YES;
                }
            }else{
                describle = dicAll[@"info"];
            }
        }
        callback(error,state,describle);
    }];
}

@end
