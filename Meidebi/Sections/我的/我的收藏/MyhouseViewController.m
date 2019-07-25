//
//  MyhouseViewController.m
//  Meidebi
//
//  Created by 杜非 on 15/2/10.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import "MyhouseViewController.h"
#import "MyhouseTableView.h"
#import "MenuView.h"
#import "ProductInfoViewController.h"
#import "VolumeContentViewController.h"
#import "OriginalDetailViewController.h"
#import "SpecialInfoViewController.h"
@interface MyhouseViewController ()<MenuDelegate,MyhouseTableViewDelegate>
@property(nonatomic,strong)MenuView     *menu;
@end

@implementation MyhouseViewController{
    MyhouseTableView *_myAricltTablview;
    MyhouseTableView *_myShareTablview;
    MyhouseTableView *_myJuancleTablview;
    MyhouseTableView *_mySpecialTablview;

    BOOL          _isfirstload;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的收藏";
    [self setNavigation];
    
    _isfirstload=NO;
    _menu=[[MenuView alloc]initWithFrame:CGRectMake(0, kTopHeight,self.view.frame.size.width, 47) titles:@[@"优惠",@"原创",@"领券"] delegat:self];//,@"专题"
    [self.view addSubview:_menu];
    UISwipeGestureRecognizer *right=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipes:)];
    right.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:right];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_isfirstload) {
        switch (_menu.index) {
            case 0:
                if (_myAricltTablview) {
                    [_myAricltTablview reloadTableViewDataSource];
                }
                break;
            case 1:
                if (_myShareTablview) {
                    [_myShareTablview reloadTableViewDataSource];
                }
                break;
            case 2:
                if (_myJuancleTablview) {
                    [_myJuancleTablview reloadTableViewDataSource];
                }
                break;
            case 3:
                if (_mySpecialTablview) {
                    [_mySpecialTablview reloadTableViewDataSource];
                }
                break;
                
            default:
                break;
        }
    }
    _isfirstload=YES;
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
}
-(void)doClickLeftAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark MenuView menuDelegate
-(void)MenuSelect:(MenuView *)menu index:(NSInteger)selectIndex title:(NSString *)title{
    
    switch (selectIndex) {
        case 0:
        {
            [self setHiddenNoWithTable];
            if (_myAricltTablview) {
                [_myAricltTablview setHidden:NO];
            }else{
                _myAricltTablview=[[MyhouseTableView alloc]initWithFrame:CGRectZero delegate:self ftype:1];
                [self.view addSubview:_myAricltTablview];
                [_myAricltTablview mas_makeConstraints:^(MASConstraintMaker *make) {
                    if (@available(iOS 11.0, *)) {
                        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(47);
                        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
                        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
                        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
                    }else{
                        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight+47, 0, 0, 0));
                    }
                }];
            }
        }
            break;
        case 1:
        {
            [self setHiddenNoWithTable];
            if (_myShareTablview) {
                [_myShareTablview setHidden:NO];
            }else{
                _myShareTablview=[[MyhouseTableView alloc]initWithFrame:CGRectZero delegate:self ftype:4];
                [self.view addSubview:_myShareTablview];
                [_myShareTablview mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(_menu.mas_bottom);
                    if (@available(iOS 11.0, *)) {
                        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(47);
                        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
                        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
                        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
                    }else{
                        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight+47, 0, 0, 0));
                    }
                }];
            }
        }
            break;
        case 2:
        {
            [self setHiddenNoWithTable];
            if (_myJuancleTablview) {
                [_myJuancleTablview setHidden:NO];
            }else{
                _myJuancleTablview=[[MyhouseTableView alloc]initWithFrame:CGRectZero delegate:self ftype:5];
                [self.view addSubview:_myJuancleTablview];
                [_myJuancleTablview mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(_menu.mas_bottom);
                    if (@available(iOS 11.0, *)) {
                        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(47);
                        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
                        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
                        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
                    }else{
                        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight+47, 0, 0, 0));
                    }
                }];
            }
        }
            break;
        case 3:
        {
            [self setHiddenNoWithTable];
            if (_mySpecialTablview) {
                [_mySpecialTablview setHidden:NO];
            }else{
                _mySpecialTablview=[[MyhouseTableView alloc]initWithFrame:CGRectZero delegate:self ftype:6];
                [self.view addSubview:_mySpecialTablview];
                [_mySpecialTablview mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(_menu.mas_bottom);
                    if (@available(iOS 11.0, *)) {
                        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(47);
                        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
                        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
                        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
                    }else{
                        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight+47, 0, 0, 0));
                    }
                }];
            }
        }
            break;
    
        default:
            break;
    }
}
-(void)setHiddenNoWithTable{
    if (_myAricltTablview) {
        if (!_myAricltTablview.hidden) {
            [_myAricltTablview setHidden:YES];
            return;
        }
    }
    
    if (_myShareTablview){
        if (!_myShareTablview.hidden) {
            [_myShareTablview setHidden:YES];
            return;
        }
    }
    
    if (_myJuancleTablview){
        if (!_myJuancleTablview.hidden) {
            [_myJuancleTablview setHidden:YES];
            return;
        }
    }
    if (_mySpecialTablview){
        if (!_mySpecialTablview.hidden) {
            [_mySpecialTablview setHidden:YES];
            return;
        }
    }
}
-(void)tableViewSelecte:(myhousejuancel *)share ftype:(NSInteger)ftype{
    if (ftype==1) {
        ProductInfoViewController *productInfoVc = [[ProductInfoViewController alloc] init];
        productInfoVc.productId = [NSString stringWithFormat:@"%@",@([share.juanid integerValue])];
        [self.navigationController pushViewController:productInfoVc animated:YES];
    }else if (ftype==4){
        OriginalDetailViewController *vc = [[OriginalDetailViewController alloc] initWithOriginalID:share.juanid];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (ftype==5){
        VolumeContentViewController *ductViewC = [[VolumeContentViewController alloc] init];
        ductViewC.juancleid=[share.juanid integerValue];
        ductViewC.type = waresTypeCoupon;
        [self.navigationController pushViewController:ductViewC animated:YES];
    }else if (ftype==6){
        SpecialInfoViewController *specialInfoVC = [[SpecialInfoViewController alloc] initWithSpecialInfo:share.juanid];
        [self.navigationController pushViewController:specialInfoVC animated:YES];
    }

}
@end
