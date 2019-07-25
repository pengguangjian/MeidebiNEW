//
//  MyAccountOrderListViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/7/10.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import "MyAccountOrderListViewController.h"
#import "VTMagic.h"
#import "MyAccountOrderListTableViewController.h"

@interface MyAccountOrderListViewController ()<VTMagicViewDataSource,VTMagicViewDelegate>
{
 
    VTMagicController *magicController;
    NSArray *menuList;
    
    NSMutableDictionary *dicSonListValue;
    
    NSMutableArray *arrallvc;
}
@end

@implementation MyAccountOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单明细";
    
    [self drawSubview];
}

-(void)drawSubview
{
    menuList = @[@{@"name":@"所有订单",
                   @"type":@"0"},
                 @{@"name":@"有效订单",
                   @"type":@"1"},
                 @{@"name":@"失效订单",
                   @"type":@"2"}];
    arrallvc = [NSMutableArray new];
    for(int i = 0; i< menuList.count; i++)
    {
        MyAccountOrderListTableViewController *viewController =  [[MyAccountOrderListTableViewController alloc] init];
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
//            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
            make.edges.equalTo(self.view);
            
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
    
    
    MyAccountOrderListTableViewController *viewController = arrallvc[pageIndex];
    viewController.type = menuList[pageIndex][@"type"];
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
