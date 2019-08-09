//
//  DaShangSuccessView.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/8/8.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import "DaShangSuccessView.h"


@interface DaShangSuccessView ()

@end

@implementation DaShangSuccessView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self drawUI];
    }
    return self;
}

-(void)drawUI
{
    [self setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *imgvsuccess = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, BOUNDS_WIDTH*0.2, BOUNDS_WIDTH*0.2)];
    [imgvsuccess setImage:[UIImage imageNamed:@"zhifu_success"]];
    [imgvsuccess setCenter:CGPointMake(kMainScreenW/2.0, 0)];
    [imgvsuccess setTop:50];
    [self addSubview:imgvsuccess];
    
    UILabel *lbtext = [[UILabel alloc] initWithFrame:CGRectMake(0, imgvsuccess.bottom+15, kMainScreenW, 20)];
    [lbtext setText:@"打赏成功！代购菌很快就会收到哦~"];
    [lbtext setTextColor:RGB(51,51,51)];
    [lbtext setTextAlignment:NSTextAlignmentCenter];
    [lbtext setFont:[UIFont systemFontOfSize:16]];
    [self addSubview:lbtext];
    
    
    UIButton *btback = [[UIButton alloc] initWithFrame:CGRectMake(0, lbtext.bottom+40, kMainScreenW*0.4, 50*kScale)];
    [btback setTitle:@"返回订单列表" forState:UIControlStateNormal];
    [btback setTitleColor:RadMenuColor forState:UIControlStateNormal];
    [btback.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [btback.layer setBorderColor:RadMenuColor.CGColor];
    [btback.layer setBorderWidth:1];
    [btback.layer setCornerRadius:4];
    [btback setCenterX:kMainScreenW/2.0];
    [self addSubview:btback];
    
    [btback addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)backAction
{
    [self.viewController.navigationController popViewControllerAnimated:YES];
}

@end
