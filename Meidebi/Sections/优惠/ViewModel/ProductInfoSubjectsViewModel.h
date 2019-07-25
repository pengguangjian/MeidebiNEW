//
//  ProductInfoSubjectsViewModel.h
//  Meidebi
//
//  Created by mdb-admin on 16/4/28.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DetailViewType) {
    DetailViewTypeActivity,
    DetailViewTypeDiscount,
    DetailViewTypeInland,
    DetailViewTypeOverseas
};

///代购或拼单数据
@interface ProductInfoSubjectsDaiGouViewModel : NSObject
///商品类别（1直下 2拼单)
@property (nonatomic, retain) NSString *daigoutype;
///结束时间（拼团列表用）
@property (nonatomic, retain) NSString *daiendtime;
///代购商品id
@property (nonatomic, retain) NSString *goods_id;
///拼单人团（限拼单）
@property (nonatomic, retain) NSString *pindannum;
///价格
@property (nonatomic, retain) NSString *price;
///关税
@property (nonatomic, retain) NSString *tariff;
///转运费（限转运）
@property (nonatomic, retain) NSString *transfermoney;
///国外本土运费（限转运）
@property (nonatomic, retain) NSString *hpostage;
///直邮运费（限直邮）
@property (nonatomic, retain) NSString *directmailmoney;
///已购买次数
@property (nonatomic, retain) NSString *purchased_nums;
///参与人头像（最多4个）
@property (nonatomic, retain) NSArray *zhixia;
///拼团数据
@property (nonatomic, retain) NSMutableArray *pindan;
///是否截单 0非截单|1已截单
@property (nonatomic, retain) NSString *isend;
///状态 0失效 1 有效'
@property (nonatomic, retain) NSString *status;

////1就是有代沟爬虫
@property (nonatomic, strong) NSString *isspiderorder;

/////现货
@property (nonatomic, strong) NSString *isspotgoods;

+ (ProductInfoSubjectsDaiGouViewModel *)viewModelWithSubject:(NSDictionary *)subject;

@end

///拼团数据
@interface ProductInfoSubjectsDaiGouPinTuanViewModel : NSObject
///拼团id/拼单id
@property (nonatomic, retain) NSString *did;
///发起人头像
@property (nonatomic, retain) NSString *image;
///发起人昵称
@property (nonatomic, retain) NSString *nickname;
///还需人数
@property (nonatomic, retain) NSString *remain_pindannum;
///发起人id
@property (nonatomic, retain) NSString *userid;

+ (ProductInfoSubjectsDaiGouPinTuanViewModel *)viewModelWithSubject:(NSDictionary *)subject;
@end

///关联阅读数据
@interface ProductInfoSubjectsGuanLianYueDuViewModel : NSObject
///文章id
@property (nonatomic, retain) NSString *did;
///文章标题
@property (nonatomic, retain) NSString *title;
///时间
@property (nonatomic, retain) NSString *createtime;
///链接
@property (nonatomic, retain) NSString *content;

+ (ProductInfoSubjectsGuanLianYueDuViewModel *)viewModelWithSubject:(NSDictionary *)subject;
@end


@interface ProductInfoSubjectsViewModel : NSObject

