//
//  SearchGoodsModel.h
//  Meidebi
//  搜索商品model
//  Created by mdb-losaic on 2018/3/12.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchGoodsModel : NSObject

typedef enum GOOGSTYPE
{
    GOOGSTYPEa = 1,     ///海淘
    GOOGSTYPEb = 2,     ///国内
    GOOGSTYPEc = 3      ///优惠券
    
} googsType;

///id
@property (nonatomic , retain) NSString *strid;
///类型
@property (nonatomic , assign) googsType type;
///图标
@property (nonatomic , retain) NSString *strpicurl;
///标题
@property (nonatomic , retain) NSString *strtitle;
///价格
@property (nonatomic , retain) NSString *strprice;
///商店
@property (nonatomic , retain) NSString *strshop;
///优惠券价格
@property (nonatomic , retain) NSString *stryouhuiprice;
////
@property(nonatomic,strong) NSString *tljurl;

@property (nonatomic , assign) BOOL isSelect;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end
