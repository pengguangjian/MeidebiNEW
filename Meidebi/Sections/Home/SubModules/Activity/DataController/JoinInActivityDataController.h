//
//  JoinInActivityDataController.h
//  Meidebi
//
//  Created by fishmi on 2017/6/9.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JoinInActivityDataController : NSObject
@property(nonatomic,strong)NSString *joinId;
@property (nonatomic, readonly, strong) NSDictionary *resultDict;
@property (nonatomic ,strong) NSString *resultInfo;
@property(nonatomic,strong)NSString *result;
- (void)requestImageTokenDataImageCount:(NSInteger)images InView:(UIView *)view callback:(completeCallback)Callback;
- (void)requestJoinAddDataWithImageArray:(NSMutableArray *)imagesArray WithDescription:(NSString *)description InView:(UIView *)view callback:(completeCallback)Callback;
@end
