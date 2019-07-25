//
//  GoodsCarSuperModel.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/8/29.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsGarModel.h"

@interface GoodsCarSuperModel : NSObject

@property (nonatomic ,retain) NSString *strid;

@property (nonatomic ,retain) NSString *strshopname;

@property (nonatomic ,retain) NSMutableArray *arrlist;

///直邮2
@property (nonatomic , retain)NSString *transfertype;

+(GoodsCarSuperModel *)viewModelDic:(NSDictionary *)dic;

@end
