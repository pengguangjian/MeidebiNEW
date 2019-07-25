//
//  JoinInActivityViewController.m
//  Meidebi
//
//  Created by fishmi on 2017/5/23.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "JoinInActivityViewController.h"
#import "JoinInActivityPickPictureView.h"
#import "JoinInActivityView.h"
#import "MDB_UserDefault.h"
#import <FCUUID/FCUUID.h>
#import "JoinInActivityDataController.h"
//#import <IQKeyboardManager/IQKeyboardManager.h>
#import "IQKeyboardManager.h"
#import "GMDCircleLoader.h"

@interface JoinInActivityViewController ()<JoinInActivityPickPictureViewDelegate,JoinInActivityViewDelegate,UIAlertViewDelegate>
@property (nonatomic ,strong) JoinInActivityPickPictureView *pickView;
@property (nonatomic, strong) NSArray *selectPics;
@property (nonatomic ,strong) JoinInActivityView *joinInV;
@property (nonatomic ,strong) JoinInActivityDataController *dataController;
@property (nonatomic, strong) NSDictionary *tokenInfoDict;
@end

@implementation JoinInActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _selectPics = [NSMutableArray array];
    [self setNavigationTitle];
    [self setSubView];
    [self setupRightBarButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadImages:) name:@"joinUploadImage" object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (iPhone4 || iPhone5) {
        [[IQKeyboardManager sharedManager] registerTextFieldViewClass:[YYTextView class]
                                      didBeginEditingNotificationName:YYTextViewTextDidBeginEditingNotification didEndEditingNotificationName:YYTextViewTextDidEndEditingNotification];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (iPhone4 || iPhone5) {
        [[IQKeyboardManager sharedManager] unregisterTextFieldViewClass:[YYTextView class]
                                        didBeginEditingNotificationName:YYTextViewTextDidBeginEditingNotification didEndEditingNotificationName:YYTextViewTextDidEndEditingNotification];
    }
    [GMDCircleLoader hideFromView:self.view animated:YES];

}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:@"joinUploadImage"];
}

- (void)uploadImages: (NSNotification *)notification{
    NSNumber *statue = (NSNumber *)notification.object;
    if (statue.boolValue) {
        self.dataController.joinId = self.activityId;
        NSMutableArray *images = [NSMutableArray array];
        NSString *str = notification.userInfo[@"content"];
        images = notification.userInfo[@"pics"];
        [self.dataController requestJoinAddDataWithImageArray:images WithDescription:str InView:nil callback:^(NSError *error, BOOL state, NSString *describle) {
            self.navigationController.view.userInteractionEnabled = YES;
            self.view.userInteractionEnabled = YES;
            if (state) {
                if (_didFinish) {
                    _didFinish();
                }
                [self backTo];
            }else{
                [MDB_UserDefault showNotifyHUDwithtext:describle inView:_joinInV];
            }
        }];
    }else{
        self.navigationController.view.userInteractionEnabled = YES;
        self.view.userInteractionEnabled = YES;
    }
   
}

- (void)setNavigationTitle{
    self.title = @"参加活动";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"]}] ;
}


-(void)setupRightBarButton{
    
    UIButton *releaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    releaseBtn.frame = CGRectMake(0, 0, 70, 30);
    [releaseBtn setTitle:@"发布" forState:UIControlStateNormal];
    [releaseBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [releaseBtn.layer setCornerRadius:4];
    [releaseBtn setBackgroundImage:[UIImage imageNamed:@"btnBackgroundImage"] forState:UIControlStateNormal];
    [releaseBtn addTarget:self action:@selector(releaseBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseItem = [[UIBarButtonItem alloc] initWithCustomView:releaseBtn];
    self.navigationItem.rightBarButtonItem = releaseItem;
    
}

- (void)backTo{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setSubView{
    JoinInActivityView *joinInV = [[JoinInActivityView alloc] init];
    joinInV.delegate = self;
    joinInV.activityLabel.text = [NSString stringWithFormat:@"#%@#",self.text_title];
    [self.view addSubview:joinInV];
    [joinInV mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }
    }];
    _joinInV = joinInV;
    
}

#pragma mark - JoinInActivityViewDelegate
- (void)picturePickerDidSelectPhotosWithTargeVc:(UIViewController *)targetVc{
    [self presentViewController:targetVc animated:YES completion:nil];

}

- (void)picturePickerDidSelectPhotos:(NSArray *)photos{
    _selectPics = photos;

}

- (void)releaseBtnClicked: (UIButton *) sender{
    [_joinInV.textV resignFirstResponder];
    if ((!_joinInV.textV.text||[_joinInV.textV.text isEqualToString:@""]) && _selectPics.count <= 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请输入内容"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles: nil];
        [alertView show];
        return;
    }
    if (_joinInV.textV.text.length < 5) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"分享不少于5个字"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles: nil];
        [alertView show];
        return;
    }
    if (_selectPics.count <= 0) {
        [MDB_UserDefault showNotifyHUDwithtext:@"请选择参与活动的图片" inView:self.view];
        return;
    }
    
    NSDictionary *dics =@{
                          @"userid":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                          @"type":@"100",
                          @"fromid":[NSString nullToString:_activityId],
                          @"pics":_selectPics,
                          @"content":_joinInV.textV.text,
                          @"uniquetoken":[FCUUID uuidForDevice]
                          };
    [self storeRemark:dics];
    [GMDCircleLoader setOnView:self.view withTitle:@"正在上传图片..." animated:YES];
    self.navigationController.view.userInteractionEnabled = NO;
    self.view.userInteractionEnabled = NO;
    if (_selectPics.count <= 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kRemarkUploadImagesNotification object:nil userInfo:nil];
    }else{
        [self.dataController requestImageTokenDataImageCount:_selectPics.count InView:nil callback:^(NSError *error, BOOL state, NSString *describle) {
            if (state) {
                _tokenInfoDict = self.dataController.resultDict;
                [[NSNotificationCenter defaultCenter] postNotificationName:kRemarkUploadImagesNotification object:_selectPics userInfo:_tokenInfoDict];
            }else{
                [MDB_UserDefault showNotifyHUDwithtext:describle inView:_joinInV];
                self.navigationController.view.userInteractionEnabled = YES;
                self.view.userInteractionEnabled = NO;
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

- (JoinInActivityDataController *)dataController{
    if (!_dataController) {
        _dataController = [[JoinInActivityDataController alloc] init];
    }
    return _dataController;
}



@end
