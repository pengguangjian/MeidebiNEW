//
//  OriginalDetailViewModel.h
//  Meidebi
//
//  Created by mdb-admin on 2017/9/26.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKTopicModuleConstant.h"
@interface OriginalDetailViewModel : NSObject

@property (nonatomic, strong, readonly) NSString *originalID;
@property (nonatomic, strong, readonly) NSString *imageLink;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *content;
@property (nonatomic, strong, readonly) NSString *bonus;
@property (nonatomic, strong, readonly) NSString *reason;
@property (nonatomic, strong, readonly) NSString *remarkStar;
@property (nonatomic, strong, readonly) NSString *createtime;
@property (nonatomic, strong, readonly) NSString *commentcount;
@property (nonatomic, strong, readonly) NSString *browsecount;
@property (nonatomic, strong, readonly) NSString *likeCount;
@property (nonatomic, strong, readonly) NSString *praisecount;
@property (nonatomic, strong, readonly) NSString *disparagecount;
@property (nonatomic, strong, readonly) NSString *favnum;
@property (nonatomic, strong, readonly) NSString *username;
@property (nonatomic, strong, readonly) NSString *avatarLink;
@property (nonatomic, strong, readonly) NSString *userId;
@property (nonatomic, strong, readonly) NSString *userLevel;
@property (nonatomic, strong, readonly) NSString *rewardCount;
@property (nonatomic, strong, readonly) NSArray *comments;
@property (nonatomic, strong, readonly) NSArray *tags;
@property (nonatomic, strong, readonly) NSArray *rewardUsers;
@property (nonatomic, strong, readonly) NSArray *mores;
@property (nonatomic, assign, readonly) TKTopicType topicType;
@property (nonatomic, assign, readonly) BOOL isFollow;
@property (nonatomic, assign, readonly) BOOL isfav;
@property (nonatomic, assign, readonly) BOOL isTimeout;

+ (instancetype)viewModelWithSubject:(NSDictionary *)subject;

@end
