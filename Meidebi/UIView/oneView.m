//
//  oneView.m
//  Meidebi
//
//  Created by 杜非 on 15/1/26.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import "oneView.h"
#import "Constants.h"
@implementation oneView
@synthesize delegate=_delegate;
-(id)initWithFrame:(CGRect)frame imageArr:(NSArray *)imageArr strArr:(NSArray *)strArr{
    if (self) {
        self=[super initWithFrame:frame];
    }
    NSInteger s=strArr.count%3>0? 1:0;
    NSInteger hcount=s+strArr.count/3;
    float  butWith=CGRectGetWidth(self.frame)/3;
    for (int x=0; x<strArr.count; x++) {
        UIButton *butt=[[UIButton alloc]initWithFrame:CGRectMake(x%3*(butWith), x/3*(butWith), butWith, butWith)];
        butt.tag=55+x;
        
        [butt addTarget:self action:@selector(buttsender:) forControlEvents:UIControlEventTouchUpInside];
        [butt setBackgroundImage:[UIImage imageNamed:@"huibg.png"] forState:UIControlStateHighlighted];
        
        [self addSubview:butt];
        UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake((butWith-50)/2.0, (butWith-70)/2, 50.0, 50.0)];
        NSString *titleName=strArr[x];
        NSString *imageName=imageArr[x];
        [imageV setImage:[UIImage imageNamed:imageName]];
        UILabel *labeV=[[UILabel alloc]initWithFrame:CGRectMake((butWith-60)/2.0, (butWith-80)/2+72.0, butWith, 12)];//
        labeV.center=CGPointMake((butWith-60)/2.0+30.0, (butWith-80)/2+72.0+4);
        labeV.font=[UIFont systemFontOfSize:12.0];
        [labeV setTextAlignment:NSTextAlignmentCenter];
        [labeV setTextColor:RadBarBiaoColor];
        labeV.text=titleName;
        [butt addSubview:imageV];
        [butt addSubview:labeV];
    }
    //横线
    for (int x=0; x<hcount; x++) {
        UIView *lionV=[[UIView alloc]initWithFrame:CGRectMake(0, x*butWith, CGRectGetWidth(self.frame), 1)];
        [lionV setBackgroundColor:RadLineColor];
        [self addSubview:lionV];
    }
    
    UIView *lionV=[[UIView alloc]initWithFrame:CGRectMake(0, (hcount+1)*butWith, CGRectGetWidth(self.frame)*2/3, 1)];
    [lionV setBackgroundColor:RadLineColor];
    [self addSubview:lionV];
    //竖线
    for (int x=0; x<2; x++) {
        UIView *lionV=[[UIView alloc]initWithFrame:CGRectMake(butWith*(x+1), 0, 1, CGRectGetWidth(self.frame)/3*hcount)];
        [lionV setBackgroundColor:RadLineColor];
        [self addSubview:lionV];
    }
    
     _yuanviewl=[[UIView alloc]initWithFrame:CGRectMake(butWith*2.0-20.0,butWith+10.0,8.0,8.0)];
    [_yuanviewl setBackgroundColor:[UIColor redColor]];
    [_yuanviewl.layer setMasksToBounds:YES];
    [_yuanviewl.layer setCornerRadius:4.0];
    [self addSubview:_yuanviewl];
    _yuanviewl.hidden=YES;
    
    _commentWarningView=[[UIView alloc]initWithFrame:CGRectMake(butWith*3.0-20.0,butWith+10.0,8.0,8.0)];
    [_commentWarningView setBackgroundColor:[UIColor redColor]];
    [_commentWarningView.layer setMasksToBounds:YES];
    [_commentWarningView.layer setCornerRadius:4.0];
    [self addSubview:_commentWarningView];
    _commentWarningView.hidden=YES;

    return self;
}
-(void)buttsender:(UIButton *)sender{
    if (_delegate) {
        
        NSInteger index=sender.tag-55;
        [_delegate butSelect:index];
    }

}
@end
