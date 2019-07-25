//
//  RemarkStatusHelper.h
//  Meidebi
//
//  Created by mdb-admin on 2017/2/6.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYKit/YYKit.h>
#import "RemarkModel.h"
@interface RemarkStatusHelper : NSObject

/// 微博图片资源 bundle
+ (NSBundle *)bundle;

/// 微博表情资源 bundle
+ (NSBundle *)emoticonBundle;

/// 微博表情 Array<WBEmotionGroup> (实际应该做成动态更新的)
+ (NSArray<EmoticonGroup *> *)emoticonGroups;

/// 微博图片 cache
+ (YYMemoryCache *)imageCache;

/// 从微博 bundle 里获取图片 (有缓存)
+ (UIImage *)imageNamed:(NSString *)name;

/// 从path创建图片 (有缓存)
+ (UIImage *)imageWithPath:(NSString *)path;

/// 圆角头像的 manager
+ (YYWebImageManager *)avatarImageManager;

/// 将 date 格式化成微博的友好显示
+ (NSString *)stringWithTimelineDate:(NSDate *)date;

/// 将微博API提供的图片URL转换成可用的实际URL
+ (NSURL *)defaultURLForImageURL:(id)imageURL;

/// 缩短数量描述，例如 51234 -> 5万
+ (NSString *)shortedNumberDesc:(NSUInteger)number;

/// Url正则 例如 http://meidebi.com
+ (NSRegularExpression *)regexUrl;

/// At正则 例如 @王思聪
+ (NSRegularExpression *)regexAt;

/// 话题正则 例如 #暖暖环游世界#
+ (NSRegularExpression *)regexTopic;

/// 表情正则 例如 [偷笑]
+ (NSRegularExpression *)regexEmoticon;

/// 正则 例如 +30铜币/2积分
+ (NSRegularExpression *)regexWelfareStrategy;

/// 表情字典 key:[偷笑] value:ImagePath
+ (NSDictionary *)emoticonDic;

@end
