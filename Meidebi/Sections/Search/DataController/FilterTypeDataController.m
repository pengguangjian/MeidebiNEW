//
//  FilterTypeDataController.m
//  Meidebi
//
//  Created by mdb-admin on 2016/11/22.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "FilterTypeDataController.h"
#import "HTTPManager.h"

@interface FilterTypeDataController ()

@property (nonatomic, strong) NSArray *resultArray;
@property (nonatomic, strong) NSMutableArray *handleArray;

@end

@implementation FilterTypeDataController

- (instancetype)init{
    self = [super init];
    if (self) {
        _handleArray = [NSMutableArray array];
    }
    return self;
}

- (void)requestFilterTypeDataWithView:(UIView *)view callback:(completeCallback)callback{
    __block BOOL state = NO;
    __block NSString *describle = @"";
    __block NSError *netError;
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    // 商城类型
    [HTTPManager sendRequestUrlToService:URL_warescategory
                 withParametersDictionry:nil
                                    view:view
                          completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
                              if (responceObjct) {
                                  NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
                                  NSDictionary *dictResult=[str JSONValue];
                                  NSString* info = [NSString stringWithFormat:@"%d",[[dictResult objectForKey:@"status"] intValue]];
                                  if ([info isEqualToString:@"1"]) {
                                      NSArray *array = dictResult[@"data"];
                                      if (array) {
                                          [_handleArray addObject:array];
                                      }
                                      state = YES;
                                  }else{
                                      describle = dictResult[@"info"];
                                  }
                              }
                              netError = error;
                              dispatch_group_leave(group);
                          }];

    dispatch_group_enter(group);
    // 热门商城
    [HTTPManager sendRequestUrlToService:URL_filter_getmall
                 withParametersDictionry:nil
                                    view:view
                          completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
                              if (responceObjct) {
                                  NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
                                  NSDictionary *dictResult=[str JSONValue];
                                  NSString* info = [NSString stringWithFormat:@"%d",[[dictResult objectForKey:@"status"] intValue]];
                                  if ([info isEqualToString:@"1"]) {
                                      NSDictionary *resultDict = dictResult[@"data"];
                                      NSArray *array = @[@{@"name":@"国内商城",
                                                           @"category":resultDict[@"guonei"],
                                                           @"type":@"1"},
                                                         @{@"name":@"海淘商城",
                                                           @"category":resultDict[@"haitao"],
                                                           @"type":@"2"}];
                                      if (array) {
                                          [_handleArray addObject:array];
                                      }
                                      state = YES;
                                  }else{
                                      describle = dictResult[@"info"];
                                      state = NO;
                                  }
                              }
                              netError = error;
                              dispatch_group_leave(group);
                          }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (callback) {
            NSArray *firstArray = _handleArray.firstObject;
            NSArray *lastArray = _handleArray.lastObject;
            if (firstArray.count<lastArray.count) {
                [_handleArray removeObjectAtIndex:0];
                [_handleArray addObject:firstArray];
            }
            _resultArray = _handleArray.mutableCopy;
            callback(netError,state,describle);
        }
    });

}

@end
