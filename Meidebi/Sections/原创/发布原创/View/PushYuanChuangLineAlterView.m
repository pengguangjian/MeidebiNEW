//
//  PushYuanChuangLineAlterView.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/9/6.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "PushYuanChuangLineAlterView.h"
@interface PushYuanChuangLineAlterView ()
{
    UITextField *fieldtext;
    
}
@end

@implementation PushYuanChuangLineAlterView

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
        UILabel *lbtext = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 50)];
        [lbtext setText:@"添加链接"];
        [lbtext setTextColor:RGB(150, 150, 150)];
        [lbtext setTextAlignment:NSTextAlignmentLeft];
        [lbtext setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:lbtext];
        
        
        fieldtext = [[UITextField alloc] initWithFrame:CGRectMake(10, 50, self.width-20, 45)];
        [fieldtext setTextColor:RGB(50, 50, 50)];
        [fieldtext setTextAlignment:NSTextAlignmentLeft];
        [fieldtext setFont:[UIFont systemFontOfSize:14]];
        [fieldtext setPlaceholder:@"复制商品链接在此处……"];
        [fieldtext setBackgroundColor:[UIColor whiteColor]];
        [fieldtext setBorderStyle:UITextBorderStyleRoundedRect];
        [self addSubview:fieldtext];
        
        
        NSArray *arrbottom = [NSArray arrayWithObjects:@"确定",@"取消", nil];
        
        for(int i = 0 ; i < arrbottom.count; i++)
        {
            UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(20+((self.width-60)/2.0+20)*i, fieldtext.bottom+20, (self.width-60)/2.0, 45)];
            [bt setTitle:arrbottom[i] forState:UIControlStateNormal];
            [bt setTitleColor:RGB(60, 60, 60) forState:UIControlStateNormal];
            [bt.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [bt.layer setMasksToBounds:YES];
            [bt.layer setCornerRadius:3];
//            [bt.layer setBorderColor:RGB(218, 218, 218).CGColor];
//            [bt.layer setBorderWidth:1];
            if(i==0)
            {
                [bt setBackgroundColor:RadMenuColor];
            }
            else
            {
                [bt setBackgroundColor:RGB(152, 152, 152)];
            }
            [bt setTag:i];
            [self addSubview:bt];
            [bt addTarget:self action:@selector(btitemAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
}

-(void)showView:(float )fbottom
{
    
    [UIView animateWithDuration:0.2 animations:^{
        [self setBottom:self.superview.center.y];
    } completion:^(BOOL finished) {
       [fieldtext becomeFirstResponder];
    }];
}

-(void)btitemAction:(UIButton *)sender
{
    [fieldtext resignFirstResponder];
    switch (sender.tag) {
        case 0:
        {
            [self.delegate addLineUrlValue:fieldtext.text];
        }
            break;
        case 1:
        {
            
        }
            break;
        default:
            break;
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self setTop:self.superview.bottom];
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
}

-(void)hiddenView
{
    [fieldtext resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        [self setTop:self.superview.bottom];
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
}

@end
