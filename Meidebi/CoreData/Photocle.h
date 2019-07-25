//
//  Photocle.h
//  Meidebi
//
//  Created by 杜非 on 15/3/2.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photocle : NSObject

@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) NSString * domain;
@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSNumber * marked;
@property (nonatomic, retain) NSString * token;
@property (nonatomic, retain) NSNumber * isupload;
//-(void)objectWithDictionary:(NSNumber *)maked dic:(NSDictionary *)dics data:(NSData *)datas;

@end
