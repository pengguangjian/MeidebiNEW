//
//  JinRiPinDanListMainModel.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/17.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JinRiPinDanListMainModel : NSObject

@property (nonatomic, retain) NSString *strtitletime;
@property (nonatomic, retain) NSString *strid;
@property (nonatomic, retain) NSString *strgoods_id;
@property (nonatomic, retain) NSString *straddtime;
@property (nonatomic, retain) NSString *strstatus;
@property (nonatomic, retain) NSString *strstate;
@property (nonatomic, retain) NSString *straddymd;
@property (nonatomic, retain) NSString *strimage;
@property (nonatomic, retain) NSString *strname;
@property (nonatomic, retain) NSString *strpurchased_nums;
@property (nonatomic, retain) NSString *strprice;
@property (nonatomic, retain) NSString *strpindannum;
@property (nonatomic, retain) NSString *strtitle;
@property (nonatomic, retain) NSString *strshare_id;
@property (nonatomic, retain) NSString *strisend;
@property (nonatomic, retain) NSArray *arrpindanusers;
@property (nonatomic, retain) NSString *isspiderorder;
/////现货
@property (nonatomic, strong) NSString *isspotgoods;

+ (instancetype)viewModelWithSubject:(NSDictionary *)subject;

//+ (instancetype)viewModelWithSubject1:(NSDictionary *)subject;

@end
