//
//  FindCouponIndexViewController.m
//  Meidebi
//
//  Created by mdb-admin on 2017/7/7.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "FindCouponIndexViewController.h"
#import "FindCouponIndexSubjectView.h"
#import "FindCouponDataController.h"
#import "MDB_UserDefault.h"
#import "FindeCouponResultViewController.h"
#import "ShowActiveViewController.h"
#import "GMDCircleLoader.h"


#define HomeYouHuiQuanHuanCun @"homesouquanhuncun"

@interface FindCouponIndexViewController ()
<
FindCouponIndexSubjectViewDelegate
>
@property (nonatomic, strong) FindCouponIndexSubjectView *subjectView;
@property (nonatomic, strong) FindCouponDataController *dataController;
@property (nonatomic , assign) BOOL isjiazai;
@end

@implementation FindCouponIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"搜券";
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadData];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [GMDCircleLoader hideFromView:_subjectView animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupSubviews{
    [self setNavRightBtn];
    _subjectView = [FindCouponIndexSubjectView new];
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
    NSDictionary *dicvalue = [[NSUserDefaults standardUserDefaults] objectForKey:HomeYouHuiQuanHuanCun];
    if(dicvalue!= nil)
    {
        [_subjectView bindeDataWithModel:dicvalue];
    }
    
}

- (void)setNavRightBtn{
    UIButton* btnright = [UIButton buttonWithType:UIButtonTypeCustom];
    btnright.frame = CGRectMake(0,0,70,44);
    btnright.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [btnright setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btnright setTitle:@"帮助" forState:UIControlStateNormal];
    [btnright setImage:[UIImage imageNamed:@"welfare_home_help"] forState:UIControlStateNormal];
    [btnright setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnright setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [btnright addTarget:self action:@selector(respondsToNavRightBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnright];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)loadData{
    if(_isjiazai==NO)
    {
        [GMDCircleLoader setOnView:_subjectView withTitle:nil animated:YES];
    }
    [self.dataController requestCouponSearchHomeDataWithView:nil
                                                    callback:^(NSError *error, BOOL state, NSString *describle) {
                                                        if(_isjiazai==NO)
                                                        {
                                                            [GMDCircleLoader hideFromView:_subjectView animated:YES];
                                                        }
                                                    
                                                    if (state) {
                                                        _isjiazai = YES;
                                                        [_subjectView bindeDataWithModel:self.dataController.resultDict];
                                                        if(self.dataController.resultDict!=nil)
                                                        {
                                                            [[NSUserDefaults standardUserDefaults] setObject:self.dataController.resultDict forKey:HomeYouHuiQuanHuanCun];
                                                        }
                                                        
                                                    }else{
                                                        if (![@"" isEqualToString:describle]) {
                                                             [MDB_UserDefault showNotifyHUDwithtext:describle inView:_subjectView];
                                                        }
                                                    }
    }];
}

- (void)respondsToNavRightBtnEvent:(UIButton *)sender{
    UIStoryboard *mainbord=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ShowActiveViewController *showAct=[mainbord instantiateViewControllerWithIdentifier:@"com.mbd.ShowActiveViewC"];
    showAct.url=@"http://m.meidebi.com/Search-help.html";
    showAct.title=@"怎么找优惠券";
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:showAct animated:YES];
    self.hidesBottomBarWhenPushed=NO;

}

#pragma mark - FindCouponIndexSubjectViewDelegate
////搜索关键词跳转
- (void)subjectViewDidSearchCouponWithKeyWord:(NSString *)keyWord{
    FindeCouponResultViewController *resultVC = [[FindeCouponResultViewController alloc] initWithSearchKeyword:keyWord];
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:resultVC animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}

#pragma mark - setters and getters 
- (FindCouponDataController *)dataController{
    if (!_dataController) {
        _dataController = [[FindCouponDataController alloc] init];
    }
    return _dataController;
}

@end
