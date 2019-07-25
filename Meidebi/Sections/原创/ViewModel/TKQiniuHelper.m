//
//  TKQiniuHelper.m
//  TaokeSecretary
//
//  Created by mdb-losaic on 2018/1/5.
//  Copyright © 2018年 leecool. All rights reserved.
//

#import "TKQiniuHelper.h"
#import <Qiniu/QiniuSDK.h>
@interface TKQiniuHelper ()
@property (nonatomic, strong) QNUploadManager *upManager;
@end

@implementation TKQiniuHelper
#pragma mark - Life Cycle
+ (instancetype)currentHelper{
    static TKQiniuHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TKQiniuHelper alloc] initInPrivate];
    });
    return instance;
}

- (instancetype)initInPrivate {
    if (self = [super init]) {
        _upManager = [[QNUploadManager alloc] init];
    }
    return self;
}

- (instancetype)init {
    return nil;
}

- (instancetype)copy {
    return nil;
}

#pragma mark - public method
- (void)uploadImageToQNWithToken:(NSString *)token
                             key:(NSString *)key
                           image:(UIImage *)image
                        callback:(void (^)(BOOL))callback{
    QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
//        NSLog(@"percent == %.2f", percent);
    }
                                                                 params:nil
                                                               checkCrc:NO
                                                     cancellationSignal:nil];
    NSString *imagePath = [self getImagePath:image];
    [_upManager putFile:imagePath key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        [self removeItemWithPath:imagePath];
        if (info.statusCode == 200) {
            callback(YES);
        }else{
            callback(NO);
        }
    }
                option:uploadOption];
}

- (void)uploadImageToQNWithTokens:(NSDictionary *)tokenDict
                           images:(NSArray<UIImage *> *)images
                         callback:(void (^)(BOOL, NSArray *))callback{
    if (images.count>1) {
        NSArray *tokens = [[NSString nullToString:tokenDict[kQiniuUploadToken]] componentsSeparatedByString:@","];
        NSArray *keys = [[NSString nullToString:tokenDict[kQiniuUploadKey]] componentsSeparatedByString:@","];
        NSString *domainStr = tokenDict[kImageURLDomain];
        NSMutableArray *urls = [NSMutableArray arrayWithArray:keys];
        __block NSInteger completeNum = 0;
        __block NSInteger successNum = 0;
        NSInteger index = 0;
        while (index < tokens.count) {
            NSString *imagePath = [self getImagePath:images[index]];
            [_upManager putFile:imagePath key:keys[index] token:tokens[index] complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                [self removeItemWithPath:imagePath];
                completeNum += 1;
                if (info.statusCode == 200) {
                    NSString *url = [[NSString nullToString:domainStr] stringByAppendingString:key];
                    NSUInteger keyIndex = [urls indexOfObject:key];
                    if (keyIndex < urls.count) {
                        [urls replaceObjectAtIndex:keyIndex withObject:url];
                        successNum += 1;
                    }
                }
                if (completeNum == tokens.count) {
                    if (successNum == tokens.count) {
                        callback(YES,urls.mutableCopy);
                    }else{
                        callback(NO,nil);
                    }
                }
            }
            option:nil];
            index += 1;
        }
    }else{
        [self uploadImageToQNWithToken:tokenDict[kQiniuUploadToken] key:tokenDict[kQiniuUploadKey] image:images.firstObject callback:^(BOOL state) {
            if (state) {
                callback(YES,@[[[NSString nullToString:tokenDict[kImageURLDomain]] stringByAppendingString:tokenDict[kQiniuUploadKey]]]);
            }else{
                callback(NO,nil);
            }
        }];
    }   
    
    
}

