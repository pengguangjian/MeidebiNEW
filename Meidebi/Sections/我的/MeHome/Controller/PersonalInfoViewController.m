//
//  PersonalInfoViewController.m
//  Meidebi
//  个人资料
//  Created by fishmi on 2017/6/22.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "PersonalInfoView.h"
#import "PersonalInfoDataController.h"
#import "ImageCorpperViewController.h"
#import "MDB_UserDefault.h"
#import "GMDCircleLoader.h"
#import "HTTPManager.h"

@interface PersonalInfoViewController ()<PersonalInfoViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ImageCorpperViewControllerDelegate>
@property (nonatomic ,strong) PersonalInfoDataController *dataController;
@property (nonatomic ,weak) PersonalInfoView *subView;
@end

@implementation PersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle];
    [self setSubView];
    [self loadPersonalInfoData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)setNavigationTitle{
    self.title = @"个人资料";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"]}] ;
}

- (void)setSubView{
    PersonalInfoView *subView = [[PersonalInfoView alloc] init];
    subView.delegate = self;
    [self.view addSubview:subView];
    [subView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }
    }];
    _subView = subView;
}

- (void)loadPersonalInfoData{
    [self.dataController requestPersonalInfoDataInView:self.view WithCallback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            [self.subView loadPersonalInfoData:self.dataController.results];
        }
    }];
}

- (PersonalInfoDataController *)dataController{
    if (!_dataController) {
        _dataController = [[PersonalInfoDataController alloc] init];
    }
    return _dataController;
}

#pragma mark - PersonalInfoViewDelegate

-(void)finishBtnClicked:(NSString *)text view:(UIView *)view{
    if (view.tag == 10) {
        [self.dataController requestPersonalNickNameInView:self.view nickName:text WithCallback:^(NSError *error, BOOL state, NSString *describle) {
            if (state) {
                [self loadPersonalInfoData];
            }else{
                [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
            }
            
            
        }];
    }else if (view.tag == 11){
        [self.dataController requestPersonalSexInView:self.view sex:text WithCallback:^(NSError *error, BOOL state, NSString *describle) {
            if (state) {
                [self loadPersonalInfoData];
            }else{
                 [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
            }
        }];
    }else if (view.tag == 12){
        [self.dataController requestPersonalBirth_dayInView:self.view birth_day:text WithCallback:^(NSError *error, BOOL state, NSString *describle) {
            if (state) {
                [self loadPersonalInfoData];
            }else{
                [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
            }
        }];
    }else if (view.tag == 13){
        [self.dataController requestPersonalAlipayInView:self.view alipay:text WithCallback:^(NSError *error, BOOL state, NSString *describle) {
            if (state) {
                [self loadPersonalInfoData];
            }else{
                 [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
            }
        }];
    }
    
}

- (void)clickToViewController:(UIViewController *)vc{
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)takePhotos{
    UIImagePickerController * Imagepicker = [[UIImagePickerController alloc] init];
    Imagepicker.delegate=self;
    //拍照
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        Imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:Imagepicker animated:YES completion:nil];
    }
}

- (void)selectePicture{
    UIImagePickerController * Imagepicker = [[UIImagePickerController alloc] init] ;
    Imagepicker.delegate=self;
    //从手机相册选择
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        Imagepicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:Imagepicker animated:YES completion:nil];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    ImageCorpperViewController *imgCor=[[ImageCorpperViewController alloc] initWithNibName:nil bundle:nil];
    imgCor.img=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    imgCor.delegate=self;
    [picker pushViewController:imgCor animated:YES];
}


-(void)loadimvImage:(UIImage *)image{
    [GMDCircleLoader setOnView:self.view withTitle:nil animated:YES];
    MDB_UserDefault *_userdefault=[MDB_UserDefault defaultInstance];
    UIImage *img= [MDB_UserDefault imageWithImage:image scaledToSize:CGSizeMake(400.0 *kScale, image.size.height*400.0/image.size.width *kScale)];
    NSData *data = UIImagePNGRepresentation(img);
    NSString* urlString = Customer_avatar;
    NSDictionary *dics=@{@"userkey":[NSString nullToString:_userdefault.usertoken]};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",nil];
    [manager POST:urlString parameters:dics constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"zxzpic.png" fileName:@"zxzpic.png" mimeType:@"image/png"];
    } success:^(NSURLSessionTask *operation,id responseObject) {
        [GMDCircleLoader hideFromView:self.view animated:YES];
        if (responseObject) {
            if ([[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]] integerValue]&&[responseObject objectForKey:@"info"]&&[[responseObject objectForKey:@"info"]isEqualToString:@"GET_DATA_SUCCESS"]) {
                [MDB_UserDefault showNotifyHUDwithtext:@"恭喜,上传成功" inView:self.navigationController.view];
                [_subView setUpImageV:img];
                [_userdefault clearTmpPic:_userdefault.userphoto];
                [_userdefault setUserPhoto:[responseObject objectForKey:@"data"]];
            }else{
                [MDB_UserDefault showNotifyHUDwithtext:@"上传失败了" inView:self.navigationController.view];
            }
        }else{
            [MDB_UserDefault showNotifyHUDwithtext:@"上传失败了" inView:self.navigationController.view];
        }
    } failure:^(NSURLSessionTask *operation,NSError *error) {
        [GMDCircleLoader hideFromView:self.view animated:YES];
        [MDB_UserDefault showNotifyHUDwithtext:@"上传失败了" inView:self.navigationController.view];
    }];
}

@end
