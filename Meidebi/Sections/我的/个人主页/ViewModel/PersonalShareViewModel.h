//
//  PersonalShareViewModel.h
//  Meidebi
//
//  Created by mdb-admin on 2017/6/21.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonalShareViewModel : NSObject

@property (nonatomic, strong, readonly) NSString *userID;
@property (nonatomic, strong, readonly) NSString *artid;
@property (nonatomic, strong, readonly) NSString *content;
@property (nonatomic, strong, readonly) NSString *collectcount;
@property (nonatomic, strong, readonly) NSString *showcount;
@property (nonatomic, strong, readonly) NSString *commentcount;
@property (nonatomic, strong, readonly) NSString *artTitle;
@property (nonatomic, strong, readonly) NSString *createtime;
@property (nonatomic, strong, readonly) NSString *image;

+ (instancetype)viewModelWithSubject:(NSDictionary *)subject;

@end
