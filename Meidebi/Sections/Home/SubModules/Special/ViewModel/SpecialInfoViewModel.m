//
//  SpecialInfoViewModel.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/2.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "SpecialInfoViewModel.h"
#import "MDB_UserDefault.h"
@implementation SpecialInfoViewModel

+ (instancetype)viewModelWithSubject:(NSDictionary *)subject{
    SpecialInfoViewModel *viewModel = [[SpecialInfoViewModel alloc] init];
    [viewModel viewModelWithSubject:subject];
    return viewModel;
}

- (void)viewModelWithSubject:(NSDictionary *)subject{
    _comments = subject[@"comments"];
    subject = subject[@"special"];
    _specialID = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"id"]]];
    _title = [NSString nullToString:subject[@"title"]];
    _type = [NSString nullToString:subject[@"type"]];
    _imageLink = [NSString nullToString:subject[@"image"]];
    _content = [NSString nullToString:subject[@"content"]];
    NSDate *startdates=[NSDate dateWithTimeIntervalSince1970:[[NSString nullToString:subject[@"starttime"]] integerValue]];
    _starttime = [MDB_UserDefault CalDateIntervalFromData:startdates endDate:[NSDate date]];
    NSDate *enddates=[NSDate dateWithTimeIntervalSince1970:[[NSString nullToString:subject[@"endtime"]] integerValue]];
    _endtime = [MDB_UserDefault CalDateIntervalFromData:enddates endDate:[NSDate date]];
    NSDate *createdates=[NSDate dateWithTimeIntervalSince1970:[[NSString nullToString:subject[@"createtime"]] integerValue]];
    _createtime = [MDB_UserDefault CalDateIntervalFromData:createdates endDate:[NSDate date]];
    _commentcount = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"commentcount"]]];
    _browsecount = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"browsecount"]]];
    _praisecount = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"praisecount"]]];
    _disparagecount = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"disparagecount"]]];
    _favnum = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"favnum"]]];
    _username = [NSString nullToString:subject[@"user"][@"username"]];
    _userId = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"user"][@"id"]]];
    _avatarLink = [NSString nullToString:subject[@"user"][@"avatar"]];
    _isFollow = [[NSString nullToString:subject[@"user"][@"is_folllow"]] integerValue] == 0? NO :YES;
    _isTimeout = [[NSString nullToString:subject[@"timeout"]] integerValue] == 0? NO :YES;
    _isfav = [[NSString nullToString:subject[@"isfav"]] integerValue] == 0? NO :YES;
}

@end
