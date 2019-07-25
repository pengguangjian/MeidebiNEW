//
//  OneUserShareBuyViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/7/18.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import "OneUserShareBuyViewController.h"

#import "OneUserShareBuyView.h"

@interface OneUserShareBuyViewController ()

@end

@implementation OneUserShareBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分享购买";
    [self drawUI];
    
}

-(void)drawUI
{
    OneUserShareBuyView *mview = [[OneUserShareBuyView alloc] init];
    [mview setBackgroundColor:RGB(118, 67, 252)];
    [self.view addSubview:mview];
    
    [mview mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            //            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
            make.edges.equalTo(self.view);
        }
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
