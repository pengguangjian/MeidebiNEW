//
//  SearchMainViewController.m
//  Meidebi
//
//  Created by 杜非 on 15/2/3.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import "SearchMainViewController.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"
#import "ProductInfoViewController.h"
#import "SearchViewController.h"
#import "NJScrollTableView.h"
#import "WareTableViewController.h"

#import "Article.h"

#import "WoGuanZhuDataController.h"

#import "VKLoginViewController.h"

@interface SearchMainViewController ()
<
ScrollTabViewDataSource,
WaresTableViewDelegate,
UIAlertViewDelegate
>{
    BOOL isloadlist;
}
@property (nonatomic, strong) UISegmentedControl *segementControl;
@property (nonatomic, assign) int         isHot;
@property (nonatomic, strong) NJScrollTableView *scrollTableView;
@property (nonatomic, strong) NSMutableArray *waresTables;
@property (nonatomic, strong) WareTableViewController *wareSimpleTableVc;
@property (nonatomic, strong) NSString *siteID;

///商城是否关注
@property (nonatomic, assign) BOOL isselectsc;
///商城id
@property (nonatomic, strong) NSString *scid;
@property (nonatomic, strong) WoGuanZhuDataController *datacontrolgz;
@end

@implementation SearchMainViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    _isHot = 1;
    UIView *allvi=[[UIView alloc]initWithFrame:CGRectMake(0, 111.0, 30, 30)];
    [allvi setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:allvi];
    
    if(_searchContents.count>0)
    {
        if ([_siteID isEqualToString:@""])
        {
            [self rightBarButton];
        }
        else
        {
            [self setrightButton:NO];
        }
    }
    else
    {
        [self rightBarButton];
    }
    
    
    
    UIButton* btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
     btnLeft.frame = CGRectMake(0,0,44,44);
    [btnLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_click.png"] forState:UIControlStateHighlighted];
    [btnLeft addTarget:self action:@selector(doClickLeftAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnLeft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem=leftBarButtonItem;
    
}

-(void)setrightButton:(BOOL)isselect
{
    UIButton* btnRight = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor
    [btnRight.titleLabel setFont:[UIFont systemFontOfSize:14]];
    if(isselect)
    {
        //        [btnRight setImage:[UIImage imageNamed:@"guanzhubaoliao_yes"] forState:UIControlStateNormal];
        //        [btnRight setImage:[UIImage imageNamed:@"guanzhubaoliao_yes"] forState:UIControlStateHighlighted];
        [btnRight setTitle:@"已关注" forState:UIControlStateNormal];
        [btnRight setTitleColor:RGB(200, 200, 200) forState:UIControlStateNormal];
    }
    else
    {
        //        [btnRight setImage:[UIImage imageNamed:@"guanzhubaoliao_no"] forState:UIControlStateNormal];
        //        [btnRight setImage:[UIImage imageNamed:@"guanzhubaoliao_yes"] forState:UIControlStateHighlighted];
        [btnRight setTitle:@"+关注" forState:UIControlStateNormal];
        [btnRight setTitleColor:RadMenuColor forState:UIControlStateNormal];
    }
    
    [btnRight setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnRight addTarget:self action:@selector(doClickrightAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}


#pragma mark - 关注
-(void)doClickrightAction
{
    if ([MDB_UserDefault getIsLogin] == NO)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请登录后再试"
                                                           delegate:self
                                                  cancelButtonTitle:Nil
                                                  otherButtonTitles:@"登录",@"取消", nil];
        [alertView setTag:110];
        [alertView show];
        
        return;
        
    }
    
    NSString *strurl = @"";
    if(_isselectsc==NO)
    {
        strurl = URL_FollowAddList;
    }
    else
    {
        strurl = URL_FollowDelList;
        return;
    }
    if([NSString nullToString:_scid].length==0)
    {
        return;
    }
    NSDictionary *parmaters = @{@"id":[NSString nullToString:_scid],
                                @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],
                                @"type":@"site"
                                };
    if(_datacontrolgz==nil)
    {
        _datacontrolgz = [WoGuanZhuDataController new];
    }
    [_datacontrolgz requestWoGuanZhuIsCancleDataInView:self.view url:strurl dicpush:parmaters Callback:^(NSError *error, BOOL state, NSString *describle) {
        if(state)
        {
            if(_isselectsc)
            {
                _isselectsc = NO;
            }
            else
            {
                _isselectsc = YES;
            }
            [self setrightButton:_isselectsc];
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
        }
    }];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(isloadlist)
    {
        [_wareSimpleTableVc updateData];
        isloadlist = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)doClickLeftAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupMenuView{
   
    WareTableViewController *artTable = [[WareTableViewController alloc] init];
    artTable.title = @"全部";
    artTable.wareType = WareTypeAll;
    artTable.tableVcType = WaresTableVcSearch;
    artTable.cates = [NSString stringWithFormat:@"%@",@(_cats)];
    artTable.delegate = self;
    [self.waresTables addObject:artTable];
    
    WareTableViewController *artGNTable = [[WareTableViewController alloc] init];
    artGNTable.title = @"国内";
    artGNTable.wareType = WareTypeGuoNei;
    artGNTable.tableVcType = WaresTableVcSearch;
    artGNTable.cates = [NSString stringWithFormat:@"%@",@(_cats)];
    artGNTable.delegate = self;
    [self.waresTables addObject:artGNTable];
    
    WareTableViewController *artHTTable = [[WareTableViewController alloc] init];
    artHTTable.title = @"海淘";
    artHTTable.wareType = WareTypeHaiTao;
    artHTTable.tableVcType = WaresTableVcSearch;
    artHTTable.cates = [NSString stringWithFormat:@"%@",@(_cats)];
    artHTTable.delegate = self;
    [self.waresTables addObject:artHTTable];
    
    WareTableViewController *artTMTable = [[WareTableViewController alloc] init];
    artTMTable.title = @"猫实惠";
    artTMTable.wareType = WareTypeTianMao;
    artTMTable.tableVcType = WaresTableVcSearch;
    artTMTable.cates = [NSString stringWithFormat:@"%@",@(_cats)];
    artTMTable.delegate = self;
    [self.waresTables addObject:artTMTable];
     _scrollTableView = [[NJScrollTableView alloc] initWithFrame:CGRectMake(0, kTopHeight, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-kTopHeight)];
    _scrollTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollTableView];
    _scrollTableView.dataSource = self;
    [_scrollTableView buildUI];
    [_scrollTableView selectTabWithIndex:0 animate:NO];
}

-(void)setCentloview:(UIView *)view{
    
    UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2.0-22.0, self.view.frame.size.height/2.0-60, 44, 44)];
    imageV.image=[UIImage imageNamed:@"ic_search_result_empty"];
    [view addSubview:imageV];
    
    UILabel *labl=[[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/2.0, self.view.frame.size.width, 40)];
    [labl setTextAlignment:NSTextAlignmentCenter];
    labl.text=@"没搜到你想要的，换个商城试试吧";
    labl.font=[UIFont systemFontOfSize:12.0];
    [labl setNumberOfLines:2];
    [view addSubview:labl];
}

