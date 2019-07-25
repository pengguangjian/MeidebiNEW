//
//  PinDanAlterView.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/27.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "PinDanAlterView.h"

#import "MDB_UserDefault.h"

#import "DaiGouXiaDanViewController.h"

#import "VKLoginViewController.h"

#import "ProductInfoDataController.h"

@interface PinDanAlterView()
{
    UIView *viewCenter;
    
    ProductInfoDataController *dataControl;
}

@end

@implementation PinDanAlterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        
    }
    return self;
}

-(void)drawSubview
{
    viewCenter = [[UIView alloc] initWithFrame:CGRectMake(15, 5, self.width-30, 100)];
    [viewCenter setBackgroundColor:[UIColor whiteColor]];
//    [viewCenter.layer setMasksToBounds:YES];
    [viewCenter.layer setCornerRadius:10];
    viewCenter.layer.shadowColor = [UIColor blackColor].CGColor;
    viewCenter.layer.shadowOffset = CGSizeMake(0, 0);
    viewCenter.layer.shadowOpacity = 0.5;
    viewCenter.layer.shadowRadius = 5.0;
    [self addSubview:viewCenter];
    
    
    UILabel *lbtitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, viewCenter.width, 20)];
    [lbtitle setText:[NSString stringWithFormat:@"参与%@的拼单",[_dicValue objectForKey:@"nickname"]]];//
    [lbtitle setTextColor:RGB(51, 51, 51)];
    [lbtitle setTextAlignment:NSTextAlignmentCenter];
    [lbtitle setFont:[UIFont systemFontOfSize:16]];
    [viewCenter addSubview:lbtitle];
    
    UILabel *lbnumber = [[UILabel alloc] initWithFrame:CGRectMake(0, lbtitle.bottom+15, viewCenter.width, 20)];
    
    [lbnumber setText:[NSString stringWithFormat:@"仅剩%@个名额，%@结束",[_dicValue objectForKey:@"remain_pindannum"],[MDB_UserDefault strTimefromData:[[_dicValue objectForKey:@"endtime"] integerValue] dataFormat:nil]]];
    [lbnumber setTextColor:RGB(153, 153, 153)];
    [lbnumber setTextAlignment:NSTextAlignmentCenter];
    [lbnumber setFont:[UIFont systemFontOfSize:14]];
    [viewCenter addSubview:lbnumber];
    
    UIButton *btdel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btdel setRight:viewCenter.width];
    [viewCenter addSubview:btdel];
    UIImageView *imgvdel = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    [imgvdel setCenter:CGPointMake(btdel.width/2.0, btdel.height/2.0)];
    [imgvdel setImage:[UIImage imageNamed:@"pindanguanbi_X"]];
    [btdel addSubview:imgvdel];
    [btdel addTarget:self action:@selector(delAction) forControlEvents:UIControlEventTouchUpInside];
    
    float fbottom = 0.0;
    NSArray *arr = [_dicValue objectForKey:@"pindanusers"];
    int icoun = (int)arr.count+1;
    if(arr.count>4)
    {
        icoun = 5;
    }
    for(int i = 0 ; i < icoun; i++)
    {
        BOOL istuanzuang = NO;
        NSString *strnickname = @"";
        if(i == 0)
        {
            istuanzuang = YES;
            strnickname = [_dicValue objectForKey:@"nickname"];
        }
        if(i>=arr.count)
        {
            UIView *viewitem0 = [self drawUserItem:CGRectMake(54+44*i, lbnumber.bottom+20, 34, 50) andstrimage:@"pindanshenyuyonghutouxiang" andname:strnickname andtuanzhuang:istuanzuang];
            [viewCenter addSubview:viewitem0];
        }
        else
        {
            UIView *viewitem0 = [self drawUserItem:CGRectMake(54+44*i, lbnumber.bottom+20, 34, 50) andstrimage:arr[i] andname:strnickname andtuanzhuang:istuanzuang];
            [viewCenter addSubview:viewitem0];
            fbottom = viewitem0.bottom;
        }
        
    }
    
    
    
    UIButton *btAction = [[UIButton alloc] initWithFrame:CGRectMake(54, fbottom+20, viewCenter.width-108, 38)];
    [btAction setBackgroundColor:RGB(230,56,47)];
    [btAction.layer setMasksToBounds:YES];
    [btAction.layer setCornerRadius:5];
    [btAction setTitle:@"参与拼团" forState:UIControlStateNormal];
    [btAction setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btAction.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [btAction addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
    [viewCenter addSubview:btAction];
    
    [viewCenter setHeight:btAction.bottom+30];
    [viewCenter setCenter:CGPointMake(self.width/2.0, self.height/2.0)];
    
    

}

-(UIView *)drawUserItem:(CGRect)rect andstrimage:(NSString *)strimage andname:(NSString *)strname andtuanzhuang:(BOOL)istuanzhuang
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.width, view.width)];
    [imgv setImage:[UIImage imageNamed:strimage]];
    [imgv.layer setMasksToBounds:YES];
    [imgv.layer setCornerRadius:imgv.height/2.0];
    if([[strimage lastPathComponent] isEqualToString:strimage])
    {
        [imgv setImage:[UIImage imageNamed:strimage]];
    }
    else
    {
        [[MDB_UserDefault defaultInstance] setViewWithImage:imgv url:strimage];
    }
    [view addSubview:imgv];
    
    UILabel *lbname = [[UILabel alloc] initWithFrame:CGRectMake(0, imgv.bottom+5, imgv.width, 15)];
    [lbname setText:strname];
    [lbname setTextColor:RGB(102, 102, 102)];
    [lbname setTextAlignment:NSTextAlignmentCenter];
    [lbname setFont:[UIFont systemFontOfSize:10]];
    [view addSubview:lbname];
    
    if(istuanzhuang)
    {
        UILabel *lbtuanzhuang = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, imgv.width, 15)];
        [lbtuanzhuang setText:@"团长"];
        [lbtuanzhuang setTextAlignment:NSTextAlignmentCenter];
        [lbtuanzhuang setFont:[UIFont systemFontOfSize:10]];
        [lbtuanzhuang setTextColor:[UIColor whiteColor]];
        [lbtuanzhuang.layer setMasksToBounds:YES];
        [lbtuanzhuang.layer setCornerRadius:2];
        [lbtuanzhuang setBackgroundColor:RGB(230,56,47)];
        [view addSubview:lbtuanzhuang];
        
    }
    
    
    return view;
}


