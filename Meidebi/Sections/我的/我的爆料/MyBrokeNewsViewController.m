//
//  MyBrokeNewsViewController.m
//  Meidebi
//
//  Created by 杜非 on 15/2/9.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import "MyBrokeNewsViewController.h"
#import "NewsTableView.h"
#import "ProductInfoViewController.h"
#import "BrokeHomeViewController.h"
@interface MyBrokeNewsViewController ()<NewsTableViewDelegate>{
    NewsTableView *_newsTableView;
}

@end

@implementation MyBrokeNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的爆料";
//    [self setNavigation];
    _newsTableView=[[NewsTableView alloc]initWithFrame:CGRectZero delegate:self];
    [self.view addSubview:_newsTableView];
    [_newsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }
    }];
    UISwipeGestureRecognizer *right=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipes:)];
    right.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:right];
    [self setupBrokeBtn];
}
-(void)handleSwipes:(UISwipeGestureRecognizer *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupBrokeBtn{
    UIButton *brokeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:brokeBtn];
    [brokeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-48);
        make.left.equalTo(self.view.mas_left).offset(85);
        make.right.equalTo(self.view.mas_right).offset(-85);
        make.height.offset(50);
    }];
    brokeBtn.layer.masksToBounds = YES;
    brokeBtn.layer.cornerRadius = 5.f;
    [brokeBtn setBackgroundColor:[UIColor colorWithHexString:@"#F77D15"]];
    [brokeBtn setTitle:@"我要爆料" forState:UIControlStateNormal];
    brokeBtn.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [brokeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [brokeBtn addTarget:self action:@selector(respondsToBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)respondsToBtnEvent:(UIButton *)sender{
    BrokeHomeViewController *brokeVc = [[BrokeHomeViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:brokeVc animated:YES];
}

-(void)tableViewSelecte:(myBorkeNews *)myBorkNews{
    ProductInfoViewController *productInfoVc = [[ProductInfoViewController alloc] init];
    productInfoVc.productId = [NSString stringWithFormat:@"%@",@([myBorkNews.artid intValue])];
    [self.navigationController pushViewController:productInfoVc animated:YES];

}


@end
