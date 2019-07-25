//
//  JiangJiaZhiBoModel.h
//  Meidebi
//
//  Created by mdb-losaic on 2019/3/26.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JiangJiaZhiBoModel : NSObject

///最新价
@property (nonatomic,retain) NSString *activeprice;
@property (nonatomic,retain) NSString *did;

@property (nonatomic,retain) NSString *image;
///历史价
@property (nonatomic,retain) NSString *last_price;
////降价百分比
@property (nonatomic,retain) NSString *reduction;

@property (nonatomic,retain) NSString *title;
///0非好价 1历史最低价 2近期好价
@property (nonatomic,retain) NSString *lowpricetype;

///时间戳
@property (nonatomic,retain) NSString *createtime;

///商城
@property (nonatomic,retain) NSString *sitename;
///是否点击过
@property (nonatomic,assign) BOOL isSelected;

-(JiangJiaZhiBoModel*)initValue:(NSDictionary *)value;


@end

NS_ASSUME_NONNULL_END
