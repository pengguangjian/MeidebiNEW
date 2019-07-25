//
//  GoodsCarViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/8/29.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "GoodsCarViewController.h"

#import "GoodsCarView.h"

@interface GoodsCarViewController ()<GoodsCarViewDelegate>
{
    GoodsCarView *goodsCarView;
    UIButton* btnright;
    BOOL isedit;
    
    BOOL ischange;
    
}
@end

@implementation GoodsCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购物车";
    isedit = NO;
    [self setNavigation];
    
    [self drawSubview];
}


-(void)setNavigation{
    
    btnright = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
    btnright.frame = CGRectMake(0,0,44,44);
    [btnright setTitle:@"编辑" forState:UIControlStateNormal];
    [btnright setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
    [btnright.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [btnright setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnright addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnright];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
}

-(void)editAction
{
    if(isedit)
    {
        [btnright setTitle:@"编辑" forState:UIControlStateNormal];
        isedit = NO;
    }
    else
    {
        [btnright setTitle:@"完成" forState:UIControlStateNormal];
        isedit = YES;
    }
    [goodsCarView iseditAction:isedit];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    ischange = YES;
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(ischange)
    {
        ischange = NO;
        
        [goodsCarView dataMessage];
        
    }
    
    
}

-(void)drawSubview
{
    goodsCarView = [[GoodsCarView alloc] init];
    [self.view addSubview:goodsCarView];
    [goodsCarView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }
        
    }];
    [goodsCarView setDelegate:self];
    
}

-(void)goodsListcount:(BOOL)isgoods
{
    if(isgoods)
    {
        [btnright setHidden:NO];
    }
    else
    {
        [btnright setHidden:YES];
    }
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
