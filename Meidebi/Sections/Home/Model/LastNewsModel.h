//
//  LastNewsModel.h
//  Meidebi
//
//  Created by leecool on 2017/9/27.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, NewsType) {
    NewsTypeDiscount,          // 爆料
    NewsTypeOriginal,          // 原创
    NewsTypeSpecial             // 专题
};
@interface LastNewsModel : NSObject
@property (nonatomic, strong, readonly) NSString *newsID;
@property (nonatomic, strong, readonly) NSString *userID;
@property (nonatomic, strong, readonly) NSString *userName;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *price;
@property (nonatomic, strong, readonly) NSString *site;
@property (nonatomic, strong, readonly) NSString *time;
@property (nonatomic, strong, readonly) NSString *sourceStr;
@property (nonatomic, strong, readonly) NSString *imageLink;
@property (nonatomic, strong, readonly) NSString *avaterImageLink;
@property (nonatomic, strong, readonly) NSString *likeCount;
@property (nonatomic, strong, readonly) NSString *remarkCount;
@property (nonatomic, assign, readonly) NewsType style;
@property (nonatomic, assign, readonly) CGFloat rowHeight;
@property (nonatomic, assign) BOOL isSelect;

+ (instancetype)viewModelWithSubject:(NSDictionary *)subject;
@end
