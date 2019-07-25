//
//  Article.h
//  Meidebi
//
//  Created by 杜非 on 15/2/5.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <CoreData/CoreData.h>


@interface Article : NSObject

@property (nonatomic, retain) NSNumber * abroadhot;
@property (nonatomic, retain) NSNumber * apilink_id;
@property (nonatomic, retain) NSNumber * artid;
@property (nonatomic, retain) NSNumber * category;
@property (nonatomic, retain) NSString * categoryname;
@property (nonatomic, retain) NSNumber * changetime;
@property (nonatomic, retain) NSNumber * changeuser;
@property (nonatomic, retain) NSNumber * commentcount;
@property (nonatomic, retain) NSString * contrysitename;
@property (nonatomic, retain) NSString * cpsurl;
@property (nonatomic, retain) NSDate * createtime;
@property (nonatomic, retain) NSString * descriptions;
@property (nonatomic, retain) NSString * directtariff;
@property (nonatomic, retain) NSNumber * editforbiden;
@property (nonatomic, retain) NSNumber * fcategory;
@property (nonatomic, retain) NSString * freight;
@property (nonatomic, retain) NSNumber * guoneihot;
@property (nonatomic, retain) NSNumber * hit;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSNumber * isabroad;
@property (nonatomic, retain) NSNumber * isamazonz;
@property (nonatomic, retain) NSNumber * isdirectmail;
@property (nonatomic, retain) NSNumber * ishot;
@property (nonatomic, retain) NSNumber * isorder;
@property (nonatomic, retain) NSNumber * issendemail;
@property (nonatomic, retain) NSNumber * jibaoguoqi;
@property (nonatomic, retain) NSNumber * linktype;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSNumber * notchecked;
@property (nonatomic, retain) NSString * orginurl;
@property (nonatomic, retain) NSNumber * perfect;
@property (nonatomic, retain) NSNumber * postage;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * procurenum;
@property (nonatomic, retain) NSString * redirecturl;
@property (nonatomic, retain) NSString * remoteimage;
@property (nonatomic, retain) NSNumber * setahottime;
@property (nonatomic, retain) NSDate * setghottime;
@property (nonatomic, retain) NSDate * sethottime;
@property (nonatomic, retain) NSNumber * setthottime;
@property (nonatomic, retain) NSNumber * showcount;
@property (nonatomic, retain) NSNumber * siteid;
@property (nonatomic, retain) NSString * sitename;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSNumber * subsiteorwh;
@property (nonatomic, retain) NSString * tagstr;
@property (nonatomic, retain) NSNumber * timeout;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * tmallhot;
@property (nonatomic, retain) NSNumber * userid;
@property (nonatomic, retain) NSNumber * votesm;
@property (nonatomic, retain) NSNumber * votesp;
@property (nonatomic, retain) NSNumber * proprice;
@property (nonatomic, retain) NSString *prodescription;
@property (nonatomic, strong) NSNumber *recommend;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, retain) NSString *old_artice;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *agttype;
@property (nonatomic, retain) NSString *pic;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *video_type;
@property (nonatomic, retain) NSArray *arrtagstr;
@property (nonatomic, retain) NSString *tljurl;

/////全网优惠数据
///优惠价格
@property (nonatomic, retain) NSString *activeprice;
///券面额
@property (nonatomic, retain) NSString *denomination;
///商品id
@property (nonatomic, retain) NSString *itemid;
///主图
@property (nonatomic, retain) NSString *itempic;
/////销量
@property (nonatomic, retain) NSString *salesnum;
///店铺类型 1天猫 2淘宝
@property (nonatomic, retain) NSString *shoptype;

////优惠券state=2,3
@property (nonatomic, retain) NSString *img;
///贡献值 1000
@property (nonatomic, retain) NSString *desc;
///
@property (nonatomic, retain) NSString *url;
///id
@property (nonatomic, retain) NSString *main_id;
///截止时间
@property (nonatomic, retain) NSString *getend;
///需要什么兑换1，2，3
@property (nonatomic, retain) NSString *changetype;

////从京东直接获取的数据，没得爆料详情 yes
@property (nonatomic, assign) BOOL isJDZhiLian;


-(instancetype)initWithDictionary:(NSDictionary *)dic;

///京东列表数据
-(instancetype)initWithJDDictionary:(NSDictionary *)dic;

-(void)setWithMyHouseDic:(NSDictionary *)dic;

@end
