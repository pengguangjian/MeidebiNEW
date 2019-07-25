//
//  HomeViewModel.h
//  Meidebi
//
//  Created by mdb-admin on 2017/5/31.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Commodity.h"
#import "SpecialViewModel.h"
typedef NS_ENUM(NSInteger, ActivityType) {
    ActivityTypeNormal,      // 普通（评论）
    ActivityTypeAccumulate,   // 积攒
    ActivityTypeBargain
};

typedef NS_ENUM(NSInteger, ActivityStateType) {
    ActivityStateTypeNoBegin,       // 未开始
    ActivityStateTypeIng,           // 进行中
    ActivityStateTypeEnd            // 结束
};

@interface HomeActivitieViewModel: NSObject
@property (nonatomic, strong, readonly) NSString *activityID;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *imageLink;
@property (nonatomic, strong, readonly) NSString *hasreward;
@property (nonatomic, strong, readonly) NSString *totaluser;
@property (nonatomic, assign, readonly) ActivityStateType status;
@property (nonatomic, assign, readonly) ActivityType activityType;
@property (nonatomic, strong, readonly) NSArray *users;
+ (instancetype)viewModelWithSubject:(NSDictionary *)subject;
@end


@interface HomeUserViewModel: NSObject
@property (nonatomic, strong, readonly) NSString *avatar;
@property (nonatomic, strong, readonly) NSString *username;
+ (instancetype)viewModelWithSubject:(NSDictionary *)subject;
@end

@interface HomeHotSticksViewModel: NSObject
@property (nonatomic, strong, readonly) NSString *stickID;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *link;
@property (nonatomic, strong, readonly) NSString *linkType;
@property (nonatomic, strong, readonly) NSString *linkId;

+ (instancetype)viewModelWithSubject:(NSDictionary *)subject;
@end

@interface HomeCheapViewModel: NSObject
@property (nonatomic, strong, readonly) NSString *commodityID;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *imageLink;
@property (nonatomic, strong, readonly) NSString *brand;
@property (nonatomic, strong, readonly) NSString *info;

+ (instancetype)viewModelWithSubject:(NSDictionary *)subject;
@end

@interface HomeDaiGouViewModel: NSObject
@property (nonatomic, strong, readonly) NSString *pintuanID;
@property (nonatomic, strong, readonly) NSString *goodsID;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *imageLink;
@property (nonatomic, strong, readonly) NSString *purchased_nums;
@property (nonatomic, strong, readonly) NSString *pindannum;
@property (nonatomic, strong, readonly) NSString *price;
@property (nonatomic, strong, readonly) NSString *share_id;
@property (nonatomic, strong, readonly) NSArray *pindanusers;

+ (instancetype)viewModelWithSubject:(NSDictionary *)subject;
@end

@interface HomeViewModel : NSObject
@property (nonatomic, strong, readonly) NSArray *activities;
@property (nonatomic, strong, readonly) NSArray *shares;
@property (nonatomic, strong, readonly) NSArray *specials;
@property (nonatomic, strong, readonly) NSArray *homeSpecials;
@property (nonatomic, strong, readonly) NSArray *hotSticks;
@property (nonatomic, strong, readonly) NSArray *cheaps;
@property (nonatomic, strong, readonly) NSArray *helpshop;
+ (instancetype)viewModelWithSubject:(NSDictionary *)subject;
@end
