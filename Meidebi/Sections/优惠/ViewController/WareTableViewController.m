//
//  WareTableViewController.m
//  Meidebi
//  搜索还在使用
//  Created by mdb-admin on 16/5/30.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "WareTableViewController.h"
#import "ContentCell.h"
#import "ImagePlayerView.h"
#import "MDB_UserDefault.h"
#import <MJRefresh/MJRefresh.h>
#import "GMDCircleLoader.h"
static NSString *cellIdentifier = @"cell";

@interface WareTableViewController ()
<
ImagePlayerViewDelegate
>
{
    float flasty;
}
@property (nonatomic, strong) WareDataController *dataController;
@property (nonatomic, strong) GMDCircleLoader *hudView;
@property (nonatomic, assign) NSInteger lastContentOffset;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *topSectionContairView;
@property (nonatomic, strong) ImagePlayerView *imagePlayerView;
@property (nonatomic, assign) CGFloat dynamicHight;
@property (nonatomic, assign) NSInteger scorllDownSum;
@property (nonatomic, assign) NSInteger scorllUpSum;
@property (nonatomic, strong) UIButton *btzhiding;
@end


@implementation WareTableViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    flasty = 0.0;
    [self.tableView registerClass:[ContentCell class] forCellReuseIdentifier:cellIdentifier];
    [self setExtraCellLineHidden:self.tableView];
    [self tableViewAddRefersh];
    if (_tableVcType != WaresTableVcSearch) {
        _tableVcType = WaresTableVcUnknown;
        [self.dataController requestCacheWithCallback:^(NSError *error, BOOL state, NSString *describle) {
            if (!error) {
                [self.tableView reloadData];
            }
        }];
    }
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
   
    
    _btzhiding = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50*kScale, 50*kScale)];
    [_btzhiding.layer setMasksToBounds:YES];
    [_btzhiding.layer setCornerRadius:_btzhiding.height/2.0];
    [_btzhiding setRight:self.view.width-10];
    [_btzhiding setBottom:self.view.height+60];
    [_btzhiding setImage:[UIImage imageNamed:@"zhiding_list"] forState:UIControlStateNormal];
    [_btzhiding setBackgroundColor:RGB(248, 248, 248)];
    [self.view addSubview:_btzhiding];
    [_btzhiding addTarget:self action:@selector(topScrollAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)tableViewAddRefersh{
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self reloadTableViewDataSource];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self footReloadTableViewDateSource];
    }];

}


- (void)loadBannerData{
    [self setupBannerView];
    [self.dataController requestBannerDataWithCallback:^(NSError *error, BOOL state, NSString *describle) {
        [self updateBannerData];
    }];
}

- (void)updateData{
    [self fetchSubjectData];
}

- (void)updateBannerData{
    if (self.dataController.requestBannerResults.count == 0) {
        CGRect newFrame = _imagePlayerView.frame;
        newFrame.size.height = 0;
        _imagePlayerView.frame = newFrame;
        
        CGRect headerViewFrame = self.headerView.frame;
        headerViewFrame.size.height = 75;
        self.headerView.frame = headerViewFrame;
        [self.tableView beginUpdates];
        [self.tableView setTableHeaderView:self.headerView];
        [self.tableView endUpdates];
        
    }else{
        [_imagePlayerView setDelagateCount:self.dataController.requestBannerResults.count delegate:self];
    }
}

