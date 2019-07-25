//
//  TKExploreViewModel.h
//  TaokeSecretary
//
//  Created by mdb-losaic on 2018/1/15.
//  Copyright © 2018年 leecool. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKTopicModuleConstant.h"
@class TKTopicListViewModel,TKTopicDetailViewModel;
@interface TKExploreViewModel : NSObject
//@property (nonatomic, strong) NSArray <TKTopicListViewModel *> *topics;
//+ (instancetype)viewModelWithSubject:(NSDictionary *)subject;
@end

@interface TKTopicListViewModel : NSObject
@property (nonatomic, strong, readonly) NSString *topicID;               // 帖子id
@property (nonatomic, strong, readonly) NSString *classify;              // 来源
@property (nonatomic, strong, readonly) NSString *title;                 // 标题
@property (nonatomic, strong, readonly) NSString *content;               // 内容
@property (nonatomic, strong, readonly) NSMutableArray  *images;                // 图
@property (nonatomic, strong, readonly) NSMutableArray  *thumbnails;            // 缩略图
@property (nonatomic, strong, readonly) NSString *thumb;                 // 点赞数量
@property (nonatomic, strong, readonly) NSString *commentCount;          // 评论数量
@property (nonatomic, strong, readonly) NSString *time;                  // 发布时间
@property (nonatomic, strong, readonly) NSString *userID;                // 用户id
@property (nonatomic, strong, readonly) NSString *avatar;                // 头像
@property (nonatomic, strong, readonly) NSString *nickname;              // 昵称
@property (nonatomic, assign, readonly) BOOL hasSticky;                  // 是否置顶
@property (nonatomic, assign, readonly) TKTopicType topicType;
@property (nonatomic, assign, readonly) BOOL hasHighlight;               // 是否加精
@property (nonatomic, strong, readonly) NSString *is_video;               // 视频图片0 无视频 1app视频 2pc视频
@property (nonatomic, strong, readonly) NSArray *video;               // 视频地址
@property (nonatomic, assign) BOOL isselectded;                         /// 是否点击过
+ (instancetype)viewModelWithSubject:(NSDictionary *)subject;
@end

@interface TKTopicDetailViewModel : NSObject
@property (nonatomic, strong, readonly) NSString *topicID;               // 帖子id
@property (nonatomic, strong, readonly) NSString *classify;              // 来源
@property (nonatomic, strong, readonly) NSString *title;                 // 标题
@property (nonatomic, strong, readonly) NSString *content_url;           // 内容
@property (nonatomic, strong, readonly) NSArray  *images;                // 图
@property (nonatomic, strong, readonly) NSString *thumb;                 // 点赞数量
@property (nonatomic, strong, readonly) NSString *comment;               // 评论数量
@property (nonatomic, strong, readonly) NSString *collect;               // 收藏数量
@property (nonatomic, strong, readonly) NSString *time;                  // 发布时间
@property (nonatomic, strong, readonly) NSString *userID;                // 用户id
@property (nonatomic, strong, readonly) NSString *avatar;                // 头像
@property (nonatomic, strong, readonly) NSString *nickname;              // 昵称
@property (nonatomic, strong, readonly) NSArray  *comments;              // 评论
@property (nonatomic, assign, readonly) TKTopicType topicType;
@property (nonatomic, assign, readonly) BOOL has_fav;                    // 是否收藏
@property (nonatomic, assign, readonly) BOOL has_thumb;                  // 是否点赞

+ (instancetype)viewModelWithSubject:(NSDictionary *)subject;
@end


