//
//  OtherLoginBangDingPhoneViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/3/12.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import "OtherLoginBangDingPhoneViewController.h"

#import "OtherLoginBangDingPhoneView.h"

@interface OtherLoginBangDingPhoneViewController ()

@end

@implementation OtherLoginBangDingPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定手机号";
    
    
    [self subjectView];
}


-(void)subjectView
{
    
    OtherLoginBangDingPhoneView *subView = [OtherLoginBangDingPhoneView new];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
