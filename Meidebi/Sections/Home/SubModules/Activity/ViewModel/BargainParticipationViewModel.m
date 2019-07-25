//
//  BargainParticipationViewModel.m
//  Meidebi
//
//  Created by mdb-admin on 2017/10/19.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "BargainParticipationViewModel.h"

@implementation BargainParticipationViewModel

+ (instancetype)viewModelWithSubject:(NSDictionary *)subject{
    if (![subject isKindOfClass:[NSDictionary class]]) return nil;
    BargainParticipationViewModel *model = [BargainParticipationViewModel new];
    [model viewModelWithSubject:subject];
    return model;
}

- (void)viewModelWithSubject:(NSDictionary *)subject{
    _itemID = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"id"]]];
    _commodityID = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"commodity"]]];
    _title = [NSString nullToString:subject[@"title"]];
    _imageLink = [NSString nullToString:subject[@"cover"]];
    _number = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"number"] preset:@"0"]];
    _finish = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"finish"] preset:@"0"]];
    _required = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"required"] preset:@"0"]];
    _rank = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"rank"] preset:@"0"]];
}
@end
