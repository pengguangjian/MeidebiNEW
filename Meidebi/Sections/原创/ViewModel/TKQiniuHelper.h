//
//  TKQiniuHelper.h
//  TaokeSecretary
//
//  Created by mdb-losaic on 2018/1/5.
//  Copyright © 2018年 leecool. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const kQiniuUploadToken = @"token";
static NSString * const kQiniuUploadKey = @"key";
static NSString * const kImageURLDomain = @"domain";

static NSString * const kQiniuUploadMovieToken = @"token";
static NSString * const kQiniuUploadMovieKey = @"video_name";
static NSString * const kImageURLMovieDomain = @"video_url";
static NSString * const kImageURLMovieImageurlDomain = @"img_url";
static NSString * const kImageURLMovieImagenameDomain = @"img_name";

@interface TKQiniuHelper : NSObject

+ (instancetype)currentHelper;

- (void)uploadImageToQNWithToken:(NSString *)token
                             key:(NSString *)key
                           image:(UIImage *)image
                        callback:(void (^)(BOOL state))callback;


- (void)uploadImageToQNWithTokens:(NSDictionary *)tokenDict
                           images:(NSArray<UIImage *> *)images
                        callback:(void (^)(BOOL state, NSArray *urls))callback;


////传视频可使用
-(void)uploadDataWithToken:(NSString *)token
                       key:(NSString *)key
                      data:(NSData *)datapush
                  callback:(void (^)(BOOL state))callback;
////传多个视频可使用
- (void)uploadDataWithTokens:(NSDictionary *)tokenDict
                           images:(NSArray<NSData *> *)datapushs
                         callback:(void (^)(BOOL state, NSArray *urls, NSArray *picurls))callback;

@end
