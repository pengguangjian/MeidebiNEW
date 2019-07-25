//
//  MyInformMessageDataController.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/4/23.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import "MyInformMessageDataController.h"
#import "HTTPManager.h"

@implementation MyInformMessageDataController
///删除选中消息
- (void)requestMyInformDelMessageInView:(UIView *)view
                                dicpush:(NSDictionary *)dicpush
                               Callback:(completeCallback)callback
{
    [HTTPManager sendRequestUrlToService:URL_DelMessage withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                state = YES;
            }
            describle = [dicAll objectForKey:@"info"];
        }
        callback(error,state,describle);
    }];
}

///全部已读
- (void)requestMyInformReadMessageInView:(UIView *)view
                                 dicpush:(NSDictionary *)dicpush
                                Callback:(completeCallback)callback
{
    
    [HTTPManager sendRequestUrlToService:URL_readmessage withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                state = YES;
            }
            describle = [dicAll objectForKey:@"info"];
        }
        callback(error,state,describle);
    }];
}

///获取消息中的爆料链接
- (void)requestMyInformYuanChuangKaPianInView:(UIView *)view
                                      dicpush:(NSDictionary *)dicpush
                                     Callback:(completeCallback)callback
{
    
    [HTTPManager sendGETRequestUrlToService:URL_Unboxing_orderShowDanData withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                state = YES;
                _dicmessage = [dicAll objectForKey:@"data"];
            }
            describle = [dicAll objectForKey:@"info"];
        }
        callback(error,state,describle);
    }];
    
}

@end
