//
//  PushYuangChuangDataController.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/9/11.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushYuangChuangDataController : NSObject

////获取链接信息
@property (nonatomic ,) NSDictionary *diclinkValue;

- (void)requestOriginalDetailWithID:(NSDictionary *)dicpush
                         targetView:(UIView *)view
                           callback:(completeCallback)callback;




@property (nonatomic ,) NSDictionary *dicMovieToken;
////获取视频上传token
- (void)requestUploadMovieToken:(NSString *)ext
                     targetView:(UIView *)targetView
                       callback:(completeCallback)callback;


@property (nonatomic ,) NSDictionary *dicImageToken;
////获取图片上传token
- (void)requestUploadImageToken:(NSInteger)pictureCount
                     targetView:(UIView *)targetView
                       callback:(completeCallback)callback;


@property (nonatomic ,) NSDictionary *dicCaoGaoValue;
////保存草稿
- (void)requestUploadCaoGaoValue:(NSDictionary *)dicpush
                     targetView:(UIView *)targetView
                       callback:(completeCallback)callback;


@property (nonatomic ,) NSDictionary *dicnomoCaoGaoValue;
////获取草稿
- (void)requestGetCaoGaoValue:(NSDictionary *)dicpush
                      targetView:(UIView *)targetView
                        callback:(completeCallback)callback;

@end
