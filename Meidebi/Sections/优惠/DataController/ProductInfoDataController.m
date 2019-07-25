//
//  ProductInfoDataController.m
//  Meidebi
//
//  Created by mdb-admin on 16/4/28.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "ProductInfoDataController.h"
#import "MDB_UserDefault.h"
#import "Qqshare.h"
#import "HTTPManager.h"



@interface ProductInfoDataController ()

@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, strong) Qqshare *resultShareInfo;
@property (nonatomic, assign) BOOL isSuccessZan;
@property (nonatomic, assign) BOOL isSuccessShou;
@property (nonatomic, assign) BOOL resportStatue;

@end

@implementation ProductInfoDataController

- (void)requestSubjectDataWithInView:(UIView *)view
                         commodityid:(NSString *)commodityid
                            callback:(completeCallback)Callback{
    
    NSDictionary *dicURL;
    if ([MDB_UserDefault getIsLogin]) {
        dicURL=@{@"id":[NSString nullToString:commodityid],
                 @"type":@"2",
                 @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                 @"channel":@"appstore"
                 };
    }else{
        dicURL=@{@"id":[NSString nullToString:commodityid],
                 @"type":@"2",
                 @"channel":@"appstore"
                 };
    }
    //URL_onelink
    [HTTPManager sendRequestUrlToService:URL_DiscountUrl withParametersDictionry:dicURL view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        NSString *describle = @"";
        BOOL state = NO;
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dictResult=[str JSONValue];
            NSInteger status = [dictResult[@"status"] integerValue];
            describle = dictResult[@"info"];
            if (status == 1) {
                if ([dictResult objectForKey:@"data"]) {
                    _dict = dictResult[@"data"];
                    [self requestShareSubjectDataWithCommodityid:[NSString stringWithFormat:@"%@",_dict[@"share"][@"id"]] inView:nil callback:nil];
                    state = YES;
                }
            }
        }
        Callback(error,state,describle);
    }];

}


- (void)requestShareSubjectDataWithCommodityid:(NSString *)commodityid inView:(UIView *)view callback:(completeCallback)callback{
    
    NSDictionary *parameter = @{@"id":[NSString nullToString:commodityid],
                                @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [HTTPManager sendGETRequestUrlToService:URL_getshare withParametersDictionry:parameter view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        NSString *describle = @"";
        BOOL state = NO;
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dictr=[str JSONValue];
            NSString* info = [NSString stringWithFormat:@"%@",[dictr objectForKey:@"info"]];
            describle = info;
            if (info && [info isEqualToString:@"GET_DATA_SUCCESS"]) {
                if ([dictr objectForKey:@"data"]&&[[dictr objectForKey:@"data"]isKindOfClass:[NSDictionary class]]) {
                    _resultShareInfo = [[Qqshare alloc] initWithdic:dictr[@"data"]];
                    
                    if([[MDB_UserDefault defaultInstance] imagediskImageExistsForURL:_resultShareInfo.image])
                    {
                        
                    }
                    else
                    {
                        UIImage *images = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_resultShareInfo.image]]];
                        [[MDB_UserDefault defaultInstance] setSaveImageToCache:images forURL:[NSURL URLWithString:_resultShareInfo.image]];
                    }
                    
                    state = YES;
                }
            }
        }
        if (callback) {
            callback(error,state,describle);
        }
    }];

}

- (void)requestByInfoSubjectDataWithCommodityid:(NSString *)commodityid
                                           type:(NSString *)type
                                         inView:(UIView *)view
                                       callback:(completeCallback)callback{

    NSDictionary *parameter = @{@"id":[NSString nullToString:commodityid],
                                @"type":[NSString nullToString:type],
                                @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [HTTPManager sendGETRequestUrlToService:URL_Buyinfo withParametersDictionry:parameter view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        NSString *describle = @"网络错误！";
        BOOL state = NO;
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dictResult=[str JSONValue];
            NSInteger status = [dictResult[@"status"] integerValue];
            describle = dictResult[@"info"];
            if (status == 1) {
                if ([dictResult objectForKey:@"data"]) {
                    _dict = dictResult[@"data"];
                    state = YES;
                }
            }
        }
        callback(error,state,describle);
    }];

}

