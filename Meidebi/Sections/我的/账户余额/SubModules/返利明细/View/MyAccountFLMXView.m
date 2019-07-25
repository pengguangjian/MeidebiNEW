//
//  MyAccountFLMXView.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/7/11.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import "MyAccountFLMXView.h"
#import "MDB_UserDefault.h"
#import "MenuView.h"
#import "MyAccountOrderListViewController.h"

@interface MyAccountFLMXView ()<MenuDelegate>
{
    
    MenuView *menuview;
    
    UIView *viewnowday;
    UIView *viewlastday;
}
@end

@implementation MyAccountFLMXView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self drawUI];
    }
    return self;
}

-(void)drawUI
{
    UIScrollView *scvback = [[UIScrollView alloc] init];
    [self addSubview:scvback];
    [scvback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.offset(0);
        make.width.offset(kMainScreenW);
    }];
//    [scvback setShowsVerticalScrollIndicator:NO];
    
    UIView *viewnowyg = [[UIView alloc] init];
    [scvback addSubview:viewnowyg];
    [viewnowyg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.width.offset(kMainScreenW/2.0);
        make.top.offset(30);
    }];
    [self drawitemView:viewnowyg andtitel:@"本月有效返利" andValue:@"￥1000.00"];
    
    
    UIView *viewlastyg = [[UIView alloc] init];
    [scvback addSubview:viewlastyg];
    [viewlastyg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewnowyg.mas_right);
        make.width.offset(kMainScreenW/2.0);
        make.top.equalTo(viewnowyg);
    }];
    [self drawitemView:viewlastyg andtitel:@"上月有效返利" andValue:@"￥1000.00"];
    
    
    UIView *viewnow = [[UIView alloc] init];
    [scvback addSubview:viewnow];
    [viewnow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewnowyg);
        make.width.equalTo(viewnowyg);
        make.top.equalTo(viewnowyg.mas_bottom).offset(20);
    }];
    [self drawitemView:viewnow andtitel:@"本月预估返利" andValue:@"￥1000.00"];
    
    UIView *viewlast = [[UIView alloc] init];
    [scvback addSubview:viewlast];
    [viewlast mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewnow.mas_right);
        make.width.equalTo(viewnow);
        make.top.equalTo(viewnow);
    }];
    [self drawitemView:viewlast andtitel:@"累计返利" andValue:@"￥1000.00"];
    
    
    UIView *viewddmx = [[UIView alloc] init];
    [viewddmx setBackgroundColor:RGB(245, 244, 245)];
    [scvback addSubview:viewddmx];
    [viewddmx mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.width.offset(kMainScreenW);
        make.top.equalTo(viewlast.mas_bottom).offset(30);
        make.height.offset(50);
    }];
    [viewddmx setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapddmx = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ddmxAction)];
    [viewddmx addGestureRecognizer:tapddmx];
    UILabel *lbddmx = [[UILabel alloc] init];
    [lbddmx setText:@"订单明细"];
    [lbddmx setTextAlignment:NSTextAlignmentLeft];
    [lbddmx setTextColor:RGB(20, 20, 20)];
    [lbddmx setFont:[UIFont systemFontOfSize:14]];
    [viewddmx addSubview:lbddmx];
    [lbddmx mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(viewddmx);
        make.left.offset(20);
        make.width.offset(150);
    }];
    UIImageView *imgvnext = [[UIImageView alloc] init];
    [imgvnext setImage:[UIImage imageNamed:@"dingdan_address_next"]];
    [viewddmx addSubview:imgvnext];
    [imgvnext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewddmx).offset(-20);
        make.centerY.equalTo(viewddmx);
        make.size.sizeOffset(CGSizeMake(18, 18));
    }];
    
    ///
    menuview = [[MenuView alloc]initWithFrame:CGRectMake(0, 100, kMainScreenW, 47) titles:[NSArray arrayWithObjects:@"今日",@"昨日", nil] delegat:self];
    [scvback addSubview:menuview];
    [menuview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.width.offset(kMainScreenW);
        make.top.equalTo(viewddmx.mas_bottom).offset(20);
        make.height.offset(47);
    }];
    
    viewnowday = [[UIView alloc] init];
    [scvback addSubview: viewnowday];
    [viewnowday mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(menuview);
        make.top.equalTo(menuview.mas_bottom);
    }];
    [self drawDayMoney:viewnowday];
    
    viewlastday = [[UIView alloc] init];
    [scvback addSubview: viewlastday];
    [viewlastday mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(menuview);
        make.top.equalTo(menuview.mas_bottom);
    }];
    [self drawDayMoney:viewlastday];
    [viewlastday setHidden:YES];
    [scvback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(viewnowday.mas_bottom);
    }];
}


-(void)drawDayMoney:(UIView *)view
{
    
    UIView *viewyg = [[UIView alloc] init];
    [view addSubview:viewyg];
    [viewyg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.width.offset(kMainScreenW/3.0);
        make.top.offset(30);
    }];
    [self drawitemView:viewyg andtitel:@"预估收入" andValue:@"￥1000.00"];
    
    UIView *viewjs = [[UIView alloc] init];
    [view addSubview:viewjs];
    [viewjs mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewyg.mas_right);
        make.width.offset(kMainScreenW/3.0);
        make.top.equalTo(viewyg);
    }];
    [self drawitemView:viewjs andtitel:@"结算收入" andValue:@"￥1000.00"];
    
    UIView *viewnumber = [[UIView alloc] init];
    [view addSubview:viewnumber];
    [viewnumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewjs.mas_right);
        make.width.offset(kMainScreenW/3.0);
        make.top.equalTo(viewyg);
    }];
    [self drawitemView:viewnumber andtitel:@"付款笔数" andValue:@"10"];
    
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(viewnumber.mas_bottom).offset(20);
    }];
    
}




-(void)drawitemView:(UIView *)view andtitel:(NSString *)title andValue:(NSString *)value
{
    
    UILabel *lbtitle = [[UILabel alloc] init];
    [lbtitle setText:title];
    [lbtitle setTextAlignment:NSTextAlignmentCenter];
    [lbtitle setTextColor:RGB(150, 150, 150)];
    [lbtitle setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbtitle];
    [lbtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.offset(0);
        make.height.offset(30);
        make.width.equalTo(view);
    }];
    
    UILabel *lbvalue = [[UILabel alloc] init];
    [lbvalue setText:value];
    [lbvalue setTextAlignment:NSTextAlignmentCenter];
    [lbvalue setTextColor:RGB(0, 0, 0)];
    [lbvalue setFont:[UIFont boldSystemFontOfSize:18]];
    [view addSubview:lbvalue];
    [lbvalue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(lbtitle.mas_bottom);
        make.height.offset(30);
        make.width.equalTo(view);
    }];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lbvalue.mas_bottom);
    }];
}


-(void)ddmxAction
{
 
    MyAccountOrderListViewController *mvc = [[MyAccountOrderListViewController alloc] init];
    [self.viewController.navigationController pushViewController:mvc animated:YES];
    
}

#pragma mark - MenuDelegate
-(void)MenuSelect:(MenuView *)menu index:(NSInteger)selectIndex title:(NSString *)title
{
    if(selectIndex==0)
    {
        [viewlastday setHidden:YES];
        [viewnowday setHidden:NO];
    }
    else
    {
        [viewlastday setHidden:NO];
        [viewnowday setHidden:YES];
    }
    
}


@end
