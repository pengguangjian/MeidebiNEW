//
//  LoginDataController.h
//  Meidebi
//
//  Created by mdb-losaic on 2019/3/14.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginDataController : NSObject

@property (nonatomic, strong) NSDictionary *dicmessage;

- (void)requestOtherLoginWithvalue:(NSDictionary *)dicpush
                            andurl:(NSString *)strurl
                              InView:(UIView *)view
                            callback:(completeCallback)Callback;

@end

NS_ASSUME_NONNULL_END
