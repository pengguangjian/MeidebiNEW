//
//  RemarkDataController.m
//  Meidebi
//
//  Created by mdb-admin on 16/6/23.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "RemarkDataController.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"
#import "RemarkModel.h"
#import "PersonalRemarkLayout.h"
typedef NS_ENUM(NSInteger, DragDirection) {
    DragDirectionUp,
    DragDirectionDown
};

@interface RemarkDataController()

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) RemarkDataType requstType;
@property (nonatomic, strong) UIView *targetView;
@property (nonatomic, strong) NSMutableArray *requestResults;

@end

@implementation RemarkDataController

- (instancetype)init{
    self = [super init];
    if (self) {
        _page = 1;
        _requestResults = [NSMutableArray array];
    }
    return self;
}

- (void)requestSubjectDataWithType:(RemarkDataType)type
                            InView:(UIView *)view
                          callback:(completeCallback)Callback{
    _requstType = type;
    _targetView = view;
    [self loadDataWithDirection:DragDirectionDown callback:Callback];
}

- (void)nextPageDataWithCallback:(completeCallback)callback{
    _page+=1;
    [self loadDataWithDirection:DragDirectionUp callback:callback];

}
- (void)lastNewPageDataWithCallback:(completeCallback)callback{
    _page = 1;
    [self loadDataWithDirection:DragDirectionDown callback:callback];
}

- (void)loadDataWithDirection:(DragDirection)direction callback:(completeCallback)callback{
    
    NSString *type = @"";
    PersonalRemarkMenuType style;
    if (_requstType == RemarkDataTypeNormal) {
        type = @"1";
        style = PersonalRemarkMenuTypeComment;
    }else{
        type = @"2";
        style = PersonalRemarkMenuTypeReply;
    }
    NSDictionary *dics=@{@"p":[NSString stringWithFormat:@"%@",@(_page)],
                         @"limit":@"20",
                         @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                         @"type":type};
    [HTTPManager sendGETRequestUrlToService:URL_customercomment withParametersDictionry:dics view:_targetView completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
            callback(error,state,describle);
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[dicAll objectForKey:@"info"]isEqualToString:@"GET_DATA_SUCCESS"]) {
                NSArray *subjects = dicAll[@"data"];
                if ([subjects isKindOfClass:[NSDictionary class]]) return ;
                if (direction == DragDirectionDown) {
                    NSMutableArray *tempArr = [NSMutableArray array];
                    for (NSDictionary *dict in subjects) {
                        PersonalRemark *aRemark = [PersonalRemark modelWithDictionary:dict];
                        aRemark.comment = [NSString stringWithFormat:@"%@ ",aRemark.comment];
                        PersonalRemarkLayout *layout = [[PersonalRemarkLayout alloc] initWithStatus:aRemark style:style];
                        if (layout) {
                            [tempArr addObject:layout];
                        }
                    }
                    _requestResults = tempArr;
                }else{
                    [subjects enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (obj) {
                            PersonalRemark *aRemark = [PersonalRemark modelWithDictionary:obj];
                            aRemark.comment = [NSString stringWithFormat:@"%@ ",aRemark.comment];
                            PersonalRemarkLayout *layout = [[PersonalRemarkLayout alloc] initWithStatus:aRemark style:style];
                            [_requestResults addObject:layout];
                        }
                    }];
                }
                state = YES;
                callback(nil,state,describle);
            }else{
                callback(error,state,describle);
            }
        }
    }];
}

- (void)requestCommentReplySubjectData:(NSDictionary *)dict InView:(UIView *)view callback:(completeCallback)Callback{
    [HTTPManager sendRequestUrlToService:URL_commindex
                 withParametersDictionry:dict view:view
                          completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
          BOOL state = NO;
          NSString *describle = @"";
        if (responceObjct==nil) {
             describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            
            if ([[dicAll objectForKey:@"status"]intValue]==1) {
                state = YES;
                if ([dicAll[@"data"] isKindOfClass:[NSString class]]) {
                    describle = dicAll[@"data"];
                }else{
                    describle = @"回复成功";
                }
            }else{
                id obj=[dicAll objectForKey:@"info"];
                if ([obj isKindOfClass:[NSString class]]) {
                    NSString *sst=(NSString *)obj;
                    describle = sst;
                }
            }
        }
          Callback(error,state,describle);
    }];
}


@end
