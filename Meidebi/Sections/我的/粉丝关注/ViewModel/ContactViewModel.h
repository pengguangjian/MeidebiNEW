//
//  ContactViewModel.h
//  Meidebi
//
//  Created by mdb-admin on 2017/6/20.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactViewModel : NSObject

@property (nonatomic, strong, readonly) NSString *attentionID;  // 关注人用户ID
@property (nonatomic, strong, readonly) NSString *uID;          // 粉丝用户ID
@property (nonatomic, strong, readonly) NSString *avatarLink;
@property (nonatomic, strong, readonly) NSString *nickname;
@property (nonatomic, strong, readonly) NSString *starttime;
@property (nonatomic, strong, readonly) NSString *standard;
@property (nonatomic, assign, readonly) BOOL isDirection;       //是否互关
@property (nonatomic, assign, readonly) BOOL isFollow;          //是否关注

+ (instancetype)viewModelWithSubject:(NSDictionary *)subject;
- (void)updateFollowStatus;
- (void)updateDirectionStatus;
@end
