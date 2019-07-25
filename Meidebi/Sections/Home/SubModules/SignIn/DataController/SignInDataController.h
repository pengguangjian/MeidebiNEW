//
//  SignInDataController.h
//  Meidebi
//
//  Created by fishmi on 2017/5/25.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignInDataController : NSObject

@property (nonatomic, strong) NSDictionary *listResults;
@property (nonatomic, strong) NSDictionary *headInfoResults;
@property (nonatomic, strong, readonly) NSDictionary *shareResultsDict;

- (void)requestSignInHeadInfoDataControllerInView: (UIView *)view DataWithCallback:(completeCallback)callback;
- (void)requestSignInListDataControllerDataWithCallback:(completeCallback)callback;
- (void)requestSignInDoSignDataControllerInView: (UIView *)view DataWithCallback:(completeCallback)callback;

- (void)requestSignInShareDataCallback:(completeCallback)callback;

@end
