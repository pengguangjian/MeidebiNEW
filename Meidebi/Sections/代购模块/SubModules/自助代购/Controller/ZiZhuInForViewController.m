//
//  ZiZhuInForViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/5/22.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import "ZiZhuInForViewController.h"

#import "ZiZhuInForView.h"

@interface ZiZhuInForViewController ()

@end

@implementation ZiZhuInForViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"自助代购";
    
    [self drawSubview];
}

-(void)drawSubview
{
    ZiZhuInForView *zview = [[ZiZhuInForView alloc] init];
    [self.view addSubview:zview];
    [zview mas_makeConstraints:^(MASConstraintMaker *make) {
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
