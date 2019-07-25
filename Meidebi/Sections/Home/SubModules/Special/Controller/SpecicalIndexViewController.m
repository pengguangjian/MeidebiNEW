//
//  SpecicalIndexViewController.m
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/8/22.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "SpecicalIndexViewController.h"
#import "NJScrollTableView.h"
#import "SpecialTableViewController.h"
#import "SpecialInfoViewController.h"
#import "HomeViewModel.h"
#import "SpecialDataController.h"
#import "MDB_UserDefault.h"
#import "VTMagic.h"
#import "ShowActiveViewController.h"
#import "SVModalWebViewController.h"
static NSString * const kMenuTitle = @"name";
static NSString * const kMenuType = @"type";

@interface SpecicalIndexViewController ()
<
VTMagicViewDataSource,
VTMagicViewDelegate,
SpecialTableViewControllerDelegate
>
@property (nonatomic, strong) VTMagicController *magicController;
@property (nonatomic, strong) SpecialDataController *datacontroller;
@property (nonatomic, strong) NSArray *menuList;
@end

@implementation SpecicalIndexViewController

#pragma mark - def

#pragma mark - override

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"热门专题";
    [self setupSubviews];
}

#pragma mark - private method
- (void)setupSubviews{
    [self addChildViewController:self.magicController];
    [self.view addSubview:_magicController.view];
    [_magicController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }
    }];
    [_magicController.magicView reloadData];
}

#pragma mark - events

#pragma mark - VTMagicViewDataSource
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
    NSMutableArray *titles = [NSMutableArray array];
    for (NSDictionary *dict in self.menuList) {
        if (dict[kMenuTitle]) {
            [titles addObject:dict[kMenuTitle]];
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
    static NSString *gridId = @"relate.identifier";
    SpecialTableViewController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
    if (!viewController) {
        viewController = [[SpecialTableViewController alloc] init];
    }
    viewController.specialType = self.menuList[pageIndex][kMenuType];
    viewController.delegate = self;
    return viewController;
}

#pragma mark - SpecialTableViewControllerDelegate
- (void)tableviewDidClickCellWithSpecialID:(NSString *)specialID{
    SpecialInfoViewController *specialInfoVc = [[SpecialInfoViewController alloc] initWithSpecialInfo:specialID];
    [self.navigationController pushViewController:specialInfoVc animated:YES];
}

- (void)tableviewDidClickCellWithTBSpecialContent:(NSString *)content{
    UIStoryboard *mainbord=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ShowActiveViewController *showAct=[mainbord instantiateViewControllerWithIdentifier:@"com.mbd.ShowActiveViewC"];
    showAct.url=[NSString nullToString:content];
    showAct.title= @"专题详情";
    showAct.external = YES;
    [self.navigationController pushViewController:showAct animated:YES];
}


#pragma mark - getter / setter
- (VTMagicController *)magicController {
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.view.translatesAutoresizingMaskIntoConstraints = NO;
        _magicController.magicView.navigationColor = [UIColor whiteColor];
        _magicController.magicView.sliderColor = [UIColor colorWithHexString:@"#F35D00"];
        _magicController.magicView.itemScale = 1;
        _magicController.magicView.itemSpacing = 40;
        _magicController.magicView.navigationColor = [UIColor whiteColor];
        _magicController.magicView.layoutStyle = VTLayoutStyleDefault;
        _magicController.magicView.switchStyle = VTSwitchStyleStiff;
        _magicController.magicView.navigationHeight = 50.f;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
    }
    return _magicController;
}

- (SpecialDataController *)datacontroller{
    if (!_datacontroller) {
        _datacontroller = [[SpecialDataController alloc] init];
    }
    return _datacontroller;
}

- (NSArray *)menuList{
    if (!_menuList) {
        _menuList = @[@{kMenuTitle:@"美妆",
                        kMenuType:@"2"},
                      @{kMenuTitle:@"女装",
                        kMenuType:@"5"},
                      @{kMenuTitle:@"服饰鞋包",
                        kMenuType:@"6"},
                      @{kMenuTitle:@"家居用品",
                        kMenuType:@"7"},
                      @{kMenuTitle:@"数码家电",
                        kMenuType:@"8"},
                      @{kMenuTitle:@"男装",
                        kMenuType:@"9"},
                      @{kMenuTitle:@"母婴",
                        kMenuType:@"4"},
                      @{kMenuTitle:@"食品",
                        kMenuType:@"11"},
                      @{kMenuTitle:@"家装",
                        kMenuType:@"12"}];

    }
    return _menuList;
}

@end
