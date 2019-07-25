//
//  MyOrderMainViewController.m
//  Meidebi
//  我的订单
//  Created by mdb-losaic on 2018/4/4.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "MyOrderMainViewController.h"

#import "VTMagic.h"

#import "MyOrderTableViewController.h"

#import "DaiGouZhiFuViewController.h"

#import "PaySuccessViewController.h"

#import "GoodsCarViewController.h"

#import "ProductInfoViewController.h"

#import "MyOrderSearchViewController.h"

@interface MyOrderMainViewController ()<VTMagicViewDataSource,VTMagicViewDelegate>
{
    VTMagicController *magicController;
    NSArray *menuList;
    
    NSMutableDictionary *dicSonListValue;
    
    NSMutableArray *arrallvc;
}

@end

@implementation MyOrderMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    
    [self drawSubview];
    
    [self setNavBarBackBtn];
}

- (void)setNavBarBackBtn{
    
    UIButton* btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
    btnLeft.frame = CGRectMake(0,0,44,44);
    [btnLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_click.png"] forState:UIControlStateHighlighted];
    [btnLeft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnLeft addTarget:self action:@selector(doClickBackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    
    
    UIButton* btnright1 = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
    [btnright1 setImage:[UIImage imageNamed:@"daigousuosuohui"] forState:UIControlStateNormal];
    [btnright1 setImage:[UIImage imageNamed:@"daigousuosuohui"] forState:UIControlStateHighlighted];
    [btnright1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnright1 addTarget:self action:@selector(rightanvAction) forControlEvents:UIControlEventTouchUpInside];
    [btnright1 setTag:2];
    UIBarButtonItem* rightBarButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:btnright1];
    
    self.navigationItem.rightBarButtonItems = @[rightBarButtonItem1];
    
}

-(void)rightanvAction
{
    MyOrderSearchViewController *vc = [[MyOrderSearchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (void)doClickBackAction{
    
    NSArray *arrvc = self.navigationController.viewControllers;
    for(UIViewController *vc in arrvc)
    {
        if([vc isKindOfClass:[ProductInfoViewController class]])
        {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
        
    }
    for(UIViewController *vc in arrvc)
    {
        if([vc isKindOfClass:[GoodsCarViewController class]])
        {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}





-(void)drawSubview
{
    menuList = @[@{@"name":@"全部",
                   @"type":@"0"},
                 @{@"name":@"待付款",
                   @"type":@"1"},
                 @{@"name":@"未成团",
                   @"type":@"2"},
                 @{@"name":@"待下单",
                   @"type":@"3"},
                 @{@"name":@"待发货",
                   @"type":@"4"},
                 @{@"name":@"已发货",
                   @"type":@"5"},
                 @{@"name":@"已完成",
                   @"type":@"6"},
                 @{@"name":@"已取消",
                   @"type":@"7"}];
    arrallvc = [NSMutableArray new];
    for(int i = 0; i< menuList.count; i++)
    {
        MyOrderTableViewController *viewController =  [[MyOrderTableViewController alloc] init];
        [arrallvc addObject:viewController];
    }
    
    dicSonListValue = [NSMutableDictionary new];
    magicController = [[VTMagicController alloc] init];
    magicController.view.translatesAutoresizingMaskIntoConstraints = NO;
    magicController.magicView.navigationColor = [UIColor whiteColor];
    magicController.magicView.sliderColor = [UIColor colorWithHexString:@"#F35D00"];
    magicController.magicView.itemScale = 1;
    magicController.magicView.itemSpacing = 40;
    magicController.magicView.navigationColor = [UIColor whiteColor];
    magicController.magicView.layoutStyle = VTLayoutStyleDefault;
    magicController.magicView.switchStyle = VTSwitchStyleStiff;
    magicController.magicView.navigationHeight = 50.f;
    magicController.magicView.dataSource = self;
    magicController.magicView.delegate = self;
    
    [self addChildViewController:magicController];
    [self.view addSubview:magicController.view];
    [magicController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }
    }];
    
    
    [magicController.magicView reloadData];
    
}

#pragma mark - VTMagicViewDataSource
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
    NSMutableArray *titles = [NSMutableArray array];
    for (NSDictionary *dict in menuList) {
        if (dict[@"name"]) {
            [titles addObject:dict[@"name"]];
        }
    }
    return titles.mutableCopy;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:[UIColor colorWithHexString:@"#444444"] forState:UIControlStateNormal];
        [menuItem setTitleColor:[UIColor colorWithHexString:@"#F35D00"] forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont systemFontOfSize:13.f];
    }
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
//    NSString *gridId = [NSString stringWithFormat:@"MyOrderTableViewController%@",menuList[pageIndex][@"type"]];
//    static NSString *gridId = @"MyOrderTableViewController";
//    MyOrderTableViewController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
//    if (!viewController) {
//        viewController = [[MyOrderTableViewController alloc] init];
//    }
    
    
    MyOrderTableViewController *viewController = arrallvc[pageIndex];
    viewController.specialType = menuList[pageIndex][@"type"];
    return viewController;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
