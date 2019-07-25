//
//  SearchEndViewController.m
//  Meidebi
//
//  Created by 杜非 on 15/2/4.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import "SearchEndViewController.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"
#import "ProductInfoViewController.h"

#import "OriginalDetailViewController.h"

#import "SearchEnginesTabView.h"

#import "SearchHomeViewController.h"

@interface SearchEndViewController ()<UITextFieldDelegate,SearchEnginesTabViewDelegate>
{
    UIView *viewtitle;
    UITextField *fieldsearch;
    SearchEnginesTabView *_searchTabview;
    
}
@property(nonatomic,strong)SearchTableView *searchTable;
@end

@implementation SearchEndViewController
@synthesize searchStr=_searchStr;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.title=[NSString stringWithFormat:@"搜索“%@”的结果",_searchStr];
    
    
    UIButton *_leftBut=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
    [_leftBut setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [_leftBut addTarget:self action:@selector(leftBack:) forControlEvents:UIControlEventTouchUpInside];
    [_leftBut setImage:[UIImage imageNamed:@"back_click.png"] forState:UIControlStateHighlighted];
    [_leftBut setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:_leftBut]];
    _searchTable=[[SearchTableView alloc]initWithFrame:CGRectZero search:_searchStr delegate:self];
    [self.view addSubview:_searchTable];
    [_searchTable mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }
    }];

}
-(void)leftBack:(UIButton *)sender{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
//    [self.navigationController popToRootViewControllerAnimated:YES];
    NSArray *arrvc = self.navigationController.viewControllers;
    for(UIViewController *vc in arrvc)
    {
        if([vc isKindOfClass:[SearchHomeViewController class]])
        {
            [self dismissViewControllerAnimated:NO completion:nil];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [viewtitle removeFromSuperview];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setsearchtitle];
}

/*
 添加了新的代理 这个在这里是无效的
 */
-(void)tableViewSelecte:(Articlel *)art{
//    ProductInfoViewController *productinfoVc = [[ProductInfoViewController alloc] init];
//    productinfoVc.productId = [NSString stringWithFormat:@"%@",@([art.artid intValue])];
//    [self.navigationController pushViewController:productinfoVc animated:YES];
}
///彭添加修改
-(void)tabViewSelectItem:(id)model andheadertag:(NSInteger)tag
{
    if(tag == 0 || tag == 1|| tag == 2|| tag == 3)
    {///全部优惠 、优惠券
        SearchGoodsModel *art = model;
        ProductInfoViewController *productinfoVc = [[ProductInfoViewController alloc] init];
        productinfoVc.productId = [NSString stringWithFormat:@"%@",@([art.strid intValue])];
        [self.navigationController pushViewController:productinfoVc animated:YES];

    }
    else if (tag == 4)
    {///原创
        SearchYuanChuangModel *art = model;
        OriginalDetailViewController *showdanVC = [[OriginalDetailViewController alloc] initWithOriginalID:art.strid];
        [self.navigationController pushViewController:showdanVC animated:YES];
    }
    else if (tag == 5)
    {///用户
        
    }
//    NSLog(@"%ld",tag);
    
}

-(void)tabViewBeginDragging
{
    
    [fieldsearch resignFirstResponder];
    [_searchTabview removeFromSuperview];
    _searchTabview = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setsearchtitle
{
    viewtitle = [[UIView alloc]initWithFrame:CGRectMake(50, 5, self.view.width-70, 34)];
    [viewtitle setBackgroundColor:RGB(233, 233, 233)];
    [viewtitle.layer setMasksToBounds:YES];
    [viewtitle.layer setCornerRadius:viewtitle.height/2.0];
    [self.navigationController.navigationBar addSubview:viewtitle];
    
    fieldsearch = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, viewtitle.width-30, viewtitle.height)];
    [fieldsearch setText:_searchStr];
    [fieldsearch setPlaceholder:@"搜一下看看~"];
    [fieldsearch setTextColor:RGB(30, 30, 30)];
    [fieldsearch setTextAlignment:NSTextAlignmentLeft];
    [fieldsearch setFont:[UIFont systemFontOfSize:14]];
    [fieldsearch setReturnKeyType:UIReturnKeySearch];
    [fieldsearch setDelegate:self];
    [viewtitle addSubview:fieldsearch];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fieldChangeValue) name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - UITextField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@"\n"])
    {
        NSLog(@"开始搜索");
        [MDB_UserDefault setProcducs:fieldsearch.text];
        [_searchTabview removeFromSuperview];
        _searchTabview = nil;
        [fieldsearch resignFirstResponder];
        [_searchTable loadSearchKeywords:fieldsearch.text];
        return NO;
    }
    return YES;
}

-(void)fieldChangeValue
{
//    if(_searchTabview == nil)
//    {
//        _searchTabview = [[SearchEnginesTabView alloc] initWithFrame:CGRectMake(0, _searchTable.top, self.view.width, 100)];
//        [_searchTabview setDegelate:self];
//        [self.view addSubview:_searchTabview];
//    }
//    _searchTabview.strkeywords = fieldsearch.text;
//    [_searchTabview loaddata];
//    NSLog(@"搜索引擎");
}

#pragma mark - SearchEnginesTabViewDelegate
-(void)SearchEnginesTabViewDelegateSelectValue:(id)value
{
    [fieldsearch setText:value];
    
    [MDB_UserDefault setProcducs:value];
    [_searchTabview removeFromSuperview];
    _searchTabview = nil;
    [fieldsearch resignFirstResponder];
    ///开始搜索
    NSLog(@"开始搜索");
    [_searchTable loadSearchKeywords:fieldsearch.text];
}



@end
