//
//  MyGoodsCouponViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/12/24.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "MyGoodsCouponViewController.h"
#import "VTMagic.h"

#import "MyGoodsCouponTableViewController.h"

#import "DaiGouGuiZheViewController.h"

@interface MyGoodsCouponViewController ()<VTMagicViewDataSource,VTMagicViewDelegate>
{
    VTMagicController *magicController;
    NSArray *menuList;
}


@end

@implementation MyGoodsCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品券";
    [self drawrightButton];
    
    [self drawSubview];
    
}

-(void)drawrightButton
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [negativeSpacer setWidth:-7];
    UIButton *butright=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 65, 44)];
    [butright addTarget:self action:@selector(rightBarBut) forControlEvents:UIControlEventTouchUpInside];
    [butright setTitle:@"使用说明" forState:UIControlStateNormal];
    [butright setTitleColor:RGB(114, 114, 114) forState:UIControlStateNormal];
    [butright.titleLabel setFont:[UIFont systemFontOfSize:13]];
    
    UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithCustomView:butright];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,rightBar];
    
}

-(void)rightBarBut
{
    
    DaiGouGuiZheViewController *dvc = [[DaiGouGuiZheViewController alloc] init];
    dvc.strtitle = @"商品券说明";
    dvc.strurl = WenZheng_ALL_rol;
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:@"coupon_xpln" forKey:@"key"];
    dvc.dicpush = dicpush;
    [self.navigationController pushViewController:dvc animated:YES];
}

-(void)drawSubview
{
    menuList = @[@{@"name":@"未使用",
                   @"type":@"1"},
                 @{@"name":@"已使用",
                   @"type":@"2"},
                 @{@"name":@"已失效",
                   @"type":@"3"}];
    
    magicController = [[VTMagicController alloc] init];
    magicController.view.translatesAutoresizingMaskIntoConstraints = NO;
    magicController.magicView.navigationColor = [UIColor whiteColor];
    magicController.magicView.sliderColor = [UIColor colorWithHexString:@"#F35D00"];
    magicController.magicView.itemScale = 1;
    magicController.magicView.itemSpacing = 40;
    magicController.magicView.navigationColor = [UIColor whiteColor];
    magicController.magicView.layoutStyle = VTLayoutStyleDivide;
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
    static NSString *gridId = @"MyGoodsCouponTableViewController";
    MyGoodsCouponTableViewController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
    if (!viewController) {
        viewController = [[MyGoodsCouponTableViewController alloc] init];
    }
    viewController.specialType = menuList[pageIndex][@"type"];
    return viewController;
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
