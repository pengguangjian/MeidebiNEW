//
//  OtherLoginBangDingPhoneView.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/3/12.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import "OtherLoginBangDingPhoneView.h"

#import "MDB_UserDefault.h"

@interface OtherLoginBangDingPhoneView ()
{
    UILabel *lbtop ;
    
    
}

@end

@implementation OtherLoginBangDingPhoneView

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
        [self setupSubviews];
    }
    return self;
}

-(void)setupSubviews
{
    UITapGestureRecognizer *tapview = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiskey)];
    [self addGestureRecognizer:tapview];
    
    UIScrollView *scv = [[UIScrollView alloc] init];
    [self addSubview:scv];
    [scv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        
    }];
    UIView *contairView = [UIView new];
    [scv addSubview:contairView];
    [contairView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scv);
        make.width.equalTo(scv);
    }];
    
    UIImageView *imageV = [[UIImageView alloc] init];
    [contairView addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contairView.mas_centerX);
        make.top.offset(20);
        make.size.mas_equalTo(CGSizeMake(280 *kScale, 125 *kScale));
    }];
    imageV.image = [UIImage imageNamed:@"bindingImage"];
    
    lbtop = [[UILabel alloc] init];
    [contairView addSubview:lbtop];
    [lbtop mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.offset(40);
        make.top.equalTo(imageV.mas_bottom).offset(20);
    }];
    [lbtop setTextColor:RadMenuColor];
    [lbtop setText:[NSString stringWithFormat:@"Hi，%@欢迎来没得比，绑定手机优惠信息不错过~",_strname]];
    [lbtop setTextAlignment:NSTextAlignmentCenter];
    [lbtop setNumberOfLines:2];
    [lbtop setFont:[UIFont systemFontOfSize:15]];
    
    
    UITextField *fieldphone = [[UITextField alloc] init];
    [fieldphone setPlaceholder:@"输入手机号"];
    UIView *viewphone = [self drawitem:CGRectZero andimage:[UIImage imageNamed:@"bangdingaccount"] andname:@"手机号" andfield:fieldphone];
    [contairView addSubview:viewphone];
    [viewphone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(lbtop.mas_bottom).offset(20);
        make.height.offset(60*kScale);
    }];
    
    
    UITextField *fieldcode = [[UITextField alloc] init];
    [fieldcode setPlaceholder:@"输入验证码"];
    UIView *viewcode = [self drawitem:CGRectZero andimage:[UIImage imageNamed:@"bangdingaccount"] andname:@"验证码" andfield:fieldcode];
    [contairView addSubview:viewcode];
    [viewcode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(viewphone.mas_bottom).offset(5);
        make.height.offset(60*kScale);
    }];
    
    UIButton *acquireCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [viewcode addSubview:acquireCodeBtn];
    [acquireCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewcode.mas_right);
        make.centerY.equalTo(viewcode.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(100 *kScale, 30 *kScale));
    }];
    acquireCodeBtn.backgroundColor = [UIColor colorWithHexString:@"#FD7A0E"];
    acquireCodeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [acquireCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    acquireCodeBtn.tag = 100;
    acquireCodeBtn.layer.cornerRadius = 4;
    acquireCodeBtn.clipsToBounds = YES;
    [acquireCodeBtn addTarget:self action:@selector(responsToButtonEvents:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UITextField *fieldpass = [[UITextField alloc] init];
    [fieldpass setPlaceholder:@"输入密码"];
    [fieldpass setSecureTextEntry:YES];
    UIView *viewpass = [self drawitem:CGRectZero andimage:[UIImage imageNamed:@"bangdingaccount"] andname:@"输入密码" andfield:fieldpass];
    [contairView addSubview:viewpass];
    [viewpass mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(viewcode.mas_bottom).offset(5);
        make.height.offset(60*kScale);
    }];
    
    UITextField *fieldpassok = [[UITextField alloc] init];
    [fieldpassok setPlaceholder:@"再次输入密码"];
    [fieldpassok setSecureTextEntry:YES];
    UIView *viewpassok = [self drawitem:CGRectZero andimage:[UIImage imageNamed:@"bangdingaccount"] andname:@"确认密码" andfield:fieldpassok];
    [contairView addSubview:viewpassok];
    [viewpassok mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(viewpass.mas_bottom).offset(5);
        make.height.offset(60*kScale);
    }];
    
    
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [contairView addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20);
        make.left.equalTo(self.mas_left).offset(20);
        make.top.equalTo(viewpassok.mas_bottom).offset(40 *kScale);
        make.height.offset(50 *kScale);
    }];
    [loginBtn setBackgroundImage:[MDB_UserDefault createImageWithColor:[UIColor colorWithHexString:@"#FD7A0E"]] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[MDB_UserDefault createImageWithColor:[UIColor colorWithHexString:@"#ff8721"]] forState:UIControlStateHighlighted];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [loginBtn setTitleColor:[UIColor whiteColor]
                   forState:UIControlStateNormal];
    [loginBtn setTitle:@"提交" forState:UIControlStateNormal];
    loginBtn.layer.masksToBounds  =YES;
    loginBtn.layer.cornerRadius = 4.f;
    loginBtn.tag = 101;
    [loginBtn addTarget:self action:@selector(responsToButtonEvents:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [contairView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20);
        make.left.equalTo(self.mas_left).offset(20);
        make.top.equalTo(loginBtn.mas_bottom);
        make.height.offset(50 *kScale);
    }];
    
    backBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [backBtn setTitleColor:RGB(203, 203, 203)
                  forState:UIControlStateNormal];
    [backBtn setTitle:@"跳过" forState:UIControlStateNormal];
    backBtn.layer.masksToBounds  =YES;
    backBtn.layer.cornerRadius = 4.f;
    backBtn.tag = 102;
    [backBtn addTarget:self action:@selector(responsToButtonEvents:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *bangdingphoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [contairView addSubview:bangdingphoneBtn];
    [bangdingphoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.bottom.equalTo(backBtn.mas_bottom).offset(50);
        make.height.offset(50 *kScale);
    }];
    
    bangdingphoneBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#69BAF1"]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:@"已有账号，立即绑定" attributes:attribtDic];
    [bangdingphoneBtn setAttributedTitle:attribtStr forState:UIControlStateNormal];
    bangdingphoneBtn.tag = 103;
    [bangdingphoneBtn addTarget:self action:@selector(responsToButtonEvents:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [contairView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bangdingphoneBtn.mas_bottom).offset(10);
    }];
    
}