//照片获取本地路径转换
- (NSString *)getImagePath:(UIImage *)Image {
    NSString *filePath = nil;
    NSData *data = nil;
    if (UIImagePNGRepresentation(Image) == nil) {
        data = UIImageJPEGRepresentation(Image, 1.0);
    } else {
        data = UIImagePNGRepresentation(Image);
    }
    
    //图片保存的路径
    //这里将图片放在沙盒的documents文件夹中
    NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //把刚刚图片转换的data对象拷贝至沙盒中
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *ImagePath = [[NSString alloc] initWithString:[NSString stringWithFormat:@"/theFirstImage.png"]];
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:ImagePath] contents:data attributes:nil];
    
    //得到选择后沙盒中图片的完整路径
    filePath = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@%@", DocumentsPath, ImagePath]];
    return filePath;
}

- (void)removeItemWithPath:(NSString *)path{
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:path error:nil];
}


-(void)uploadDataWithToken:(NSString *)token
                       key:(NSString *)key
                      data:(NSData *)datapush
                  callback:(void (^)(BOOL state))callback
{
    
    QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
        //        NSLog(@"percent == %.2f", percent);
    }
                                                                 params:nil
                                                               checkCrc:NO
                                                     cancellationSignal:nil];
    [_upManager putData:datapush key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        if (info.statusCode == 200) {
            callback(YES);
        }else{
            callback(NO);
        }
    } option:uploadOption];
    
}

- (void)uploadDataWithTokens:(NSDictionary *)tokenDict
                      images:(NSArray<NSData *> *)datapushs
                    callback:(void (^)(BOOL state, NSArray *urls, NSArray *picurls))callback
{
    if(datapushs.count>1)
    {
        NSArray *tokens = [[NSString nullToString:tokenDict[kQiniuUploadMovieToken]] componentsSeparatedByString:@","];
        NSArray *keys = [[NSString nullToString:tokenDict[kQiniuUploadMovieKey]] componentsSeparatedByString:@","];
        NSString *domainStr =  [[NSString nullToString:tokenDict[kImageURLMovieDomain]] stringByAppendingString:@"/"];
        NSString *domainimageStr =  [[NSString nullToString:tokenDict[kImageURLMovieImageurlDomain]] stringByAppendingString:@"/"];
        NSMutableArray *urls = [NSMutableArray arrayWithArray:keys];
        NSMutableArray *urlsImages = [NSMutableArray arrayWithArray:keys];
        __block NSInteger completeNum = 0;
        __block NSInteger successNum = 0;
        NSInteger index = 0;
        while (index < tokens.count)
        {
            [_upManager putData:datapushs[index] key:keys[index] token:tokens[index] complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                
                completeNum += 1;
                if (info.statusCode == 200)
                {
                    NSString *url = [[NSString nullToString:domainStr] stringByAppendingString:key];
                    NSString *urlimage = [[NSString nullToString:domainimageStr] stringByAppendingString:key];
                    urlimage = [urlimage stringByReplacingOccurrencesOfString:@".mp4" withString:@".jpg"];
                    NSUInteger keyIndex = [urls indexOfObject:key];
                    if (keyIndex < urls.count)
                    {
                        [urls replaceObjectAtIndex:keyIndex withObject:url];
                        [urlsImages replaceObjectAtIndex:keyIndex withObject:urlimage];
                        successNum += 1;
                    }
                }
                if (completeNum == tokens.count)
                {
                    if (successNum == tokens.count)
                    {
                        callback(YES,urls.mutableCopy,urlsImages);
                    }
                    else
                    {
                        callback(NO,nil,nil);
                    }
                }
            } option:nil];
            index += 1;
            
        }
    }
    else
    {
        [self uploadDataWithToken:tokenDict[kQiniuUploadMovieToken] key:tokenDict[kQiniuUploadMovieKey] data:datapushs.firstObject callback:^(BOOL state) {
            if (state) {
                callback(YES,@[[[NSString stringWithFormat:@"%@/",[NSString nullToString:tokenDict[kImageURLMovieDomain]]] stringByAppendingString:tokenDict[kQiniuUploadMovieKey]]],@[[[NSString stringWithFormat:@"%@/",[NSString nullToString:tokenDict[kImageURLMovieImageurlDomain]]] stringByAppendingString:tokenDict[kImageURLMovieImagenameDomain]]]);
            }else{
                callback(NO,nil,nil);
            }
        }];
        
    }
    
}

@end
