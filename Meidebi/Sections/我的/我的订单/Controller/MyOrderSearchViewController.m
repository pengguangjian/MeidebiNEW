//
//  MyOrderSearchViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/4/16.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import "MyOrderSearchViewController.h"

#import "MyOrderSearchListTableViewController.h"

@interface MyOrderSearchViewController ()<UITextFieldDelegate>
{
    UIView *viewtitle;
    UITextField *fieldsearch;
    
    UIButton *button;
    UIScrollView *scvtemp;
    
    NSString *strsearchkey;
    
}
@end

@implementation MyOrderSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    strsearchkey = @"";
    // Do any additional setup after loading the view.
    [self setsearchtitle];
    [self btrightView];
    
    [self drawSubview];
    
    
}

-(void)btrightView
{
    UIButton* btnright = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnright setTitle:@"取消" forState:UIControlStateNormal];
    [btnright setTitleColor:RGB(50, 50, 50) forState:UIControlStateNormal];
    [btnright.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btnright addTarget:self action:@selector(doClickRightAction) forControlEvents:UIControlEventTouchUpInside];
    [btnright setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnright];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void)doClickRightAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)setsearchtitle
{
    viewtitle = [[UIView alloc]initWithFrame:CGRectMake(15, 5, self.view.width-80, 34)];
    [viewtitle setBackgroundColor:RGB(233, 233, 233)];
    [viewtitle.layer setMasksToBounds:YES];
    [viewtitle.layer setCornerRadius:viewtitle.height/2.0];
    [self.navigationController.navigationBar addSubview:viewtitle];
    
    fieldsearch = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, viewtitle.width-30, viewtitle.height)];
    [fieldsearch setText:@""];
    [fieldsearch setPlaceholder:@"搜索全部订单"];
    [fieldsearch setTextColor:RGB(30, 30, 30)];
    [fieldsearch setTextAlignment:NSTextAlignmentLeft];
    [fieldsearch setFont:[UIFont systemFontOfSize:14]];
    [fieldsearch setReturnKeyType:UIReturnKeySearch];
    [fieldsearch setDelegate:self];
    [viewtitle addSubview:fieldsearch];
    [fieldsearch becomeFirstResponder];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [viewtitle setHidden:NO];
    
    if(scvtemp!=nil)
    {
        [self drawview];
    }
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [viewtitle setHidden:YES];
    [fieldsearch resignFirstResponder];
}

-(void)drawSubview
{
    
    scvtemp = [[UIScrollView alloc] init];
    [self.view addSubview:scvtemp];
    [scvtemp mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }
    }];
    [scvtemp setBackgroundColor:[UIColor whiteColor]];
    
    [self drawview];
    
}


-(void)drawview
{
    [scvtemp removeAllSubviews];
    
    NSArray *arrbiaoqian = [[NSUserDefaults standardUserDefaults] objectForKey:@"daigoudingdansousuohestory"];
    if(arrbiaoqian.count<1)return;
    
    UILabel *lbtitle = [[UILabel alloc] init];
    [lbtitle setText:@"历史搜索"];
    [lbtitle setTextColor:RGB(200, 200, 200)];
    [lbtitle setTextAlignment:NSTextAlignmentLeft];
    [lbtitle setFont:[UIFont systemFontOfSize:13]];
    [scvtemp addSubview:lbtitle];
    [lbtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(15);
        make.height.offset(20);
    }];
    
    
    float fbottom = [self drawItem:arrbiaoqian andview:scvtemp];
    
    
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [scvtemp addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(scvtemp);
        make.top.offset(fbottom+60);
        make.height.offset(42);
        make.width.offset(100);
    }];
    [button setTitle:@"清除记录" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [button setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(respondesToButton) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"clearSearchHistory"] forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, -6)];
}