- (void)requestShareRecordDataWithUrl:(NSString *)url
                             callback:(completeCallback)callback{
    NSDictionary *parameter = @{@"url":[NSString nullToString:url],
                                @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [HTTPManager sendGETRequestUrlToService:URL_shareRecord withParametersDictionry:parameter view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        NSString *describle = @"网络错误！";
        BOOL state = NO;
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dictResult=[str JSONValue];
            NSInteger status = [dictResult[@"status"] integerValue];
            describle = dictResult[@"info"];
            if (status == 1) {
                if ([dictResult objectForKey:@"data"]) {
                    _dict = dictResult[@"data"];
                    state = YES;
                }
            }
        }
        callback(error,state,describle);
    }];
}

- (void)requestZanDataWithInView:(UIView *)view
                     Commodityid:(NSString *)commodityid
                        callback:(completeCallback)callback{
    NSString *userkey=[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken];
    NSDictionary *dicURL=@{@"id":commodityid,
                           @"votes":@"1",
                           @"userid":userkey,
                           @"type":@"1"};
    [HTTPManager sendRequestUrlToService:URL_prace withParametersDictionry:dicURL view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        NSString *describle = @"";
        BOOL state = NO;
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dic=[str JSONValue];
            if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]] isEqualToString:@"VOTES_SUCCESS"]&&[[dic objectForKey:@"status"] integerValue] == 1) {
                _isSuccessZan = YES;
                [MDB_UserDefault showNotifyHUDwithtext:@"投票成功" inView:view];
            }else if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]] isEqualToString:@"YOUR_ARE_VOTEED"]){
                _isSuccessZan = NO;
                [MDB_UserDefault showNotifyHUDwithtext:@"你已经投过票了" inView:view];
            }
            state = YES;
            describle = dic[@"info"];
        }
        callback(error,state,describle);
    }];

}

- (void)requestShouDataWithInView:(UIView *)view
                      Commodityid:(NSString *)commodityid
                         linkType:(NSString *)linkType
                         callback:(completeCallback)callback{
    NSDictionary *dicURL=@{@"id":commodityid,
                           @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                           @"fetype":linkType};
    [HTTPManager sendRequestUrlToService:URL_favorite withParametersDictionry:dicURL view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        NSString *describle = @"";
        BOOL state = NO;
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dic=[str JSONValue];
            if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]] isEqualToString:@"GET_DATA_SUCCESS"]&&[[dic objectForKey:@"status"] integerValue]) {
                if ([[dic objectForKey:@"data"]isKindOfClass:[NSString class]]) {
                    if ([[dic objectForKey:@"data"]isEqualToString:@"取消收藏成功！"]) {
                        _isSuccessShou = NO;
                    }else{
                        _isSuccessShou = YES;
                    }
                }
            }else if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]] isEqualToString:@"YOUR_ARE_VOTEED"]){
            }
            state = YES;
            describle = dic[@"info"];
        }
        callback(error,state,describle);
    }];
}

- (void)requestResportDataWithInView:(UIView *)view
                           productid:(NSString *)productid
                            callback:(completeCallback)callback{
    
    NSDictionary *parmaters = @{@"id":[NSString nullToString:productid],
                                @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                                @"feedback":@""};
    [HTTPManager sendRequestUrlToService:URL_report withParametersDictionry:parmaters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        NSString *describle = @"";
        BOOL state = NO;
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dictr=[str JSONValue];
            if ([[NSString nullToString:dictr[@"status"]] intValue] == 1) {
                _resportStatue = YES;
                state = YES;
            }else{
                describle = dictr[@"info"];
                [MDB_UserDefault showNotifyHUDwithtext:[NSString nullToString:dictr[@"info"]] inView:view];
            }
        }else{
            describle = @"操作失败";
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:view];
        }
        callback(error,state,describle);
    }];

}



