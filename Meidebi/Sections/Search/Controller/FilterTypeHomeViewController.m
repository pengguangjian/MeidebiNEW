//
//  FilterTypeHomeViewController.m
//  Meidebi
//
//  Created by mdb-admin on 2016/11/21.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "FilterTypeHomeViewController.h"
#import "SearchHomeViewController.h"
#import "FilterTypeHomeSubjectsView.h"
#import "FilterTypeDataController.h"
#import "MDB_UserDefault.h"
#import "SearchMainViewController.h"
#import "HomeNavTitleView.h"
@interface FilterTypeHomeViewController ()
<
FilterTypeHomeSubjectsViewDelegate,
HomeNavTitleViewDelegate
>
@property (nonatomic, strong) FilterTypeHomeSubjectsView *subjectsView;
@property (nonatomic, strong) FilterTypeDataController *dataController;
@property (nonatomic, strong) HomeNavTitleView *homeTitleView;

@end

@implementation FilterTypeHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigation];
    self.automaticallyAdjustsScrollViewInsets=NO;
    _subjectsView = [[FilterTypeHomeSubjectsView alloc] init];
    [self.view addSubview:_subjectsView];
    [_subjectsView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }
    }];
    _subjectsView.delegate = self;
    [self fetchFilterTypeData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setNavigation{
    UIButton* btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame = CGRectMake(0,0,40,44);
    [btnLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_click.png"] forState:UIControlStateHighlighted];
    [btnLeft addTarget:self action:@selector(doClickLeftAction) forControlEvents:UIControlEventTouchUpInside];
    if (@available(iOS 11.0, *)) {
        [btnLeft setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 8)];
    }
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    
    UIBarButtonItem *spaceBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceBar.width = -10;
    self.navigationItem.leftBarButtonItems = @[spaceBar,leftBarButtonItem];
    
    if (@available(iOS 11.0, *)) {
    }
    else
    {
        UIButton* btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
        btnRight.frame = CGRectMake(0,0,20,20);
        
        [btnRight setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 8)];
        
        UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
        
        UIBarButtonItem *spaceBarright = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceBarright.width = -20;
        self.navigationItem.rightBarButtonItems = @[spaceBarright,rightBarButtonItem];
    }
    
    
    
    
    
    
    HomeNavTitleView *viewtemp = [self titleView];
    viewtemp.intrinsicContentSize =  CGSizeMake(self.view.width-90, viewtemp.height);
    self.navigationItem.titleView = viewtemp;
    
    
//    self.navigationItem.titleView = [self titleView];
}

- (HomeNavTitleView *)titleView{
    
    CGRect rect = self.navigationController.navigationBar.bounds;
    HomeNavTitleView *titleView =[[HomeNavTitleView alloc] initWithFrame:CGRectMake(0, rect.origin.y, self.view.width-90, rect.size.height)];///self.navigationController.navigationBar.bounds
    [titleView setBackgroundColor:self.navigationController.view.backgroundColor];
    titleView.delegate = self;
    titleView.searchHotKeyWord = kDefaultHotSearchStr;
    if (_hotSearchStr) {
        titleView.searchHotKeyWord = _hotSearchStr;
    }
    [_homeTitleView setbackColor:RGBAlpha(245, 245, 245, 0.7)];
    
    
//    HomeNavTitleView *titleView =[[HomeNavTitleView alloc] initWithFrame:self.navigationController.navigationBar.bounds];
//    [titleView setBackgroundColor:self.navigationController.view.backgroundColor];
//    titleView.delegate = self;
//    _homeTitleView = titleView;
//    titleView.searchHotKeyWord = kDefaultHotSearchStr;
//    if (_hotSearchStr) {
//        titleView.searchHotKeyWord = _hotSearchStr;
//    }
    return titleView;
}

- (void)doClickLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)fetchFilterTypeData{
    [self.dataController requestFilterTypeDataWithView:_subjectsView
                                              callback:^(NSError *error, BOOL state, NSString *describle) {
                                                  if (state) {
                                                      [_subjectsView bindFilterTypeData:self.dataController.resultArray];
                                                  }else{
                                                      [MDB_UserDefault showNotifyHUDwithtext:describle inView:_subjectsView];
                                                  }
    }];
}
#pragma mark - HomeNavTitleViewDelegate
- (void)titleViewDidClickSearchWithHotWord:(NSString *)keyword{
    SearchHomeViewController *searchVc = [[SearchHomeViewController alloc] init];
    if (![keyword isEqualToString:kDefaultHotSearchStr]) {
        searchVc.hotSearchStr = keyword;
    }
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchVc];
    [self presentViewController:nav animated:NO completion:nil];
}

#pragma mark - FilterTypeHomeSubjectsViewDelegate
- (void)resultFilterTypes:(NSArray *)types{
    UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchMainViewController *searchM=[story instantiateViewControllerWithIdentifier:@"com.mdb.SearchMainView.ViewController"];
    searchM.searchContents = types;
    [self.navigationController pushViewController:searchM animated:YES];
}

#pragma mark - setters and getters
- (FilterTypeDataController *)dataController{
    if (!_dataController) {
        _dataController = [[FilterTypeDataController alloc] init];
    }
    return _dataController;
}

@end
