//
//  RegUserInfoDataController.m
//  Meidebi
//
//  Created by mdb-admin on 16/7/13.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "RegUserInfoDataController.h"
#import "HTTPManager.h"
@interface RegUserInfoDataController ()

@property (nonatomic, strong) NSString *resultMessage;

@end

@implementation RegUserInfoDataController


- (void)requestRegUserInfoWithData:(NSDictionary *)dataDict
                               vid:(NSString *)vid
                            InView:(UIView *)view
                        withInvite:(NSString *)invite
                          callback:(regCompleteCallback)Callback{
    
    __block BOOL statue;
    __block NSString *mailAddress = @"";
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:dataDict];
    [tempDict setObject:[NSString nullToString:vid] forKey:@"vid"];
    if (invite.length > 0) {
        [tempDict setObject:[NSString nullToString:invite] forKey:@"invitation_code"];
    }
    NSDictionary *parameters = [tempDict mutableCopy];
   
    [HTTPManager sendRequestUrlToService:URL_mobilereg withParametersDictionry:parameters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct==nil) {
            _resultMessage = @"网络错误";
            statue = NO;
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                _resultMessage = [NSString stringWithFormat:@"%@",[dicAll objectForKey:@"info"]];
                statue = YES;
            }else if([@"USERNAME_EXIST" isEqualToString:[NSString stringWithFormat:@"%@",[dicAll objectForKey:@"info"]]]){
                _resultMessage = @"帐号已存在！";
                statue = NO;
            }else if([[NSString stringWithFormat:@"%@",[dicAll objectForKey:@"info"]] hasPrefix:@"账号创建成功"]&&[[NSString stringWithFormat:@"%@",[dicAll objectForKey:@"data"]] hasPrefix:@"http"]){
                _resultMessage = @"账号创建成功";
                mailAddress = [NSString stringWithFormat:@"%@",[dicAll objectForKey:@"data"]];
                statue = YES;
            }else{
                _resultMessage = [NSString stringWithFormat:@"%@",[dicAll objectForKey:@"info"]];
                statue = NO;
            }
            
        }
        Callback(error,statue,mailAddress);
    }];

    
}

@end