- (void)fetchSubjectData{
    _hudView = [GMDCircleLoader setOnView:self.navigationController.view withTitle:nil animated:YES];
    [self.dataController requestSubjectDataWithType:_requestType
                                   WaresTableVcType:_tableVcType
                                           wareType:_wareType
                                               cats:_cates
                                             siteid:_siteid
                                             InView:nil
                                           callback:^(NSError *error, BOOL state, NSString *describle) {
                                               [GMDCircleLoader hideFromView:self.navigationController.view animated:YES];
                                               if (self.dataController.requestResults.count > 0) {
                                                   [self.tableView reloadData];
                                                   [self scrollTop];
                                                   
                                                   if([self.delegate respondsToSelector:@selector(tabviewShopData:)])
                                                   {
                                                       NSDictionary *dic = @{@"followed":[NSString nullToString:self.dataController.followed],@"id":[NSString nullToString:self.dataController.did]};
                                                       [self.delegate tabviewShopData:dic];
                                                   }
                                                   
                                               }else{
                                                   if ([self.delegate respondsToSelector:@selector(tableviewDidLoadDataFailure:)]) {
                                                       [self.delegate tableviewDidLoadDataFailure:self];
                                                   }
                                               }
                                           }];
}

- (void)setupBannerView{
    [self setupTableViewHeaderView];
}

- (void)setupTableViewHeaderView{
    
    _imagePlayerView=[[ImagePlayerView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame),self.dynamicHight)];
    [_imagePlayerView setDelagateCount:self.dataController.requestBannerResults.count delegate:self];
    [self.headerView addSubview:_imagePlayerView];
    
    CGRect headerViewFrame = self.headerView.frame;
    headerViewFrame.size.height = self.dynamicHight + 75;
    self.headerView.frame = headerViewFrame;

    _topSectionContairView = ({
        UIView *view = [UIView new];
        [self.headerView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_imagePlayerView.mas_bottom).offset(2);
            make.left.right.bottom.equalTo(self.headerView);
        }];
        view.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3"];
        view;
    });
    [self setupHeaderView];
    
     self.tableView.tableHeaderView = self.headerView;
}

- (void)setupHeaderView{
    UIView *topLineView = [[UIView alloc] init];
    [_topSectionContairView addSubview:topLineView];
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_topSectionContairView);
        make.height.offset(1);
    }];
    topLineView.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
    
    UIView *bottomLineView = [[UIView alloc] init];
    [_topSectionContairView addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_topSectionContairView);
        make.top.equalTo(_topSectionContairView.mas_bottom).offset(-1);
        make.height.offset(1);
    }];
    topLineView.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
    
    NSString *outsideTitleStr = @"海淘直邮";
    NSMutableAttributedString *outsideAttributeStr = [[NSMutableAttributedString alloc] initWithString:outsideTitleStr];
    [outsideAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ff6b58"] range:NSMakeRange(0, 2)];
    [outsideAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#121212"] range:NSMakeRange(2, 2)];
    UIView *haitaoView = [[UIView alloc] init];
    [_topSectionContairView addSubview:haitaoView];
    haitaoView.backgroundColor = [UIColor whiteColor];
    
    UIControl *haitaoContentControl = [self setupFuntionControlOfTitle:outsideAttributeStr
                                                              subTitle:@"直邮就是这么爽"
                                                                 image:[UIImage imageNamed:@"outside_shopping"]];
    [haitaoView addSubview:haitaoContentControl];
     haitaoContentControl.tag = 1;
    [haitaoContentControl addTarget:self action:@selector(responsControlEvents:) forControlEvents:UIControlEventTouchUpInside];

    NSString *cheapTitleStr = @"白菜价";
    NSMutableAttributedString *cheapAttributeStr = [[NSMutableAttributedString alloc] initWithString:cheapTitleStr];
    [cheapAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#121212"] range:NSMakeRange(0, cheapTitleStr.length)];
    UIView *baicaiView = [[UIView alloc] init];
    [_topSectionContairView addSubview:baicaiView];
    baicaiView.backgroundColor = [UIColor whiteColor];
    UIControl *baicaiContentControl = [self setupFuntionControlOfTitle:cheapAttributeStr
                                                              subTitle:nil
                                                                 image:[UIImage imageNamed:@"cheap"]];
    [baicaiView addSubview:baicaiContentControl];
     baicaiContentControl.tag = 2;
    [baicaiContentControl addTarget:self action:@selector(responsControlEvents:) forControlEvents:UIControlEventTouchUpInside];
    

    
    NSString *couponLiveTitleStr = @"优惠券直播";
    NSMutableAttributedString *ouponLiveAttributeStr = [[NSMutableAttributedString alloc] initWithString:couponLiveTitleStr];
    [ouponLiveAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#666666"] range:NSMakeRange(0, couponLiveTitleStr.length)];
    UIView *couponLiveView = [[UIView alloc] init];
    [_topSectionContairView addSubview:couponLiveView];
    couponLiveView.backgroundColor = [UIColor whiteColor];
   
    
    UIControl *couponLiveContentControl = [self setupFuntionControlOfTitle:ouponLiveAttributeStr
                                                              subTitle:nil
                                                                 image:[UIImage imageNamed:@"juan_live"]];
    [couponLiveView addSubview:couponLiveContentControl];
     couponLiveContentControl.tag = 3;
    [couponLiveContentControl addTarget:self action:@selector(responsControlEvents:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [haitaoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topSectionContairView.mas_left);
        make.top.equalTo(_topSectionContairView.mas_top).offset(2);
        make.bottom.equalTo(_topSectionContairView.mas_bottom).offset(-5);
        make.width.offset(BOUNDS_WIDTH*0.55);
    }];
    
    [couponLiveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(haitaoView.mas_top);
        make.right.equalTo(_topSectionContairView.mas_right);
        make.left.equalTo(haitaoView.mas_right).offset(3);
        make.bottom.equalTo(haitaoView.mas_centerY).offset(-1.5);

    }];
    
    [baicaiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(couponLiveView.mas_left);
        make.top.equalTo(haitaoView.mas_centerY).offset(1.5);
        make.right.equalTo(couponLiveView.mas_right);
        make.bottom.equalTo(haitaoView.mas_bottom);
    }];
    
    [haitaoContentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(haitaoView);
    }];
    [couponLiveContentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(couponLiveView);
    }];
    [baicaiContentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(baicaiView.mas_centerY);
        make.left.equalTo(couponLiveContentControl.mas_left);
    }];
    
    
}

