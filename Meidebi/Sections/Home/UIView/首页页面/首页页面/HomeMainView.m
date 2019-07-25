//
//  HomeMainView.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/21.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "HomeMainView.h"
#import "MenuView.h"

#import "JingXuanView.h"

#import "CheapOrOutsideSubjectsView.h"

#import "CheapOrOutsideDataController.h"

#import "HomePaiHangBangView.h"

#import "HomeGuanZhuDongTaiView.h"

#import "ProductInfoViewController.h"

#import "MDB_UserDefault.h"

@interface HomeMainView ()<
MenuDelegate,
JingXuanViewDelegate,
CheapOrOutsideSubjectsViewDelgate,
HomeGuanZhuDongTaiViewDelegate
>
{
    MenuView *_menu;
    ///精选页面
    JingXuanView *jxView;
    ///海淘直邮页面
    CheapOrOutsideSubjectsView *cooView;
    ///9.9包邮
    CheapOrOutsideSubjectsView *coo99View;
    ///排行榜页面
    HomePaiHangBangView *phbView;
    ///关注动态
    HomeGuanZhuDongTaiView *gzdtView;
    
    ///关注动态红点
    UIView *viewgzRead;
    
}
///海淘数据
@property (nonatomic, strong) CheapOrOutsideDataController *dataController;
///9.9包邮
@property (nonatomic, strong) CheapOrOutsideDataController *data99Controller;

@end

@implementation HomeMainView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
       
        [self setupSubViews];
        
    }
    return self;
}

-(void)setupSubViews
{
    _menu=[[MenuView alloc]initWithFrame:CGRectMake(0, 0,BOUNDS_WIDTH, 47) titles:@[@"精选",@"海淘直邮",@"9.9包邮",@"排行榜",@"关注动态"] delegat:self];
    [self addSubview:_menu];
    
    viewgzRead = [[UIView alloc] initWithFrame:CGRectMake(_menu.width-20, _menu.top+5, 8, 8)];
    [viewgzRead setBackgroundColor:[UIColor redColor]];
    [viewgzRead.layer setMasksToBounds:YES];
    [viewgzRead.layer setCornerRadius:viewgzRead.height/2.0];
    [viewgzRead setHidden:YES];
    [self addSubview:viewgzRead];
    
}


#pragma mark - MenuView
-(void)MenuSelect:(MenuView *)menu index:(NSInteger)selectIndex title:(NSString *)title
{
    switch (selectIndex) {
        case 0:
        {
            if(jxView==nil)
            {
                jxView = [[JingXuanView alloc]initWithFrame:CGRectMake(0, 47, self.width, self.height-47)];
                [jxView setDelegate:self];
                [self addSubview:jxView];
            }
            if(gzdtView == nil)
            {
                gzdtView =[[HomeGuanZhuDongTaiView alloc] initWithFrame:jxView.frame];
                [gzdtView setDelegate:self];
                [self addSubview:gzdtView];
            }
            [jxView setHidden:NO];
            [cooView setHidden:YES];
            [coo99View setHidden:YES];
            [phbView setHidden:YES];
            [gzdtView setHidden:YES];
        }
            break;
        case 1:
        {
            if(cooView == nil)
            {
                cooView =[[CheapOrOutsideSubjectsView alloc] initWithFrame:jxView.frame];
                [cooView setDelegate:self];
                [self addSubview:cooView];
                self.dataController = [[CheapOrOutsideDataController alloc] init];
                [self fetchSubjectData];
            }
            [jxView setHidden:YES];
            [cooView setHidden:NO];
            [coo99View setHidden:YES];
            [phbView setHidden:YES];
            [gzdtView setHidden:YES];
        }
            break;
        case 2:
        {
            if(coo99View == nil)
            {
                coo99View =[[CheapOrOutsideSubjectsView alloc] initWithFrame:jxView.frame];
                [coo99View setDelegate:self];
                [self addSubview:coo99View];
                self.data99Controller = [[CheapOrOutsideDataController alloc] init];
                [self fetchSubjectData];
            }
            [jxView setHidden:YES];
            [cooView setHidden:YES];
            [coo99View setHidden:NO];
            [phbView setHidden:YES];
            [gzdtView setHidden:YES];
        }
            break;
        case 3:
        {
            
            if(phbView == nil)
            {
                phbView =[[HomePaiHangBangView alloc] initWithFrame:jxView.frame];
                [self addSubview:phbView];
            }
            
            [jxView setHidden:YES];
            [cooView setHidden:YES];
            [coo99View setHidden:YES];
            [phbView setHidden:NO];
            [gzdtView setHidden:YES];
        }
            break;
        case 4:
        {
            if(gzdtView == nil)
            {
                gzdtView =[[HomeGuanZhuDongTaiView alloc] initWithFrame:jxView.frame];
                [gzdtView setDelegate:self];
                [self addSubview:gzdtView];
            }
            else
            {
                [gzdtView loadrefdata];
            }
            [jxView setHidden:YES];
            [cooView setHidden:YES];
            [coo99View setHidden:YES];
            [phbView setHidden:YES];
            [gzdtView setHidden:NO];
            [viewgzRead setHidden:YES];
        }
            break;
        default:
            break;
    }
    
    
}

