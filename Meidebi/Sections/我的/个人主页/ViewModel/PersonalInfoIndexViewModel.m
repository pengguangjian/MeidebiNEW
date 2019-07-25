//
//  PersonalViewModel.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/20.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "PersonalInfoIndexViewModel.h"

@implementation PersonalInfoIndexViewModel

+ (instancetype)viewModelWithSubject:(NSDictionary *)subject{
    PersonalInfoIndexViewModel *viewModel = [[PersonalInfoIndexViewModel alloc] init];
    [viewModel viewModelWithSubject:subject];
    return viewModel;
}

- (void)viewModelWithSubject:(NSDictionary *)subject{
    _avatarLink = [NSString nullToString:subject[@"photo"]];
    _nickname = [NSString nullToString:subject[@"nickname"]];
    _totalLevel = [NSString nullToString:[NSString stringWithFormat:@"%@",subject[@"totallevel"]]];
    _followNum = [NSString stringWithFormat:@"关注 %@",[NSString nullToString:subject[@"follow_num"]]];
    _fansNum = [NSString stringWithFormat:@"粉丝 %@",[NSString nullToString:subject[@"fans_num"]]];
    _brokethenewsNum = [NSString nullToString:[NSString stringWithFormat:@"%@",subject[@"brokethenews_num"]]];
    _showdanNum = [NSString nullToString:[NSString stringWithFormat:@"%@",subject[@"showdan_num"]]];
    if ([[NSString nullToString:[NSString stringWithFormat:@"%@",subject[@"is_follow"]]] isEqualToString:@"1"]) {
        _isFollow = YES;
    }else{
        _isFollow = NO;
    }
}
@end
