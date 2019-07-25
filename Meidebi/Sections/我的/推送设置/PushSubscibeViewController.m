//
//  PushSubscibeViewController.m
//  Meidebi
//
//  Created by mdb-admin on 16/9/18.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "PushSubscibeViewController.h"
#import "PushSubscibeSubjectView.h"
#import "PushSubscibeDataController.h"
#import "MDB_UserDefault.h"

//#import "UMessage.h"
#import <UMPush/UMessage.h>

#import "HTTPManager.h"

@interface PushSubscibeViewController ()
<
PushSubscibeSubjectViewDelegate
>
@property (nonatomic, strong) PushSubscibeSubjectView *subjectView;
@property (nonatomic, strong) PushSubscibeDataController *dataController;
@property (nonatomic, strong) NSString *keys;
@property (nonatomic, strong) NSDictionary *dicGetPush;
@property (nonatomic, assign) BOOL isBest;
@property (nonatomic, assign) BOOL isall;

@end

@implementation PushSubscibeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setnavigation];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的订阅";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupSubview];
    
    [self loadData];
    [self gettuisongset];
    [self getAllKeys];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setnavigation{
    UIButton *butleft=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [butleft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [butleft setImage:[UIImage imageNamed:@"back_click.png"] forState:UIControlStateHighlighted];
    [butleft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [butleft addTarget:self action:@selector(doClickBackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBar=[[UIBarButtonItem alloc]initWithCustomView:butleft];
    self.navigationItem.leftBarButtonItem=leftBar;
}
-(void)doClickBackAction{
    [self uploadData];
}

- (void)setupSubview{
    _subjectView = [[PushSubscibeSubjectView alloc] init];
    [self.view addSubview:_subjectView];
    [_subjectView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }
    }];
    _subjectView.delegate = self;
}

- (void)loadData{
    [self.dataController requestSubjectDataInView:_subjectView
                                         callback:^(NSError *error, BOOL state, NSString *describle) {
        if (self.dataController.resultMessage) {
            [MDB_UserDefault showNotifyHUDwithtext:self.dataController.resultMessage inView:_subjectView];
        }else{
            [_subjectView bindDataWithPushKeys:self.dataController.requestResults];
        }
    }];
}


-(void)gettuisongset
{
    NSDictionary *prama;
    if ([MDB_UserDefault getIsLogin]) {
        prama=@{@"umengtoken":[NSString nullToString:[MDB_UserDefault getUmengDeviceToken]],
                @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    }else{
        if ([MDB_UserDefault getUmengDeviceToken]) {
            prama=@{@"umengtoken":[MDB_UserDefault getUmengDeviceToken]};
        }
    }
    [HTTPManager sendRequestUrlToService:URL_getumengconfig withParametersDictionry:prama view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[dicAll objectForKey:@"info"]isEqualToString:@"GET_DATA_SUCCESS"]&&[[dicAll objectForKey:@"status"] intValue]) {
                if ([[dicAll objectForKey:@"data"]isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dic=[dicAll objectForKey:@"data"];
                    _isall=[[NSString stringWithFormat:@"%@",[dic objectForKey:@"isclose"]]boolValue];
  
                    _isBest=[[NSString stringWithFormat:@"%@",[dic objectForKey:@"best"]]boolValue];
                    _dicGetPush = dic;
                }
            }
        }
    }];
}

-(void)getAllKeys
{
    [HTTPManager sendGETRequestUrlToService:URL_GetPushconfigRecSubscribe withParametersDictionry:nil view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
       
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[dicAll objectForKey:@"status"] intValue] == 1) {
                if ([[dicAll objectForKey:@"data"]isKindOfClass:[NSArray class]]) {
                    NSArray *arrkeys=[dicAll objectForKey:@"data"];
                    [_subjectView bindHotKeys:arrkeys];
                }
            }
        }
        
        
    }];
    
}


- (void)uploadData{
    [self.dataController requestSetPushKeywordDataInView:_subjectView
                                                 keyword:_keys
                                                callback:^(NSError *error, BOOL state, NSString *describle) {
        if (self.dataController.resultMessage) {
            
            if(_dicGetPush!=nil)
            {
                if(_keys.length>0)
                {
                    if(_isBest)
                    {
//                        [UMessage removeTag:@"daihuanxing" response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
//
//                        }];
//                        [UMessage addTag:@"jinghua" response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
//
//                        }];
                        
                        [UMessage deleteTags:@"daihuanxing" response:^(id  _Nullable responseObject, NSInteger remain, NSError * _Nullable error) {
                            
                        }];
                        [UMessage addTags:@"jinghua" response:^(id  _Nullable responseObject, NSInteger remain, NSError * _Nullable error) {
                            
                        }];
                    }
                    else
                    {
//                        [UMessage removeTag:@"daihuanxing" response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
//
//                        }];
//                        [UMessage removeTag:@"jinghua" response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
//
//                        }];
                        
                        
                        [UMessage deleteTags:@"daihuanxing" response:^(id  _Nullable responseObject, NSInteger remain, NSError * _Nullable error) {
                            
                        }];
                        [UMessage deleteTags:@"jinghua" response:^(id  _Nullable responseObject, NSInteger remain, NSError * _Nullable error) {
                            
                        }];
                    }
                }
                else
                {
                    //UMessage
                    if(_isBest)
                    {
//                        [UMessage removeTag:@"daihuanxing" response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
//
//                        }];
//                        [UMessage addTag:@"jinghua" response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
//
//                        }];
                        
                        [UMessage deleteTags:@"daihuanxing" response:^(id  _Nullable responseObject, NSInteger remain, NSError * _Nullable error) {
                            
                        }];
                        [UMessage addTags:@"jinghua" response:^(id  _Nullable responseObject, NSInteger remain, NSError * _Nullable error) {
                            
                        }];
                    }
                    else
                    {
//                        [UMessage removeTag:@"jinghua" response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
//
//                        }];
//                        [UMessage addTag:@"daihuanxing" response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
//
//                        }];
                        [UMessage deleteTags:@"jinghua" response:^(id  _Nullable responseObject, NSInteger remain, NSError * _Nullable error) {
                            
                        }];
                        [UMessage addTags:@"daihuanxing" response:^(id  _Nullable responseObject, NSInteger remain, NSError * _Nullable error) {
                            
                        }];
                    }
                }
            }
            
            
            
            [MDB_UserDefault showNotifyHUDwithtext:self.dataController.resultMessage inView:_subjectView];
            
            
        }else{
            [MDB_UserDefault setpushKeywordsStatue:YES];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


#pragma mark - PushSubscibeSubjectViewDelegate
- (void)subscibeSubjectView:(PushSubscibeSubjectView *)subjectView
            addPushKeywords:(NSArray *)keywords{
    _keys = @"";
    if (keywords.count != 0) {
        _keys = [keywords componentsJoinedByString:@","];
    }
}

#pragma mark - setters and getters
- (PushSubscibeDataController *)dataController{
    if (!_dataController) {
        _dataController = [[PushSubscibeDataController alloc] init];
    }
    return _dataController;
}

@end
