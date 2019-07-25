//
//  OrderGoodsInfoModel.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/19.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MyGoodsCouponModel.h"

@interface OrderGoodsMoneyInfoModel : NSObject

///关税(限转运)
@property (nonatomic , retain) NSString *tariff;
///转运费（限转运）
@property (nonatomic , retain) NSString *transfermoney;
///国外本土运费（限转运）
@property (nonatomic , retain) NSString *hpostage;
///直邮运费（限直邮）
@property (nonatomic , retain) NSString *directmailmoney;

@property (nonatomic , assign) int ikey;

+ (instancetype)viewModelWithSubject:(NSDictionary *)subject;

@end


@interface OrderShopInfoModel : NSObject

///店铺id
@property (nonatomic , retain) NSString *share_id;
///店铺名称
@property (nonatomic , retain) NSString *name;
///店铺中的商品
@property (nonatomic , retain) NSMutableArray *arrgoods;

+ (instancetype)viewModelWithSubject:(NSDictionary *)subject;

@end

@interface OrderGoodsInfoModel : NSObject
///添加时间
@property (nonatomic , retain) NSString *addtime;
///添加日期 eg 20180330
@property (nonatomic , retain) NSString *addymd;
///代购类型 1直下 2拼单
@property (nonatomic , retain) NSString *daigoutype;
///直邮运费（限直邮）
@property (nonatomic , retain) NSString *directmailmoney;
///购买截止时间
@property (nonatomic , retain) NSString *endtime;
///已成团次数，限拼单类型
@property (nonatomic , retain) NSString *has_pindantimes;
///国外本土运费（限转运）
@property (nonatomic , retain) NSString *hpostage;
///代购商品id
@property (nonatomic , retain) NSString *did;
///是否置顶|推荐  0不推荐 1推荐
@property (nonatomic , retain) NSString *istop;
///单人限购数量
@property (nonatomic , retain) NSString *onelimit;
///拼单人数（成团人数），限拼单类型
@property (nonatomic , retain) NSString *pindannum;
///规定成团次数，限拼单类型
@property (nonatomic , retain) NSString *pindantimes;
///商品单价（RMB）
@property (nonatomic , retain) NSString *price;
///已购买数量
@property (nonatomic , retain) NSString *purchased_nums;
///商品id
@property (nonatomic , retain) NSString *share_id;
///商城
@property (nonatomic , retain) NSString *siteid;
///状态 0失效 1 有效'
@property (nonatomic , retain) NSString *status;
///限制基本库存数量
@property (nonatomic , retain) NSString *stock;
///关税(限转运)
@property (nonatomic , retain) NSString *tariff;
///标题
@property (nonatomic , retain) NSString *title;
///转运费（限转运）
@property (nonatomic , retain) NSString *transfermoney;
///运输方式 1转运 2直邮
@property (nonatomic , retain) NSString *transfertype;
///转运公司线路id
@property (nonatomic , retain) NSString *transitelineid;
///单个商品重量(kg单位)
@property (nonatomic , retain) NSString *weight;
///商品图片
@property (nonatomic , retain) NSString *image;
///店铺名称
@property (nonatomic , retain) NSString *name;
///商品数量对应的费用
@property (nonatomic , retain) NSMutableArray *incidentals;
///剩余抵扣运费
@property (nonatomic , retain) NSString *remain_bonus;
///规格
@property (nonatomic , retain) NSString *spec_val;
///规格id
@property (nonatomic , retain) NSString *goodsdetail_id;
///选中了几件
@property (nonatomic , assign) int iselectnumber;
///拼单id
@property (nonatomic , retain) NSString *pindanid;

/////现货
@property (nonatomic, strong) NSString *isspotgoods;

+ (instancetype)viewModelWithSubject:(NSDictionary *)subject;

@end


