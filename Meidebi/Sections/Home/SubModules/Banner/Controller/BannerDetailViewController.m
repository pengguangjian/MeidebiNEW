//
//  BannerDetailViewController.m
//  Meidebi
//
//  Created by mdb-admin on 2017/5/15.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "BannerDetailViewController.h"
#import "BannerDetailSubjectView.h"
#import "RemarkHomeDatacontroller.h"
#import "RemarkHomeViewController.h"
#import "RemarkComposeViewController.h"
#import "VKLoginViewController.h"
#import "MDB_UserDefault.h"
@interface BannerDetailViewController ()
<
UIAlertViewDelegate,
BannerDetailSubjectViewDelegate
>
@property (nonatomic, strong) NSDictionary *bannerInfoDict;
@property (nonatomic, strong) BannerDetailSubjectView *subjectView;
@property (nonatomic, strong) RemarkHomeDatacontroller *remarkDataController;
@end

@implementation BannerDetailViewController

- (instancetype)initWithBannerInfo:(NSDictionary *)infoDict{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _bannerInfoDict = infoDict;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动详情";
    _subjectView = [BannerDetailSubjectView new];
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
    [_subjectView bindDetailData:@{}];
    [self loadCommentData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadCommentData{
    [self.remarkDataController requestRemarkDataWithType:RemarkTypeNormal linkid:@"1724275" InView:nil callback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            // 测试限制数据
            NSMutableArray *temps = [NSMutableArray array];
            if (self.remarkDataController.resultArray.count > 3) {
                for (NSInteger i = 0; i < 3 ; i++) {
                    [temps addObject:self.remarkDataController.resultArray[i]];
                }
            }else{
                temps = self.remarkDataController.resultArray.mutableCopy;
            }
            [_subjectView bindCommentData:temps.mutableCopy];
        }
    }];
}

- (void)showAlertView{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请登录后再试"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"登录",@"取消", nil];
    [alertView show];

}

#pragma mark - BannerDetailSubjectViewDelegate
- (void)detailSubjectViewDidCickHotScaleUrlBtn:(NSString *)linke{

}

- (void)detailSubjectViewDidCickInputRemarkView{
    if ([MDB_UserDefault getIsLogin]){
        RemarkComposeViewController *remarkEditVc = [[RemarkComposeViewController alloc] init];
        remarkEditVc.type = RemarkTypeNormal;
        remarkEditVc.linkid = @"1724275";
        [self.navigationController pushViewController:remarkEditVc animated:YES];
    }else{
        [self showAlertView];
    }
}

- (void)detailSubjectViewDidCickReadMoreRemark{
    RemarkHomeViewController *remarkHomeVc = [[RemarkHomeViewController alloc] init];
    remarkHomeVc.type = RemarkTypeNormal;
    remarkHomeVc.linkid = @"1724275";
    [self.navigationController pushViewController:remarkHomeVc animated:YES];
}

- (void)detailSubjectViewDidCickCollectBtn{
    if ([MDB_UserDefault getIsLogin]){
     
    }else{
        [self showAlertView];
    }
}

- (void)detailSubjectViewDidCickReadBtn{
    if ([MDB_UserDefault getIsLogin]){
       
    }else{
        [self showAlertView];
    }
}

- (void)detailSubjectViewDidCicklikeBtn{
    if ([MDB_UserDefault getIsLogin]){
      
    }else{
        [self showAlertView];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        VKLoginViewController* theViewController= [[VKLoginViewController alloc] init];
        [self.navigationController pushViewController:theViewController animated:YES ];
    }
}
#pragma mark - setters and getters
- (RemarkHomeDatacontroller *)remarkDataController{
    if (!_remarkDataController) {
        _remarkDataController = [[RemarkHomeDatacontroller alloc] init];
    }
    return _remarkDataController;
}
@end
