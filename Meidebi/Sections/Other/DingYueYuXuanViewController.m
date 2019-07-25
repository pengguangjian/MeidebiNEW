//
//  DingYueYuXuanViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/12/20.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "DingYueYuXuanViewController.h"
//#import "AppDelegate.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"

@interface DingYueYuXuanViewController ()
{
//    AppDelegate *dele;
    
    UIScrollView *scvback;
    
    UIButton *btbottom;
    
    NSMutableArray *arrselectitem;
    
}
@end

@implementation DingYueYuXuanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
//    dele=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.view.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    [self setupSubViews];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"tuijiandingyuefirst"];
    
}

-(void)setupSubViews
{
    
    scvback = [[UIScrollView alloc] init];
    scvback.frame = self.view.bounds;
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    scvback.showsHorizontalScrollIndicator = NO;
    scvback.contentSize = CGSizeMake(5*width, height);
//    scvback.pagingEnabled = YES;
    scvback.backgroundColor =[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    scvback.bounces = NO;
    [self.view addSubview:scvback];
    
    
    
    UIButton *btyixuan = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-80, 30, 80, 40)];
    [btyixuan setTitle:@"跳过" forState:UIControlStateNormal];
    [btyixuan setTitleColor:RadMenuColor forState:UIControlStateNormal];
    [btyixuan.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:btyixuan];
    [btyixuan addTarget:self action:@selector(dismisAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lbnkng = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, scvback.width-20, 50)];
    [lbnkng setText:@"你可能感兴趣"];
    [lbnkng setTextColor:RGB(30, 30, 30)];
    [lbnkng setTextAlignment:NSTextAlignmentCenter];
    [lbnkng setFont:[UIFont systemFontOfSize:25]];
    [scvback addSubview:lbnkng];
    
    
    UILabel *lbnkng1 = [[UILabel alloc] initWithFrame:CGRectMake(10, lbnkng.bottom+10, scvback.width-20, 40)];
    [lbnkng1 setText:@"我们会根据你的的兴趣来推荐优惠"];
    [lbnkng1 setTextColor:RGB(153, 153, 153)];
    [lbnkng1 setTextAlignment:NSTextAlignmentCenter];
    [lbnkng1 setFont:[UIFont systemFontOfSize:15]];
    [scvback addSubview:lbnkng1];
    
    
    
    NSMutableArray *arrlbitem = [NSMutableArray new];
    int i = 0;
    
    for(NSString *model in _arrallkey)
    {
        UIButton *btitem = [[UIButton alloc] init];
        UILabel *lbitem = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 35)];
        [lbitem setText:model];
        [lbitem setTextColor:RGB(102, 102, 102)];
        [lbitem setTextAlignment:NSTextAlignmentCenter];
        [lbitem setFont:[UIFont systemFontOfSize:14]];
        [lbitem setNumberOfLines:0];
        [lbitem sizeToFit];
        [lbitem setBackgroundColor:[UIColor clearColor]];
        [lbitem setHeight:lbitem.height+15];
        if(lbitem.height<=35)
        {
            [lbitem setHeight:35];
        }
        [lbitem setWidth:lbitem.width+15];
        if(lbitem.width>scvback.width-20)
        {
            [lbitem setWidth:scvback.width-20];
        }
        [scvback addSubview:btitem];
        [btitem addSubview:lbitem];
        [btitem setTag:i];
        [btitem setFrame:CGRectMake(0, 0, lbitem.width, lbitem.height)];
        [arrlbitem addObject:btitem];
        [lbitem setTag:i];
        [btitem setBackgroundImage:[UIImage imageNamed:@"backitem_yuxuan_nomo.png"] forState:UIControlStateNormal];
        i++;
        [btitem addTarget:self action:@selector(btitemAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    float fleft = 20;
    float ftop = lbnkng1.bottom+50;
    float fbottom = lbnkng1.bottom+50;
    float flastitemheight = 35.0;
    for(UIButton *item in arrlbitem)
    {
        
        [item setLeft:fleft];
        [item setTop:ftop];
        if(item.right>scvback.width-20)
        {
            fleft = 20;
            [item setLeft:fleft];
            ftop = item.top+flastitemheight+10;
            [item setTop:ftop];
        }
        
        
        fleft = item.right+10;
        ftop = item.top;
        fbottom = item.bottom;
        flastitemheight = item.height;
    }
    
    
    btbottom = [[UIButton alloc] initWithFrame:CGRectMake(20, fbottom+50, scvback.width-40, 45)];
    [btbottom.layer setMasksToBounds:YES];
    [btbottom.layer setCornerRadius:4];
    [btbottom.layer setBorderColor:RadMenuColor.CGColor];
    [btbottom.layer setBorderWidth:1];
    [btbottom setTitle:@"选好了，马上使用" forState:UIControlStateNormal];
    [btbottom setTitleColor:RadMenuColor forState:UIControlStateNormal];
    [btbottom.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [scvback addSubview:btbottom];
    [btbottom addTarget:self action:@selector(bottomAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lbnkng2 = [[UILabel alloc] initWithFrame:CGRectMake(10, btbottom.bottom+20, scvback.width-20, 20)];
    [lbnkng2 setText:@"可在app首页右上角“订阅”里取消关注"];
    [lbnkng2 setTextColor:RGB(153, 153, 153)];
    [lbnkng2 setTextAlignment:NSTextAlignmentCenter];
    [lbnkng2 setFont:[UIFont systemFontOfSize:12]];
    [scvback addSubview:lbnkng2];
    
    [scvback setContentSize:CGSizeMake(0, lbnkng2.bottom+20)];
    
}

-(void)btitemAction:(UIButton *)sender
{
    if(arrselectitem==nil)
    {
        arrselectitem = [NSMutableArray new];
    }
    
    BOOL isbool = [arrselectitem containsObject: _arrallkey[sender.tag]];
    
    if(isbool)
    {
        [arrselectitem removeObject:_arrallkey[sender.tag]];
        [sender setBackgroundImage:[UIImage imageNamed:@"backitem_yuxuan_nomo.png"] forState:UIControlStateNormal];
    }
    else
    {
        [arrselectitem addObject:_arrallkey[sender.tag]];
        [sender setBackgroundImage:[UIImage imageNamed:@"backitem_yuxuan_select.png"] forState:UIControlStateNormal];
    }
    
    if(arrselectitem.count>0)
    {
        [btbottom setBackgroundColor:RadMenuColor];
        [btbottom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else
    {
        [btbottom setBackgroundColor:[UIColor whiteColor]];
        [btbottom setTitleColor:RadMenuColor forState:UIControlStateNormal];
    }
    
}


-(void)bottomAction
{
    if(arrselectitem.count>0)
    {
        NSString *strkey = [arrselectitem componentsJoinedByString:@","];
        [self uploadDatakey:strkey];
        
    }
}

-(void)dismisAction
{
    
    [self dismissViewControllerAnimated:NO completion:^{
        [self.delegate dimisview];
    }];
}

- (void)requestSetPushKeywordDataInView:(UIView *)view
                                keyword:(NSString *)keyword
                               callback:(completeCallback)Callback{
    
    NSDictionary *parameters = @{
                                 @"umengtoken":[NSString nullToString:[MDB_UserDefault getUmengDeviceToken]],
                                 @"keyword":[NSString nullToString:keyword],
                                 @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]
                                 };
    [HTTPManager sendRequestUrlToService:URL_setsubscrib withParametersDictionry:parameters view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *_resultMessage=@"";
        if (responceObjct==nil) {
            _resultMessage = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *resultDict=[str JSONValue];
            if ([[NSString nullToString:resultDict[@"status"]] intValue] == 1) {
                state = YES;
                _resultMessage = resultDict[@"info"];
            }else{
                _resultMessage = resultDict[@"info"];
            }
        }
        Callback(error,state,_resultMessage);
    }];
    
}

- (void)uploadDatakey:(NSString *)strkey{
    [self requestSetPushKeywordDataInView:self.view
                                  keyword:strkey
                                 callback:^(NSError *error, BOOL state, NSString *describle) {
                                     
                                     [self dismisAction];
                                                }];
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
