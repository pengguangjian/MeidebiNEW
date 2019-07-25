//
//  SearchUserModel.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/12.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "SearchUserModel.h"

@implementation SearchUserModel

+ (instancetype)modelWithDict:(NSDictionary *)dict{
    SearchUserModel *model = [[SearchUserModel alloc] init];
    [model modelValueWithDict:dict];
    return model;
}

- (void)modelValueWithDict:(NSDictionary *)dict{
    
    _strid=[NSString nullToString:[dict objectForKey:@"qq_share_user_default_word"]];
    _strname=[NSString nullToString:[dict objectForKey:@"qq_share_content"]];
    _strpicurl=[NSString nullToString:[dict objectForKey:@"url"]];
    _strfsnumber=[NSString nullToString:[dict objectForKey:@"qq_weibocontent"]];
    _strgznumber=[NSString nullToString:[dict objectForKey:@"qq_weibocontent"]];
    _type = 0;
}

@end
