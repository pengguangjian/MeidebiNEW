//
//  OriginalDatacontroller.h
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/25.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKTopicModuleConstant.h"
@interface OriginalDatacontroller : NSObject

@property (nonatomic, readonly, strong) NSArray *results;
@property (nonatomic, readonly, strong) NSDictionary *resultDict;
@property (nonatomic, readonly, strong) NSDictionary *resultShareDict;
@property (nonatomic, readonly, strong) NSString *resultStr;
@property (nonatomic, strong, readonly) NSString *postingsCount;
@property (nonatomic, strong, readonly) NSString *commentCount;

@property (nonatomic, strong) NSDictionary *diccaogao;
@property (nonatomic, strong) NSDictionary *dicgetcaogao;

- (void)requestOriginalIndexDataCallback:(completeCallback)callback;
- (void)requestOriginalListTargetView:(UIView *)view
                             callback:(completeCallback)callback;
- (void)lastNewPageDataWithCallback:(completeCallback)callback;
- (void)nextPageDataWithCallback:(completeCallback)callback;

- (void)requestOriginalDetailWithID:(NSString *)originalID
                         targetView:(UIView *)view
                           callback:(completeCallback)callback;

- (void)requestOriginalShareWithID:(NSString *)originalID
                          callback:(completeCallback)callback;

- (void)requestOriginalLinkWithOriginalID:(NSString *)originalID
                               targetView:(UIView *)targetView
                                 callback:(completeCallback)callback;

- (void)requestOriginalCollectWithOriginalID:(NSString *)originalID
                                  targetView:(UIView *)targetView
                                    callback:(completeCallback)callback;


- (void)requestOriginalListWithTagName:(NSString *)tagName
                            targetView:(UIView *)targetView
                              callback:(completeCallback)callback;
- (void)lastOriginalPageDataWithCallback:(completeCallback)callback;
- (void)nextOriginalPageDataWithCallback:(completeCallback)callback;


- (void)requestUploadImageToken:(NSInteger)pictureCount
                     targetView:(UIView *)targetView
                       callback:(completeCallback)callback;

- (void)requestPosteTopicWithType:(TKTopicType)type
                            title:(NSString *)title
                          content:(NSString *)content
                           images:(NSString *)images
                           draft_id:(NSString *)draft_id
                         is_video:(NSString *)is_video
                         videourl:(NSString *)videourl
                         callback:(completeCallback)callback;


////获取视频上传token
- (void)requestUploadMovieToken:(NSString *)ext
                     targetView:(UIView *)targetView
                       callback:(completeCallback)callback;

// 帖子列表
- (void)requestTopicListWithType:(TKTopicType)type
                       sortStyle:(TopicSortStyle)sortStyle
                        callback:(completeCallback)callback;
- (void)requestLastPageTopicDataCallback:(completeCallback)callback;
- (void)requestNextPageTopicDataCallback:(completeCallback)callback;


///保存草稿
- (void)requestPosteTopicWithValue:(NSMutableDictionary *)dicpush
                        targetView:(UIView *)targetView
                          callback:(completeCallback)callback;


///获取草稿
- (void)requestGetCaoGaoWithValue:(NSMutableDictionary *)dicpush
                       targetView:(UIView *)targetView
                          callback:(completeCallback)callback;

///删除草稿
-(void)requestRemoveCaoGaoValue:(NSMutableDictionary *)dicpush
                       callback:(completeCallback)callback;

@end
