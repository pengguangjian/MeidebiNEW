//
//  MyInformViewController.m
//  Meidebi
//
//  Created by 杜非 on 15/2/11.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import "MyInformViewController.h"
#import "MyInformTableView.h"
#import "RemarkViewController.h"
#import "MyInformDetailViewController.h"
#import "PersonalInfoIndexViewController.h"
#import "PersonalInfoDataController.h"
#import "MDB_UserDefault.h"
#import "MyZanAndCallMeViewController.h"
#import "MyOrderInfomTableViewController.h"
#import "MyInformMainModel.h"

@interface MyInformViewController ()<MyInformTableViewDelegate>
{
    UIButton* btnright;
}
@property (nonatomic ,strong) MyInformTableView *myInformtableV;
@property (nonatomic, strong) PersonalInfoDataController *datacontroller;
@end

@implementation MyInformViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"消息";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"]}] ;
    [self setNavigation];
    self.automaticallyAdjustsScrollViewInsets = NO;
    MyInformTableView *myInformtableV = [[MyInformTableView alloc] init];
    [self.view addSubview:myInformtableV];
    _myInformtableV = myInformtableV;
    [myInformtableV mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }
    }];
    _myInformtableV.delegate = self;
    [self.view addSubview:_myInformtableV];
    if ([_commentnum integerValue] >= 1) {
        [_myInformtableV remindVIsShow:YES];
    }else{
        [_myInformtableV remindVIsShow:NO];
    }
    if ([_zannum integerValue] >= 1) {
        [_myInformtableV zanRemindVIsShow:YES];
    }else{
        [_myInformtableV zanRemindVIsShow:NO];
    }
    
    if ([_orderunm integerValue] >= 1) {
        [_myInformtableV orderRemindVIsShow:YES];
    }else{
        [_myInformtableV orderRemindVIsShow:NO];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remindVIsShow) name:@"MyInformViewIsRemind" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zanRemindVIsShow) name:@"MyInformViewIsZanRemind" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderRemindVIsShow) name:@"MyInformViewIsOrderRemind" object:nil];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)remindVIsShow{
    [_myInformtableV remindVIsShow:NO];
}

- (void)zanRemindVIsShow{
    [_myInformtableV zanRemindVIsShow:NO];
}

-(void)orderRemindVIsShow
{
    [_myInformtableV orderRemindVIsShow:NO];
}

-(void)handleSwipes:(UISwipeGestureRecognizer *)sender{
   
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setNavigation{
    UIButton* btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
    btnLeft.frame = CGRectMake(0,0,44,44);
    [btnLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_click.png"] forState:UIControlStateHighlighted];
    [btnLeft addTarget:self action:@selector(doClickLeftAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnLeft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    
    
    btnright = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
//    btnright.frame = CGRectMake(0,0,44,44);
    [btnright setTitle:@"编辑" forState:UIControlStateNormal];
    [btnright setTitleColor:RGB(120, 120, 120) forState:UIControlStateNormal];
    [btnright.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btnright addTarget:self action:@selector(doClickRightAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnright setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnright];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    
}

-(void)doClickRightAction:(UIButton *)sender
{
    if([sender.titleLabel.text isEqualToString:@"编辑"])
    {
        [sender setTitle:@"取消" forState:UIControlStateNormal];
        [_myInformtableV setIsedit:YES];
    }
    else
    {
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
        [_myInformtableV setIsedit:NO];
    }
    [_myInformtableV editAction];
}

-(void)doClickLeftAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MyInformTableViewDelegate
-(void)tableViewClickRemark{
    RemarkViewController *remarkVc = [[RemarkViewController alloc] init];
    [self.navigationController pushViewController:remarkVc animated:YES];
}
- (void)tableViewClickZan{
    MyZanAndCallMeViewController *vc = [[MyZanAndCallMeViewController alloc] initWithType:ViewControllerTypeZan];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableViewClickCallMe{
    MyZanAndCallMeViewController *vc = [[MyZanAndCallMeViewController alloc] initWithType:ViewControllerTypeCallMe];
    [self.navigationController pushViewController:vc animated:YES];
}

///我的订单消息
- (void)tableViewClickOrder
{
    MyOrderInfomTableViewController *vc = [[MyOrderInfomTableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickToMyInformDetailViewControllerWithDataDic: (MyInformMainModel *)model{
    MyInformDetailViewController *myInformDetailVc = [[MyInformDetailViewController alloc] init];
    myInformDetailVc.dataDic = model.dicall;
    [self.navigationController pushViewController:myInformDetailVc animated:YES];
}

- (void)tableViewDidDeleteRowWithNewsID:(NSString *)newsid didComplete:(void (^)(BOOL))callback{
    [self.datacontroller requestNewsDeleteInView:self.view
                                          newsid:newsid
                                        callback:^(NSError *error, BOOL state, NSString *describle) {
                                            callback(state);
                                            if (!state) {
                                                [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
                                            }
    }];
}

////改变已读为未读
- (void)iseditchange
{
    [btnright setTitle:@"编辑" forState:UIControlStateNormal];
    
}

#pragma mark - setters and getters
- (PersonalInfoDataController *)datacontroller{
    if (!_datacontroller) {
        _datacontroller = [[PersonalInfoDataController alloc] init];
    }
    return _datacontroller;
}



@end
