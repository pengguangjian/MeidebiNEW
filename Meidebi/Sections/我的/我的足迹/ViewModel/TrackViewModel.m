//
//  TrackViewModel.m
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/8.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "TrackViewModel.h"
#import "MDB_UserDefault.h"
@implementation TrackViewModel

+ (instancetype)viewModelWithSubject:(NSDictionary *)subject{
    TrackViewModel *viewModel = [[TrackViewModel alloc] init];
    [viewModel viewModelWithSubjects:subject];
    return viewModel;
}

- (void)viewModelWithSubjects:(NSDictionary *)subject{
    _time = [NSString nullToString:subject[@"time"]];
    NSMutableArray *events = [NSMutableArray array];
    for (NSDictionary *dict in subject[@"event"]) {
        TrackEventModel *model = [TrackEventModel viewModelWithSubject:dict];
        if (model) {
            [events addObject:model];
        }
    }
    _events = events.mutableCopy;
}


@end

@implementation TrackEventModel

+ (instancetype)viewModelWithSubject:(NSDictionary *)subject{
    TrackEventModel *viewModel = [[TrackEventModel alloc] init];
    [viewModel viewModelWithSubjects:subject];
    return viewModel;
}

- (void)viewModelWithSubjects:(NSDictionary *)subject{
    _trackID = [NSString nullToString:subject[@"id"]];
    _iconImageLink = [NSString nullToString:subject[@"image"]];
    _title = [NSString nullToString:subject[@"title"]];
    _orginprice = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"price"]]];
    if ([subject[@"createtime"] integerValue] > 0) {
        _publishTime = [NSString stringWithFormat:@"%@",[MDB_UserDefault CalDateIntervalFromData:[NSDate dateWithTimeIntervalSince1970:[subject[@"createtime"] integerValue]] endDate:[NSDate date]]];
    }
    _siteName = [NSString nullToString:subject[@"shop_name"]];
    NSString *type = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"type"]]];
    switch (type.integerValue) {
        case 0:
            _type = TrackEventTypeBeginUse;
            _handle = @"开始使用没得比";
            break;
        case 1:
            _type = TrackEventTypeSigin;
            _handle = @"签到";
            break;
        case 2:
            _type = TrackEventTypeShowdan;
            _handle = @"发布了原创";
            break;
        case 3:
            _type = TrackEventTypeDiscount;
            _handle = @"发布了爆料";
            break;
        case 4:
            _type = TrackEventTypeDiscount;///TrackEventTypeWantBy
            _handle = @"看了";
            break;
        case 5:
            _type = TrackEventTypeShowdan;///TrackEventTypeHaveBy
            _handle = @"看了";
            break;
        default:
            _type = TrackEventTypeUnknown;
            _handle = @"看了";
            break;
    }
    
    if (_type == TrackEventTypeSigin ||
        _type == TrackEventTypeUnknown ||
        _type == TrackEventTypeBeginUse) {
        _height = 40.f;
    }else if (_type == TrackEventTypeShowdan){
        _height = 220.f;
    }else{
        _height = 135.f;
    }
    
    
}


@end
