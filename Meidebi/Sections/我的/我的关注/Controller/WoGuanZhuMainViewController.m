//
//  WoGuanZhuMainViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/3/26.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import "WoGuanZhuMainViewController.h"
#import "VTMagic.h"

#import "WoGuanZhuTableViewController.h"

@interface WoGuanZhuMainViewController ()<VTMagicViewDataSource,VTMagicViewDelegate>
{
    VTMagicController *magicController;
    NSArray *menuList;
    
    NSArray *arrstatic;
}
@end

@implementation WoGuanZhuMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我关注的";
    
    [self drawSubview];
}

-(void)drawSubview
{
    menuList = @[@{@"name":@"商品",
                   @"type":@"0"},
                 @{@"name":@"商城",
                   @"type":@"1"},
                 @{@"name":@"标签",
                   @"type":@"2"},
                 @{@"name":@"达人",
                   @"type":@"3"}];
    arrstatic = @[@"WoGuanZhuTableViewController0",@"WoGuanZhuTableViewController1",@"WoGuanZhuTableViewController2",@"WoGuanZhuTableViewController3"];
    
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
    static NSString *itemIdentifier = @"itemIdentifierwoguanzhu";
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
    NSString *gridId = arrstatic[pageIndex];
    WoGuanZhuTableViewController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
    if (!viewController) {
        viewController = [[WoGuanZhuTableViewController alloc] init];
    }
    viewController.specialType = menuList[pageIndex][@"type"];
    
    return viewController;
}
//- (void)magicView:(VTMagicView *)magicView didSelectItemAtIndex:(NSUInteger)itemIndex
//{
//    static NSString *gridId = @"WoGuanZhuTableViewController";
//    WoGuanZhuTableViewController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
//    [viewController reloadDataValue];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
