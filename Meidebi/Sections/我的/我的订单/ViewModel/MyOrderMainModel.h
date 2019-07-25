//
//  MyOrderMainModel.h
//  Meidebi
//  我的订单model
//  Created by mdb-losaic on 2018/4/19.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOrderMainModel : NSObject
///订单类型(1:直接下单 2:拼单)
@property (nonatomic , retain) NSString *daigoutype;
///代购商品id
@property (nonatomic , retain) NSString *goods_id;
///订单id
@property (nonatomic , retain) NSString *did;
///订单编号
@property (nonatomic , retain) NSString *orderon;
///商城名称
@property (nonatomic , retain) NSString *name;
///拼单id
@property (nonatomic , retain) NSString *pindan_id;
///退款状态｛退款状态 0无退款 1标记退款（待退款） 2退款中(预留，计划任务退款则用) 3退款成功 4退款失败
@property (nonatomic , retain) NSString *refundstatus;
//@property (nonatomic , retain) NSString *refund;
////部分退款状态
@property (nonatomic , retain) NSString *re_status;

///拼单成团所差人数
@property (nonatomic , retain) NSString *remain_pindannum;
///备注
@property (nonatomic , retain) NSString *remark;

///订单状态｛0新创建(待支付)  1未成团（拼单才有）2待下单 3待发货 4已发货 5已完成 10订单取消 ｝
@property (nonatomic , retain) NSString *status;
///总额
@property (nonatomic , retain) NSString *totalprice;

///参与拼单者头像
@property (nonatomic , retain) NSArray *userimg;

@property (nonatomic , retain) NSString *link;

///是否团长 1:是 0:否
@property (nonatomic , retain) NSString *colonel;

@property (nonatomic , retain) NSString *share_id;

///商品
@property (nonatomic , retain) NSMutableArray *goodsinfo;

//////

///购买数量
@property (nonatomic , retain) NSString *num;
///商品单价
@property (nonatomic , retain) NSString *spprice;
///商品主图
@property (nonatomic , retain) NSString *image;
///直达链接
@property (nonatomic , retain) NSString *redirecturl;
///商品标题
@property (nonatomic , retain) NSString *title;
///订单异常信息
@property (nonatomic , retain) NSString *accident_xpln;


+(MyOrderMainModel *)binddata:(NSDictionary *)dic;

@end

@interface MyOrderGoodsModel : NSObject
///购买数量
@property (nonatomic , retain) NSString *num;
///商品单价
@property (nonatomic , retain) NSString *spprice;
///商品主图
@property (nonatomic , retain) NSString *image;
///直达链接
@property (nonatomic , retain) NSString *redirecturl;
///商品标题
@property (nonatomic , retain) NSString *title;
///是否团长 1:是 0:否
@property (nonatomic , retain) NSString *colonel;
///订单类型(1:直接下单 2:拼单)
@property (nonatomic , retain) NSString *daigoutype;
///规格
@property (nonatomic , retain) NSString *spec_val;
///1 现货
@property (nonatomic , retain) NSString * spot;
///代购商品id
@property (nonatomic , retain) NSString *goods_id;

+(MyOrderGoodsModel *)binddata:(NSDictionary *)dic;
@end

