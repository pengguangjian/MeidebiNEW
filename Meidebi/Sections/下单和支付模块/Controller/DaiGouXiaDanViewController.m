//
//  DaiGouXiaDanViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/30.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "DaiGouXiaDanViewController.h"

#import "DaiGouXiaDanMainView.h"


//static UIEdgeInsets kPadding = {64,0,0,0};

@interface DaiGouXiaDanViewController ()
{
    DaiGouXiaDanMainView *dgView;
    
}
@end

@implementation DaiGouXiaDanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(_itype==2)
    {
        self.title = @"拼单下单";
    }
    else
    {
        self.title = @"代购下单";
    }
    
    
    [self drawSubview];
    
}

-(void)drawSubview
{
    float ftopheith =  kStatusBarHeight+44;
    float fother = 34.0;
    if(ftopheith<66)
    {
        ftopheith = 64;
        fother = 0;
    }
    dgView = [[DaiGouXiaDanMainView alloc] initWithFrame:CGRectMake(0, ftopheith, BOUNDS_WIDTH, self.view.height-ftopheith-fother)];
    dgView.iscanyupintuan = _iscanyupintuan;
    dgView.iseditnumber = _iseditnumber;
    [self.view addSubview:dgView];
    if(_dicvalue!= nil)
    {
        
        [dgView bindData:_dicvalue andstrpindan_id:_strpindan_id];
    }
    else
    {
        [dgView bindUrl:_strid andstrpindan_id:_strpindan_id];
    }
    
    
}

-(void)dealloc
{
    [dgView.toptimeer invalidate];
    
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
