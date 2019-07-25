//
//  HomeViewModel.m
//  Meidebi
//
//  Created by mdb-admin on 2017/5/31.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "HomeViewModel.h"
#import <MJExtension/MJExtension.h>

@implementation HomeActivitieViewModel
+ (instancetype)viewModelWithSubject:(NSDictionary *)subject{
    if ([subject isKindOfClass:[NSNull class]]) return nil;
    HomeActivitieViewModel *viewModel = [[HomeActivitieViewModel alloc] init];
    [viewModel viewModelWithSubjects:subject];
    return viewModel;
}
- (void)viewModelWithSubjects:(NSDictionary *)subject{
    _activityID = [NSString nullToString:subject[@"id"]];
    _title = [NSString nullToString:subject[@"title"]];
    _imageLink = [NSString nullToString:subject[@"image"]];
    _hasreward = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"hasreward"]]];
    _totaluser = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"totaluser"]]];
    NSMutableArray *usersMutable = [NSMutableArray array];
    for (NSDictionary *dict in subject[@"users"]) {
        HomeUserViewModel *model = [HomeUserViewModel viewModelWithSubject:dict];
        if (model) {
            [usersMutable addObject:model];
        }
    }
    _users = usersMutable.mutableCopy;
    NSString *type = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"acttype"]]];
    if ([type isEqualToString:@"1"]) {
        _activityType = ActivityTypeNormal;
    }else if ([type isEqualToString:@"2"]){
        _activityType = ActivityTypeAccumulate;
    }else if ([type isEqualToString:@"3"]){
        _activityType = ActivityTypeBargain;
    }
    NSString *state = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"state"]]];
    if ([@"0" isEqualToString:state]) {
        _status = ActivityStateTypeNoBegin;
    }else if ([@"-1" isEqualToString:state]){
        _status = ActivityStateTypeEnd;
    }else if ([@"1" isEqualToString:state]){
        _status = ActivityStateTypeIng;
    }
}

@end

@implementation HomeUserViewModel

+ (instancetype)viewModelWithSubject:(NSDictionary *)subject{
    HomeUserViewModel *viewModel = [[HomeUserViewModel alloc] init];
    [viewModel viewModelWithSubjects:subject];
    return viewModel;
    
}
- (void)viewModelWithSubjects:(NSDictionary *)subject{
    _avatar = [NSString nullToString:subject[@"avatar"]];
    _username = [NSString nullToString:subject[@"username"]];
}
@end

@implementation HomeHotSticksViewModel

+ (instancetype)viewModelWithSubject:(NSDictionary *)subject{
    HomeHotSticksViewModel *viewModel = [[HomeHotSticksViewModel alloc] init];
    [viewModel viewModelWithSubjects:subject];
    return viewModel;
}

- (void)viewModelWithSubjects:(NSDictionary *)subject{
    _stickID = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"id"]]];
    _title = [NSString nullToString:subject[@"title"]];
    _link = [NSString nullToString:subject[@"link"]];
    _linkType = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"linkType"]]];
    _linkId = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"linkId"]]];
}

@end

@implementation HomeCheapViewModel

+ (instancetype)viewModelWithSubject:(NSDictionary *)subject{
    HomeCheapViewModel *viewModel = [[HomeCheapViewModel alloc] init];
    [viewModel viewModelWithSubjects:subject];
    return viewModel;
}

- (void)viewModelWithSubjects:(NSDictionary *)subject{
    _commodityID = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"id"]]];
    _title = [NSString nullToString:subject[@"title"]];
    _imageLink = [NSString nullToString:subject[@"image"]];
    _info = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"info"]]];
    _brand = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"brand"]]];
}
@end

@implementation HomeDaiGouViewModel

+ (instancetype)viewModelWithSubject:(NSDictionary *)subject{
    HomeDaiGouViewModel *viewModel = [[HomeDaiGouViewModel alloc] init];
    [viewModel viewModelWithSubjects:subject];
    return viewModel;
}

- (void)viewModelWithSubjects:(NSDictionary *)subject{
    _pintuanID = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"id"]]];
    _goodsID = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"goods_id"]]];
    _imageLink = [NSString nullToString:subject[@"image"]];
//    _pindanusers = subject[@"pindanusers"];
    
    
//    NSDictionary *dic = [subject objectForKey:@"goods_message"];
    
    _purchased_nums = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"purchased_nums"]]];
    _title = [NSString nullToString:subject[@"title"]];
    _price = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"price"]]];
    _pindannum = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"pindannum"]]];
    _share_id = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"share_id"]]];
}
@end

@implementation HomeViewModel

+ (instancetype)viewModelWithSubject:(NSDictionary *)subject{
    HomeViewModel *viewModel = [[HomeViewModel alloc] init];
    [viewModel viewModelWithSubjects:subject];
    return viewModel;
}

- (void)viewModelWithSubjects:(NSDictionary *)subject{
    if ([subject[@"activities"] isKindOfClass:[NSArray class]]) {
        NSMutableArray *activitiesMutable = [NSMutableArray array];
        for (NSDictionary *dict in subject[@"activities"]) {
            HomeActivitieViewModel *model = [HomeActivitieViewModel viewModelWithSubject:dict];
            if (model) {
                [activitiesMutable addObject:model];
            }
        }
        _activities = activitiesMutable.mutableCopy;
    }
    if ([subject[@"shares"] isKindOfClass:[NSArray class]]) {
        NSMutableArray *sharesMutable = [NSMutableArray array];
        for (NSDictionary *dict in subject[@"shares"]) {
            Commodity *aCommodity = [Commodity mj_objectWithKeyValues:dict];
            if (aCommodity) {
                [sharesMutable addObject:aCommodity];
            }
        }
        _shares = sharesMutable.mutableCopy;
    }
    
    if([subject[@"specials"] isKindOfClass:[NSArray class]]){
        NSMutableArray *homeSpecialMutable = [NSMutableArray array];
        for (NSDictionary *dict in subject[@"specials"]) {
            SpecialViewModel *model = [SpecialViewModel viewModelWithSubject:dict];
            if (model) {
                [homeSpecialMutable addObject:model];
            }
        }
        _homeSpecials = homeSpecialMutable.mutableCopy;
    }
    
    if ([subject[@"slides"] isKindOfClass:[NSArray class]]) {
        NSMutableArray *hotStickMutable = [NSMutableArray array];
        for (NSDictionary *dict in subject[@"slides"]) {
            HomeHotSticksViewModel *model = [HomeHotSticksViewModel viewModelWithSubject:dict];
            if (model) {
                [hotStickMutable addObject:model];
            }
        }
        _hotSticks = hotStickMutable.mutableCopy;
    }

    if ([subject[@"cheap"] isKindOfClass:[NSArray class]]) {
        NSMutableArray *cheapMutable = [NSMutableArray array];
        for (NSDictionary *dict in subject[@"cheap"]) {
            HomeCheapViewModel *model = [HomeCheapViewModel viewModelWithSubject:dict];
            if (model) {
                [cheapMutable addObject:model];
            }
        }
        _cheaps = cheapMutable.mutableCopy;
    }
    
    if ([subject[@"helpshop"] isKindOfClass:[NSDictionary class]]) {
        NSMutableArray *cheapMutable = [NSMutableArray array];
        HomeDaiGouViewModel *model = [HomeDaiGouViewModel viewModelWithSubject:subject[@"helpshop"]];
        if (model) {
            [cheapMutable addObject:model];
        }
        _helpshop = cheapMutable.mutableCopy;
    }
}
@end