-(UIView *)drawitem:(CGRect)rect andimage:(UIImage *)image andname:(NSString *)name andfield:(UITextField *)field
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    
    UIImageView *imgv = [[UIImageView alloc] init];
    [imgv setImage:image];
    [view addSubview:imgv];
    [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(10);
        make.height.equalTo(view.mas_height).multipliedBy(0.3);
        make.width.equalTo(view.mas_height).multipliedBy(0.3);
        make.centerY.equalTo(view);
        
    }];
    [imgv setContentMode:UIViewContentModeScaleAspectFit];
    
    UILabel *lbname = [[UILabel alloc] init];
    [view addSubview:lbname];
    [lbname mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(imgv.mas_right).offset(10);
        make.top.bottom.equalTo(view);
        make.width.offset(80);
    }];
    [lbname setTextAlignment:NSTextAlignmentLeft];
    [lbname setText:name];
    [lbname setTextColor:RGB(150, 150, 150)];
    [lbname setFont:[UIFont systemFontOfSize:15]];
    
    [view addSubview:field];
    [field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbname.mas_right).offset(15);
        make.top.bottom.equalTo(view);
        make.right.equalTo(view.mas_right).offset(-10);
    }];
    [field setTextColor:RGB(50, 50, 50)];
    [field setFont:[UIFont systemFontOfSize:15]];
    [field setTextAlignment:NSTextAlignmentLeft];
    
    UIView *viewline = [[UIView alloc] init];
    [viewline setBackgroundColor:RGB(235, 235, 235)];
    [view addSubview:viewline];
    [viewline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.bottom.equalTo(view);
        make.height.offset(1);
    }];
    
    return view;
}
-(void)valueInput
{
    [lbtop setText:[NSString stringWithFormat:@"Hi，%@欢迎来没得比，绑定手机优惠信息不错过~",_strname]];
}
-(void)dismiskey
{
    [self endEditing:YES];
}

-(void)responsToButtonEvents:(UIButton *)sender
{
    switch (sender.tag) {
        case 100:
        {////验证码
            
        }
            break;
        case 101:
        {////登录
            NSArray *arrvcs = self.viewController.navigationController.viewControllers;
            if(arrvcs.count>=4)
            {
                UIViewController *vc = arrvcs[arrvcs.count-4];
                [self.viewController.navigationController popToViewController:vc animated:YES];
            }
            else
            {
                [self.viewController.navigationController popViewControllerAnimated:YES];
            }
        }
            break;
        case 102:
        {////跳过
            NSArray *arrvcs = self.viewController.navigationController.viewControllers;
            if(arrvcs.count>=4)
            {
                UIViewController *vc = arrvcs[arrvcs.count-4];
                [self.viewController.navigationController popToViewController:vc animated:YES];
            }
            else
            {
                [self.viewController.navigationController popViewControllerAnimated:YES];
            }
        }
            break;
        case 103:
        {////已有账号，绑定账号
            
            [self.viewController.navigationController popViewControllerAnimated:YES];
        }
            break;
        default:
            break;
    }
    
}



@end
