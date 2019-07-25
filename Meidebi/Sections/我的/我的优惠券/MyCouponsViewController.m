//
//  MyCouponsViewController.m
//  Meidebi
//
//  Created by 杜非 on 15/2/12.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import "MyCouponsViewController.h"
#import "MyCouponsTableView.h"
#import "MenuView.h"
#import "VolumeContentViewController.h"
#import "MDB_UserDefault.h"

@interface MyCouponsViewController ()<MenuDelegate,MyCouponsTableViewDelegate>
@property(nonatomic,strong)MenuView     *menu;
@end

@implementation MyCouponsViewController{
    MyCouponsTableView *_myConpontNewTablview;
    MyCouponsTableView *_myConponOutTablview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的优惠券";
    [self setNavigation];
    _menu=[[MenuView alloc]initWithFrame:CGRectMake(0, kTopHeight,self.view.frame.size.width, 47) titles:@[@"可使用的",@"已过期的"] delegat:self];
    [self.view addSubview:_menu];
    
    UISwipeGestureRecognizer *right=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipes:)];
    right.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:right];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)doClickLeftAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)tableViewSelecte:(Juancle *)share{
    [MDB_UserDefault showNotifyHUDwithtext:@"复制成功" inView:self.view];
  
}
#pragma mark MenuView menuDelegate
-(void)MenuSelect:(MenuView *)menu index:(NSInteger)selectIndex title:(NSString *)title{
    
    switch (selectIndex) {
        case 0:
        {
            [self setHiddenNoWithTable];
            if (_myConpontNewTablview) {
                [_myConpontNewTablview setHidden:NO];
            }else{
                _myConpontNewTablview=[[MyCouponsTableView alloc]initWithFrame:CGRectZero delegate:self istimeOut:NO];
                [self.view addSubview:_myConpontNewTablview];
                [_myConpontNewTablview mas_makeConstraints:^(MASConstraintMaker *make) {
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
            if (_myConponOutTablview) {
                [_myConponOutTablview setHidden:NO];
            }else{
                _myConponOutTablview=[[MyCouponsTableView alloc]initWithFrame:CGRectZero delegate:self istimeOut:YES];
                [self.view addSubview:_myConponOutTablview];
                [_myConponOutTablview mas_makeConstraints:^(MASConstraintMaker *make) {
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
    if (_myConpontNewTablview) {
        if (!_myConpontNewTablview.hidden) {
            [_myConpontNewTablview setHidden:YES];
            return;
        }
    }
    
    if (_myConponOutTablview){
        if (!_myConponOutTablview.hidden) {
            [_myConponOutTablview setHidden:YES];
            return;
        }
    }
  
}

@end
