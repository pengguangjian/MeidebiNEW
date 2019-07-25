//
//  JiangJiaTongZhiModel.h
//  Meidebi
//
//  Created by mdb-losaic on 2019/3/20.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JiangJiaTongZhiModel : NSObject

@property(nonatomic,strong)NSString *did;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *image;
@property(nonatomic,strong)NSString *price;
@property (nonatomic, strong) NSString *statue;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *coinsign;
///0非好价 1历史最低价 2近期好价
@property (nonatomic, strong) NSString *lowpricetype;

@property (nonatomic, strong) NSString *linktype;

@property (nonatomic, strong) NSString *agttype;
///是否取消了关注
@property (nonatomic, assign) BOOL iscancle;

-(id)initWithdic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
