//
//  OrderLogisticsModel.h
//  Meidebi
//  物流model
//  Created by mdb-losaic on 2018/4/9.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderLogisticsModel : NSObject


@property (nonatomic , retain) NSString *strid;

@property (nonatomic , retain) NSString *strname;

@property (nonatomic , retain) NSString *strtime;

+(OrderLogisticsModel *)binddata:(NSDictionary *)dic;

@end
