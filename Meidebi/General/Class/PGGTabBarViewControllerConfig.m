//
//  PGGTabBarViewControllerConfig.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/6/7.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "PGGTabBarViewControllerConfig.h"
@import Foundation;
@import UIKit;
@interface PGGBaseNavigationController : UINavigationController
@end
@implementation PGGBaseNavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
    
    // 修改tabBra的frame
    CGRect frame = self.tabBarController.tabBar.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
    self.tabBarController.tabBar.frame = frame;
}
@end


#import "MainSpotViewController.h"
#import "OneUserViewController.h"
#import "HomeViewController.h"
#import "OriginalHomeViewController.h"
//#import "PlusButtonSubclass.h"
#import "FindCouponIndexViewController.h"

#import "DaiGouHomeViewController.h"

#import <CoreSpotlight/CoreSpotlight.h>


@interface PGGTabBarViewControllerConfig ()

///页面
@property (nonatomic , retain) NSArray *arrVC;
///选中后的图片
@property (nonatomic , retain) NSMutableArray *arrSelectimg;
///默认图片
@property (nonatomic , retain) NSMutableArray *arrnomimg;
///按钮标题
@property (nonatomic , readwrite) NSMutableArray *arrbttitle;
///选中的字体颜色
@property (nonatomic , retain) UIColor *colorSelect;
///默认颜色
@property (nonatomic , retain) UIColor *colornomo;
///当前选中的是那个按钮
@property (nonatomic , retain) UIButton *btnowselect;


@property (nonatomic , retain) NSMutableArray *arrallbt;

@end

@implementation PGGTabBarViewControllerConfig
@synthesize viewTabBar;

//数组数据和颜色
-(void)writeData
{
    self.arrVC = [self PGGviewControllers];
    self.arrbttitle = [[NSMutableArray alloc]initWithObjects:@"首页",@"搜券",@"代购",@"原创",@"我的", nil];
    self.colornomo = [UIColor grayColor];
    self.colorSelect = [UIColor colorWithHexString:@"#faa159"];
    self.arrSelectimg = [[NSMutableArray alloc]initWithObjects:@"home_select",@"findcoupon_select",@"yijiandaigou_select",@"original_select",@"user_select", nil];
    self.arrnomimg = [[NSMutableArray alloc]initWithObjects:@"home_normal",@"findcoupon_normal",@"yijiandaigou_normal",@"original_normal",@"user_normal", nil];
}

- (NSArray *)PGGviewControllers {
    
    UIStoryboard *Oneselfboard = [UIStoryboard storyboardWithName:@"Oneself" bundle:nil];
    OneUserViewController *UserViewController=[Oneselfboard instantiateViewControllerWithIdentifier:@"com.mdb.OneUserViewC"];
    
    /////
    DaiGouHomeViewController *daigouViewController = [[DaiGouHomeViewController alloc] init];
    
    
    OriginalHomeViewController *ShareViewController = [[OriginalHomeViewController alloc] init];
    FindCouponIndexViewController *findCouponViewController = [[FindCouponIndexViewController alloc] init];
    
    HomeViewController *homeViewController = [[HomeViewController alloc] init];
    
    
    
    ///这里占用了部分cup20%
    PGGBaseNavigationController *firstNavigationController = [[PGGBaseNavigationController alloc]
                                                   initWithRootViewController:homeViewController];

    PGGBaseNavigationController *secondNavigationController = [[PGGBaseNavigationController alloc]
                                                    initWithRootViewController:findCouponViewController];

    PGGBaseNavigationController *thirdNavigationController = [[PGGBaseNavigationController alloc]
                                                   initWithRootViewController:daigouViewController];


    PGGBaseNavigationController *fourthNavigationController = [[PGGBaseNavigationController alloc]
                                                    initWithRootViewController:ShareViewController];

    PGGBaseNavigationController *fiveNavigationController = [[PGGBaseNavigationController alloc]
                                                  initWithRootViewController:UserViewController];
    
    
    
    
    
    NSMutableArray *arrtempdata = [NSMutableArray new];
    [arrtempdata addObject:[self dictiaozhuanitem:@[@"海淘",@"海外购"] andident:@"com.meidebi.iPhone.haitao"]];
    
    [arrtempdata addObject:[self dictiaozhuanitem:@[@"优惠",@"省钱",@"全球购",@"打折",@"猫实惠",@"直邮"] andident:@"com.meidebi.iPhone.home"]];
    
    [arrtempdata addObject:[self dictiaozhuanitem:@[@"9块9"] andident:@"com.meidebi.iPhone.home99"]];
    
    [arrtempdata addObject:[self dictiaozhuanitem:@[@"原创"] andident:@"com.meidebi.iPhone.yuanchuang"]];
    
    [arrtempdata addObject:[self dictiaozhuanitem:@[@"代购",@"拼单"] andident:@"com.meidebi.iPhone.daigou"]];
    
    [arrtempdata addObject:[self dictiaozhuanitem:@[@"搜券"] andident:@"com.meidebi.iPhone.souquan"]];
    
    
    [arrtempdata addObject:[self dictiaozhuanitem:@[@"家居日用",@"数码家电",@"美妆个护",@"鞋包配饰"] andident:@"com.meidebi.iPhone.blsearch"]];
    
    [arrtempdata addObject:[self dictiaozhuanitem:@[@"食品保健",@"母婴玩具",@"钟表配饰",@"运动户外"] andident:@"com.meidebi.iPhone.blsaixuansearch"]];
    
    
    [arrtempdata addObject:[self dictiaozhuanitem:@[@"lookfantastic中",@"lookfantastic英",@"unineed",@"feelunique",@"perfume´s club"] andident:@"com.meidebi.iPhone.dgshangjialiebiao"]];
    
    
    @try {
        NSMutableArray *seachableItems = [NSMutableArray new];
        for(NSDictionary *dic in arrtempdata)
        {
            NSString *strident = [NSString nullToString:[dic objectForKey:@"identifier"]];
            NSArray *arrtitl = [dic objectForKey:@"title"];
            int itemp = 0;
            for(NSString *strt in arrtitl)
            {
                NSString *strtemp = [NSString stringWithFormat:@"%@%d",strident,itemp];
                CSSearchableItem *item = [self setitemValue:strt andidentifier:strtemp];
                [seachableItems addObject:item];
                itemp++;
            }
        }
        
        [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:seachableItems completionHandler:^(NSError * _Nullable error) {
            
        }];
    } @catch (NSException *exception) {

    } @finally {

    }

    
    
    
    
    
    /**
     * 以下两行代码目的在于手动设置让TabBarItem只显示图标，不显示文字，并让图标垂直居中。
     * 等效于在 `-tabBarItemsAttributesForController` 方法中不传 `CYLTabBarItemTitle` 字段。
     * 更推荐后一种做法。
     */
    //tabBarController.imageInsets = UIEdgeInsetsMake(4.5, 0, -4.5, 0);
    //tabBarController.titlePositionAdjustment = UIOffsetMake(0, MAXFLOAT);
//    NSArray *viewControllers = @[
//                                 homeViewController,
//                                 findCouponViewController,
//                                 daigouViewController,
//                                 ShareViewController,
//                                 UserViewController
//                                 ];
    NSArray *viewControllers = @[
                                 firstNavigationController,
                                 secondNavigationController,
                                 thirdNavigationController,
                                 fourthNavigationController,
                                 fiveNavigationController
                                 ];
    
    return viewControllers;
}