#pragma mark - 关注动态代理
-(void)latesNewsTableViewWihtFirstRow:(NSString *)strvalue
{
    if ([MDB_UserDefault hotLastNewID] == strvalue.integerValue) {
        [viewgzRead setHidden:YES];
    }else{
        [viewgzRead setHidden:NO];
        [MDB_UserDefault setHotLastNewID:strvalue.integerValue];
    }
}

#pragma mark - 精选数据
- (void)bindJinXuanData:(NSDictionary *)dicmodels
{
    [jxView bindData:dicmodels];
}
-(void)bindBanarData:(NSArray *)arrmodels;
{
    [jxView bindBanarData:arrmodels];
}
///精选下拉刷新数据
- (void)bindJinXuanRefData:(NSDictionary *)dicmodels
{
    [jxView bindJinXuanRefData:dicmodels];
}


//////
#pragma mark - 海淘直邮数据
- (void)fetchSubjectData{
    if(_menu.index == 1)
    {
        [self.dataController requestSubjectDataWithType:RequestTypeHaitao
                                                 InView:cooView
                                               callback:^(NSError *error, BOOL state, NSString *describle) {
                                                   if (!error) {
                                                       [self renderSubjectView];
                                                   }
                                               }];
    }
    else if (_menu.index == 2)
    {
        [self.data99Controller requestSubjectDataWithType:RequestTypeBaicai
                                                 InView:coo99View
                                               callback:^(NSError *error, BOOL state, NSString *describle) {
                                                   if (!error) {
                                                       [self renderSubjectView];
                                                   }
                                               }];
    }
    
}

- (void)renderSubjectView{
    if(_menu.index == 1)
    {
        CheapOrOutsideSubjectsViewModel *viewModel = [CheapOrOutsideSubjectsViewModel viewModelWithSubjects:self.dataController.requestResults];
        [cooView bindDataWithViewModel:viewModel];
    }
    else if (_menu.index == 2)
    {
        CheapOrOutsideSubjectsViewModel *viewModel = [CheapOrOutsideSubjectsViewModel viewModelWithSubjects:self.data99Controller.requestResults];
        [coo99View bindDataWithViewModel:viewModel];
    }
    
    
}


#pragma mark - 海淘直邮Delegate
- (void)subjectsView:(CheapOrOutsideSubjectsView *)view didPressCellWithCommodity:(Commodity *)aCommodity
{
    aCommodity.isSelect = YES;
    ProductInfoViewController *productInfoVc = [[ProductInfoViewController alloc] init];
    productInfoVc.theObject = aCommodity;
    [self.viewController.navigationController pushViewController:productInfoVc animated:YES];
}
- (void)subjectsViewWithPullupTableview
{
    if(_menu.index == 1)
    {
        [self.dataController nextPageDataWithCallback:^(NSError *error, BOOL state, NSString *describle) {
            if (!error) {
                [self renderSubjectView];
            }
        }];
    }
    else if (_menu.index == 2)
    {
        [self.data99Controller nextPageDataWithCallback:^(NSError *error, BOOL state, NSString *describle) {
            if (!error) {
                [self renderSubjectView];
            }
        }];
    }
    
}
- (void)subjectsViewWithPullDownTableview
{
    if(_menu.index == 1)
    {
        [self.dataController lastNewPageDataWithCallback:^(NSError *error, BOOL state, NSString *describle) {
            if (!error) {
                [self renderSubjectView];
            }
        }];
    }
    else if (_menu.index == 2)
    {
        [self.data99Controller lastNewPageDataWithCallback:^(NSError *error, BOOL state, NSString *describle) {
            if (!error) {
                [self renderSubjectView];
            }
        }];
    }
    
}

#pragma mark - 精选JingXuanViewDelegate
-(void)banaerSelectAction:(NSInteger)index
{
    [self.delegate HomeMainViewBanaerSelect:index];
}

///分类点击 优惠券 抽奖等
-(void)jingXuanItemSelectAction:(NSInteger)index
{
    [self.delegate HomeMainViewItemSelect:index];
}
///比比活动点击
-(void)jingXuanBiBISelectAction:(NSInteger)index
{
    [self.delegate HomeMainViewBiBiSelect:index];
}
/// 热门推荐点击
- (void)jingXuanHotViewDidClichkCurrentHotWithItem:(HomeHotSticksViewModel *)item
{
    [self.delegate HomeMainViewXuanHotViewDidClichkCurrentHotWithItem:item];
}
///白菜精选点击
- (void)jingXuanbaiCaiDidClichkCurrentHotWithItem:(HomeCheapViewModel *)item
{
    [self.delegate HomeMainViewjingXuanbaiCaiDidClichkCurrentHotWithItem:item];
}
///热门专题
- (void)jingXuansepcialProtalTableViewDidSelectSpecial:(NSString *)specialID
{
    [self.delegate HomeMainViewjingXuansepcialProtalTableViewDidSelectSpecial:specialID];
}
///更多
- (void)jingXuanhomeSepcialProtalViewDidClickMoreBtn
{
    [self.delegate HomeMainViewjingXuanhomeSepcialProtalViewDidClickMoreBtn];
}
///精选列表点击
-(void)jingxuanListCellSelectAction:(Commodity *)item
{
    [self.delegate HomeMainViewjingxuanListCellSelectAction:item];
}
///下拉刷新
-(void)jingxuanHeaderRefAction
{
    [self.delegate HomeMainViewjingxuanHeaderRefAction];
}
@end
