//
//  RemarkHomeViewController.m
//  Meidebi
//
//  Created by mdb-admin on 2017/2/6.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "RemarkHomeViewController.h"
#import "RemarkHomeSubjectView.h"
#import "RemarkComposeViewController.h"
#import "MDB_UserDefault.h"
#import "ADHandleViewController.h"
#import "VKLoginViewController.h"
#import "RemarkHomeInputTabBarView.h"
#import <YYKit/YYKit.h>
#import <FCUUID/FCUUID.h>
#import "PersonalInfoIndexViewController.h"
@interface RemarkHomeViewController ()
<
RemarkHomeSubjectViewDelegate,
RemarkHomeInputTabBarViewDelegate,
UIAlertViewDelegate
>
@property (nonatomic, strong) RemarkHomeSubjectView *subjectView;
@property (nonatomic, strong) RemarkHomeDatacontroller *dataController;
@property (nonatomic, strong) RemarkHomeInputTabBarView *inputTabBarView;
@property (nonatomic, assign) PopupMenuHandleType menuHandleType;
@property (nonatomic, strong) Remark *aRemark;
@property (nonatomic, strong) NSArray *uploadPics;
@property (nonatomic, strong) NSDictionary *tokenInfoDict;
@end

@implementation RemarkHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论";
    if ([self respondsToSelector:@selector( setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self setupSubviews];
    [self obtainRemarkData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardchange:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHidenChange:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateRemarkTable:)
                                                 name:kRemarkUpdataNotification
                                               object:nil];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupSubviews{
    NSInteger topPadding = kTopHeight;
    self.view.backgroundColor = [UIColor whiteColor];
    _subjectView = [RemarkHomeSubjectView new];
    [self.view addSubview:_subjectView];
    [_subjectView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(topPadding, 0, 0, 0));
        }
    }];
    _subjectView.delegate = self;
    [self setNavigation];
}

-(void)setNavigation{
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame = CGRectMake(0,0,44,44);
    [btnLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_click.png"] forState:UIControlStateHighlighted];
    [btnLeft addTarget:self action:@selector(doClickLeftAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnLeft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

-(void)doClickLeftAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)obtainRemarkData{
    [self.dataController requestRemarkDataWithType:_type linkid:_linkid InView:_subjectView callback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            [_subjectView bindDataWithModel:self.dataController.resultArray];
        }else{
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:_subjectView];
        }
    }];
}

-(void)keyboardchange:(NSNotification *)notification{
    self.inputTabBarView.hidden = NO;
    NSDictionary    *info=[notification userInfo];
    NSValue         *avalue=[info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect=[self.view convertRect:[avalue CGRectValue] fromView:nil];
    float keyboardHeight=keyboardRect.size.height;//键盘高度
    self.inputTabBarView.bottom = self.view.frame.size.height-keyboardHeight;
    self.inputTabBarView.left = 0;
}

-(void)keyboardHidenChange:(NSNotification *)notification{
    self.inputTabBarView.bottom = self.view.frame.size.height-50;
    self.inputTabBarView.hidden = YES;
}

- (void)submitRemark:(NSDictionary *)remarkDict{
    _uploadPics = remarkDict[@"pics"];
    [self updateRemarkList:remarkDict];
    [self storeRemark:remarkDict];
    if (_uploadPics.count <= 0) {
         [[NSNotificationCenter defaultCenter] postNotificationName:kRemarkUploadImagesNotification object:nil userInfo:nil];
    }else{
        [self.dataController requestImageTokenDataImageCount:_uploadPics.count
                                                      InView:nil
                                                    callback:^(NSError *error, BOOL state, NSString *describle) {
                                                        if (state) {
                                                            _tokenInfoDict = self.dataController.resultDict;
                                                            [[NSNotificationCenter defaultCenter] postNotificationName:kRemarkUploadImagesNotification object:_uploadPics userInfo:_tokenInfoDict];
                                                        }else{
                                                            [[NSNotificationCenter defaultCenter] postNotificationName:kRemarkUpdataNotification object:@(NO) userInfo:@{kRemarkErrorTips:describle}];
                                                        }
                                                    }];

    }
}
- (void)storeRemark:(NSDictionary *)remarkDict{
    NSMutableArray *pics = [NSMutableArray array];
    for (UIImage *image in remarkDict[@"pics"]) {
        NSData *data = UIImagePNGRepresentation(image);
        if (data) {
            [pics addObject:data];
        }
    }
    [MDB_UserDefault setRemarkImages:pics.mutableCopy];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:remarkDict];
    [dict setValue:@[] forKey:@"pics"];
    [MDB_UserDefault setRemarkCache:[NSString DicToJsonStr:dict]];
}

