//
//  OriginalDetailViewModel.m
//  Meidebi
//
//  Created by mdb-admin on 2017/9/26.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "OriginalDetailViewModel.h"
#import "MDB_UserDefault.h"
@implementation OriginalDetailViewModel

+ (instancetype)viewModelWithSubject:(NSDictionary *)subject{
    OriginalDetailViewModel *viewModel = [[OriginalDetailViewModel alloc] init];
    if (!subject) return nil;
    [viewModel viewModelWithSubject:subject];
    return viewModel;
}

- (void)viewModelWithSubject:(NSDictionary *)subject{
    _comments = subject[@"comments"];
    _tags = subject[@"tags"];
    _rewardUsers = subject[@"reward"][@"users"];
    _mores = subject[@"more"];
    _originalID = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"id"]]];
    _title = [NSString nullToString:subject[@"title"]];
    _imageLink = [NSString nullToString:subject[@"iamge"]];
    _content = [NSString nullToString:subject[@"content"]];
    _reason = [NSString nullToString:subject[@"reason"]];
    NSDate *createdates=[NSDate dateWithTimeIntervalSince1970:[[NSString nullToString:subject[@"createtime"]] integerValue]];
    _createtime = [MDB_UserDefault strTimefromDatas:createdates dataFormat:nil];
    _rewardCount = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"reward"][@"count"]]];
    _bonus = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"bonus"]]];
    _remarkStar = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"star"]]];
    _likeCount = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"votesp"]]];
    _commentcount = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"commentcoount"]]];
    _browsecount = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"browsecount"]]];
    _praisecount = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"praisecount"]]];
    _disparagecount = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"disparagecount"]]];
    _favnum = [NSString stringWithFormat:@"%@",[[NSString nullToString:subject[@"fav_num"]] isEqualToString:@""]?@"0":[NSString nullToString:subject[@"fav_num"]]];
    _username = [NSString nullToString:subject[@"user"][@"username"]];
    _userId = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"user"][@"userid"]]];
    _userLevel = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"user"][@"level"]]];
    _avatarLink = [NSString nullToString:subject[@"user"][@"photo"]];
    _isFollow = [[NSString nullToString:subject[@"is_follow"]] integerValue] == 0? NO :YES;
    _isTimeout = [[NSString nullToString:subject[@"timeout"]] integerValue] == 0? NO :YES;
    _isfav = [[NSString nullToString:subject[@"is_fav"]] integerValue] == 0? NO :YES;
    NSString *classify = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"classify"]]];
    if ([@"1" isEqualToString:classify]) {
        _topicType = TKTopicTypeShaiDan;
    }else if ([@"2" isEqualToString:classify]) {
        _topicType = TKTopicTypeEnable;
    }else if ([@"3" isEqualToString:classify]) {
        _topicType = TKTopicTypeShoppingList;
    }else if ([@"4" isEqualToString:classify]) {
        _topicType = TKTopicTypeSpitslot;
    }else if ([@"5" isEqualToString:classify]) {
        _topicType = TKTopicTypeDaily;
    }else{
        _topicType = TKTopicTypeUnknown;
    }
}



@end
