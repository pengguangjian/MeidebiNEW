//
//  OrderLogisticsView.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/9.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "OrderLogisticsView.h"
#import "OrderLogisticsTableViewCell.h"

#import "OrderLogisticsDataController.h"

#import "MDB_UserDefault.h"

#import "UITextView+Placeholder.h"

@interface OrderLogisticsView ()<UITableViewDelegate,UITableViewDataSource>
{
    OrderLogisticsDataController *dataControl;
    
    UITableView *tabview;
    
    NSMutableArray *arrdata;
    
    NSString *strorderno;
    
    NSTimer *toptimer;
    
}
@end


@implementation OrderLogisticsView

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
        
    }
    return self;
}

-(void)bindSubview:(NSString *)strid
{
    if(strid==nil)return;
    if(dataControl==nil)
    {
        dataControl = [[OrderLogisticsDataController alloc] init];
    }
    NSDictionary *dicpush = @{@"order_id":[NSString nullToString:strid],@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    [dataControl requestDGHomeDataInView:self dicpush:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
        NSLog(@"%@",dataControl.dicreuselt);
        if(state)
        {
            [self dataValue:dataControl.dicreuselt];
            /*
             order_exception->code 1  无异常 2  异常 3  异常已处理
             order_exception->msg 异常描述
             */
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self];
        }
        
    }];
    
    
}
///nodestatus >= 11) 到达用户  >= 9) 到达没得比 >= 3) 到达转运公司 >= 1) 商家发货
-(void)drawtabHeaderview:(NSDictionary *)dicvalue
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tabview.width, 100)];
    [view setBackgroundColor:[UIColor whiteColor]];
 
    ///
    UIView *viewtopline = [self drawTopLineView:CGRectMake(0, 0, BOUNDS_WIDTH, 40*kScale)];
    [view addSubview:viewtopline];
    
    ///头部本地物流公司和物流编号
    float ftempbot = viewtopline.bottom;
    if([[NSString stringWithFormat:@"%@",[dicvalue objectForKey:@"expressnumber"]] length]>=5)
    {
        UIView *viewbd = [[UIView alloc] initWithFrame:CGRectMake(0, ftempbot, tabview.width, 100)];
        [viewbd setBackgroundColor:[UIColor whiteColor]];
        
        
        UIImageView *imgvhead = [[UIImageView alloc] initWithFrame:CGRectMake(10, 17, 71, 71)];
        [imgvhead.layer setMasksToBounds:YES];
        [imgvhead.layer setCornerRadius:4];
        [[MDB_UserDefault defaultInstance] setViewImageWithURL:[NSURL URLWithString:[dicvalue objectForKey:@"shotpics"]] placeholder:[UIImage imageNamed:@"icon120.png"] UIimageview:imgvhead];
        [viewbd addSubview:imgvhead];
        
        UILabel *lbtitle = [[UILabel alloc] initWithFrame:CGRectMake(imgvhead.right+10, imgvhead.top+15, view.width-imgvhead.right-75, 20)];
        [lbtitle setText:[NSString stringWithFormat:@"物流公司：%@",[dicvalue objectForKey:@"expressname"] ]];
        [lbtitle setTextColor:RGB(102,102,102)];
        [lbtitle setTextAlignment:NSTextAlignmentLeft];
        [lbtitle setFont:[UIFont systemFontOfSize:12]];
        [viewbd addSubview:lbtitle];
        
        UILabel *lbwldanhao = [[UILabel alloc] initWithFrame:CGRectMake(imgvhead.right+10, lbtitle.bottom+5, viewbd.width-imgvhead.right-75, 20)];
        [lbwldanhao setText:[NSString stringWithFormat:@"物流单号：%@",[dicvalue objectForKey:@"expressnumber"] ]];
        [lbwldanhao setTextColor:RGB(102,102,102)];
        [lbwldanhao setTextAlignment:NSTextAlignmentLeft];
        [lbwldanhao setFont:[UIFont systemFontOfSize:12]];
        [viewbd addSubview:lbwldanhao];
        strorderno = [dicvalue objectForKey:@"expressnumber"] ;
        
        UIButton *btcopy = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30*kScale, 17*kScale)];
        [btcopy setTitle:@"复制" forState:UIControlStateNormal];
        [btcopy setTitleColor:RGB(51,51,51) forState:UIControlStateNormal];
        [btcopy.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [btcopy.layer setMasksToBounds:YES];
        [btcopy.layer setCornerRadius:2];
        [btcopy.layer setBorderColor:RGB(102,102,102).CGColor];
        [btcopy.layer setBorderWidth:1];
        [btcopy setTop:lbwldanhao.top];
        [btcopy setRight:viewbd.width-10];
        [viewbd addSubview:btcopy];
        [btcopy addTarget:self action:@selector(copyAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *viewlin = [[UIView alloc] initWithFrame:CGRectMake(0, imgvhead.bottom+17,viewbd.width , 10)];
        [viewlin setBackgroundColor:RGB(241,241,241)];
        [viewbd addSubview:viewlin];
        [viewbd setHeight:viewlin.bottom];
        [view addSubview:viewbd];
        ftempbot = viewbd.bottom;
    }
    
    
    
    //////所有物流轨迹
    UILabel *lbname = [[UILabel alloc] initWithFrame:CGRectMake(10, ftempbot+20, 250, 30)];
    [lbname setText:@"物流中心"];
    [lbname setTextColor:RGB(51,51,51)];
    [lbname setTextAlignment:NSTextAlignmentLeft];
    [lbname setFont:[UIFont systemFontOfSize:15]];
    [view addSubview:lbname];
    
    NSDictionary *dicavg_time = [dicvalue objectForKey:@"avg_time"];
    NSArray *arrtimes = @[[NSString nullToString:[dicavg_time objectForKey:@"ship_to_mdb"]],[NSString nullToString:[dicavg_time objectForKey:@"mdb_to_user"]]];
    NSArray *arrname = @[@"商家发货",@"到达没得比",@"比比"];
    NSArray *arrimage = @[@"wuliu_feiji_graw",@"wuliu_meidebi_graw",@"wuliu_user_graw"];
    NSArray *arrimageselect = @[@"wuliu_feiji_orange",@"wuliu_meidebi_orange",@"wuliu_user_orange"];
    
    if([[dicvalue objectForKey:@"transfertype"] intValue] == 1)
    {
        arrtimes = @[[NSString nullToString:[dicavg_time objectForKey:@"ship_to_transport"]],[NSString nullToString:[dicavg_time objectForKey:@"transport_to_mdb"]],[NSString nullToString:[dicavg_time objectForKey:@"mdb_to_user"]]];
        arrname = @[@"商家发货",@"到达转运公司",@"到达没得比",@"比比"];
        arrimage = @[@"wuliu_feiji_graw",@"wuliu_dizhi_graw",@"wuliu_meidebi_graw",@"wuliu_user_graw"];
        arrimageselect = @[@"wuliu_feiji_orange",@"wuliu_dizhi_orange",@"wuliu_meidebi_orange",@"wuliu_user_orange"];
    }
    
    
    UIView *viewlinegraw = [[UIView alloc] initWithFrame:CGRectMake(10, lbname.bottom+70, view.width-20, 2)];
    [viewlinegraw setBackgroundColor:RGB(201, 201, 201)];
    [view addSubview:viewlinegraw];
    
    UIView *viewlineorange = [[UIView alloc] initWithFrame:CGRectMake(viewlinegraw.left, viewlinegraw.top, 0, viewlinegraw.height)];
    [viewlineorange setBackgroundColor:RadMenuColor];
    [view addSubview:viewlineorange];
    
    int iwuliu = -1;
    int inodestatus = [[dicvalue objectForKey:@"nodestatus"] intValue];
    if([[dicvalue objectForKey:@"transfertype"] intValue] == 1)
    {
        if(inodestatus>=1&&inodestatus<3)
        {
            iwuliu=0;
        }
        else if(inodestatus>=3&&inodestatus<9)
        {
            iwuliu=1;
        }
        else if(inodestatus>=9&&inodestatus<11)
        {
            iwuliu=2;
        }
        else if(inodestatus>=11)
        {
            iwuliu=3;
        }
    }
    else
    {
        if(inodestatus>=1&&inodestatus<3)
        {
            iwuliu=0;
        }
        else if(inodestatus>=9&&inodestatus<11)
        {
            iwuliu=1;
        }
        else if(inodestatus>=11)
        {
            iwuliu=2;
        }
    }
    
    
    float fwidth = (view.width-20)/arrname.count;
    
    for(int i = 0 ; i < arrname.count; i++)
    {
        UIButton *btitem = [[UIButton alloc] initWithFrame:CGRectMake(0, lbname.bottom+20, fwidth, 30)];
        [btitem setImage:[UIImage imageNamed:arrimage[i]] forState:UIControlStateNormal];
        [btitem setTitle:arrname[i] forState:UIControlStateNormal];
        [btitem setTitleColor:RGB(150, 150, 150) forState:UIControlStateNormal];
        [btitem.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [btitem setCenterX:10+fwidth*i+fwidth/2.0];
        [view addSubview:btitem];
        if(i==0)
        {
            [btitem setCenterX:10+fwidth*i+fwidth/2.0-fwidth*0.1];
        }
        else if (i==arrname.count-1)
        {
            [btitem setCenterX:10+fwidth*i+fwidth/2.0+fwidth*0.1];
        }
        else
        {
            if(arrname.count==4)
            {
                if(i==1)
                {
                    [btitem setCenterX:10+fwidth*i+fwidth/2.0-fwidth*0.1];
                }
                else if (i==2)
                {
                    [btitem setCenterX:10+fwidth*i+fwidth/2.0+fwidth*0.1];
                }
            }
        }
        
        UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        [imgv setImage:[UIImage imageNamed:@"wuliu_graw"]];
        [imgv setCenterY:viewlinegraw.centerY];
        [imgv setCenterX:btitem.centerX];
        [view addSubview:imgv];
        if(i<=iwuliu)
        {
            [imgv setImage:[UIImage imageNamed:@"wuliu_orange"]];
            [btitem setImage:[UIImage imageNamed:arrimageselect[i]] forState:UIControlStateNormal];
            [btitem setTitleColor:RadMenuColor forState:UIControlStateNormal];
            [viewlineorange setWidth:imgv.centerX-viewlineorange.left];
            
        }
        if(iwuliu == arrname.count-1)
        {
            [viewlineorange setWidth:viewlinegraw.right];
        }
        if(i<arrname.count-1)
        {
            UILabel *lbyujiTime = [[UILabel alloc] initWithFrame:CGRectMake(imgv.right, imgv.bottom, (view.width-20-imgv.width*arrname.count)/arrname.count, 40)];
            [lbyujiTime setTextColor:[UIColor redColor]];
            [lbyujiTime setTextAlignment:NSTextAlignmentCenter];
            [lbyujiTime setFont:[UIFont systemFontOfSize:12]];
            [lbyujiTime setNumberOfLines:2];
            [view addSubview:lbyujiTime];
            if(i<arrtimes.count)
            {
                if([arrtimes[i] integerValue]>0)
                {
                   [lbyujiTime setText:[NSString stringWithFormat:@"平均耗时%@天",arrtimes[i]]];
                }
            }
            
        }
        
    }
    
    
    
    UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(10, viewlinegraw.bottom+60, view.width-20, 1)];
    [viewline setBackgroundColor:RGB(238,238,238)];
    [view addSubview:viewline];
    [view setHeight:viewline.bottom];
    
    [tabview setTableHeaderView:view];
}

/*
-(void)drawtabHeaderview:(NSDictionary *)dicvalue
{
    
    if([[NSString stringWithFormat:@"%@",[dicvalue objectForKey:@"expressnumber"]] length]<5)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tabview.width, 20)];
        [view setBackgroundColor:[UIColor whiteColor]];
        [tabview setTableHeaderView:view];
        return;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tabview.width, 100)];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    
    UIImageView *imgvhead = [[UIImageView alloc] initWithFrame:CGRectMake(10, 17, 71, 71)];
    [imgvhead.layer setMasksToBounds:YES];
    [imgvhead.layer setCornerRadius:4];
//    [[MDB_UserDefault defaultInstance] setViewWithImage:imgvhead url:[dicvalue objectForKey:@"shotpics"]];
    ///icon120.png
    [[MDB_UserDefault defaultInstance] setViewImageWithURL:[NSURL URLWithString:[dicvalue objectForKey:@"shotpics"]] placeholder:[UIImage imageNamed:@"icon120.png"] UIimageview:imgvhead];
    [view addSubview:imgvhead];
    
//    NSArray *arrlogis = [[dicvalue objectForKey:@"expressnumber"] componentsSeparatedByString:@"("];
//    if(arrlogis.count != 2)
//    {
//        arrlogis = [NSArray arrayWithObjects:@"物流公司",@"未知", nil];
//    }
    UILabel *lbtitle = [[UILabel alloc] initWithFrame:CGRectMake(imgvhead.right+10, imgvhead.top+15, view.width-imgvhead.right-75, 20)];
    [lbtitle setText:[NSString stringWithFormat:@"物流公司：%@",[dicvalue objectForKey:@"expressname"] ]];
    [lbtitle setTextColor:RGB(102,102,102)];
    [lbtitle setTextAlignment:NSTextAlignmentLeft];
    [lbtitle setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:lbtitle];
    
    UILabel *lbwldanhao = [[UILabel alloc] initWithFrame:CGRectMake(imgvhead.right+10, lbtitle.bottom+5, view.width-imgvhead.right-75, 20)];
    [lbwldanhao setText:[NSString stringWithFormat:@"物流单号：%@",[dicvalue objectForKey:@"expressnumber"] ]];
    [lbwldanhao setTextColor:RGB(102,102,102)];
    [lbwldanhao setTextAlignment:NSTextAlignmentLeft];
    [lbwldanhao setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:lbwldanhao];
    strorderno = [dicvalue objectForKey:@"expressnumber"] ;
    
    UIButton *btcopy = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30*kScale, 17*kScale)];
    [btcopy setTitle:@"复制" forState:UIControlStateNormal];
    [btcopy setTitleColor:RGB(51,51,51) forState:UIControlStateNormal];
    [btcopy.titleLabel setFont:[UIFont systemFontOfSize:11]];
    [btcopy.layer setMasksToBounds:YES];
    [btcopy.layer setCornerRadius:2];
    [btcopy.layer setBorderColor:RGB(102,102,102).CGColor];
    [btcopy.layer setBorderWidth:1];
    [btcopy setTop:lbwldanhao.top];
    [btcopy setRight:view.width-10];
    [view addSubview:btcopy];
    [btcopy addTarget:self action:@selector(copyAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *viewlin = [[UIView alloc] initWithFrame:CGRectMake(0, imgvhead.bottom+17,view.width , 10)];
    [viewlin setBackgroundColor:RGB(241,241,241)];
    [view addSubview:viewlin];
    
    
    UILabel *lbname = [[UILabel alloc] initWithFrame:CGRectMake(10, viewlin.bottom+20, 150, 30)];
    [lbname setText:@"物流中心"];
    [lbname setTextColor:RGB(51,51,51)];
    [lbname setTextAlignment:NSTextAlignmentLeft];
    [lbname setFont:[UIFont systemFontOfSize:15]];
    [view addSubview:lbname];
    
    [view setHeight:lbname.bottom+20];
    
    [tabview setTableHeaderView:view];
}
*/



-(UIView *)drawTopLineView:(CGRect)rect
{
    UIView *viewtop = [[UIView alloc] initWithFrame:rect];
    [viewtop setBackgroundColor:RGB(254, 236, 226)];
    [viewtop setClipsToBounds:YES];
    
    UILabel *lbtop = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewtop.width, viewtop.height)];
    [lbtop setText:@"平均耗时为当前网站所有有效订单平均数据，实际发货时长以实际耗时为准。"];
    [lbtop setTextColor:RadMenuColor];
    [lbtop setTextAlignment:NSTextAlignmentCenter];
    [lbtop setFont:[UIFont systemFontOfSize:14]];
    [lbtop setBackgroundColor:RGB(254, 236, 226)];
    [viewtop addSubview:lbtop];
    
    UIButton *btdel = [[UIButton alloc] initWithFrame:CGRectMake(viewtop.width-viewtop.height, 0, viewtop.height, viewtop.height)];
