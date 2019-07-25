//
//  CheapOrOutsideDataController.h
//  Meidebi
//
//  Created by mdb-admin on 16/5/6.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RequestType) {
    RequestTypeHaitao,
    RequestTypeBaicai,
    RequestTypeCouponLive
};

@interface CheapOrOutsideDataController : NSObject

@property (nonatomic, strong, readonly) NSArray *requestResults;

- (void)requestSubjectDataWithType:(RequestType)type
                            InView:(UIView *)view
                          callback:(completeCallback)Callback;

- (void)nextPageDataWithCallback:(completeCallback)callback;
- (void)lastNewPageDataWithCallback:(completeCallback)callback;
@end
