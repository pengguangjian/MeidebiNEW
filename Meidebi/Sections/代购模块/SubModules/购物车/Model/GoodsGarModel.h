//
//  GoodsGarModel.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/8/29.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsGarModel : NSObject
///是否编辑
@property (nonatomic , assign)BOOL isEdit;
///是否过期
@property (nonatomic , assign)BOOL isendtime;
///是否在编辑状态选中
@property (nonatomic , assign)BOOL isEditSelect;
///是否选中
@property (nonatomic , assign)BOOL isSelect;

///直邮2
@property (nonatomic , retain)NSString *transfertype;

@property (nonatomic , retain) NSString *did;

@property (nonatomic , retain) NSString *daigoutype;

@property (nonatomic , retain) NSString *goods_id;

@property (nonatomic , retain) NSString *image;

@property (nonatomic , retain) NSString *ischecked;

@property (nonatomic , retain) NSString *isend;

@property (nonatomic , retain) NSString *num;

@property (nonatomic , retain) NSString *onelimit;

@property (nonatomic , retain) NSString *pindannum;

@property (nonatomic , retain) NSString *price;

@property (nonatomic , retain) NSString *share_id;

@property (nonatomic , retain) NSString *siteid;

@property (nonatomic , retain) NSString *status;

@property (nonatomic , retain) NSString *title;

@property (nonatomic , retain) NSString *userid;

@property (nonatomic , retain) NSString *weight;

@property (nonatomic , retain) NSMutableArray *arrincidentals;

@property (nonatomic , retain) NSString *spec_val;

/////现货
@property (nonatomic, strong) NSString *isspotgoods;

+(GoodsGarModel *)viewModelDic:(NSDictionary *)dic;

@end

@interface GoodsGarincidentalsModel : NSObject

@property (nonatomic , retain) NSString *count;
///关税(限转运)
@property (nonatomic , retain) NSString *tariff;
///转运费（限转运）
@property (nonatomic , retain) NSString *transfermoney;
///国外本土运费（限转运）
@property (nonatomic , retain) NSString *hpostage;
///直邮运费（限直邮）
@property (nonatomic , retain) NSString *directmailmoney;

+(GoodsGarincidentalsModel *)viewModelDic:(NSDictionary *)dic;

@end
