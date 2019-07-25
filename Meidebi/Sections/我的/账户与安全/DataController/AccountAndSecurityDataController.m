//
//  AccountAndSecurityDataController.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/4/25.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import "AccountAndSecurityDataController.h"
#import "HTTPManager.h"

@implementation AccountAndSecurityDataController

////
- (void)requestAccountAndSecurityInView: (UIView *)view
                                andpush:(NSDictionary *)dicpush
                                 andurl:(NSString *)strurl
                           WithCallback:(completeCallback)callback
{
    
    [HTTPManager sendRequestUrlToService:strurl withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                state = YES;
                _dicback = [dicAll objectForKey:@"data"];
            }
            describle = [dicAll objectForKey:@"info"];
        }
        callback(error,state,describle);
    }];
    
}

@end
