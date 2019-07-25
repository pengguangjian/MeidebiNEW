//
//  MyJiangLiMingXiView.m
//  Meidebi
//  奖励明细
//  Created by mdb-losaic on 2018/7/18.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "MyJiangLiMingXiView.h"

#import "MDB_UserDefault.h"
#import "MyJiangLiMingXiTableViewCell.h"

#import "MyJiangLiDataController.h"

#import <MJRefresh.h>

@interface MyJiangLiMingXiView ()<UITableViewDelegate,UITableViewDataSource>
{
    NSTimer *toptimer;
    UITableView *tabView;
    MyJiangLiDataController *datacontrol;
    NSMutableArray *arrlistdata;
    int inowpage;
    
}
@end


@implementation MyJiangLiMingXiView

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
        [self drawSubview];
        datacontrol = [[MyJiangLiDataController alloc] init];
        inowpage = 1;
        [self getdata];
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
        
        [[NSRunLoop mainRunLoop] addTimer:toptimer forMode:NSRunLoopCommonModes];
        
    }
    
    tabView = [[UITableView alloc] init];
    [self addSubview:tabView];
    [tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewtop.mas_bottom);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
    [tabView setDelegate:self];
    [tabView setDataSource:self];
    [tabView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        inowpage = 1;
        [self getdata];
    }];
    tabView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        inowpage++;
        [self getdata];
    }];
    
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

-(void)getdata
{
    
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:[NSString nullToString: [MDB_UserDefault defaultInstance].usertoken] forKey:@"userkey"];
    [dicpush setObject:[NSNumber numberWithInt:inowpage] forKey:@"page"];
    [dicpush setObject:@"20" forKey:@"pagesize"];
    
    [datacontrol requestDetailDataInView:self dicpush:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
       if(state)
       {
           if(inowpage==1)
           {
               arrlistdata = [NSMutableArray new];
           }
           
           if([datacontrol.arrdetail isKindOfClass:[NSArray class]])
           {
               [arrlistdata addObjectsFromArray:datacontrol.arrdetail];
           }
           [tabView reloadData];
           if(tabView.mj_header.refreshing)
           {
               [tabView.mj_header endRefreshing];
           }
           if(tabView.mj_footer.refreshing)
           {
               [tabView.mj_footer endRefreshing];
           }
       }
    }];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrlistdata.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strcell = @"MyJiangLiMingXiTableViewCell";
    
    MyJiangLiMingXiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strcell];
    
    if(!cell)
    {
        cell = [[MyJiangLiMingXiTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strcell];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if(arrlistdata.count>indexPath.row)
    {
        [cell bindValue:arrlistdata[indexPath.row]];
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 55;
}





-(void)dealloc
{
    [toptimer invalidate];
    toptimer = nil;
}

@end
