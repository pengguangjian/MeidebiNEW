//
//  JoinInActivityDataController.m
//  Meidebi
//
//  Created by fishmi on 2017/6/9.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "JoinInActivityDataController.h"
#import "MDB_UserDefault.h"
#import "HTTPManager.h"

@implementation JoinInActivityDataController

- (void)requestImageTokenDataImageCount:(NSInteger)images InView:(UIView *)view callback:(completeCallback)Callback{
    
    NSDictionary *pramr=@{@"count":[NSString stringWithFormat:@"%@",@(images)],
                          @"type":@"1",
                          @"ext":@"png",
                          @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    
    [HTTPManager sendRequestUrlToService:URL_uploadtoken withParametersDictionry:pramr view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct!=nil){
            
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            
            if ([[dicAll objectForKey:@"status"]intValue] == 1) {
                state = YES;
                _resultDict = dicAll[@"data"];
            }else{
                describle = dicAll[@"info"];
            }
        }else{
            describle = @"网络错误";
        }
        Callback(error,state,describle);
    }];
    
}

- (void)requestJoinAddDataWithImageArray:(NSMutableArray *)imagesArray WithDescription:(NSString *)description InView:(UIView *)view callback:(completeCallback)Callback{
  
    NSDictionary *para=@{ @"id" : _joinId,
                          @"description" : [NSString nullToString:[NSString nullToString:description]],
                          @"userkey" : [NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    NSMutableDictionary *imageDict = [NSMutableDictionary dictionaryWithDictionary:para];
    for (NSInteger i = 0; i<imagesArray.count; i++) {
        [imageDict setValue:imagesArray[i] forKey:[NSString stringWithFormat:@"images[%@]",@(i)]];
    }
    [HTTPManager sendRequestUrlToService:URL_activityJoinAdd withParametersDictionry:imageDict.mutableCopy view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct!=nil){
            
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            
            if ([[dicAll objectForKey:@"status"]intValue] == 1) {
                state = YES;
                _result = dicAll[@"info"];
            }else{
                describle = dicAll[@"info"];
            }
        }else{
            describle = @"网络错误";
        }
        Callback(error,state,describle);
    }];
    
}


@end
