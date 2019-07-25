//
//  Sharecle.h
//  Meidebi
//
//  Created by 杜非 on 15/1/25.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sharecle : NSObject

@property (nonatomic, retain) NSString * album;
@property (nonatomic, retain) NSString * average;
@property (nonatomic, retain) NSNumber * chechtime;
@property (nonatomic, retain) NSNumber * coinsnum;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * commentcount;
@property (nonatomic, retain) NSNumber * coppernum;
@property (nonatomic, retain) NSString * cover;
@property (nonatomic, retain) NSNumber * createtime;
@property (nonatomic, retain) NSString * custom;
@property (nonatomic, retain) NSString * dbquality;
@property (nonatomic, retain) NSString * dispatch;
@property (nonatomic, retain) NSString * headphoto;
@property (nonatomic, retain) NSString * impression;
@property (nonatomic, retain) NSString * ip;
@property (nonatomic, retain) NSString * orgimages;
@property (nonatomic, retain) NSNumber * isabroad;
@property (nonatomic, retain) NSNumber * isperfect;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * pic;
@property (nonatomic, retain) NSString * pics;
@property (nonatomic, retain) NSString * reason;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * remotelink;
@property (nonatomic, retain) NSNumber * setpftime;
@property (nonatomic, retain) NSNumber * showcount;
@property (nonatomic, retain) NSNumber * siteid;
@property (nonatomic, retain) NSNumber * star;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * tagstr;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * transitcopany;
@property (nonatomic, retain) NSNumber * unchecked;
@property (nonatomic, retain) NSNumber * userid;
@property (nonatomic, retain) NSNumber * votesm;
@property (nonatomic, retain) NSNumber * votesp;
@property (nonatomic, retain) NSNumber * shareid;
@property (nonatomic, retain) NSNumber * devicetype;
@property (nonatomic, retain) NSNumber * width;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, strong) NSString *userLevel;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, assign) BOOL isFllow;
@property (nonatomic, assign) CGFloat cellHeight;
-(instancetype)initWithDictionary:(NSDictionary *)dic;
-(void)setWithMyHouseDic:(NSDictionary *)dic;



@end
