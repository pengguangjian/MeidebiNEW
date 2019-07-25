//
//  BargainActivityViewModel.m
//  Meidebi
//
//  Created by mdb-admin on 2017/10/17.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "BargainActivityViewModel.h"
#import "MDB_UserDefault.h"
@implementation BargainActivityViewModel
+ (instancetype)viewModelWithSubject:(NSDictionary *)subject{
    if (![subject isKindOfClass:[NSDictionary class]]) return nil;
    BargainActivityViewModel *model = [BargainActivityViewModel new];
    [model viewModelWithSubject:subject];
    return model;
}

- (void)viewModelWithSubject:(NSDictionary *)subject{
    _comments = subject[@"comments"];
    subject = subject[@"activity"];
    _bargainActivityID = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"id"]]];
    _title = [NSString nullToString:subject[@"title"]];
    _imageLink = [NSString nullToString:subject[@"image"]];
    _content = [NSString nullToString:subject[@"content"]];
    _victoryway = [NSString nullToString:subject[@"victoryway"]];
    _explain = [NSString nullToString:subject[@"explain"]];
    _state = [NSString nullToString:subject[@"state"]];
    _isfav = [NSString nullToString:subject[@"isfav"]];
    _prizes = [NSString nullToString:subject[@"prizes"]];
    _starttime = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"starttime"]]];
    _endtime = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"endtime"]]];
    _createtime = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"createtime"]]];
    _timeout = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"timeout"]]];
    _commentcount = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"commentcount"]]];
    _browsecount = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"browsecount"]]];
    _praisecount = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"praisecount"]]];
    _disparagecount = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"disparagecount"]]];
    _favnum = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"favnum"]]];
    _username = [NSString nullToString:subject[@"user"][@"username"]];
    _userId = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"user"][@"id"]]];
    _avatarLink = [NSString nullToString:subject[@"user"][@"avatar"]];
    _activitytime = [NSString stringWithFormat:@"%@ 至 %@",[MDB_UserDefault strTimefromDatas:[NSDate dateWithTimeIntervalSince1970:[_starttime integerValue]] dataFormat:@"yyyy-MM-dd hh:mm"],[MDB_UserDefault strTimefromDatas:[NSDate dateWithTimeIntervalSince1970:[_endtime integerValue]] dataFormat:@"yyyy-MM-dd hh:mm"]];
    if ([subject[@"commodity"] isKindOfClass:[NSArray class]]) {
        NSMutableArray *commodityMutable = [NSMutableArray array];
        for (NSDictionary *dict in subject[@"commodity"]) {
            BargainItemViewModel *model = [BargainItemViewModel viewModelWithSubject:dict];
            if (model) {
                [commodityMutable addObject:model];
            }
        }
        _commoditys = commodityMutable.mutableCopy;
    }
}
@end

@implementation BargainItemViewModel

+ (instancetype)viewModelWithSubject:(NSDictionary *)subject{
    if (![subject isKindOfClass:[NSDictionary class]]) return nil;
    BargainItemViewModel *model = [BargainItemViewModel new];
    [model viewModelWithSubject:subject];
    return model;
}

- (void)viewModelWithSubject:(NSDictionary *)subject{
    _itemID = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"id"]]];
     _activityID = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"activity"]]];
     _commodityID = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"commodity"]]];
    _title = [NSString nullToString:subject[@"title"]];
    _imageLink = [NSString nullToString:subject[@"cover"]];
    NSDate *startdates=[NSDate dateWithTimeIntervalSince1970:[[NSString nullToString:subject[@"createtime"]] integerValue]];
    _createtime = [MDB_UserDefault CalDateIntervalFromData:startdates endDate:[NSDate date]];
    NSDate *enddates=[NSDate dateWithTimeIntervalSince1970:[[NSString nullToString:subject[@"updatetime"]] integerValue]];
    _updatetime = [MDB_UserDefault CalDateIntervalFromData:enddates endDate:[NSDate date]];
    _number = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"number"]]];
    _price = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"price"]]];
    _required = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"required"]]];
    _participants = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"participants"]]];
   
    
}
@end
