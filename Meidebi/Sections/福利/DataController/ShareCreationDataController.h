//
//  ShareCreationDataController.h
//  Meidebi
//
//  Created by mdb-admin on 2016/10/31.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareCreationDataController : NSObject

@property (nonatomic, readonly, strong) NSDictionary *resultDict;

// 获取福利分享信息
- (void)requestWelfareShareDataWithView:(UIView *)view
                               callback:(completeCallback)callback;

// 分享成功(加铜币)
- (void)requestWelfareShareSuccessCallback:(completeCallback)callback;
@end
