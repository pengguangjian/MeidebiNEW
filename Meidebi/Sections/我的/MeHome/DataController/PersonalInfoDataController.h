//
//  PersonalInfoDataController.h
//  Meidebi
//
//  Created by fishmi on 2017/6/22.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonalInfoDataController : NSObject
@property (nonatomic ,strong) NSDictionary *results;
@property (nonatomic, strong, readonly) NSArray *resultArr;

- (void)requestPersonalInfoDataInView: (UIView *)view WithCallback:(completeCallback)callback;
- (void)requestPersonalNickNameInView: (UIView *)view nickName:(NSString *)nickName WithCallback:(completeCallback)callback;
- (void)requestPersonalSexInView: (UIView *)view sex:(NSString *)sex WithCallback:(completeCallback)callback;
- (void)requestPersonalBirth_dayInView: (UIView *)view birth_day:(NSString *)birth_day WithCallback:(completeCallback)callback;
- (void)requestPersonalAlipayInView: (UIView *)view alipay:(NSString *)alipay WithCallback:(completeCallback)callback;
- (void)requestNewsDeleteInView: (UIView *)view newsid:(NSString *)newsid callback:(completeCallback)callback;
// 收到的赞
- (void)requestNewsMyZanInView: (UIView *)view callback:(completeCallback)callback;
- (void)lastNewPageDataWithCallback:(completeCallback)callback;
- (void)nextPageDataWithCallback:(completeCallback)callback;
@end
