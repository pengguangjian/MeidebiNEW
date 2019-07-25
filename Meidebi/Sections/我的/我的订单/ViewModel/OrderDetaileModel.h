//
//  OrderDetaileModel.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/20.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "MyOrderMainModel.h"

@interface OrderDetaileModel : MyOrderMainModel
///收货人
@property (nonatomic , retain) NSString *truename;
///电话
@property (nonatomic , retain) NSString *mobile;
///收货地址
@property (nonatomic , retain) NSString *address;
///身份证正面
@property (nonatomic , retain) NSString *front_pic;
///身份证反面
@property (nonatomic , retain) NSString *back_pic;
///身份证号
@property (nonatomic , retain) NSString *idcard;
///商品附加信息
@property (nonatomic , retain) NSString *extra;
///国内快递(暂无价格)
@property (nonatomic , retain) NSString *express;
///订单编号
@property (nonatomic , retain) NSString *orderno;
///下单时间
@property (nonatomic , retain) NSString *addtime;
///代购结束时间
@property (nonatomic , retain) NSString *endtime;
///发货时间
@property (nonatomic , retain) NSString *sendtime;
///支付时间
@property (nonatomic , retain) NSString *paytime;
///购买凭证
@property (nonatomic , retain) NSString *abshippedpics;
@property (nonatomic , retain) NSArray *shotpics;

///退款状态
@property (nonatomic , retain) NSString *refund;

@property (nonatomic , retain) NSArray *shoppics;

///国际快递
@property (nonatomic , retain) NSString *international;
///国内快递
@property (nonatomic , retain) NSString *domestic;
///订单取消原因
@property (nonatomic , retain) NSString *remove_reason;
///订单取消时间
@property (nonatomic , retain) NSString *removetime;
///国内快递运费
@property (nonatomic , retain) NSString *guonei_cost;

///支付方式 1支付宝 2微信
@property (nonatomic , retain) NSString *paytype;
///物流
@property (nonatomic , retain) NSString *logistics;
///类别( 1转运 2直邮)
@property (nonatomic , retain) NSString *transfertype;
///价格
@property (nonatomic , retain) NSString *price;
///
@property (nonatomic , retain) NSString *share_id;
///税费
@property (nonatomic , retain) NSString *tariff;
///参加拼单用户的头像
@property (nonatomic , retain) NSArray *pindanusers;

@property (nonatomic , retain) NSString *qq;

@property (nonatomic , retain) NSString *link;

///其他费用费率6/10000
@property (nonatomic , retain) NSString *orderpoundage;

///手续费
@property (nonatomic , retain) NSString *poundage_cost;

///抵扣运费
@property (nonatomic , retain) NSString *bounty_cost;

///商品抵扣
@property (nonatomic , retain) NSString *coupon_cost;

///国际邮费
@property (nonatomic , retain) NSString *guoji_cost;

///0不可领（没有配置、未支付、分享红包超时） 1未创建 2未领取 3已领取
@property (nonatomic , retain) NSString *couponinfortype;
///已领取多少
@property (nonatomic , retain) NSString *sendnum;
///多少个
@property (nonatomic , retain) NSString *num;

@property (nonatomic , retain) NSString *stris_slow;
///订单的详细状态 
@property (nonatomic , retain) NSString *strnodestatus;

+(OrderDetaileModel *)bindModelData:(NSDictionary *)subject;

@end
@interface OrderDetaileGoodsModel : NSObject
///代购商品id
@property (nonatomic , retain) NSString *goods_id;
///购买数量
@property (nonatomic , retain) NSString *num;
///商品单价
@property (nonatomic , retain) NSString *price;
///商品主图
@property (nonatomic , retain) NSString *image;
///直达链接
@property (nonatomic , retain) NSString *redirecturl;
///商品标题
@property (nonatomic , retain) NSString *title;
///是否团长 1:是 0:否
@property (nonatomic , retain) NSString *colonel;
///订单类型(1:直接下单 2:拼单)
@property (nonatomic , retain) NSString *transfertype;

@property (nonatomic , retain) NSString *link;
///国际邮费
@property (nonatomic , retain) NSString *guoji_cost;
///税费
@property (nonatomic , retain) NSString *tariff;
///规格
@property (nonatomic , retain) NSString *spec_val;

+(OrderDetaileGoodsModel *)binddata:(NSDictionary *)dic;
@end
