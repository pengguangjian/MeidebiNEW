//
//  SearchYuanChuangModel.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/12.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "SearchYuanChuangModel.h"

@implementation SearchYuanChuangModel

+ (instancetype)modelWithDict:(NSDictionary *)dict{
    SearchYuanChuangModel *model = [[SearchYuanChuangModel alloc] init];
    [model modelValueWithDict:dict];
    return model;
}

- (void)modelValueWithDict:(NSDictionary *)dict{
    
    _strid=[NSString nullToString:[dict objectForKey:@"id"]];
    _strcontent=[NSString nullToString:[dict objectForKey:@"content"]];
    _strpicurl=[NSString nullToString:[dict objectForKey:@"image"]];
    _strtitle=[NSString nullToString:[dict objectForKey:@"title"]];
}

@end
