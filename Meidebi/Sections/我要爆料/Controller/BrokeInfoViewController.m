//
//  BrokeInfoViewController.m
//  Meidebi
//
//  Created by mdb-admin on 16/7/27.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "BrokeInfoViewController.h"
#import "BrokeShareDataController.h"
#import "MDB_UserDefault.h"
#import "BrokeInfoViewModel.h"
#import "BrokeSuccessSubjectView.h"
#import "BrokeAlertView.h"
#import "RemarkHomeDatacontroller.h"
//#import <CYLTabBarController/CYLTabBarController.h>
//#import "OneUserViewController.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import <TZImagePickerController/UIView+Layout.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <UMAnalytics/MobClick.h>
@interface BrokeInfoViewController ()
<
BrokeInfoSubjectViewDelegate,
BrokeSuccessSubjectViewDelegate
>
@property (nonatomic, strong) BrokeInfoSubjectView *infoSubView;
@property (nonatomic, strong) BrokeShareDataController *datacontroller;
@property (nonatomic, strong) RemarkHomeDatacontroller *remarkDatacontroller;
@property (nonatomic, assign) BrokeType type;
@property (nonatomic, strong) BrokeInfoViewModel *viewModel;
@property (nonatomic, assign) BOOL brokeState;
@end

@implementation BrokeInfoViewController
- (instancetype)initWithType:(BrokeType)type{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _brokeState = NO;
        _type = type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我要爆料";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigation];
    _infoSubView = [[BrokeInfoSubjectView alloc] initWithType:_type];
    [self.view addSubview:_infoSubView];
    [_infoSubView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }
    }];
    _infoSubView.delegate = self;
    [self renderSubjectView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBrokeLocalImage:) name:kBrokeUpdataImageNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setNavigation{
    UIButton* btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame = CGRectMake(0,0,44,44);
    [btnLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_click.png"] forState:UIControlStateHighlighted];
    [btnLeft addTarget:self action:@selector(doClickLeftAction) forControlEvents:UIControlEventTouchUpInside];
    [btnLeft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

-(void)doClickLeftAction{
    [_infoSubView endEditing:YES];
    if (_brokeState) {
        if (self.navigationController.viewControllers[1]) {
            [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)renderSubjectView {
    _viewModel = [BrokeInfoViewModel viewModelWithSubjects:_brokeInfoDict];
    [_infoSubView bindDataWithViewModel:_viewModel];
}

- (void)updateBrokeLocalImage:(NSNotification *)notification{
    BOOL state = [(NSNumber *)notification.object boolValue];
    if (state) {
        NSDictionary *tokenInfoDict = self.remarkDatacontroller.resultDict;
        NSArray *imageNames = [tokenInfoDict[@"key"] componentsSeparatedByString:@","];
        NSString *str = [NSString stringWithFormat:@"%@%@",tokenInfoDict[@"domain"],imageNames.firstObject];
        [_viewModel updateImageLinkWithNewLink:str];
    }else{
        [MDB_UserDefault showNotifyHUDwithtext:@"更改图片失败，请重新选择" inView:self.view];
    }
}

#pragma mark - BrokeInfoSubjectViewDelegate
- (void)brokeInfoSubjectView:(BrokeInfoSubjectView *)subView didPressBrokeBtnWithInfo:(NSDictionary *)dict{
    
    [self.datacontroller requestSubmitBrokeWithInfo:dict
                                             InView:subView
                                           callback:^(NSError *error, BOOL state, NSString *describle) {
        if ([NSString nullToString:self.datacontroller.resultMessage].length>0) {
            [MDB_UserDefault showNotifyHUDwithtext:self.datacontroller.resultMessage inView:subView];
        }else{
            BrokeSuccessSubjectView *brokeStatueView  = [[BrokeSuccessSubjectView alloc] init];
            [self.view addSubview:brokeStatueView];
            [brokeStatueView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
            }];
            brokeStatueView.brokeType = BrokeSuccessTypeNomal;
            brokeStatueView.delegate = self;
            [MDB_UserDefault setFinishBrokeDate:[NSDate date]];
            _brokeState = YES;
            [MobClick event:@"tianjia_baoliao"];
        }
    }];
}

- (void)brokeInfoSubjectViewDidPressNoBrokeBtn{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)brokeInfoSubjectViewDidPressChoicePhotoBtnWithDidComplete:(void (^)(UIImage *))callback{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:nil pushPhotoPickerVc:YES];
    imagePickerVc.isSelectOriginalPhoto = NO;
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.sortAscendingByModificationDate = YES;
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowPreview = NO;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.needCircleCrop = NO;
    imagePickerVc.isStatusBarDefault = NO;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (callback) {
            callback(photos.firstObject);
        }
        [self updateImage:photos.firstObject];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)updateImage:(UIImage *)image{
    if (image == nil) return;
    [self.remarkDatacontroller requestImageTokenDataImageCount:1
                                                  InView:nil
                                                callback:^(NSError *error, BOOL state, NSString *describle) {
                                                    if (state) {
                                                        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.remarkDatacontroller.resultDict];
                                                        [dict setValue:@"11111" forKey:@"type"];
                                                        [[NSNotificationCenter defaultCenter] postNotificationName:kRemarkUploadImagesNotification object:@[image] userInfo:dict.mutableCopy];
                                                    }else{
                                                        [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
                                                    }
                                                }];
}

#pragma mark - BrokeSuccessSubjectViewDelegate
- (void)brokeSuccessSubjectViewdidPressJumpBtn{
//    [[self cyl_popSelectTabBarChildViewControllerAtIndex:4] dismissViewControllerAnimated:NO completion:nil];
//    [self cyl_popSelectTabBarChildViewControllerAtIndex:4 completion:^(__kindof UIViewController *selectedTabBarChildViewController) {
//         OneUserViewController *userViewController = selectedTabBarChildViewController;
//        [userViewController intoBrokeNews];
//    }];
    if (self.navigationController.viewControllers[1]) {
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    }
}

#pragma mark - getter and setter
- (BrokeShareDataController *)datacontroller{
    if (!_datacontroller) {
        _datacontroller = [[BrokeShareDataController alloc] init];
    }
    return _datacontroller;
}
- (RemarkHomeDatacontroller *)remarkDatacontroller{
    if (!_remarkDatacontroller) {
        _remarkDatacontroller = [[RemarkHomeDatacontroller alloc] init];
    }
    return _remarkDatacontroller;
}
@end
