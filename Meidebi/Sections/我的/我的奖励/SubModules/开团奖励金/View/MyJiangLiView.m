//
//  MyJiangLiView.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/7/18.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "MyJiangLiView.h"

#import "MDB_UserDefault.h"

#import "MyJiangLiTableViewCell.h"

#import "MyJiangLiMingXiViewController.h"

@interface MyJiangLiView ()<UITableViewDelegate,UITableViewDataSource>
{
    
    NSTimer *toptimer;
    
    UIView *viewnotValue;
    
    UITableView *tabView;
    
    NSMutableArray *arrListvalue;
    
}

@end

@implementation MyJiangLiView

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
        arrListvalue = [NSMutableArray new];
        [self drawSubview];
    }
    return self;
}


-(void)drawSubview
{
    UIView *viewtop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BOUNDS_WIDTH, 40*kScale)];
    [viewtop setBackgroundColor:RGB(254, 236, 226)];
    [viewtop setClipsToBounds:YES];
    [self addSubview:viewtop];
    
    UILabel *lbtop = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewtop.width, viewtop.height)];
    [lbtop setText:@"抢第一单，并分享朋友圈！赢团长奖励金，每团￥5.00"];
    [lbtop setTextColor:RadMenuColor];
    [lbtop setTextAlignment:NSTextAlignmentCenter];
    [lbtop setFont:[UIFont systemFontOfSize:14]];
    [lbtop setBackgroundColor:RGB(254, 236, 226)];
    [viewtop addSubview:lbtop];
    float flbtopw = [MDB_UserDefault getStrWightFont:lbtop.font str:lbtop.text hight:20].width;
    if(lbtop.width<flbtopw)
    {
        toptimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(toptimer:) userInfo:lbtop repeats:YES];
        [lbtop setWidth:flbtopw];
        [lbtop setLeft:10];
        
        [toptimer setFireDate:[NSDate dateWithTimeIntervalSince1970:[[NSDate date] timeIntervalSince1970]+3]];
        
        _yidongTimer = toptimer;
        
        [[NSRunLoop mainRunLoop] addTimer:toptimer forMode:NSRunLoopCommonModes];
        
        
    }
    
    
    tabView = [[UITableView alloc] init];
    [self addSubview:tabView];
    [tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewtop.mas_bottom);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-40);
    }];
    [tabView setDelegate:self];
    [tabView setDataSource:self];
    [tabView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    UIButton *btbottom = [[UIButton alloc] init];
    [self addSubview:btbottom];
    [btbottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tabView.mas_bottom);
        make.left.right.bottom.equalTo(self);
    }];
    [btbottom setBackgroundColor:RGB(246, 246, 246)];
    [btbottom setTitle:@"奖励明细" forState:UIControlStateNormal];
    [btbottom setTitleColor:RGB(80, 80, 80) forState:UIControlStateNormal];
    [btbottom.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btbottom addTarget:self action:@selector(bottomAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    viewnotValue = [self viewnomoValue:CGRectMake(0, viewtop.bottom, BOUNDS_WIDTH, BOUNDS_HEIGHT-viewtop.bottom)];
    [self addSubview:viewnotValue];
    [viewnotValue setHidden:YES];
    
}

////头部
-(void)drawTabheaderView:(NSDictionary *)dicvalue
{
    float fheight = 75*kScale;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, fheight*2+20)];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UIView *viewback = [[UIView alloc] initWithFrame:CGRectMake(10, 10, view.width-20, fheight*2)];
    [viewback setBackgroundColor:[UIColor whiteColor]];
    viewback.layer.shadowColor = [UIColor blackColor].CGColor;//设置阴影的颜色
    viewback.layer.shadowOpacity = 0.8;//设置阴影的透明度
    viewback.layer.shadowOffset = CGSizeMake(1, 1);//设置阴影的偏移量
    viewback.layer.shadowRadius = 3;//设置阴影的圆角
    [viewback.layer setCornerRadius:8];
    [view addSubview:viewback];
    
    UIView *viewcenter = [[UIView alloc] initWithFrame:CGRectMake(10, 10, view.width-20, fheight*2)];
    [viewcenter setBackgroundColor:[UIColor whiteColor]];
    [viewcenter.layer setCornerRadius:8];
    [viewcenter.layer setMasksToBounds:YES];
    [view addSubview:viewcenter];
    
    
    float fwidth = viewcenter.width/2.0;
    
    
    
    ///
    UIView *viewitem0 = [self drawheaderitem:CGRectMake(0, 0, fwidth, fheight) andtitle:@"累计奖励" andvalue:[NSString nullToString:[NSString stringWithFormat:@"￥%@",[dicvalue objectForKey:@"total_bonus"]]]];
    [viewcenter addSubview:viewitem0];
    
    ///
    UIView *viewitem1 = [self drawheaderitem:CGRectMake(fwidth, 0, fwidth, fheight) andtitle:@"剩余奖励" andvalue:[NSString nullToString:[NSString stringWithFormat:@"￥%@",[dicvalue objectForKey:@"remain_bonus"]]]];
    [viewcenter addSubview:viewitem1];
    
    ///
    UIView *viewitem00 = [self drawheaderitem:CGRectMake(0, fheight, fwidth, fheight) andtitle:@"总开团数" andvalue:[NSString nullToString:[NSString stringWithFormat:@"%@",[dicvalue objectForKey:@"total_num"]]]];
    [viewcenter addSubview:viewitem00];
    
    ///
    UIView *viewitem11 = [self drawheaderitem:CGRectMake(fwidth, fheight, fwidth, fheight) andtitle:@"总成团数" andvalue:[NSString nullToString:[NSString stringWithFormat:@"%@",[dicvalue objectForKey:@"finish_num"]]]];
    [viewcenter addSubview:viewitem11];
    
    
    UIView *viewlienheng = [[UIView alloc] initWithFrame:CGRectMake(0, fheight, viewcenter.width, 1)];
    [viewlienheng setBackgroundColor:RGB(234, 234, 234)];
    [viewcenter addSubview:viewlienheng];
    
    UIView *viewlineshu = [[UIView alloc] initWithFrame:CGRectMake(fwidth, 0, 1, viewcenter.height)];
    [viewlineshu setBackgroundColor:RGB(234, 234, 234)];
    [viewcenter addSubview:viewlineshu];
    
    
    
    [tabView setTableHeaderView:view];
}