#pragma mark - WaresTableViewDelegate
- (void)tableViewSelecte:(Article *)art{
    art.isSelected = YES;
    ProductInfoViewController *productInfoVc = [[ProductInfoViewController alloc] init];
    productInfoVc.theObject = art;
    [self.navigationController pushViewController:productInfoVc animated:YES];
}

- (void)tableviewDidLoadDataFailure:(WareTableViewController *)vc{
    [self setCentloview:vc.view];
    
}

#pragma mark - ScorllTableViewDelegate
- (NSUInteger)numberOfPagers:(NJScrollTableView *)view{
    return self.waresTables.count;
}

- (UITableViewController *)scrollTableViewOfPagers:(NJScrollTableView *)view
                                     indexOfPagers:(NSUInteger)index{
    [self.waresTables[index] updateData];
    return self.waresTables[index];
}

#pragma mark - WaresTableViewDelegate///商城标签信息数据
-(void)tabviewShopData:(NSDictionary *)value
{
    if(_searchContents.count>0&& _siteID.length>0)
    {
        _isselectsc = [[value objectForKey:@"followed"] boolValue];
        _scid = [NSString nullToString:[value objectForKey:@"id"]];
        
        [self setrightButton:_isselectsc];
    }
    
}


-(void)rightBarButton{
    _segementControl=[[UISegmentedControl alloc]initWithItems:@[@"精华",@"最新"]];
    [_segementControl setFrame:CGRectMake(0, 20, 80, 28)];//80,32
    _segementControl.selectedSegmentIndex=0;
    [_segementControl setTintColor:RadMenuColor];
    
    [_segementControl.layer setMasksToBounds:YES];
    [_segementControl.layer setCornerRadius:4.0];
    [_segementControl.layer setBorderWidth:1.0];
    [_segementControl.layer setBorderColor:RadMenuColor.CGColor];
    
    if (_isHot==0) {
        _segementControl.selectedSegmentIndex=1;
    }else{
        _segementControl.selectedSegmentIndex=0;
    }
    UIBarButtonItem *rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:_segementControl];
    [_segementControl addTarget:self
                         action:@selector(segebtnValueChanged:)
               forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                  target:nil
                                                                                  action:nil];
    spaceBarItem.width = -5;
    self.navigationItem.rightBarButtonItems = @[spaceBarItem,rightBarButtonItem];
}

-(void)leftBarBut{
    UIStoryboard *Mainboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchViewController *searchV=[Mainboard instantiateViewControllerWithIdentifier:@"com.mdb.SearchView.ViewController"];
    [self.navigationController pushViewController:searchV animated:YES];
}
-(UIBarButtonItem *)leftBarButton{
    UIButton *butleft=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [butleft addTarget:self action:@selector(leftBarBut) forControlEvents:UIControlEventTouchUpInside];
    [butleft setBackgroundImage:[UIImage imageNamed:@"serch.png"] forState:UIControlStateNormal];
    [butleft setBackgroundImage:[UIImage imageNamed:@"serch_click.png"] forState:UIControlStateHighlighted];
    UIBarButtonItem *leftBar=[[UIBarButtonItem alloc]initWithCustomView:butleft];
    
    return leftBar;
}

