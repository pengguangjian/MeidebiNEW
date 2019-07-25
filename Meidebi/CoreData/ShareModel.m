//
//  ShareModel.m
//  Meidebi
//
//  Created by mdb-admin on 2017/10/13.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "ShareModel.h"

@implementation ShareModel

+ (instancetype)modelWithDict:(NSDictionary *)dict{
    ShareModel *model = [[ShareModel alloc] init];
    [model modelValueWithDict:dict];
    return model;
}

- (void)modelValueWithDict:(NSDictionary *)dict{

    _defaultWord=[NSString nullToString:[dict objectForKey:@"qq_share_user_default_word"]];
    _content=[NSString nullToString:[dict objectForKey:@"qq_share_content"]];
    _title=[NSString nullToString:[dict objectForKey:@"qq_share_title"]];
    _url=[NSString nullToString:[dict objectForKey:@"url"]];
    _qq_weibocontent=[NSString nullToString:[dict objectForKey:@"qq_weibocontent"]];
    _sina_weibocontent=[NSString nullToString:[dict objectForKey:@"sina_weibocontent"]];
    _shareImage=[NSString nullToString:[dict objectForKey:@"image"]];
}


@end