///
@property (nonatomic, strong, readonly) NSString *commodityName;
///
@property (nonatomic, strong, readonly) NSAttributedString *commodityPirce;
///
@property (nonatomic, strong, readonly) NSString *commodityPrimeCost;
///
@property (nonatomic, strong, readonly) NSString *commoditySourceArea;
@property (nonatomic, strong, readonly) NSString *commddd;
///商城
@property (nonatomic, strong, readonly) NSString *commoditySupply;
///
@property (nonatomic, strong, readonly) NSString *commodityPostage;
///
@property (nonatomic, strong, readonly) NSString *commodityTransfer;
@property (nonatomic, strong, readonly) NSString *commodityTax;
///
@property (nonatomic, strong, readonly) NSString *commodityZan;
///
@property (nonatomic, strong, readonly) NSString *commodityShou;
///
@property (nonatomic, strong, readonly) NSString *commodityCom;
///
@property (nonatomic, strong, readonly) NSString *nickname;
///
@property (nonatomic, strong, readonly) NSString *createtime;
///
@property (nonatomic, strong, readonly) NSString *commodityImageLink;
///
@property (nonatomic, strong, readonly) NSString *iconImageLink;
///
@property (nonatomic, strong, readonly) NSString *navTitle;
///
@property (nonatomic, strong, readonly) NSString *webDescription;
///
@property (nonatomic, strong, readonly) NSString *activityDate;
///
@property (nonatomic, strong, readonly) NSString *outurl;
///
@property (nonatomic, strong, readonly) NSString *linkType;
///
@property (nonatomic, strong, readonly) NSString *redirectUrl;
///
@property (nonatomic, strong, readonly) NSString *otherprice;
///
@property (nonatomic, strong, readonly) NSString *courselink;
///
@property (nonatomic, strong, readonly) NSString *totalmoney_dec;
///
@property (nonatomic, strong, readonly) NSString *tmallid;
///
@property (nonatomic, strong, readonly) NSString *waresid;
///
@property (nonatomic, strong, readonly) NSString *activeImageLink;
///
@property (nonatomic, strong, readonly) NSString *activeLink;
///
@property (nonatomic, strong, readonly) NSString *tmalltWoinOneUrlLink;
///
@property (nonatomic, strong, readonly) NSString *appactiveopen;
///
@property (nonatomic, strong, readonly) NSString *userID;
///
@property (nonatomic, assign, readonly) BOOL isDirect;
///
@property (nonatomic, assign, readonly) BOOL isEnshrine;
///
@property (nonatomic, assign, readonly) BOOL isTianMao;
///
@property (nonatomic, assign, readonly) BOOL isOpenActive;
///
@property (nonatomic, assign, readonly) DetailViewType viewType;
////
@property (nonatomic, strong, readonly) NSString *commentSum;
@property (nonatomic, strong, readonly) NSString *userShareSum;
///
@property (nonatomic, assign, readonly) BOOL isFollow;
///
@property (nonatomic, strong, readonly) NSArray *comments;
///
@property (nonatomic, strong, readonly) NSArray *relateShares;
///
@property (nonatomic, strong, readonly) NSArray *flags;
///
@property (nonatomic, strong, readonly) NSString *privilegeType;
///
@property (nonatomic, strong, readonly) NSString *prodescription;
///
@property (nonatomic, strong, readonly) NSString *wantbuy;
///
@property (nonatomic, strong, readonly) NSString *alreadybuy;
///
@property (nonatomic, strong, readonly) NSString *share_num;
///
@property (nonatomic, strong, readonly) NSString *showdan_num;
////
@property (nonatomic, strong, readonly) NSString *user_level;
///
@property (nonatomic, strong, readonly) NSString *rewardCount;
///
@property (nonatomic, strong, readonly) NSArray *rewardUsers;
///
@property (nonatomic, strong, readonly) NSArray *hotshowdans;

@property (nonatomic, strong, readonly) NSMutableArray *articles;

///是否显示求开团
@property (nonatomic , strong) NSString *wishBtn;

////所属商城可代购
@property (nonatomic, strong, readonly) NSString *site_can_order;

///是否唤起safari浏览器
@property (nonatomic , strong) NSString *outopen;

///商城id
@property (nonatomic, strong) NSString *commoditySupplyid;

///淘礼金链接
@property (nonatomic, strong) NSString *tljurl;

////免邮教程
@property (nonatomic, strong) NSString *free_freight_url;

////是否是京东
@property (nonatomic, assign) BOOL isJD;
///京东链接
@property (nonatomic, strong) NSString *redirecturl;

////代购或拼单model daigou
@property (nonatomic , retain )ProductInfoSubjectsDaiGouViewModel *daigouModel;

////历史价格数组 包含时间和价格
@property (nonatomic, strong) NSArray *historyPrice;

////是否已经关注该爆料
@property (nonatomic, strong) NSString *is_attention;


+ (ProductInfoSubjectsViewModel *)viewModelWithSubject:(NSDictionary *)subject;
+ (ProductInfoSubjectsViewModel *)viewModelInitializeWithSubject:(id)subject;

@end