-(void)delAction
{
    [viewCenter removeFromSuperview];
    viewCenter = nil;
    [self removeFromSuperview];
}
#pragma mark - 参与拼团
-(void)startAction
{
    if ([MDB_UserDefault getIsLogin] == NO)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请登录后再试"
                                                           delegate:self
                                                  cancelButtonTitle:Nil
                                                  otherButtonTitles:@"登录",@"取消", nil];
        [alertView setTag:111];
        [alertView show];
        return;
    }
    if(_dicnextValue==nil)
    {
        if(dataControl == nil)
        {
            dataControl = [[ProductInfoDataController alloc] init];
        }
        
        NSString *strgoodsid=[NSString stringWithFormat:@"%@",[_dicValue objectForKey:@"goods_id"]];
        NSString *strpindanid=[NSString stringWithFormat:@"%@",[_dicValue objectForKey:@"pindan_id"]];
        NSDictionary *dicpush = @{@"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken],@"id":strgoodsid,@"pindanid":strpindanid};
        [dataControl requestDGHomeDataInView:self.viewController.view.window dicpush:dicpush Callback:^(NSError *error, BOOL state, NSString *describle) {
            if(state)
            {
                DaiGouXiaDanViewController *dvc = [[DaiGouXiaDanViewController alloc] init];
                dvc.strid = strgoodsid;/////
                dvc.strpindan_id = strpindanid;
                dvc.itype = 2;
                dvc.iscanyupintuan = YES;
                dvc.dicvalue = dataControl.dicValue;
                [self.viewController.navigationController pushViewController:dvc animated:YES];
                
                [viewCenter removeFromSuperview];
                viewCenter = nil;
                [self removeFromSuperview];
            }
            else
            {
                [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.viewController.view.window];
            }
        }];
    }
    else
    {
        NSString *strgoodsid=[NSString stringWithFormat:@"%@",[_dicValue objectForKey:@"goods_id"]];
        NSString *strpindanid=[NSString stringWithFormat:@"%@",[_dicValue objectForKey:@"pindan_id"]];
        DaiGouXiaDanViewController *dvc = [[DaiGouXiaDanViewController alloc] init];
        dvc.strid = strgoodsid;/////
        dvc.strpindan_id = strpindanid;
        dvc.itype = 2;
        dvc.iscanyupintuan = YES;
        dvc.dicvalue = _dicnextValue;
        [self.viewController.navigationController pushViewController:dvc animated:YES];
        
        [viewCenter removeFromSuperview];
        viewCenter = nil;
        [self removeFromSuperview];
    }
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==111){
        if (buttonIndex==0) {
            
            VKLoginViewController *vkVC = [[VKLoginViewController alloc] init];
            [self.viewController.navigationController pushViewController:vkVC animated:YES];
        }
    }
    
}


@end