- (void)updateRemarkList:(NSDictionary *)remarkDict{
    Remark *aRemark = [[Remark alloc] init];
    aRemark.userid = remarkDict[@"userid"];
    aRemark.nickname = [MDB_UserDefault defaultInstance].userName;
    aRemark.status = @"1";
    aRemark.content = remarkDict[@"content"];
    aRemark.pics = remarkDict[@"pics"];
    aRemark.photo = [MDB_UserDefault defaultInstance].userphoto;
    aRemark.createtime = @"发送中...";
    [_subjectView updateDataWithModel:aRemark];
}

- (void)updateRemarkTable:(NSNotification *)notification{
    NSNumber *statue = (NSNumber *)notification.object;
    if (statue.boolValue) {
        [self obtainRemarkData];
    }else{
        if (![@"" isEqualToString:notification.userInfo[kRemarkErrorTips]]) {
            [MDB_UserDefault showNotifyHUDwithtext:notification.userInfo[kRemarkErrorTips] inView:_subjectView];
        }
    }
    [_subjectView refreshUploadingRemakInfo:statue.boolValue];
}

#pragma mark - RemarkHomeInputTabBarViewDelegate
- (void)textViewShouldReturn:(NSString *)text{
    
    if (!text||[text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请输入内容"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles: nil];
        [alertView show];
        return;
    }
    [self.inputTabBarView textViewDismissFirstResponder];
    NSDictionary *parameters = nil;
    if (_menuHandleType == PopupMenuHandleTypeReply) {
        parameters = @{
                       @"userid":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                        @"type":[NSString stringWithFormat:@"%@",@(_type)],
                      @"fromid":[NSString nullToString:_linkid],
                    @"touserid":[NSString nullToString:_aRemark.userid],
                       @"content":text,
                       @"uniquetoken":[FCUUID uuidForDevice]
                       };
    }else{
        parameters = @{
                       @"userid":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                       @"type":[NSString stringWithFormat:@"%@",@(_type)],
                       @"fromid":[NSString nullToString:_linkid],
                       @"referid":[NSString nullToString:_aRemark.comentid],
                       @"content":text,
                       @"uniquetoken":[FCUUID uuidForDevice]
                       };
    }
    
    [self.dataController requestHandleRemarkDataWithParameters:parameters
                                                        InView:_subjectView
                                                      callback:^(NSError *error, BOOL state, NSString *describle) {
                                                          if (state) {
                                                              [self obtainRemarkData];
                                                          }else{
                                                              [MDB_UserDefault showNotifyHUDwithtext:describle inView:_subjectView];
                                                          }
    }];
}

#pragma mark - RemarkHomeSubjectViewDelegate
- (void)remarkHomeSubjectViewDidClickToolBar{
    if (![MDB_UserDefault defaultInstance].usertoken){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请登录后再试"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"登录",@"取消", nil];
        [alertView setTag:111];
        [alertView show];
        return;
    }
    
    RemarkComposeViewController *composeVc = [[RemarkComposeViewController alloc] init];
    composeVc.type = _type;
    composeVc.linkid = _linkid;
    [self.navigationController pushViewController:composeVc animated:YES];
    composeVc.confirmRemark = ^(NSDictionary *dict){
        [self submitRemark:dict];
    };
}

- (void)remarklastPage{
    [self.dataController lastNewPageDataWithCallback:^(NSError *error, BOOL state, NSString *describle) {
        [_subjectView bindDataWithModel:self.dataController.resultArray];
    }];
}

- (void)remarkNextPage{
    [self.dataController nextPageDataWithCallback:^(NSError *error, BOOL state, NSString *describle) {
        [_subjectView bindDataWithModel:self.dataController.resultArray];
    }];
}

- (void)remarkHomeSubjectClickUrl:(NSString *)urlStr{
    if (!urlStr) return;
    ADHandleViewController *vc = [[ADHandleViewController alloc] initWithAdLink:urlStr];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)photoGroupView:(YYPhotoGroupView *)photoGroupView didClickImageView:(UIView *)fromeView{
    [photoGroupView presentFromImageView:fromeView
                             toContainer:self.navigationController.view
                                animated:YES
                              completion:nil];
}

- (void)remarkTableViewDidAgainUploadRemark{
    NSArray *imageDatas = [MDB_UserDefault remarkImages];
    [[NSNotificationCenter defaultCenter] postNotificationName:kRemarkUploadImagesNotification object:imageDatas userInfo:_tokenInfoDict];
}

- (void)popupMenuDidHandle:(PopupMenuHandleType)handeType targetObject:(Remark *)remark{
    _menuHandleType = handeType;
    _aRemark = remark;
    switch (handeType) {
        case PopupMenuHandleTypePraise:
        {
            
            if (![MDB_UserDefault defaultInstance].usertoken){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"请登录后再试"
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"登录",@"取消", nil];
                [alertView setTag:111];
                [alertView show];
                return;
            }
            
//            if ([MDB_UserDefault getIsLogin]) {RemarkTypeNormal
                [self.dataController requestRemarkPriseDataWithType:_type//RemarkTypeNormal
                                                          CommentID:remark.comentid
                                                             InView:_subjectView
                                                           callback:^(NSError *error, BOOL state, NSString *describle) {
                                                               if (state) {
                                                                   [_subjectView successPrise];
                                                               }else{
                                                                   [MDB_UserDefault showNotifyHUDwithtext:describle inView:_subjectView];
                                                               }
                }];
//            }else{
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                                    message:@"请登录后再试"
//                                                                   delegate:self
//                                                          cancelButtonTitle:nil
//                                                          otherButtonTitles:@"登录",@"取消", nil];
//                [alertView setTag:122];
//                [alertView show];
//            }
        }
            break;
        case PopupMenuHandleTypeReply:{
            [self.view addSubview:self.inputTabBarView];
            [self.inputTabBarView textViewBecomeFirstResponder];
        }
            break;
        case PopupMenuHandleTypeQuote:{
            [self.view addSubview:self.inputTabBarView];
            [self.inputTabBarView textViewBecomeFirstResponder];
        }
            break;
        case PopupMenuHandleTypeCopy:{
            if (!remark.content) return;
            [[UIPasteboard generalPasteboard] setString:remark.content];
            [MDB_UserDefault showNotifyHUDwithtext:@"复制成功" inView:_subjectView];
        }
            break;
            
        default:
            break;
    }
}