//    [btdel setImage:[UIImage imageNamed:@"delguanggao_gundong"] forState:UIControlStateNormal];
    //    [btdel.imageView setBackgroundColor:RGBAlpha(0, 0, 0, 0.3)];
    [btdel addTarget:self action:@selector(delgundongguanggaoAction:) forControlEvents:UIControlEventTouchUpInside];
    [viewtop addSubview:btdel];
    if(toptimer != nil)
    {
        [toptimer timeInterval];
        toptimer = nil;
    }
    
    float flbtopw = [MDB_UserDefault getStrWightFont:lbtop.font str:lbtop.text hight:20].width;
    if(lbtop.width<flbtopw)
    {
        toptimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(toptimer:) userInfo:lbtop repeats:YES];
        [lbtop setWidth:flbtopw];
        [lbtop setLeft:10];
        
        [toptimer setFireDate:[NSDate dateWithTimeIntervalSince1970:[[NSDate date] timeIntervalSince1970]+3]];
        
        [[NSRunLoop mainRunLoop] addTimer:toptimer forMode:NSRunLoopCommonModes];
        
        
    }
    return viewtop;
}

-(void)delgundongguanggaoAction:(UIButton *)sender
{
//    [sender.superview removeFromSuperview];
}

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


-(void)dealloc
{
    [toptimer invalidate];
    toptimer = nil;
    
}

