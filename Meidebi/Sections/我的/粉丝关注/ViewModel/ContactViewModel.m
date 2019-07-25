//
//  ContactViewModel.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/20.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "ContactViewModel.h"

@implementation ContactViewModel
+ (instancetype)viewModelWithSubject:(NSDictionary *)subject{
    ContactViewModel *viewModel = [[ContactViewModel alloc] init];
    [viewModel viewModelWithSubject:subject];
    return viewModel;
}

- (void)viewModelWithSubject:(NSDictionary *)subject{
    _attentionID = [NSString nullToString:[NSString stringWithFormat:@"%@",subject[@"id"]]];
    _uID = [NSString nullToString:[NSString stringWithFormat:@"%@",subject[@"uid"]]];
    _avatarLink = [NSString nullToString:subject[@"avatar"]];
    _nickname = [NSString nullToString:subject[@"nickname"]];
    _starttime = [NSString nullToString:subject[@"follow_time"]];
    if ([_starttime isEqualToString:@""]) {
        _starttime = [NSString nullToString:subject[@"fans_time"]];
    }
    _standard = [NSString nullToString:@""];
    if ([[NSString nullToString:[NSString stringWithFormat:@"%@",subject[@"direction"]]] isEqualToString:@"3"]) {
        _isDirection = YES;
    }else{
        _isDirection = NO;
    }
    _isFollow = YES;
}

- (void)updateFollowStatus{
    _isFollow = !_isFollow;
}

- (void)updateDirectionStatus{
    _isDirection = !_isDirection;
}
@end
