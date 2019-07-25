//
//  CheapOrOutsideDataController.m
//  Meidebi
//
//  Created by mdb-admin on 16/5/6.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "CheapOrOutsideDataController.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"
typedef NS_ENUM(NSInteger, DragDirection) {
    DragDirectionUp,
    DragDirectionDown
};

@interface CheapOrOutsideDataController ()

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) RequestType requstType;
@property (nonatomic, strong) UIView *targetView;
@property (nonatomic, strong) NSMutableArray *results;

@end

@implementation CheapOrOutsideDataController
- (instancetype)init{
    self = [super init];
    if (self) {
        _page = 1;
    }
    return self;
}
- (void)requestSubjectDataWithType:(RequestType)type
                            InView:(UIView *)view
                          callback:(completeCallback)Callback{
    _requstType = type;
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
    
    NSString *url = URL_baicaidirect;
    if (_requstType == RequestTypeHaitao) {
        url = URL_haitaodirect;
    }else if (_requstType == RequestTypeCouponLive){
        url = URL_tmallcoupon;
    }
    NSDictionary *dics=@{@"p":[NSString stringWithFormat:@"%@",@(_page)],
                         @"limit":@"20"};
    [HTTPManager sendGETRequestUrlToService:url withParametersDictionry:dics view:_targetView completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct){
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                NSArray *subjects = dicAll[@"data"][@"linklist"];
                if ([subjects isKindOfClass:[NSArray class]] && ![subjects isKindOfClass:[NSNull class]]){
                    state = YES;
                    if (direction == DragDirectionDown) {
                        self.results = subjects.mutableCopy;
                    }else{
                        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.results];
                        [tempArray addObjectsFromArray:subjects];
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
