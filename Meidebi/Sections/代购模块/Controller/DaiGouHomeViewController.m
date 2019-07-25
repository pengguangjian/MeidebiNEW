//
//  DaiGouHomeViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/28.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "DaiGouHomeViewController.h"

#import "DaiGouHomeView.h"

#import "DaiGouSearchViewController.h"

#import "GoodsCarViewController.h"

#import "MDB_UserDefault.h"

#import "VKLoginViewController.h"
#import "HTTPManager.h"

#import "ZiZhuDaiGouHomeViewController.h"

@interface DaiGouHomeViewController ()<DaiGouHomeViewDelegate,UIAlertViewDelegate>

@property (nonatomic , strong) UILabel *lbgwcnumber;

@property (nonatomic , strong) DaiGouHomeView *dghView;

@end

@implementation DaiGouHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"代购";
    
    [self setNavigation];
    
    [self setSubview];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    
    [self.dghView loadListTimeData];
    
    [self getgoodsnumber];
}

-(void)getgoodsnumber
{
    
    
    if ([MDB_UserDefault getIsLogin] == NO)
    {
        [_lbgwcnumber setHidden:YES];
        return;
    }
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken] forKey:@"userkey"];
    
    [HTTPManager sendGETRequestUrlToService:MyGoodsCarNumberUrl withParametersDictionry:dicpush view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
       
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"info"];
            if ([[NSString nullToString:dicAll[@"status"]] intValue] == 1) {
                NSDictionary *dicdata = [dicAll objectForKey:@"data"];
                @try
                {
                    NSString *strcount = [NSString nullToString:[dicdata objectForKey:@"num"]];
                    [self gouwuchenumchange:strcount.intValue];
                    [[NSUserDefaults standardUserDefaults] setObject:strcount forKey:@"gouwuchegoodsnumber"];
                }
                @catch (NSException *exc)
                {
                    
                }
                @finally
                {
                    
                }
                
                
                
            }
        }
        
        
        
    }];
    
}


-(void)setNavigation{
    
    UIButton* btnright = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
    btnright.frame = CGRectMake(0,0,44,44);
    [btnright setImage:[UIImage imageNamed:@"daigougouwuchehui"] forState:UIControlStateNormal];
    [btnright setImage:[UIImage imageNamed:@"daigougouwuchehui"] forState:UIControlStateHighlighted];
    [btnright setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnright addTarget:self action:@selector(rightanvAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnright setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [btnright setTag:1];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnright];
    _lbgwcnumber = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 15)];
    [_lbgwcnumber setTextColor:[UIColor whiteColor]];
    [_lbgwcnumber setTextAlignment:NSTextAlignmentCenter];
    [_lbgwcnumber setFont:[UIFont systemFontOfSize:10]];
    [_lbgwcnumber setBackgroundColor:[UIColor redColor]];
    [_lbgwcnumber setRight:btnright.width];
    [_lbgwcnumber.layer setMasksToBounds:YES];
    [_lbgwcnumber.layer setCornerRadius:_lbgwcnumber.height/2.0];
    [btnright addSubview:_lbgwcnumber];
    [_lbgwcnumber setHidden:YES];
    
    if ([MDB_UserDefault getIsLogin])
    {
        NSString *strtemp = [NSString stringWithFormat:@"%d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"gouwuchegoodsnumber"] intValue]];
        [self gouwuchenumchange:strtemp.intValue];
    }
    
    
    UIButton* btnright1 = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
    btnright1.frame = CGRectMake(44,0,44,44);
    [btnright1 setImage:[UIImage imageNamed:@"daigousuosuohui"] forState:UIControlStateNormal];
    [btnright1 setImage:[UIImage imageNamed:@"daigousuosuohui"] forState:UIControlStateHighlighted];
    [btnright1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnright1 addTarget:self action:@selector(rightanvAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnright1 setTag:2];
    UIBarButtonItem* rightBarButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:btnright1];
    
    self.navigationItem.rightBarButtonItems = @[rightBarButtonItem,rightBarButtonItem1];
    
    /*
    UIButton* btnleft = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
//    btnleft.frame = CGRectMake(0,5,70,34);
//    [btnleft setImage:[UIImage imageNamed:@"daigousuosuohui"] forState:UIControlStateNormal];
//    [btnleft setImage:[UIImage imageNamed:@"daigousuosuohui"] forState:UIControlStateHighlighted];
    [btnleft setTitle:@"自助代购" forState:UIControlStateNormal];
    [btnleft setTitleColor:RadMenuColor forState:UIControlStateNormal];
    [btnleft.titleLabel setFont:[UIFont systemFontOfSize:13]];
//    [btnleft.layer setBorderColor:RGB(200, 200, 200).CGColor];
//    [btnleft.layer setBorderWidth:1];
//    [btnleft.layer setMasksToBounds:YES];
//    [btnleft.layer setCornerRadius:3];
//    [btnleft setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [btnleft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnleft addTarget:self action:@selector(leftanvAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnleft];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    */
}

- (void)doClickLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)leftanvAction
{
    ZiZhuDaiGouHomeViewController *zvc = [[ZiZhuDaiGouHomeViewController alloc] init];
    [self.navigationController pushViewController:zvc animated:YES];
}

-(void)rightanvAction:(UIButton *)sender{
    
    if(sender.tag==1)
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
        
        GoodsCarViewController *gvc = [[GoodsCarViewController alloc] init];
        [self.navigationController pushViewController:gvc animated:YES];
    }
    else
    {
        DaiGouSearchViewController *dvc = [[DaiGouSearchViewController alloc] init];
        [self.navigationController pushViewController:dvc animated:YES];
    }
    
    
    
}

-(void)setSubview
{
    float ftopheith =  kStatusBarHeight+44;
    float fother = 0.0;
    if(ftopheith<66)
    {
        ftopheith = 64;
        fother = 0;
    }
    _dghView = [[DaiGouHomeView alloc] initWithFrame:CGRectMake(0, ftopheith, BOUNDS_WIDTH, BOUNDS_HEIGHT-ftopheith-fother-kTabBarHeight)];
    [_dghView setDelegate:self];
    [self.view addSubview:_dghView];
    
}

////添加购物车
-(void)gouwucheadd
{////处理数量
    
    int itemp = _lbgwcnumber.text.intValue+1;
    NSString *strtemp = [NSString stringWithFormat:@"%d",itemp];
    if(itemp>99)
    {
        strtemp = @"99+";
    }
    [_lbgwcnumber setHidden:NO];
    [_lbgwcnumber setText:strtemp];
    
}

-(void)gouwuchenumchange:(int)itemp
{
    NSString *strtemp = [NSString stringWithFormat:@"%d",itemp];
    if(itemp>99)
    {
        strtemp = @"99+";
    }
    [_lbgwcnumber setHidden:NO];
    [_lbgwcnumber setText:strtemp];
    if(itemp<=0)
    {
        [_lbgwcnumber setHidden:YES];
    }
}

#pragma mark - UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0 && alertView.tag == 110) {
        VKLoginViewController *vkVc = [[VKLoginViewController alloc] init];
        [self.navigationController pushViewController:vkVc animated:YES];
    }
}


-(void)dealloc
{
    [_dghView.timer invalidate];
    _dghView.timer = nil;
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