-(void)segebtnValueChanged:(UISegmentedControl *)sender{
    
    if (sender.selectedSegmentIndex==0) {
        _isHot=1;
        if (_vcType == SearchMainVcTypeCategory) {
            if(_waresTables.count==0)
            {
                _wareSimpleTableVc.requestType = WareRequestTypeEssence;
                [_wareSimpleTableVc updateData];
            }
            else
            {
                for (WareTableViewController *waresTableVc in _waresTables) {
                    waresTableVc.requestType = WareRequestTypeEssence;
                    [waresTableVc updateData];
                }
            }
            
        }else if (_vcType == SearchMainVcTypeHot){
            _wareSimpleTableVc.requestType = WareRequestTypeEssence;
            [_wareSimpleTableVc updateData];
        }
    }else if(sender.selectedSegmentIndex==1){
        _isHot=0;
        
        if (_vcType == SearchMainVcTypeCategory) {
            if(_waresTables.count==0)
            {
                _wareSimpleTableVc.requestType = WareRequestTypeNew;
                [_wareSimpleTableVc updateData];
            }
            else
            {
                for (WareTableViewController *waresTableVc in _waresTables) {
                    waresTableVc.requestType = WareRequestTypeNew;
                    [waresTableVc updateData];
                }
            }
            
        }else if (_vcType == SearchMainVcTypeHot){
            _wareSimpleTableVc.requestType = WareRequestTypeNew;
            [_wareSimpleTableVc updateData];
        }
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        VKLoginViewController* theViewController= [[VKLoginViewController alloc] init];
        [self.navigationController pushViewController:theViewController animated:YES ];
        isloadlist = YES;
    }
}
#pragma mark - getters and setters

- (NSMutableArray *)waresTables{
    if (!_waresTables) {
        _waresTables = [NSMutableArray array];
    }
    return _waresTables;
}

- (void)setSearchContents:(NSArray *)searchContents{
    _searchContents = searchContents;
//    NSString *cateName = @"";
//    NSString *cateID = @"";
//    NSString *siteID = @"";
//    if(searchContents.count>0)
//    {
//        if([searchContents[0] isKindOfClass:[NSDictionary class]])
//        {
//            id obj = searchContents[0];
//            if ([obj[@"dependentPathSection"] integerValue] == 0) {
//                cateName = obj[@"itemName"];
//                cateID = obj[@"itemID"];
//            }
//            if ([obj[@"dependentPathSection"] integerValue] == 1) {
//                siteID = obj[@"itemID"];
//                cateName = obj[@"itemName"];
//            }
//        }
//    }
    __block NSString *cateName = @"";
    __block NSString *cateID = @"";
    __block NSString *siteID = @"";
    [searchContents enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj[@"dependentPathSection"] integerValue] == 0) {
            cateName = obj[@"itemName"];
            cateID = obj[@"itemID"];
        }
        if ([obj[@"dependentPathSection"] integerValue] == 1) {
            siteID = obj[@"itemID"];
            cateName = obj[@"itemName"];
        }
    }];
    _cats = cateID.intValue;
    _siteID = siteID;
    _catName = cateName;
    
    if ([_siteID isEqualToString:@""]) {
        self.title=[NSString stringWithFormat:@"筛选\"%@\"",_catName];
        [self setupMenuView];
    }else{
        
        self.title=[NSString stringWithFormat:@"%@",_catName];
        _isHot = 1;
        _wareSimpleTableVc = [[WareTableViewController alloc] init];
        _wareSimpleTableVc.wareType = WareTypeAll;
        _wareSimpleTableVc.tableVcType = WaresTableVcSearch;
        _wareSimpleTableVc.siteid = [NSString stringWithFormat:@"%@",siteID];
        _wareSimpleTableVc.cates = [NSString nullToString:cateID];
        _wareSimpleTableVc.delegate = self;
        _wareSimpleTableVc.view.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64);
        _wareSimpleTableVc.requestType = WareRequestTypeNew;
        [_wareSimpleTableVc updateData];
        [self.view addSubview:_wareSimpleTableVc.view];
    }
}

- (void)setVcType:(SearchMainVcType)vcType{
    _vcType = vcType;
    if (_vcType == SearchMainVcTypeCategory) {
        self.title=[NSString stringWithFormat:@"筛选\"%@\"",_catName];
        [self setupMenuView];
    }else if (_vcType == SearchMainVcTypeHot){
        self.title=[NSString stringWithFormat:@"%@",_catName];
        _isHot = 1;
        _wareSimpleTableVc = [[WareTableViewController alloc] init];
        _wareSimpleTableVc.wareType = WareTypeAll;
        _wareSimpleTableVc.tableVcType = WaresTableVcSearch;
        _wareSimpleTableVc.siteid = [NSString stringWithFormat:@"%@",@(_cats)];
        _wareSimpleTableVc.delegate = self;
        _wareSimpleTableVc.view.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64);
        [_wareSimpleTableVc updateData];
        [self.view addSubview:_wareSimpleTableVc.view];
    }
}
@end