- (UIControl *)setupFuntionControlOfTitle:(NSAttributedString *)title
                                 subTitle:(NSString *)subTitle
                                    image:(UIImage *)image{
    UIControl *control = [[UIControl alloc] init];
    control.backgroundColor = [UIColor whiteColor];
    
    UIImageView *flagImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        [control addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(control.mas_centerY);
            make.left.equalTo(control.mas_left).offset(10);
            if (subTitle) {
                make.size.mas_equalTo(CGSizeMake(38, 38));
            }else{
                make.size.mas_equalTo(CGSizeMake(20, 20));
            }
        }];
        imageView.image = image;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView;
    });
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [control addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(flagImageView.mas_right).offset(10);
        if (subTitle) {
            make.bottom.equalTo(flagImageView.mas_centerY);
        }else{
            make.centerY.equalTo(flagImageView.mas_centerY);
        }
    }];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.attributedText = title;
    
    UILabel *subtitleLabel = [[UILabel alloc] init];
    [control addSubview:subtitleLabel];
    [subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_left);
        make.top.equalTo(flagImageView.mas_centerY).offset(3);
    }];
    subtitleLabel.font = [UIFont systemFontOfSize:12];
    subtitleLabel.text = subTitle;
    subtitleLabel.textColor = [UIColor colorWithHexString:@"#707070"];
    
    [control mas_makeConstraints:^(MASConstraintMaker *make) {
        if (subTitle) {
            make.right.equalTo(subtitleLabel.mas_right);
        }else{
            make.right.equalTo(titleLabel.mas_right);
        }
        make.bottom.equalTo(flagImageView.mas_bottom);
    }];
    
    return control;
}


- (void)responsControlEvents:(UIControl *)control{
    if ([self.delegate respondsToSelector:@selector(tableViewDidSelectHeaderBarView:)]) {
        [self.delegate tableViewDidSelectHeaderBarView:[NSString stringWithFormat:@"%@",@(control.tag)]];
    }
}


- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)scrollTop{
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

- (void)reloadTableViewDataSource{
    [self.dataController lastNewPageDataWithCallback:^(NSError *error, BOOL state, NSString *describle) {
        if (!error) {
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)footReloadTableViewDateSource{
    [self.dataController nextPageDataWithCallback:^(NSError *error, BOOL state, NSString *describle) {
        if (!error) {
            [self.tableView reloadData];
        }
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataController.requestResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell fetchCellData:self.dataController.requestResults[indexPath.row]];
    return cell;
}

#pragma mark - UITableView Delegate methods

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row>self.dataController.requestResults.count-1) return;
    if ([self.delegate respondsToSelector:@selector(tableViewSelecte:withTableVc:)]) {
        [self.delegate tableViewSelecte:self.dataController.requestResults[indexPath.row] withTableVc:self];
    }
    if ([self.delegate respondsToSelector:@selector(tableViewSelecte:)]) {
        [self.delegate tableViewSelecte:self.dataController.requestResults[indexPath.row]];
    }
//    [_delegate tableViewSelecte:self.dataController.requestResults[indexPath.row] withTableVc:self];
    [tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125;
}

#pragma mark - UIScorllViewDelegate
//-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    _lastContentOffset = scrollView.contentOffset.y;
//}
//
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    //向上滚动
//    if (scrollView.contentOffset.y<_lastContentOffset)
//    {   _scorllDownSum = 0;
//        _scorllUpSum ++;
//        if ([self.delegate respondsToSelector:@selector(tableViewScrollDirectionUp)] && _scorllUpSum == 1) {
//            [self.delegate tableViewScrollDirectionUp];
//        }
//    }else if (scrollView.contentOffset.y>_lastContentOffset){
//        _scorllDownSum ++;
//        _scorllUpSum = 0;
//        //向下滚动
//        if ([self.delegate respondsToSelector:@selector(tableViewScrollDirectionDown)] && _scorllDownSum == 1) {
//            [self.delegate tableViewScrollDirectionDown];
//        }
//    }
//    
//}


#pragma mark ImagePlayerView ImageplayerViewDelegate

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index{
    
    NSArray *banners = self.dataController.requestBannerResults;
    if (banners.count>index) {
        [[MDB_UserDefault defaultInstance]setViewImageWithURL:[NSURL URLWithString:[NSString nullToString:banners[index][@"imgurl"]]] placeholder:[UIImage imageNamed:@"Active.jpg"] UIimageview:imageView];
    }

}

-(void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index{
    NSDictionary * dict = self.dataController.requestBannerResults[index];
    if ([self.delegate respondsToSelector:@selector(bannerViewDidSelectWithUrl:title:)]) {
        [self.delegate bannerViewDidSelectWithUrl:[NSString nullToString:dict[@"link"]]
                                            title:[NSString nullToString:dict[@"title"]]];
    }
}

#pragma mark - getter and setters

- (WareDataController *)dataController{
    if (!_dataController) {
        _dataController = [[WareDataController alloc] init];
    }
    return _dataController;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 0)];
    }
    return _headerView;
}

- (CGFloat)dynamicHight{
    if (!_dynamicHight) {
        _dynamicHight = CGRectGetWidth(self.view.frame)*0.34;
    }
    return _dynamicHight;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y<flasty)
    {
//        [UIView animateWithDuration:0.3 animations:^{
//            [_btzhiding setBottom:scrollView.contentOffset.y+scrollView.height-80];
//        }];
        [_btzhiding setBottom:scrollView.contentOffset.y+scrollView.height-60];
    }
    else
    {
        [_btzhiding setBottom:scrollView.contentOffset.y+scrollView.height+60];
    }
    
    
    flasty = scrollView.contentOffset.y;
}

-(void)topScrollAction
{
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

@end
