//
//  WoGuanZhuShopAndBiaoModel.h
//  Meidebi
//  标签和商城model
//  Created by mdb-losaic on 2019/4/1.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WoGuanZhuShopAndBiaoModel : NSObject
@property(nonatomic,strong)NSString *logo1;
@property(nonatomic,strong)NSString *sitesigndes;
@property(nonatomic,strong)NSString *did;
@property (nonatomic, strong) NSString *name;
///用于查询的拼音表达式
@property (nonatomic, strong) NSString *seourl;
///是否取消了关注
@property (nonatomic, assign) BOOL iscancle;

-(id)initWithdic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
