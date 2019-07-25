//
//  RecommendActivityDataController.m
//  Meidebi
//
//  Created by fishmi on 2017/5/18.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "RecommendActivityDataController.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"


@interface RecommendActivityDataController ()

@property (nonatomic ,assign) NSInteger page;
@property (nonatomic ,assign) NSInteger hot;
@end

@implementation RecommendActivityDataController

- (instancetype)init{
    self = [super init];
    if (self) {
        _page = 1;
        _hot = 0;
    }
    return self;
}

- (void)nextPageDataInView :(UIView *)view WithCallback:(completeCallback)callback{
    _page += 1;
    [self requestRecommendListDataInView:view WithCallback:callback];
}

- (void)hotDataInView :(UIView *)view WithCallback:(completeCallback)callback{
    _hot = 1;
    _page = 1;
    [self requestRecommendListDataInView:view WithCallback:callback];
}

- (void)latestDataInView :(UIView *)view WithCallback:(completeCallback)callback{
    _hot = 0;
    _page = 1;
    [self requestRecommendListDataInView:view WithCallback:callback];
}



- (void)requestRecommendListDataInView :(UIView *)view WithCallback:(completeCallback)callback{
    NSDictionary *parameters = @{ @"id" : [NSString nullToString:_recommendId],
                                  @"page" : [NSString stringWithFormat:@"%@",@(_page)],
                                  @"hot" : [NSString stringWithFormat:@"%@",@(_hot)]
                                  };
    
    [HTTPManager sendGETRequestUrlToService:URL_activityList withParametersDictionry:parameters view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
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
                    _requestRecommendActivityResults = dic;
                    state = YES;
                }
                
            }else{
                describle = [dicAll objectForKey:@"info"];
            }
        }
        callback(error,state,describle);
    }];
    
}

- (void)requestRecommendHeadViewDataInView :(UIView *)view WithCallback:(completeCallback)callback{
    NSDictionary *parameters = @{ @"id" : [NSString nullToString:_recommendId],
                                  @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                                 };
    
    [HTTPManager sendRequestUrlToService:URL_commentRewards withParametersDictionry:parameters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
//        if(error != nil)
//        {
//            NSDictionary *dicerror = error.userInfo;
//            NSString *str = [[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
//            NSLog(@"%@",str);
//        }
        if (responceObjct==nil) {
            describle = @"网络错误";
            
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                NSDictionary *dic=[dicAll objectForKey:@"data"];
                if (dic&&dic.count>0) {
                    _requestRecommendActivityResults = dic;
                    
                    state = YES;
                }
                
            }else{
                describle = [dicAll objectForKey:@"info"];
            }
        }
        callback(error,state,describle);
    }];

}
@end
