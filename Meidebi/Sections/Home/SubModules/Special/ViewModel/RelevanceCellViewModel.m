//
//  RelevanceCellViewModel.m
//  Meidebi
//
//  Created by mdb-admin on 2017/5/25.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "RelevanceCellViewModel.h"
#import "MDB_UserDefault.h"

@interface RelevanceCellViewModel ()

@property (nonatomic, strong) NSString *likeNumber;
@property (nonatomic, assign) BOOL isLike;

@end

@implementation RelevanceCellViewModel

+ (instancetype)viewModelWithSubject:(NSDictionary *)subject{
    RelevanceCellViewModel *viewModel = [[RelevanceCellViewModel alloc] init];
    [viewModel viewModelWithSubjects:subject];
    return viewModel;
}

- (void)viewModelWithSubjects:(NSDictionary *)subject{
    _relevanceID = [NSString nullToString:subject[@"id"]];
    _iconImageLink = [NSString nullToString:subject[@"image"]];
    _title = [NSString nullToString:subject[@"title"]];
    _orginprice = [NSString stringWithFormat:@"￥%@",[NSString nullToString:subject[@"orginprice"]]];
    _activeprice = [NSString stringWithFormat:@"￥%@",[NSString nullToString:subject[@"activeprice"]]];
    if ([subject[@"createtime"] integerValue] > 0) {
        _publishTime = [NSString stringWithFormat:@"%@",[MDB_UserDefault CalDateIntervalFromData:[NSDate dateWithTimeIntervalSince1970:[subject[@"createtime"] integerValue]] endDate:[NSDate date]]];
    }
    _siteName = [NSString nullToString:subject[@"sitename"]];
    _linkurl = [NSString nullToString:subject[@"linkurl"]];
    _likeNumber = [NSString nullToString:subject[@"votesp"]];
    NSString *classify = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"classify"]]];
    if ([classify isEqualToString:@"2"]) {
        _type = RelevanceTypeRecommend;
        _height = IS_IPHONE_WIDE_SCREEN ? (kMainScreenW*.60) : (kMainScreenW*.63);
    }else{
        _type = RelevanceTypeNormal;
        _height = 122;
    }
    _isLike = NO;
}

- (void)updateLikeAmount{
    _likeNumber = [NSString stringWithFormat:@"%@",@([_likeNumber integerValue]+1)];
    _isLike = YES;
}
@end
