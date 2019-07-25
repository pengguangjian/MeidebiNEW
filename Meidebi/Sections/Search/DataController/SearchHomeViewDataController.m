//
//  SearchHomeViewDataController.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/2/15.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import "SearchHomeViewDataController.h"
#import "HTTPManager.h"

@implementation SearchHomeViewDataController
- (void)requestSearchHomeViewDataWithView:(UIView *)view
                                pushValue:(NSDictionary *)dicvalue
                                 callback:(completeCallback)callback
{
    
    [HTTPManager sendGETRequestUrlToService:URL_searchHotkeyword
                 withParametersDictionry:dicvalue
                                    view:view
                          completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
                              BOOL state = NO;
                              NSString *describle = @"";
                              NSError *netError;
                              if (responceObjct) {
                                  NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
                                  NSDictionary *dictResult=[str JSONValue];
                                  NSString* info = [NSString stringWithFormat:@"%d",[[dictResult objectForKey:@"status"] intValue]];
                                  _arrkeys = [NSMutableArray new];
                                  if ([info isEqualToString:@"1"]) {
                                      if ([[dictResult objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                                          NSArray *array = dictResult[@"data"];
                                          [_arrkeys addObjectsFromArray:array];
                                           state = YES;
                                      }
                                  }else{
                                      describle = dictResult[@"info"];
                                  }
                              }
                              netError = error;
                              callback(netError,state,describle);
                          }];
}
@end
