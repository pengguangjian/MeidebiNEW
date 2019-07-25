
//  WareDataController.m
//  Meidebi
//
//  Created by mdb-admin on 16/5/30.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "WareDataController.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"
#import "Article.h"
#import "FMDBHelper.h"
typedef NS_ENUM(NSInteger, DragDirection) {
    DragDirectionUp,
    DragDirectionDown
};
@interface WareDataController ()

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSString *cats;
@property (nonatomic, strong) NSString *siteid;
@property (nonatomic, assign) WareRequestType requstType;
@property (nonatomic, assign) WareType wareType;
@property (nonatomic, assign) WaresTableVcType tableType;
@property (nonatomic, strong) UIView *targetView;
@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic, strong) NSArray *requestBannerResults;
@end

@implementation WareDataController

- (instancetype)init{
    self = [super init];
    if (self) {
        _page = 1;
        _requestBannerResults=[MDB_UserDefault getActive];
    }
    return self;
}

- (void)requestSubjectDataWithType:(WareRequestType)type
                  WaresTableVcType:(WaresTableVcType)tableType
                          wareType:(WareType)wareType
                              cats:(NSString *)cats
                            siteid:(NSString *)siteid
                            InView:(UIView *)view
                          callback:(completeCallback)Callback{
    
    _requstType = type;
    _wareType = wareType;
    _targetView = view;
    _tableType = tableType;
    _cats = cats;
    _siteid = siteid;
    [self loadDataWithDirection:DragDirectionDown callback:Callback];
}

- (void)lastNewPageDataWithCallback:(completeCallback)callback{
    _page = 1;
    [self loadDataWithDirection:DragDirectionDown callback:callback];
}

- (void)nextPageDataWithCallback:(completeCallback)callback{
    _page += 1;
    [self loadDataWithDirection:DragDirectionUp callback:callback];
}

- (void)loadDataWithDirection:(DragDirection)direction callback:(completeCallback)callback{
    
    NSString *url = URL_allhotlist;
    
    if (_requstType == WareRequestTypeNew) {
        url = URL_alllist;
    }

//    NSString *url = URL_baicaidirect;
//    if (_requstType == RequestTypeHaitao) {
//        url = URL_haitaodirect;
    
    NSString *type = @"";
    if (_wareType == WareTypeHaiTao) {
        type = @"hai";
    }else if (_wareType == WareTypeGuoNei){
        type = @"guo";
    }else if (_wareType == WareTypeTianMao){
        type = @"tian";
    }
    

    NSMutableDictionary *dics=[@{@"p":[NSString stringWithFormat:@"%@",@(_page)],
                         @"limit":@"20",
                         @"type":type} mutableCopy];
    [dics setObject:[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken] forKey:@"userkey"];
    if (_cats) {
        [dics setValue:_cats forKey:@"cats"];
    }
    if (_siteid) {
        [dics setValue:_siteid forKey:@"siteid"];
    }
    
    [HTTPManager sendGETRequestUrlToService:url withParametersDictionry:[dics mutableCopy] view:_targetView completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
            callback(error,state,describle);
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                NSDictionary *dicdata = [dicAll objectForKey:@"data"];
                _followed = [NSString nullToString:[[dicdata objectForKey:@"site"] objectForKey:@"followed"]];
                _did = [NSString nullToString:[[dicdata objectForKey:@"site"] objectForKey:@"id"]];
                NSArray *subjects = [dicdata objectForKey:@"linklist"];
                if(![[dicdata objectForKey:@"linklist"] isKindOfClass:[NSArray class]])
                {
                    state = NO;
                    describle = @"未查到相关数据";
                    callback(nil,state,describle);
                    return;
                }
                
                if ([subjects isKindOfClass:[NSDictionary class]] || [subjects isKindOfClass:[NSString class]] || [subjects isKindOfClass:[NSNull class]]){
                    describle = @"未查到相关数据";
                    callback(nil,state,describle);
                    return;
                };
                state = YES;
                if (direction == DragDirectionDown) {
                    NSMutableArray *articles = [NSMutableArray array];
                    for (NSDictionary *dict in subjects) {
                        Article *article = [[Article alloc] initWithDictionary:dict];
                        [articles addObject:article];
                    }
                    self.results=[[NSArray arrayWithArray:articles] mutableCopy];
                    
                }else{
                    NSMutableArray *articles = [NSMutableArray array];
                    for (NSDictionary *dict in subjects) {
                        Article *article = [[Article alloc] initWithDictionary:dict];
                        [articles addObject:article];
                    }
                    NSMutableArray *muta=[[NSMutableArray alloc]initWithArray:self.results];
                    
                    for (Article *artCle in articles) {
                        BOOL statue = YES;
                        for (Article *artCles in self.results) {
                            if (artCle.artid.integerValue == artCles.artid.integerValue) {
                                statue = NO;
                                break;
                            }
                        }
                        if (statue) {
                            [muta addObject:artCle];
                        }
                    }

                    self.results=[[NSArray arrayWithArray:muta] mutableCopy];
                }
                
                if (_tableType != WaresTableVcSearch) {
                    [[FMDBHelper shareInstance] saveWithTabeleName:articleTableName objects:str type:[type isEqualToString:@""]?@"all":type];
                }
                callback(nil,state,describle);
            }else{
                callback(error,state,describle);
            }
        }
    }];
}


- (void)requestBannerDataWithCallback:(completeCallback)callback{
    
    [HTTPManager sendRequestUrlToService:URL_showactive withParametersDictionry:nil view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
            _requestBannerResults=[MDB_UserDefault getActive];
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                NSArray *arr=[dicAll objectForKey:@"data"];
                if (arr&&arr.count>0) {
                    _requestBannerResults = arr;
                    [MDB_UserDefault setActive:arr];
                    state = YES;
                }
            }
        }
        callback(error,state,describle);
    }];

}

- (void)requestCacheWithCallback:(completeCallback)callback{
    NSError *error;

    NSString *type = @"all";
    if (_wareType == WareTypeHaiTao) {
        type = @"hai";
    }else if (_wareType == WareTypeGuoNei){
        type = @"guo";
    }else if (_wareType == WareTypeTianMao){
        type = @"tian";
    }
    
    NSArray *arrData = [[FMDBHelper shareInstance] findObjectWithTabeleName:@"article" format:type];
    if (arrData.count==0) {
        callback(error,NO,@"");
    }else{
        NSMutableArray *articles = [NSMutableArray array];
        for (NSString *articleStr in arrData) {
            NSDictionary *dict=[articleStr JSONValue];
            NSArray * datas = [[dict objectForKey:@"data"] objectForKey:@"linklist"];
            for (NSDictionary *articleDict in datas) {
                Article *article = [[Article alloc] initWithDictionary:articleDict];
                [articles addObject:article];
            }
        }
        self.results = [articles mutableCopy];
        callback(nil,YES,@"");
    }

}

- (NSMutableArray *)results{
    if (!_results) {
        _results = [NSMutableArray array];
    }
    return _results;
}
- (NSArray *)requestResults{
    return self.results? : @[];
}

@end
