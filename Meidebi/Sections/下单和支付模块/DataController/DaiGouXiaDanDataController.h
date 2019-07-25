//
//  DaiGouXiaDanDataController.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/18.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DaiGouXiaDanDataController : NSObject

@property (nonatomic , retain) NSDictionary *dicValue;

@property (nonatomic , retain) NSMutableArray *arrExrequest;

@property (nonatomic , retain) NSDictionary *dicUserInfo;

@property (nonatomic , retain) NSArray *arrqiniu;

@property (nonatomic , retain) NSDictionary *dicXiaDan;

// 获取下单数据
- (void)requestDGHomeDataInView:(UIView *)view
                        dicpush:(NSDictionary *)dicpush
                       Callback:(completeCallback)callback;

// 获取运费数据
- (void)requestExpressDataInView:(UIView *)view
                        dicpush:(NSDictionary *)dicpush
                       Callback:(completeCallback)callback;


// 获取身份证数据
- (void)requestUserInfoDataInView:(UIView *)view
                         dicpush:(NSDictionary *)dicpush
                        Callback:(completeCallback)callback;


///七牛上传图片
- (void)requestqiniuImageDataInView:(UIView *)view
                          dicpush:(NSArray *)arrpushimage
                           Callback:(completeCallback)callback;

///下单
-(void)requestXiaDanDataInView:(UIView *)view
                         dicpush:(NSDictionary *)dicpush
                        Callback:(completeCallback)callback;

@end
