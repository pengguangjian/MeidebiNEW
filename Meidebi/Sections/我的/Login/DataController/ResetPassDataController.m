//
//  ResetPassDataController.m
//  Meidebi
//
//  Created by mdb-admin on 16/7/14.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "ResetPassDataController.h"
#import "HTTPManager.h"
@implementation ResetPassDataController

- (void)requestResetPassWithPassword:(NSString *)password
                                 vid:(NSString *)vid
                              InView:(UIView *)view
                            callback:(completeCallback)Callback{
    
    NSDictionary *parameters = @{@"vid":vid,
                                 @"password":password
                                 };
    [HTTPManager sendRequestUrlToService:URL_mobilefindpass withParametersDictionry:parameters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        if (responceObjct==nil) {
            _resultMessage = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                _resultMessage = @"";
                state = YES;
            }else{
                _resultMessage = [NSString nullToString:dicAll[@"info"]];
            }
        }
        Callback(error,state,_resultMessage);
    }];

}

@end
