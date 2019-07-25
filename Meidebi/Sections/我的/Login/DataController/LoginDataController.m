//
//  LoginDataController.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/3/14.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import "LoginDataController.h"
#import "HTTPManager.h"

@implementation LoginDataController

- (void)requestOtherLoginWithvalue:(NSDictionary *)dicpush
                            andurl:(NSString *)strurl
                            InView:(UIView *)view
                          callback:(completeCallback)Callback
{
    
    [HTTPManager sendRequestUrlToService:strurl withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *_resultMessage = @"";
        if (responceObjct==nil) {
            _resultMessage = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                _resultMessage = @"";
                
                if([[dicAll objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
                {
                    _dicmessage = [dicAll objectForKey:@"data"];
                    state = YES;
                }
                else
                {
                    state = NO;
                }
                
            }else{
                _resultMessage = [NSString nullToString:dicAll[@"info"]];
            }
        }
        Callback(error,state,_resultMessage);
    }];
    
}
@end
