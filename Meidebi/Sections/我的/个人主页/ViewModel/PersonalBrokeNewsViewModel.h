//
//  PersonalBrokeNewsViewModel.h
//  Meidebi
//
//  Created by mdb-admin on 2017/6/20.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonalBrokeNewsViewModel : NSObject

@property (nonatomic, strong, readonly) NSString * abroadhot;
@property (nonatomic, strong, readonly) NSString * apilink_id;
@property (nonatomic, strong, readonly) NSString * artid;
@property (nonatomic, strong, readonly) NSString * category;
@property (nonatomic, strong, readonly) NSString * categoryname;
@property (nonatomic, strong, readonly) NSString * changetime;
@property (nonatomic, strong, readonly) NSString * changeuser;
@property (nonatomic, strong, readonly) NSString * commentcount;
@property (nonatomic, strong, readonly) NSString * contrysitename;
@property (nonatomic, strong, readonly) NSString * cpsurl;
@property (nonatomic, strong, readonly) NSString * createtime;
@property (nonatomic, strong, readonly) NSString * descriptions;
@property (nonatomic, strong, readonly) NSString * directtariff;
@property (nonatomic, strong, readonly) NSString * editforbiden;
@property (nonatomic, strong, readonly) NSString * fcategory;
@property (nonatomic, strong, readonly) NSString * freight;
@property (nonatomic, strong, readonly) NSString * guoneihot;
@property (nonatomic, strong, readonly) NSString * hit;
@property (nonatomic, strong, readonly) NSString * image;
@property (nonatomic, strong, readonly) NSString * isabroad;
@property (nonatomic, strong, readonly) NSString * isamazonz;
@property (nonatomic, strong, readonly) NSString * ishot;
@property (nonatomic, strong, readonly) NSString * isorder;
@property (nonatomic, strong, readonly) NSString * issendemail;
@property (nonatomic, strong, readonly) NSString * jibaoguoqi;
@property (nonatomic, strong, readonly) NSString * linktype;
@property (nonatomic, strong, readonly) NSString * nickname;
@property (nonatomic, strong, readonly) NSString * notchecked;
@property (nonatomic, strong, readonly) NSString * orginurl;
@property (nonatomic, strong, readonly) NSString * perfect;
@property (nonatomic, strong, readonly) NSString * postage;
@property (nonatomic, strong, readonly) NSString * price;
@property (nonatomic, strong, readonly) NSString * procurenum;
@property (nonatomic, strong, readonly) NSString * redirecturl;
@property (nonatomic, strong, readonly) NSString * remoteimage;
@property (nonatomic, strong, readonly) NSString * setahottime;
@property (nonatomic, strong, readonly) NSString * setghottime;
@property (nonatomic, strong, readonly) NSString * sethottime;
@property (nonatomic, strong, readonly) NSString * setthottime;
@property (nonatomic, strong, readonly) NSString * showcount;
@property (nonatomic, strong, readonly) NSString * siteid;
@property (nonatomic, strong, readonly) NSString * sitename;
@property (nonatomic, strong, readonly) NSString * statustext;
@property (nonatomic, strong, readonly) NSString * subsiteorwh;
@property (nonatomic, strong, readonly) NSString * tagstr;
@property (nonatomic, strong, readonly) NSString * timeout;
@property (nonatomic, strong, readonly) NSString * title;
@property (nonatomic, strong, readonly) NSString * tmallhot;
@property (nonatomic, strong, readonly) NSString * userid;
@property (nonatomic, strong, readonly) NSString * votesm;
@property (nonatomic, strong, readonly) NSString * votesp;
@property (nonatomic, strong, readonly) NSString * proprice;
@property (nonatomic, strong, readonly) NSString *prodescription;

+ (instancetype)viewModelWithSubject:(NSDictionary *)subject;

@end