- (void)requestAddFollwDataWithInView:(UIView *)view
                               userid:(NSString *)userid
                             callback:(completeCallback)callback{
    NSDictionary *parmaters = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                                @"userid":[NSString nullToString:userid]};
    [HTTPManager sendRequestUrlToService:URL_AddFollow withParametersDictionry:parmaters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        NSString *describle = @"";
        BOOL state = NO;
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dictResult=[str JSONValue];
            NSInteger status = [dictResult[@"status"] integerValue];
            describle = dictResult[@"info"];
            if (status == 1) {
                if ([dictResult objectForKey:@"data"]) {
                    _dict = dictResult[@"data"];
                    state = YES;
                }
            }
        }
        callback(error,state,describle);
    }];
}

// DaiGouXiaDanDataController
- (void)requestDGHomeDataInView:(UIView *)view
                        dicpush:(NSDictionary *)dicpush
                       Callback:(completeCallback)callback
{
    [HTTPManager sendGETRequestUrlToService:DaiGouXiaDanViewUrl withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                NSDictionary *dict=[dicAll objectForKey:@"data"];
                if (dict) {
                    _dicValue = dict;
                    state = YES;
                }
            }
        }
        callback(error,state,describle);
    }];
}

///举报
-(void)requestJuBaoHomeDataInView:(UIView *)view
                          dicpush:(NSDictionary *)dicpush
                         Callback:(completeCallback)callback
{
    
    [HTTPManager sendRequestUrlToService:BaoLiaoJuBaoViewUrl withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                NSDictionary *dict=[dicAll objectForKey:@"data"];
                if (dict) {
                    state = YES;
                }
            }
        }
        callback(error,state,describle);
    }];
}

///求开团s
-(void)requestQiukaiTuanHomeDataInView:(UIView *)view
                               dicpush:(NSDictionary *)dicpush
                              Callback:(completeCallback)callback
{
    
    [HTTPManager sendRequestUrlToService:BaoLiaodaigouwishViewUrl withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                state = YES;
            }
        }
        callback(error,state,describle);
    }];
    
}
///加入购物车
- (void)requestAddBuCarDataLine:(NSDictionary *)dicpush
                       Callback:(completeCallback)callback
{
    
    [HTTPManager sendRequestUrlToService:MainDaiGouHomeAddByCarUrl withParametersDictionry:dicpush view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([NSString nullToString:dicAll[@"status"]].intValue == 1) {
                state = YES;
            }
            
        }
        callback(error,state,describle);
    }];
    
}


// 关注爆料商品
- (void)requestguanzhushangpingDataWithInView:(UIView *)view
                                        value:(NSDictionary *)dicpush
                                     callback:(completeCallback)callback
{
    [HTTPManager sendRequestUrlToService:URL_AddFollow_link withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        NSString *describle = @"";
        BOOL state = NO;
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dictResult=[str JSONValue];
            NSInteger status = [dictResult[@"status"] integerValue];
            describle = [NSString nullToString:dictResult[@"info"]];
            if (status == 1) {
                state = YES;
            }
        }
        callback(error,state,describle);
    }];
    
}

/// 求开团获取同款商品
- (void)requestgQiuKiaTuanItemsDataWithInView:(UIView *)view
                                        value:(NSDictionary *)dicpush
                                     callback:(completeCallback)callback
{
    
    [HTTPManager sendGETRequestUrlToService:QiuKaiYuanItemsViewUrl withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                NSArray *dict=[dicAll objectForKey:@"data"];
                if (dict) {
                    _qiukaituanValue = dict;
                    state = YES;
                }
            }
        }
        callback(error,state,describle);
    }];
}

#pragma mark - getters and setters
- (NSDictionary *)resultDict{
    return _dict? : @{};
}




@end
