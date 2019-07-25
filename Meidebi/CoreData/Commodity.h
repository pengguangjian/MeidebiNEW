//
//  Commodity.h
//  Meidebi
//
//  Created by losaic on 16/5/8.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Commodity : NSObject

@property (nonatomic, strong) NSString *activeprice;
@property (nonatomic, strong) NSString *activeprice_change;
@property (nonatomic, strong) NSString *agttype;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *categoryname;
@property (nonatomic, strong) NSString *coinsign;
@property (nonatomic, strong) NSString *commentcount;
@property (nonatomic, strong) NSString *cpsurl;
@property (nonatomic, strong) NSString *createtime;
@property (nonatomic, strong) NSString *commodityDescription;
@property (nonatomic, strong) NSString *fcategory;
@property (nonatomic, strong) NSString *commodityid;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *isabroad;
@property (nonatomic, strong) NSString *linktype;
@property (nonatomic, strong) NSString *linkurl;
@property (nonatomic, strong) NSString *lowpricetype;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *orginprice;
@property (nonatomic, strong) NSString *orginprice_change;
@property (nonatomic, strong) NSString *postage;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *prodescription;
@property (nonatomic, strong) NSString *proprice;
@property (nonatomic, strong) NSString *redirecturl;
@property (nonatomic, strong) NSString *setagthottime;
@property (nonatomic, strong) NSString *sethottime;
@property (nonatomic, strong) NSString *siteid;
@property (nonatomic, strong) NSString *sitename;
@property (nonatomic, strong) NSString *timeout;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *votesm;
@property (nonatomic, strong) NSString *votesp;
@property (nonatomic, strong) NSString *coupontype;
@property (nonatomic, strong) NSString *denomination;

@property (nonatomic, assign) BOOL isSelect;

@end
