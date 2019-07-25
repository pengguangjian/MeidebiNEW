//
//  ExchangeRcordDataController.m
//  Meidebi
//
//  Created by mdb-admin on 2016/11/7.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "ExchangeRcordDataController.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"
typedef NS_ENUM(NSInteger, DragDirection) {
    DragDirectionUp,
    DragDirectionDown
};

@interface ExchangeRcordDataController ()

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UIView *targetView;
@property (nonatomic, strong) NSMutableArray *results;

@end

@implementation ExchangeRcordDataController

- (instancetype)init{
    self = [super init];
    if (self) {
        _page = 1;
    }
    return self;
}
- (void)requestSubjectDataWithInView:(UIView *)view
                          callback:(completeCallback)Callback{
    _targetView = view;
    [self loadDataWithDirection:DragDirectionDown callback:Callback];
}

- (void)lastNewPageDataWithCallback:(completeCallback)callback{
    _page = 1;
    [self loadDataWithDirection:DragDirectionDown callback:callback];
}

- (void)nextPageDataWithCallback:(completeCallback)callback{
    _page += 1;
    [self loadDataWithDirection:DragDirectionUp callback:callback];
}

- (void)loadDataWithDirection:(DragDirection)direction callback:(completeCallback)callback{
    
    NSDictionary *dics=@{@"p":[NSString stringWithFormat:@"%@",@(_page)],
                         @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [HTTPManager sendGETRequestUrlToService:URL_recordExchange withParametersDictionry:dics view:_targetView completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct){
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                NSArray *subjects = dicAll[@"data"][@"linklist"];
                if (![subjects isKindOfClass:[NSDictionary class]] && ![subjects isKindOfClass:[NSNull class]]){
                    state = YES;
                    if (direction == DragDirectionDown) {
                        self.results = subjects.mutableCopy;
                    }else{
                        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.results];
                        for (NSDictionary *dict in subjects) {
                            BOOL statue = YES;
                            for (NSDictionary *artDict in self.results) {
                                if ([[NSString nullToString:dict[@"order_id"]] isEqualToString:[NSString nullToString:artDict[@"order_id"]]]) {
                                    statue = NO;
                                    break;
                                }
                            }
                            if (statue) {
                                [tempArray addObjectsFromArray:subjects];
                            }
                        }
                        self.results = tempArray;
                        
                    }
                }
            }else{
                describle = dicAll[@"info"];
            }
        }
        callback(error,state,describle);
    }];
}

#pragma mark - getters and setters
- (NSMutableArray *)results{
    if (!_results) {
        _results = [NSMutableArray array];
    }
    return _results;
}
- (NSArray *)requestResults{
    return self.results? : @[];
}

@end
