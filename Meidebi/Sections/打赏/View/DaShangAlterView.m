//
//  DaShangAlterView.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/8/8.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import "DaShangAlterView.h"


@interface DaShangAlterView ()<UITextFieldDelegate>
{
    UITextField *fieldvalue;
}
@end

@implementation DaShangAlterView

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
    [self setBackgroundColor:RGBAlpha(0, 0, 0, 0.4)];
    
    UIView *viewcenter = [[UIView alloc] init];
    [viewcenter setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:viewcenter];
    [viewcenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.equalTo(self).offset(-20);
        make.centerY.equalTo(self);
    }];
    [viewcenter.layer setMasksToBounds:YES];
    [viewcenter.layer setCornerRadius:5];
    [viewcenter.layer setBorderColor:RGBAlpha(234, 234, 234, 1).CGColor];
    [viewcenter.layer setBorderWidth:1];
    
    
    UILabel *lbtitle = [[UILabel alloc] init];
    [lbtitle setTextColor:RGBAlpha(30, 30, 30, 1)];
    [lbtitle setText:@"感谢您的一份心意"];
    [lbtitle setTextAlignment:NSTextAlignmentCenter];
    [lbtitle setFont:[UIFont boldSystemFontOfSize:15]];
    [viewcenter addSubview:lbtitle];
    [lbtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(viewcenter);
        make.top.offset(10);
        make.height.offset(30);
    }];
    
    UIButton *btdel = [[UIButton alloc] init];
    [btdel setImage:[UIImage imageNamed:@"pindanguanbi_X"] forState:UIControlStateNormal];
    [viewcenter addSubview:btdel];
    [btdel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(viewcenter);
        make.height.offset(40);
        make.width.offset(40);
    }];
    [btdel addTarget:self action:@selector(delAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    fieldvalue = [[UITextField alloc] init];
    [fieldvalue setFont:[UIFont systemFontOfSize:14]];
    [fieldvalue setTextColor:RGB(30, 30, 30)];
    [fieldvalue setTextAlignment:NSTextAlignmentCenter];
    [fieldvalue setPlaceholder:@"请输入1-50元的金额"];
    [viewcenter addSubview:fieldvalue];
    [fieldvalue setBackgroundColor:RGB(245, 245, 245)];
    [fieldvalue.layer setBorderWidth:1];
    [fieldvalue.layer setBorderColor:RGB(234, 234, 234).CGColor];
    [fieldvalue.layer setCornerRadius:2];
    [fieldvalue setKeyboardType:UIKeyboardTypeNumberPad];
    [fieldvalue mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.offset(20);
        make.right.equalTo(viewcenter).offset(-20);
        make.top.equalTo(lbtitle.mas_bottom).offset(20);
        make.height.offset(50*kScale);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fieldValueDidChange) name:UITextFieldTextDidChangeNotification object:nil];
    
    
    UIButton *btdas = [[UIButton alloc] init];
    [btdas setBackgroundColor:RadMenuColor];
    [btdas setTitle:@"确认打赏" forState:UIControlStateNormal];
    [btdas setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btdas.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [btdas.layer setMasksToBounds:YES];
    [btdas.layer setCornerRadius:2];
    [viewcenter addSubview:btdas];
    [btdas mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(fieldvalue);
        make.top.equalTo(fieldvalue.mas_bottom).offset(20);
        make.height.equalTo(fieldvalue);
    }];
    [btdas addTarget:self action:@selector(dasAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [viewcenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(btdas.mas_bottom).offset(30);
    }];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:NO];
}

-(void)fieldValueDidChange
{
    if(fieldvalue.text.floatValue > 50)
    {
        fieldvalue.text = @"50";
    }
}

-(void)delAction
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [self removeFromSuperview];
}


-(void)dasAction
{
    [self delAction];
    [self.delegate DaShangAlterViewDaShangAction:fieldvalue.text];
    
}

@end