- (void)remarkTableViewDidDrage{
    [self.inputTabBarView textViewDismissFirstResponder];
}

- (void)remarkTableViewDidClickUser:(NSString *)userid{
    PersonalInfoIndexViewController *personalInfoIndexVC = [[PersonalInfoIndexViewController alloc] initWithUserID:userid];
    [self.navigationController pushViewController:personalInfoIndexVC animated:YES];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==111||alertView.tag==110){
        if (buttonIndex==0) {
            VKLoginViewController* theViewController= [[VKLoginViewController alloc] init];
            [self.navigationController pushViewController:theViewController animated:YES ];
            
        }
    }else if(alertView.tag==122){
        if (buttonIndex==0) {
            VKLoginViewController* theViewController= [[VKLoginViewController alloc] init];
            [self.navigationController pushViewController:theViewController animated:YES ];
        }else{
            
            
        }
    }else if(alertView.tag==202){
//        [_textView resignFirstResponder];
    }
}

#pragma mark - seeters and getters
- (RemarkHomeDatacontroller *)dataController{
    if (!_dataController) {
        _dataController = [[RemarkHomeDatacontroller alloc] init];
    }
    return _dataController;
}

- (RemarkHomeInputTabBarView *)inputTabBarView{
    if (!_inputTabBarView) {
        _inputTabBarView = [RemarkHomeInputTabBarView new];
        _inputTabBarView.bottom = self.view.frame.size.height;
        _inputTabBarView.left = 0;
        _inputTabBarView.delegate = self;
    }
    return _inputTabBarView;
}

@end
