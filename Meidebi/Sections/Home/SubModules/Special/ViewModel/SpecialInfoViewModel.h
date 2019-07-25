//
//  SpecialInfoViewModel.h
//  Meidebi
//
//  Created by mdb-admin on 2017/6/2.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpecialInfoViewModel : NSObject

@property (nonatomic, strong, readonly) NSString *specialID;
@property (nonatomic, strong, readonly) NSString *imageLink;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *content;
@property (nonatomic, strong, readonly) NSString *starttime;
@property (nonatomic, strong, readonly) NSString *endtime;
@property (nonatomic, strong, readonly) NSString *createtime;
@property (nonatomic, strong, readonly) NSString *commentcount;
@property (nonatomic, strong, readonly) NSString *browsecount;
@property (nonatomic, strong, readonly) NSString *praisecount;
@property (nonatomic, strong, readonly) NSString *disparagecount;
@property (nonatomic, strong, readonly) NSString *favnum;
@property (nonatomic, strong, readonly) NSString *username;
@property (nonatomic, strong, readonly) NSString *avatarLink;
@property (nonatomic, strong, readonly) NSString *userId;
@property (nonatomic, strong, readonly) NSString *type;
@property (nonatomic, strong, readonly) NSArray *comments;
@property (nonatomic, assign, readonly) BOOL isFollow;
@property (nonatomic, assign, readonly) BOOL isfav;
@property (nonatomic, assign, readonly) BOOL isTimeout;

+ (instancetype)viewModelWithSubject:(NSDictionary *)subject;

@end
