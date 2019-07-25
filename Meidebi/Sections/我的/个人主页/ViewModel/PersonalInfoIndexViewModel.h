//
//  PersonalViewModel.h
//  Meidebi
//
//  Created by mdb-admin on 2017/6/20.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonalInfoIndexViewModel : NSObject

@property (nonatomic, strong, readonly) NSString *avatarLink;
@property (nonatomic, strong, readonly) NSString *nickname;
@property (nonatomic, strong, readonly) NSString *totalLevel;
@property (nonatomic, strong, readonly) NSString *followNum;
@property (nonatomic, strong, readonly) NSString *fansNum;
@property (nonatomic, strong, readonly) NSString *brokethenewsNum;
@property (nonatomic, strong, readonly) NSString *showdanNum;
@property (nonatomic, assign, readonly) BOOL isFollow;          //是否关注

+ (instancetype)viewModelWithSubject:(NSDictionary *)subject;

@end
