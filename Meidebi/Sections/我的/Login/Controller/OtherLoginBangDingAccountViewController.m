//
//  OtherLoginBangDingAccountViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/3/11.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import "OtherLoginBangDingAccountViewController.h"

#import "OtherLoginBangDingAccountView.h"

@interface OtherLoginBangDingAccountViewController ()
{
    OtherLoginBangDingAccountView *subView;
}
@end

@implementation OtherLoginBangDingAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"已有账号绑定";
    [self setnavigation];
    
    [self subjectView];
}


-(void)subjectView
{
    
    subView = [OtherLoginBangDingAccountView new];
    subView.strtype = _strtype;
    subView.strname = _strname;
    subView.dicparams = _dicparams;
    subView.strpushurl = _strpushurl;
    [self.view addSubview:subView];
    [subView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }
    }];
    [subView valueInput];
    
}
-(void)setnavigation{
    UIButton *butleft=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [butleft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [butleft setImage:[UIImage imageNamed:@"back_click.png"] forState:UIControlStateHighlighted];
    [butleft addTarget:self action:@selector(doClickBackAction) forControlEvents:UIControlEventTouchUpInside];
    [butleft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    UIBarButtonItem *leftBar=[[UIBarButtonItem alloc]initWithCustomView:butleft];
    
    self.navigationItem.leftBarButtonItem=leftBar;
    
    
}

-(void)doClickBackAction
{
//    NSArray *arrvcs = self.navigationController.viewControllers;
//    if(arrvcs.count>=3)
//    {
//        UIViewController *vc = arrvcs[arrvcs.count-3];
//        [self.navigationController popToViewController:vc animated:YES];
//    }
//    else
//    {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    
    [subView backsAction];
    
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