-(float)drawItem:(NSArray *)arrvalue andview:(UIView *)view
{
    if(arrvalue.count<1)
    {
        return 0;
    }
    NSMutableArray *arrlbitem = [NSMutableArray new];
    int i = 0;
    for(NSString *strvalue in arrvalue)
    {
        UILabel *lbitem = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.width, 30)];
        [lbitem setText:strvalue];
        [lbitem setTextColor:RGB(90, 90, 90)];
        [lbitem setTextAlignment:NSTextAlignmentCenter];
        [lbitem setFont:[UIFont systemFontOfSize:13]];
        [lbitem setNumberOfLines:0];
        [lbitem sizeToFit];
        [lbitem setBackgroundColor:RGB(245, 245, 245)];
        [lbitem setHeight:lbitem.height+15];
        if(lbitem.height<=30)
        {
            [lbitem setHeight:30];
        }
        [lbitem setWidth:lbitem.width+20];
        if(lbitem.width>kMainScreenW-20)
        {
            [lbitem setWidth:kMainScreenW-20];
        }
        [view addSubview:lbitem];
        [lbitem.layer setMasksToBounds:YES];
        [lbitem.layer setCornerRadius:3];
        [lbitem setBackgroundColor:RGB(244, 244, 244)];
        [arrlbitem addObject:lbitem];
        [lbitem setUserInteractionEnabled:YES];
        [lbitem setTag:i];
        i++;
        UITapGestureRecognizer *tapitem = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemAction:)];
        [lbitem addGestureRecognizer:tapitem];
        i++;
    }
    
    float fleft = 10;
    float ftop = 50;
    float fbottom = 50;
    float flastitemheight = 30.0;
    for(UILabel *item in arrlbitem)
    {
        
        [item setLeft:fleft];
        [item setTop:ftop];
        if(item.right>kMainScreenW-10)
        {
            fleft = 10;
            [item setLeft:fleft];
            ftop = item.top+flastitemheight+10;
            [item setTop:ftop];
        }
        
        
        fleft = item.right+10;
        ftop = item.top;
        fbottom = item.bottom;
        flastitemheight = item.height;
    }
    
    return fbottom;
}

-(void)respondesToButton
{
    NSMutableArray *arr = [NSMutableArray new];
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"daigoudingdansousuohestory"];
    [self drawview];
}

-(void)itemAction:(UIGestureRecognizer *)gesture
{
    UILabel *lbtemp = (UILabel *)gesture.view;
    NSString *strtemp = [NSString nullToString:lbtemp.text];
    NSMutableArray *arr = [NSMutableArray new];
    
    NSArray *arrtemp = [[NSUserDefaults standardUserDefaults] objectForKey:@"daigoudingdansousuohestory"];
    [arr addObjectsFromArray:arrtemp];
    [arr removeObject:strtemp];
    [arr insertObject:strtemp atIndex:0];
    
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"daigoudingdansousuohestory"];
    strsearchkey = strtemp;
    ///进行搜索
    [self startSearchAction];
    
}

-(void)startSearchAction
{
    MyOrderSearchListTableViewController *svc = [[MyOrderSearchListTableViewController alloc] init];
    svc.keywords = strsearchkey;
    svc.specialType = @"0";
    [self.navigationController pushViewController:svc animated:YES];
}

#pragma mark - UITextField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@"\n"])
    {
        [fieldsearch resignFirstResponder];
//        [MobClick event:@"dgsousuo" label:@"代购频道搜索"];
        if([textField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length>0)
        {
            NSMutableArray *arr = [NSMutableArray new];
            
            NSArray *arrtemp = [[NSUserDefaults standardUserDefaults] objectForKey:@"daigoudingdansousuohestory"];
            [arr addObjectsFromArray:arrtemp];
            if(arr.count>=20)
            {
                [arr removeLastObject];
            }
            [arr insertObject:textField.text atIndex:0];
            
            
            [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"daigoudingdansousuohestory"];
            
            strsearchkey = textField.text;
            ///进行搜索
            [self startSearchAction];
            
        }
        
        
        return NO;
    }
    return YES;
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
