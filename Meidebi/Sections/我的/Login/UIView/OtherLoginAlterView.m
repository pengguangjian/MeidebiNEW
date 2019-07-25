//
//  OtherLoginAlterView.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/3/5.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import "OtherLoginAlterView.h"

@interface OtherLoginAlterView ()
{
    
}
@end

@implementation OtherLoginAlterView

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
        [self setBackgroundColor:RGBAlpha(0, 0, 0, 0.35)];
        
        UIView *viewalter = [[UIView alloc] init];
        [viewalter setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:viewalter];
        [viewalter mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.mas_width).offset(-90);
            make.height.offset(180);
            make.center.equalTo(self);
        }];
        [viewalter.layer setMasksToBounds:YES];
        [viewalter.layer setCornerRadius:5];
        
        UILabel *lbtitle = [[UILabel alloc] init];
        [viewalter addSubview:lbtitle];
        [lbtitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.right.equalTo(viewalter.mas_right).offset(-10);
            make.top.offset(30);
            make.height.offset(20);
        }];
        [lbtitle setText:@"是否已注册没得比账号？"];
        [lbtitle setTextColor:RGB(30, 30, 30)];
        [lbtitle setTextAlignment:NSTextAlignmentCenter];
        [lbtitle setFont:[UIFont systemFontOfSize:14]];
        
        
        
        UIButton *btbd = [[UIButton alloc] init];
        [viewalter addSubview:btbd];
        [btbd mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(120);
            make.height.offset(40);
            make.top.equalTo(lbtitle.mas_bottom).offset(25);
            make.centerX.equalTo(viewalter);
        }];
        [btbd.layer setMasksToBounds:YES];
        [btbd.layer setCornerRadius:3];
        [btbd.layer setBorderColor:RGB(30, 30, 30).CGColor];
        [btbd.layer setBorderWidth:1];
        [btbd setTitle:@"已注册，绑定账号" forState:UIControlStateNormal];
        [btbd setTitleColor:RGB(30, 30, 30) forState:UIControlStateNormal];
        [btbd.titleLabel setFont:[UIFont systemFontOfSize:13]];
        
        
        
        
        UIButton *btzc = [[UIButton alloc] init];
        [viewalter addSubview:btzc];
        [btzc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(120);
            make.height.offset(40);
            make.top.equalTo(btbd.mas_bottom).offset(5);
            make.centerX.equalTo(viewalter);
        }];
        [btzc setTitle:@"继续第三方登录" forState:UIControlStateNormal];
        [btzc setTitleColor:RGB(30, 30, 30) forState:UIControlStateNormal];
        [btzc.titleLabel setFont:[UIFont systemFontOfSize:12]];
        
        
        
        
    }
    return self;
}


@end
