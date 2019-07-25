//
//  Marked.h
//  Meidebi
//
//  Created by 杜非 on 15/2/28.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Marked : NSObject

@property (nonatomic, retain) NSString * markedid;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * usertoken;
@property (nonatomic, retain) NSString * count;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSString * sdquality;
@property (nonatomic, retain) NSString * sdship;
@property (nonatomic, retain) NSString * sdcustom;
@property (nonatomic, retain) NSString * siteid;

//-(void)objectWithDictionary:(NSString *)makedid content:(NSString *)cont usertoken:(NSString *)token count:(NSInteger)count time:(NSDate *)time sdqualit:(NSInteger )sdqulti  sdship:(NSInteger)sdship sdcustom:(NSInteger)sdcust siteid:(NSInteger)siteid;

@end
