//
//  AccountAndSecurityDataController.h
//  Meidebi
//
//  Created by mdb-losaic on 2019/4/25.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AccountAndSecurityDataController : NSObject

@property (nonatomic , retain) NSDictionary *dicback;

////
- (void)requestAccountAndSecurityInView: (UIView *)view
                                andpush:(NSDictionary *)dicpush
                                 andurl:(NSString *)strurl
                           WithCallback:(completeCallback)callback;



@end

NS_ASSUME_NONNULL_END
