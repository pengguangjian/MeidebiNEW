//
//  BargainActivityViewModel.h
//  Meidebi
//
//  Created by mdb-admin on 2017/10/17.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BargainActivityViewModel : NSObject

@property (nonatomic, strong, readonly) NSString *bargainActivityID;
@property (nonatomic, strong, readonly) NSString *createUserID;
@property (nonatomic, strong, readonly) NSString *imageLink;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *content;
@property (nonatomic, strong, readonly) NSString *victoryway;
@property (nonatomic, strong, readonly) NSString *explain;
@property (nonatomic, strong, readonly) NSString *state;
@property (nonatomic, strong, readonly) NSString *isfav;
@property (nonatomic, strong, readonly) NSString *prizes;
@property (nonatomic, strong, readonly) NSString *timeout;
@property (nonatomic, strong, readonly) NSString *starttime;
@property (nonatomic, strong, readonly) NSString *endtime;
@property (nonatomic, strong, readonly) NSString *createtime;
@property (nonatomic, strong, readonly) NSString *activitytime;
@property (nonatomic, strong, readonly) NSString *commentcount;
@property (nonatomic, strong, readonly) NSString *browsecount;
@property (nonatomic, strong, readonly) NSString *praisecount;
@property (nonatomic, strong, readonly) NSString *disparagecount;
@property (nonatomic, strong, readonly) NSString *favnum;
@property (nonatomic, strong, readonly) NSString *username;
@property (nonatomic, strong, readonly) NSString *avatarLink;
@property (nonatomic, strong, readonly) NSString *userId;
@property (nonatomic, strong, readonly) NSArray *comments;
@property (nonatomic, strong, readonly) NSArray *commoditys;

+ (instancetype)viewModelWithSubject:(NSDictionary *)subject;

@end


@interface BargainItemViewModel : NSObject

@property (nonatomic, strong, readonly) NSString *itemID;
@property (nonatomic, strong, readonly) NSString *activityID;
@property (nonatomic, strong, readonly) NSString *commodityID;
@property (nonatomic, strong, readonly) NSString *imageLink;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *price;
@property (nonatomic, strong, readonly) NSString *number;
@property (nonatomic, strong, readonly) NSString *required;
@property (nonatomic, strong, readonly) NSString *participants;
@property (nonatomic, strong, readonly) NSString *updatetime;
@property (nonatomic, strong, readonly) NSString *createtime;

+ (instancetype)viewModelWithSubject:(NSDictionary *)dict;

@end
