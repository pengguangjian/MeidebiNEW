//
//  Juancle.h
//  Meidebi
//
//  Created by 杜非 on 15/1/26.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Juancle : NSObject

@property (nonatomic, retain) NSNumber * juanid;
@property (nonatomic, retain) NSNumber * man;
@property (nonatomic, retain) NSNumber * jian;
@property (nonatomic, retain) NSNumber * ishot;
@property (nonatomic, retain) NSString * imgurl;
@property (nonatomic, retain) NSNumber * timeout;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSNumber * copper;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * saledcount;
@property (nonatomic, retain) NSNumber * createtime;
@property (nonatomic, retain) NSNumber * usestart;
@property (nonatomic, retain) NSNumber * useend;


-(instancetype)initWithDictionary:(NSDictionary *)dic;
-(void)setWithMyHouseDic:(NSDictionary *)dic;


@end