-(void)dataValue:(NSDictionary *)dic
{
    tabview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [tabview setDelegate:self];
    [tabview setDataSource:self];
    [tabview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tabview setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:tabview];
    [self drawtabHeaderview:dic];
    
    
    if([[dic objectForKey:@"logistics"] isKindOfClass:[NSArray class]])
    {
        NSArray *arrtmep = [dic objectForKey:@"logistics"];
        arrdata = [NSMutableArray new];
        for(NSDictionary *dictemp in arrtmep)
        {
            [arrdata addObject:[OrderLogisticsModel binddata:dictemp]];
            
        }
        [tabview reloadData];
    }
    
}

#pragma mark - 复制
-(void)copyAction
{
    
    UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
    
    pasteboard.string=strorderno;
    [MDB_UserDefault showNotifyHUDwithtext:@"复制成功" inView:self];
    
    
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrdata.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strcell = @"OrderLogisticsTableViewCell";
    OrderLogisticsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strcell];
    if(!cell)
    {
        cell = [[OrderLogisticsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strcell];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.model = arrdata[indexPath.row];
    cell.iline = indexPath.row;
    cell.islast = NO;
    if(indexPath.row == arrdata.count-1)
    {
        cell.islast = YES;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderLogisticsModel *model = arrdata[indexPath.row];
    
    float ftemp = [MDB_UserDefault countTextSize:CGSizeMake(tableView.width-80, 1000) andtextfont:[UIFont systemFontOfSize:12] andtext:model.strname].height+10+40;
    
    return ftemp;
}

@end
