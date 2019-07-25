//
//  OneUserHeadFunctionView.m
//  Meidebi
//
//  Created by fishmi on 2017/6/19.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "OneUserHeadFunctionView.h"
#import "MDB_UserDefault.h"
#import "VKLoginViewController.h"
@interface OneUserHeadFunctionView ()<UIAlertViewDelegate>
{
    UIView *viewyindao;
    UIView *viewson;
}
@end

@implementation OneUserHeadFunctionView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setUpSubView];
    }
    return self;
}

- (void)setUpSubView{
    UIView *view = [[UIView alloc] init];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    NSArray *strArr = @[@"订单",@"收藏",@"原创",@"爆料",@"优惠券"];
    NSArray *imageNameArr = @[@"home_user_dingdan",@"mycollection",@"myshare",@"mybroke",@"myconcessions"];
    for (int i = 0; i < strArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
       
        btn.tag = 100 + i ;
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset( i * (kMainScreenW - 3) * 0.2  + i * 1);
            make.top.bottom.equalTo(view);
            make.width.offset((kMainScreenW - 3) * 0.2);
        }];
        
        UIImageView *imageV = [[UIImageView alloc] init];
        imageV.image = [UIImage imageNamed:imageNameArr[i]];
//        imageV.backgroundColor = [UIColor blueColor];
        [btn addSubview:imageV];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btn.mas_centerX);
            make.top.equalTo(btn).offset(26);
            make.size.mas_equalTo(CGSizeMake(47 *kScale, 47 *kScale));
        }];
        UILabel *label = [[UILabel alloc] init];
        label.text = strArr[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor colorWithHexString:@"#666666"];
        [btn addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageV.mas_bottom).offset(9);
            make.centerX.equalTo(btn.mas_centerX);
            make.left.right.equalTo(btn);
        }];
        
        
    }
    
    
    
    
    
    
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    /*
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"homeuseryindao"] intValue]!=1)
    {
        ////UIImageResizingModeTile：平铺模式  UIImageResizingModeStretch：拉伸模式
        if(viewyindao != nil)
        {
            [viewyindao removeFromSuperview];
            
            
        }
        
        float fheig = 0.0;
        if (iPhone4 || iPhone5) {
            fheig = 140*kScale;
        }else{
            fheig = 140;
        }
        viewyindao = [MDB_UserDefault drawYinDaoLine:CGRectMake(0, 0, (kMainScreenW - 3) * 0.2, fheig) addview:self andtitel:@"代购订单进度查询点这里"];
        UITapGestureRecognizer *tapyindao = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disyindaoAction)];
        [viewyindao addGestureRecognizer:tapyindao];
    }

    */
    
}

-(void)disyindaoAction
{
    [viewyindao removeFromSuperview];
    viewyindao = nil;

    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"homeuseryindao"];
}


- (void)btnClicked: (UIButton *)sender{
    if (![MDB_UserDefault getIsLogin]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请登录后再试"
                                                           delegate:self
                                                  cancelButtonTitle:Nil
                                                  otherButtonTitles:@"登录",@"取消", nil];
        [alertView setTag:110];
        [alertView show];
    }else{
        if ([self.delegate respondsToSelector:@selector(functionSelectbyButton:)]) {
            [self.delegate functionSelectbyButton:sender];
        }
    }

    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 110) {
        if (buttonIndex == 0) {
            VKLoginViewController* theViewController= [[VKLoginViewController alloc] init];
            if ([self.delegate respondsToSelector:@selector(clickToViewController:)]) {
                [self.delegate clickToViewController:theViewController];
            }
            else
            {
                [self.viewController.navigationController pushViewController:theViewController animated:YES];
            }
            
        }
        
    }
    
}

@end
