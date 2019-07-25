//
//  MyShareViewController.m
//  Meidebi
//
//  Created by 杜非 on 15/2/10.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import "MyShareViewController.h"
#import "MyshareTableView.h"
#import "OriginalDetailViewController.h"

#import "NJScrollTableView.h"

#import "MyShareTableViewController.h"

#import "TKTopicComposeViewController.h"

#import "PushYuanChuangViewController.h"

@interface MyShareViewController ()<MyShareTableViewControllerDelegate,ScrollTabViewDataSource>{
    MyshareTableView *_shareTableView;
    
    NSMutableArray *arrremark;
    
    
    NSInteger itempselect;
    
}

@end

@implementation MyShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的原创";
//    [self setNavigation];
    arrremark = [NSMutableArray new];
    MyShareTableViewController *mvc = [[MyShareTableViewController alloc] init];
    mvc.title = @"已发布";
    mvc.strtype = @"1";
    mvc.delegate = self;
    [arrremark addObject:mvc];
    
    MyShareTableViewController *dmvc = [[MyShareTableViewController alloc] init];
    dmvc.title = @"待发布";
    dmvc.strtype = @"2";
    dmvc.delegate = self;
    [arrremark addObject:dmvc];
    
    NJScrollTableView *_scrollTableView = [[NJScrollTableView alloc] initWithFrame:CGRectMake(0, kTopHeight, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-kTopHeight)];
    _scrollTableView.backgroundColor = [UIColor whiteColor];
    _scrollTableView.selectedLineWidth = kScreenW/1.5;
    [self.view addSubview:_scrollTableView];
    _scrollTableView.dataSource = self;
    [_scrollTableView buildUI];
    _scrollTableView.scrollEnable = NO;
    [_scrollTableView selectTabWithIndex:0 animate:NO];
    
    
//    _shareTableView=[[MyshareTableView alloc]initWithFrame:CGRectZero delegate:self];
//    [self.view addSubview:_shareTableView];
//    [_shareTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        if (@available(iOS 11.0, *)) {
//            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
//            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
//            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
//            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
//        }else{
//            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
//        }
//    }];
//    UISwipeGestureRecognizer *right=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipes:)];
//    right.direction=UISwipeGestureRecognizerDirectionRight;
//    [self.view addGestureRecognizer:right];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSuccessSendShare:) name:kShaidanDidSuccessSendNotification object:nil];
    
    if(itempselect == 1)
    {
        NSString *strtemp = [[NSUserDefaults standardUserDefaults] objectForKey:@"yuanchuangfabugengxin1"];
        if(strtemp.integerValue == 1)
        {
            MyShareTableViewController *vc = arrremark[itempselect];
            if(vc.arrData.count>0)
            {
                [vc reloadTableViewDataSource];
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"yuanchuangfabugengxin1"];
        }
    }
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
    
    
    
}

//-(void)handleSwipes:(UISwipeGestureRecognizer *)sender{
//    [self.navigationController popViewControllerAnimated:YES];
//}
-(void)setNavigation{
    UIButton* btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
    btnLeft.frame = CGRectMake(0,0,44,44);
    [btnLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_click.png"] forState:UIControlStateHighlighted];
    [btnLeft addTarget:self action:@selector(doClickLeftAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnLeft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}
-(void)doClickLeftAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)tableViewSelecte:(NSInteger )shareid boll:(BOOL)isRightbut{
//    UIStoryboard *mainStroy=[UIStoryboard storyboardWithName:@"Share" bundle:nil];
//    ShareContViewController *ductViewC=[mainStroy instantiateViewControllerWithIdentifier:@"com.mdb.ShareContViewC"];
//    ductViewC.shareid=shareid;
//    ductViewC.isDockView=YES;
//    ductViewC.isRightBut=isRightbut;
    OriginalDetailViewController *vc = [[OriginalDetailViewController alloc] initWithOriginalID:[NSString stringWithFormat:@"%@",@(shareid)]];
    [self.navigationController pushViewController:vc animated:YES];

}

-(void)tableViewcaogaoSelecte:(NSString *)shareid type:(NSInteger)type
{
//    TKTopicComposeViewController *tvc = [[TKTopicComposeViewController alloc] initWithTopicType:type];
//    tvc.strcaogaoid = shareid;
//    [self.navigationController pushViewController:tvc animated:YES];
    
    PushYuanChuangViewController *pvc = [[PushYuanChuangViewController alloc] init];
    pvc.strdraft_id = shareid;
    [self.navigationController pushViewController:pvc animated:YES];
    

}

-(void)didSuccessSendShare:(NSNotification *)notification{
//    BOOL state = [(NSNumber *)notification.object boolValue];
//    [_shareTableView didSuccessSendShare:state];
}

#pragma mark - ScorllTableViewDelegate
- (NSUInteger)numberOfPagers:(NJScrollTableView *)view{
    return arrremark.count;
}

- (UITableViewController *)scrollTableViewOfPagers:(NJScrollTableView *)view
                                     indexOfPagers:(NSUInteger)index{
    return arrremark[index];
}

- (void)whenSelectOnPager:(NSUInteger)number{
    itempselect = number;
    
    MyShareTableViewController *vc = arrremark[number];
    [vc didSuccessSendShare:YES];
    
    
    
    
}


@end
