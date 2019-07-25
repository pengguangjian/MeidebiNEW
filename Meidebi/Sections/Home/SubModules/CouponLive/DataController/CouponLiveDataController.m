//
//  CouponLiveDataController.m
//  Meidebi
//
//  Created by mdb-admin on 2017/7/10.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "CouponLiveDataController.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"
typedef NS_ENUM(NSInteger, DragDirection) {
    DragDirectionUp,
    DragDirectionDown
};

@interface CouponLiveDataController ()

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UIView *targetView;
@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, strong) NSString *order;

@end

@implementation CouponLiveDataController

- (instancetype)init{
    self = [super init];
    if (self) {
        _page = 1;
    }
    return self;
}

- (void)requestSubjectDataKeyword:(NSString *)keyword
                            order:(NSString *)order
                           InView:(UIView *)view
                         callback:(completeCallback)callback{
    _targetView = view;
    _keyword = keyword;
    _order = order;
    [self loadDataWithDirection:DragDirectionDown callback:callback];
}

- (void)nextPageDataWithCallback:(completeCallback)callback{
    _targetView = nil;
    _page += 1;
    [self loadDataWithDirection:DragDirectionUp callback:callback];
}
- (void)lastNewPageDataWithCallback:(completeCallback)callback{
    _targetView = nil;
    _page = 1;
    [self loadDataWithDirection:DragDirectionDown callback:callback];
}

- (void)loadDataWithDirection:(DragDirection)direction callback:(completeCallback)callback{
    NSDictionary *dics=@{@"p":[NSString stringWithFormat:@"%@",@(_page)],
                         @"limit":@"20",
                         @"keyword":[NSString nullToString:_keyword],
                         @"order":[NSString nullToString:_order]};
    [HTTPManager sendGETRequestUrlToService:URL_CouponTmall
                    withParametersDictionry:dics
                                       view:_targetView
                             completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct){
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[NSString nullToString:dicAll[@"status"]] isEqualToString:@"1"]) {
                NSArray *subjects = dicAll[@"data"][@"linklist"];
                if (![subjects isKindOfClass:[NSDictionary class]] && ![subjects isKindOfClass:[NSNull class]]){
                    state = YES;
                    if (direction == DragDirectionDown) {
                        if([subjects isKindOfClass:[NSArray class]])
                        {
                            _requestResults = subjects.mutableCopy;
                        }
                        else
                        {
                            state = NO;
                        }
                    }else{
                        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:_requestResults];
                        for (NSDictionary *dict in _requestResults) {
                            BOOL statue = YES;
                            for (NSDictionary *reciveDict in subjects) {
                                if ([[NSString nullToString:reciveDict[@"id"]] isEqualToString:[NSString nullToString:dict[@"id"]]]) {
                                    statue = NO;
                                    break;
                                }
                            }
                            if (statue) {
                                [tempArray addObject:dict];
                            }
                        }
                        _requestResults = tempArray;
                    }
                }
            }else{
                describle = dicAll[@"info"];
            }
        }
        callback(error,state,describle);
    }];
}
@end