-(NSMutableDictionary *)dictiaozhuanitem:(NSArray *)arr andident:(NSString *)strident
{
    
    NSMutableDictionary *dicitemtemp = [NSMutableDictionary new];
    [dicitemtemp setObject:arr forKey:@"title"];
    [dicitemtemp setObject:strident forKey:@"identifier"];
    return dicitemtemp;
}

-(CSSearchableItem *)setitemValue:(NSString *)title andidentifier:(NSString *)identifier
{
    CSSearchableItemAttributeSet *attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:@"views"];
    attributeSet.title = title;
    attributeSet.contentType = @"测试";
    UIImage *thumbImage = [UIImage imageNamed:[NSString stringWithFormat:@"icon120.png"]];
    attributeSet.thumbnailData = UIImagePNGRepresentation(thumbImage);//beta 1 there is a bug
    CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:identifier                                                                                                                                                                                                                                      domainIdentifier:@"com.meidebi.iPhone"                                                                                                                                                                                  attributeSet:attributeSet];
    return item;
}

- (void)setTabBarItem:(UITabBarItem *)tabbarItem
                title:(NSString *)title
            titleSize:(CGFloat)size
        titleFontName:(NSString *)fontName
        selectedImage:(NSString *)selectedImage
   selectedTitleColor:(UIColor *)selectColor
          normalImage:(NSString *)unselectedImage
     normalTitleColor:(UIColor *)unselectColor
{
    
    //设置图片
    tabbarItem = [tabbarItem initWithTitle:title image:[[UIImage imageNamed:unselectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    tabbarItem.imageInsets = UIEdgeInsetsMake(0, -10, -6, -10);
    if(title.length==0)
    {
        tabbarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    }
    
    // S未选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:unselectColor,NSFontAttributeName:[UIFont fontWithName:fontName size:size]} forState:UIControlStateNormal];
    
    // 选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:selectColor,NSFontAttributeName:[UIFont fontWithName:fontName size:size]} forState:UIControlStateSelected];
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self writeData];

    for(int i = 0 ; i <_arrVC.count ; i++)
    {
        UIViewController *homeVC=_arrVC[i];
        [self setTabBarItem:homeVC.tabBarItem
                      title:self.arrbttitle[i]
                  titleSize:11.0
              titleFontName:@"HeiTi SC"
              selectedImage:self.arrSelectimg[i]
         selectedTitleColor:self.colorSelect
                normalImage:self.arrnomimg[i]
           normalTitleColor:self.colornomo];
    }
    self.viewControllers = _arrVC;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectSetItem:) name:@"tabbarselectother" object:nil];
    
    UIImage *i = [UIImage imageNamed:@"write_back_tabbar.png"];
    
    [self.tabBar setBackgroundImage:i];
    
    [self.tabBar setShadowImage:i];
    
    UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(0, -1, self.tabBar.width, 1)];
    [viewline setBackgroundColor:RGB(245, 245, 245)];
    [self.tabBar addSubview:viewline];
    self.tabBar.layer.shadowColor = RGB(0, 0, 0).CGColor;
    // 设置阴影偏移量
    self.tabBar.layer.shadowOffset = CGSizeMake(0,-2);
    // 设置阴影透明度
    self.tabBar.layer.shadowOpacity = 0.2;
    // 设置阴影半径
    self.tabBar.layer.shadowRadius = 4;
    
    
    
    
}


-(void)selectSetItem:(NSNotification *)notifi
{
    NSInteger itemp = [notifi.object integerValue];
    if(itemp<0)
    {
        itemp=0;
    }
    if(itemp>=self.arrVC.count)return;
    self.selectedIndex = itemp;
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
