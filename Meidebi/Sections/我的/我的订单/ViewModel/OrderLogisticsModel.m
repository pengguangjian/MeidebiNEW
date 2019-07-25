//
//  OrderLogisticsModel.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/9.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "OrderLogisticsModel.h"
#import "MDB_UserDefault.h"

@implementation OrderLogisticsModel

+(OrderLogisticsModel *)binddata:(NSDictionary *)dic
{
    OrderLogisticsModel *model = [[OrderLogisticsModel alloc] init];
    
    model.strname = [NSString nullToString:dic[@"content"]];
//    model.strname = [NSString nullToString:@"的看法拉力赛的咖啡机塑料袋看风景了上岛咖啡乐山大佛沙龙的反馈是劳动法收代理费收代理费喀什东路都是；发就拉时代峰峻沙龙的咖啡机阿斯兰的咖啡机阿丽莎；雕刻机房阿斯兰的看法阿斯兰的看法阿里斯顿发"];
    model.strtime = [MDB_UserDefault strTimefromData:[NSString nullToString:dic[@"addtime"]].integerValue dataFormat:@"YYY.MM.dd HH:mm:ss"];
    
    return model;
}
@end