-(UIView *)drawheaderitem:(CGRect)rect andtitle:(NSString *)strtitle andvalue:(NSString *)strvalue
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *lbnomo = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.width, 20)];
    [lbnomo setText:strtitle];
    [lbnomo setTextColor:RGB(163, 163, 163)];
    [lbnomo setTextAlignment:NSTextAlignmentCenter];
    [lbnomo setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbnomo];
    
    UILabel *lbvalue = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.width, 30)];
    [lbvalue setText:strvalue];
    [lbvalue setTextColor:RGB(229, 0, 0)];
    [lbvalue setTextAlignment:NSTextAlignmentCenter];
    [lbvalue setFont:[UIFont systemFontOfSize:20]];
    [view addSubview:lbvalue];
    [lbnomo setTop:(view.height-lbnomo.height-lbvalue.height)/2.0];
    [lbvalue setTop:lbnomo.bottom];
    
    return view;
}

#pragma mark - 没得数据展示的页面
-(UIView *)viewnomoValue:(CGRect)rect
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *lbnomo = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.width, 150)];
    [lbnomo setText:@"暂无数据"];
    [lbnomo setTextColor:RGB(60, 60, 60)];
    [lbnomo setTextAlignment:NSTextAlignmentCenter];
    [lbnomo setFont:[UIFont systemFontOfSize:18]];
    [view addSubview:lbnomo];
    
    
    UIButton *btgou = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, view.width*0.5, 50)];
    [btgou setTitle:@"快去下第一单吧" forState:UIControlStateNormal];
    [btgou setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btgou.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [btgou.layer setMasksToBounds:YES];
    [btgou.layer setCornerRadius:3];
    [btgou setBackgroundColor:RadMenuColor];
    [btgou setCenter:CGPointMake(view.width/2.0, 0)];
    [btgou setTop:lbnomo.bottom];
    [btgou addTarget:self action:@selector(gouAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btgou];
    
    
    return view;
}


#pragma makr - 快去下第一单吧
-(void)gouAction
{
    
    [self.viewController.navigationController popViewControllerAnimated:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(dismisAction) userInfo:nil repeats:NO];
}

-(void)dismisAction
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarselectother" object:@"2"];
}


#pragma mark - 奖励明细
-(void)bottomAction
{
    MyJiangLiMingXiViewController *mvc = [[MyJiangLiMingXiViewController alloc] init];
    [self.viewController.navigationController pushViewController:mvc animated:YES];
    
}

#pragma mark - lbtop移动
-(void)toptimer:(NSTimer *)timer
{
    
    UILabel *lb = timer.userInfo;
    
    if(lb.right>0)
    {
        [lb setRight:lb.right-1];
    }
    else
    {
        [lb setLeft:self.width];
    }
}

////header数据
-(void)bindheaderValue:(NSDictionary *)dicvalue
{
    if(![dicvalue isKindOfClass:[NSDictionary class]] || dicvalue.count<3)return;
    [self drawTabheaderView:dicvalue];
    
}
///列表数据
-(void)bindListValue:(NSArray *)arr
{
    if(arrListvalue == nil)
    {
        arrListvalue = [NSMutableArray new];
    }
    
    if([arr isKindOfClass:[NSArray class]])
    {
        [arrListvalue addObjectsFromArray:arr];
        [tabView reloadData];
    }
    
    if(arrListvalue.count==0)
    {
        [viewnotValue setHidden:NO];
    }
    else
    {
        [viewnotValue setHidden:YES];
    }
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrListvalue.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strcell = @"MyJiangLiTableViewCell";
    
    MyJiangLiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strcell];
    
    if(!cell)
    {
        cell = [[MyJiangLiTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strcell];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if(arrListvalue.count>indexPath.row)
    {
        [cell bindValue:arrListvalue[indexPath.row]];
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 120;
}


-(void)dealloc
{
    [toptimer invalidate];
    toptimer = nil;
}
@end
