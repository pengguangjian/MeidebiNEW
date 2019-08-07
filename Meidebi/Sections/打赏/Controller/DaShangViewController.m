//
//  DaShangViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/8/7.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import "DaShangViewController.h"
#import "DaShangView.h"

@interface DaShangViewController ()

@end

@implementation DaShangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"打赏代购菌";
    [self drawUI];
}

-(void)drawUI
{
    DaShangView *mview = [[DaShangView alloc] init];
    [mview setBackgroundColor:RGB(237, 236, 237)];
    [self.view addSubview:mview];
    
    [mview mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
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
