//
//  JiangJiaZhiBoViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/3/25.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import "JiangJiaZhiBoViewController.h"

#import "VTMagic.h"

#import "JiangJiaZhiBoTableViewController.h"
#import "ProductInfoViewController.h"

@interface JiangJiaZhiBoViewController ()<VTMagicViewDataSource,VTMagicViewDelegate,JiangJiaZhiBoTableViewDelegate>
{
    VTMagicController *magicController;
    NSArray *menuList;
}
@end

@implementation JiangJiaZhiBoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"降价直播";
    
    
    [self drawSubview];
    
}

-(void)drawSubview
{
    
    menuList = @[@{@"name":@"最新",
                   @"type":@"0"},
                 @{@"name":@"最优惠",
                   @"type":@"1"}];
    
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
    static NSString *itemIdentifier = @"itemIdentifierjiangjiazhibo";
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
    NSString *gridId = @"itemIdentifierjiangjiazhibo";
    JiangJiaZhiBoTableViewController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
    if (!viewController) {
        viewController = [[JiangJiaZhiBoTableViewController alloc] init];
    }
    NSString *strtype = menuList[pageIndex][@"type"];;
    viewController.isvery = NO;
    if(strtype.integerValue == 1)
    {
        viewController.isvery = YES;
    }
    [viewController setDelegate:self];
    
    return viewController;
}


-(void)selectItem:(NSString *)strid
{
    ProductInfoViewController *pvc = [[ProductInfoViewController alloc] init];
    pvc.productId =strid;
    [self.navigationController pushViewController:pvc animated:YES];
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
