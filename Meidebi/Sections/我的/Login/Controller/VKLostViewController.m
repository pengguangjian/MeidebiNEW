//
//  VKLostViewController.m
//  Meidebi
//
//  Created by 杜非 on 15/3/19.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import "VKLostViewController.h"
#import "HTTPManager.h"
#import "Constants.h"
#import "MDB_UserDefault.h"
@interface VKLostViewController (){
    UIWebView  *_webVIew;
    
}

@end

@implementation VKLostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"邮箱验证";
    [self setNavigation];
    
    UITapGestureRecognizer *tapNum=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapNum)];
    tapNum.numberOfTapsRequired=1;
    tapNum.numberOfTouchesRequired=1;
    [self.view addGestureRecognizer:tapNum];
    // Do any additional setup after loading the view.
}
-(void)tapNum{
    [_textField resignFirstResponder];

}
-(void)setNavigation{
    UIButton* btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
    btnLeft.frame = CGRectMake(0,0,44,44);
    [btnLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_click.png"] forState:UIControlStateHighlighted];
    [btnLeft addTarget:self action:@selector(doClickLeftAction) forControlEvents:UIControlEventTouchUpInside];
    [btnLeft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)doClickLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)butSure:(id)sender {
    
    [_textField resignFirstResponder];
    [HTTPManager sendRequestUrlToService:URL_findpass withParametersDictionry:@{@"email":[NSString nullToString:_textField.text]} view:self.view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct){
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[dicAll objectForKey:@"status"] intValue]==1) {
                if (![dicAll[@"data"] isKindOfClass:[NSString class]]) return;
                _webVIew=[[UIWebView alloc]initWithFrame:CGRectMake(0, 64.0, self.view.frame.size.width, self.view.frame.size.height-64)];
                NSURLRequest *requst=[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:[dicAll objectForKey:@"data"]]];
                [_webVIew loadRequest:requst];
                [self.view addSubview:_webVIew];
            }else{
                if ([dicAll[@"info"] isKindOfClass:[NSString class]]) {
                    [MDB_UserDefault showNotifyHUDwithtext:[dicAll objectForKey:@"info"] inView:self.view];
                }else{
                    [MDB_UserDefault showNotifyHUDwithtext:@"邮箱验证失败！" inView:self.view];
                }
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
