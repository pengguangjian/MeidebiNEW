//
//  PushYuanChuangViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/9/5.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "PushYuanChuangViewController.h"

#import "PushYuanChuangView.h"
#import"IQUIViewController+Additions.h"

#import <IQKeyboardManager.h>

#import "PushYuanChuangSelectFMViewController.h"

#import "MDB_UserDefault.h"

#import "PusnYuanChuangItemModel.h"

@interface PushYuanChuangViewController ()<PushYuanChuangViewDelegate>
{
    PushYuanChuangView *pview;
}
@end

@implementation PushYuanChuangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"写原创";
    [self drawRightTititBt];
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
    [self drawUI];
}

-(void)drawRightTititBt
{
    UIButton* btnright = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
    btnright.frame = CGRectMake(0,7,50,30);
//    [btnright setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnright setTitle:@"下一步" forState:UIControlStateNormal];
    [btnright setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnright.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
    [btnright addTarget:self action:@selector(rightBarClicked) forControlEvents:UIControlEventTouchUpInside];
    [btnright.layer setMasksToBounds:YES];
    [btnright.layer setCornerRadius:3];
    [btnright setBackgroundColor:RadMenuColor];
//    [btnright setTitleEdgeInsets:UIEdgeInsetsMake(0, 12, 0, -12)];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnright];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    
    UIButton* btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
    btnLeft.frame = CGRectMake(0,0,44,44);
    [btnLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_click.png"] forState:UIControlStateHighlighted];
    [btnLeft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnLeft addTarget:self action:@selector(doClickBackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
}

-(void)doClickBackAction
{
    NSString *strtitle = [pview gettitle];
    NSString *strcontent = [pview getcontent];
    NSMutableArray *arrlist = [pview getlistmodel];
    [pview timerremove];
    if(strtitle.length<1 && strcontent.length<1 && arrlist.count<1)
    {
        
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"yuanchuangfabugengxin1"];
        [pview saveCaoGao];
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"草稿已保存，可在“个人中心-原创中”查看" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightBarClicked
{
    NSInteger type = [pview gettype];
    NSString *strtitle = [pview gettitle];
    NSString *strcontent = [pview getcontent];
    NSMutableArray *arrlist = [pview getlistmodel];
    
    if(type <1)
    {
        [MDB_UserDefault showNotifyHUDwithtext:@"请选择分类" inView:self.view];
        return;
    }
    if([strtitle stringByReplacingOccurrencesOfString:@" " withString:@""].length < 1)
    {
        [MDB_UserDefault showNotifyHUDwithtext:@"请输入标题" inView:self.view];
        return;
    }
    if([strcontent stringByReplacingOccurrencesOfString:@" " withString:@""].length < 1)
    {
        [MDB_UserDefault showNotifyHUDwithtext:@"请输入内容" inView:self.view];
        return;
    }
    BOOL isyou = NO;
    for(PusnYuanChuangItemModel *model in arrlist)
    {
        if([model.strtype isEqualToString:@"image"] || [model.strtype isEqualToString:@"video"])
        {
            isyou = YES;
            break;
        }
    }
    if(isyou==NO)
    {
        [MDB_UserDefault showNotifyHUDwithtext:@"请添加图片" inView:self.view];
        return;
    }
    
    
    PushYuanChuangSelectFMViewController *pvc = [[PushYuanChuangSelectFMViewController alloc] init];
    pvc.type = type;
    pvc.strtitle = strtitle;
    pvc.strcontent = strcontent;
    pvc.arrlistitem = arrlist;
    pvc.strdraft_id = pview.strdraft_id;
    pvc.timercaogao = [pview getcaogaotimer];
    [self.navigationController pushViewController:pvc animated:YES];
    
    
    
}

-(void)drawUI
{
    float ftopheith =  kStatusBarHeight+44;
    float fother = 34.0;
    if(ftopheith<66)
    {
        ftopheith = 64;
        fother = 0;
    }
    pview = [[PushYuanChuangView alloc] initWithFrame:CGRectMake(0, kTopHeight, BOUNDS_WIDTH, BOUNDS_HEIGHT-kTopHeight-fother)];
    [pview setDelegate:self];
    pview.strdraft_id = _strdraft_id;
    [self.view addSubview:pview];
    if(_arrbaoliaourl.count>0)
    {
        [pview getMessageBaoLiao:_arrbaoliaourl];
    }
    else
    {
        if(_strdraft_id.length>0)
        {
            [pview getcaogaoNOMO:_strdraft_id];
        }
        else
        {
            [pview selectNomoImageItem];
        }
    }
     
}

///进入没有选择图片
-(void)selectNomoImageNO
{
    [self.navigationController popViewControllerAnimated:YES];
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
