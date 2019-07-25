//
//  FindCouponDataController.m
//  Meidebi
//
//  Created by mdb-admin on 2017/7/10.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "FindCouponDataController.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"
#import <FCUUID/FCUUID.h>
typedef NS_ENUM(NSInteger, DragDirection) {
    DragDirectionUp,
    DragDirectionDown
};
@interface FindCouponDataController ()
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSString *order;
@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, strong) UIView *targetView;
@end

@implementation FindCouponDataController

- (void)requestCouponSearchHomeDataWithView:(UIView *)view
                                   callback:(completeCallback)callback{
    [HTTPManager sendRequestUrlToService:URL_SearchCouponIndex withParametersDictionry:nil view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dictResult=[str JSONValue];
            NSString* info = [NSString stringWithFormat:@"%d",[[dictResult objectForKey:@"status"] intValue]];
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

- (void)requestCouponSearchDataWithView:(UIView *)view keyword:(NSString *)keyword order:(NSString *)order callback:(completeCallback)callback{

    _targetView = view;
    _keyword = keyword;
    _order = order;
    _page = 1;
    [self loadDataWithDirection:DragDirectionDown callback:callback];
}

- (void)lastNewPageDataWithCallback:(completeCallback)callback{
    _targetView = nil;
    _page = 1;
    [self loadDataWithDirection:DragDirectionDown callback:callback];
}

- (void)nextPageDataWithCallback:(completeCallback)callback{
    _targetView = nil;
    _page += 1;
    [self loadDataWithDirection:DragDirectionUp callback:callback];
}

- (void)loadDataWithDirection:(DragDirection)direction callback:(completeCallback)callback{
    NSDictionary *parameters = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                                 @"deviceId":[FCUUID uuidForDevice],
                                 @"keyword":[NSString nullToString:_keyword],
                                 @"order":[NSString nullToString:_order],
                                 @"page":[NSString stringWithFormat:@"%@",@(_page)],
                                 @"pageSize":@"20"};
    [HTTPManager sendGETRequestUrlToService:URL_SearchCoupon withParametersDictionry:parameters view:_targetView completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"网络错误!";
        if (responceObjct){
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                NSArray *subjects = dicAll[@"data"];
                if ([subjects isKindOfClass:[NSDictionary class]] || [subjects isKindOfClass:[NSString class]] || [subjects isKindOfClass:[NSNull class]]){
                    describle = @"未查到相关数据";
                    callback(nil,state,describle);
                    return;
                };
                state = YES;
                if (direction == DragDirectionDown) {
                    _resultArray=subjects.mutableCopy;
                }else{
                    NSMutableArray *muta=[[NSMutableArray alloc]initWithArray:_resultArray];
                    for (NSDictionary *dict in subjects) {
                        [muta addObject:dict];
                    }
                    _resultArray=[[NSArray arrayWithArray:muta] mutableCopy];
                }
            }
        }
        callback(error,state,describle);
    }];

}
@end
