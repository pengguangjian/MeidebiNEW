//
//  ZiZhuUserInfoViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/5/22.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import "ZiZhuUserInfoViewController.h"

#import "ZiZhuUserInfoView.h"

@interface ZiZhuUserInfoViewController ()

@end

@implementation ZiZhuUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"自助代购";
    
    [self drawSubview];
    
}

-(void)drawSubview
{
    float ftopheith =  kStatusBarHeight+44;
    float fother = 0.0;
    if(ftopheith<66)
    {
        ftopheith = 64;
        fother = 0;
    }
    
    ZiZhuUserInfoView *zview = [[ZiZhuUserInfoView alloc] initWithFrame:CGRectMake(0, ftopheith, BOUNDS_WIDTH, BOUNDS_HEIGHT-ftopheith-fother)];
    [self.view addSubview:zview];
    
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
