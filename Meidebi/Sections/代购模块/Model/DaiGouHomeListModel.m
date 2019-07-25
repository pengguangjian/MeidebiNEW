//
//  DaiGouHomeListModel.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/17.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "DaiGouHomeListModel.h"
#import "MDB_UserDefault.h"
@implementation DaiGouHomeListModel
+ (instancetype)viewModelWithSubject:(NSDictionary *)subject
{
    if ([subject isKindOfClass:[NSNull class]]) return nil;
    DaiGouHomeListModel *model = [[DaiGouHomeListModel alloc] init];
    [model viewModelWithSubjects:subject];
    
    
    
    return model;
}
- (void)viewModelWithSubjects:(NSDictionary *)subject
{
     _dgID = [NSString nullToString:subject[@"id"]];
     _image = [NSString nullToString:subject[@"image"]];
     _name = [NSString nullToString:subject[@"name"]];
    _addtime =
    [MDB_UserDefault CalDateIntervalFromData:[NSDate dateWithTimeIntervalSince1970:[[NSString nullToString:subject[@"addtime"]] intValue]] endDate:[NSDate date]];
//    [MDB_UserDefault strTimefromData:[[NSString nullToString:subject[@"addtime"]] integerValue] dataFormat:@"yyyy-MM-dd HH:mm"];
     _istop = [NSString nullToString:subject[@"istop"]];
     _ishot = [NSString nullToString:subject[@"ishot"]];
    _share_id = [NSString nullToString:subject[@"share_id"]];
    _status = [NSString nullToString:subject[@"status"]];
    _isend = [NSString nullToString:subject[@"isend"]];
    
    _purchased_nums = [NSString nullToString:subject[@"purchased_nums"]];
    
    _isspiderorder =  [NSString nullToString:subject[@"isspiderorder"]];
    _isspotgoods = [NSString nullToString:subject[@"isspotgoods"]];
     _transfertype = [NSString nullToString:subject[@"transfertype"]];
    NSDictionary *dicgoods_message = subject[@"goods_message"];
    if(dicgoods_message==nil)
    {
        _title = [NSString nullToString:subject[@"title"]];
        _price = [NSString nullToString:subject[@"price"]];
    }
    else
    {
        _title = [NSString nullToString:dicgoods_message[@"title"]];
        _price = [NSString nullToString:dicgoods_message[@"price"]];
    }
    
    
    
}


//+ (instancetype)viewModelWithSubject1:(NSDictionary *)subject
//{
//    if ([subject isKindOfClass:[NSNull class]]) return nil;
//    DaiGouHomeListModel *model = [[DaiGouHomeListModel alloc] init];
//    [model viewModelWithSubjects1:subject];
//    
//    
//    
//    return model;
//}
//
//- (void)viewModelWithSubjects1:(NSDictionary *)subject
//{
//    _dgID = [NSString nullToString:subject[@"goods_id"]];
//    _image = [NSString nullToString:subject[@"image"]];
//    _name = [NSString nullToString:subject[@"name"]];
////    _addtime =
////    [MDB_UserDefault CalDateIntervalFromData:[NSDate dateWithTimeIntervalSince1970:[[NSString nullToString:subject[@"addtime"]] intValue]] endDate:[NSDate date]];
//    //    [MDB_UserDefault strTimefromData:[[NSString nullToString:subject[@"addtime"]] integerValue] dataFormat:@"yyyy-MM-dd HH:mm"];
//    _istop = [NSString nullToString:subject[@"istop"]];
//    _ishot = [NSString nullToString:subject[@"ishot"]];
//    _share_id = [NSString nullToString:subject[@"share_id"]];
//    _status = [NSString nullToString:subject[@"status"]];
//    _isend = [NSString nullToString:subject[@"isend"]];
//    
//    _transfertype = [NSString nullToString:subject[@"transfertype"]];
//    NSDictionary *dicgoods_message = subject[@"goods_message"];
//    if(dicgoods_message==nil)
//    {
//        _title = [NSString nullToString:subject[@"title"]];
//        _price = [NSString nullToString:subject[@"price"]];
//    }
//    else
//    {
//        _title = [NSString nullToString:dicgoods_message[@"title"]];
//        _price = [NSString nullToString:dicgoods_message[@"price"]];
//    }
//    
//    
//    
//}


@end
