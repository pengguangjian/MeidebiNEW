//
//  PersonalTextAlertView.m
//  Meidebi
//  昵称弹窗
//  Created by fishmi on 2017/6/23.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "PersonalTextAlertView.h"

#import "MDB_UserDefault.h"

@interface PersonalTextAlertView ()
@property (nonatomic ,weak) UIView *backgrandV;
@property (nonatomic ,weak) UIButton *cancleBtn;
@property (nonatomic ,weak) UIButton *finishBtn;
@property (nonatomic ,weak) UILabel *titleL;
@property (nonatomic ,weak) UIImageView *imageV;
@property (nonatomic ,weak) UITextField *textField;
@end

@implementation PersonalTextAlertView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, kMainScreenW, kMainScreenH);
        [self setUpSubView];
    }
    return self;
}

- (void)setUpSubView{
    
    UIView *backgrandV = [[UIView alloc] init];
    [self addSubview:backgrandV];
    [backgrandV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    backgrandV.backgroundColor = [UIColor darkGrayColor];
    backgrandV.alpha = 0.8;
    _backgrandV = backgrandV;
    
    UIView *view = [[UIView alloc] init];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(backgrandV);
        make.size.mas_equalTo(CGSizeMake(321 *kScale, 166 *kScale));
    }];
    view.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    view.layer.cornerRadius = 4;
    view.clipsToBounds = YES;
    
    
    
    UILabel *titleL = [[UILabel alloc] init];
    titleL.textColor = [UIColor colorWithHexString:@"#333333"];
    titleL.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    titleL.font = [UIFont systemFontOfSize:18];
    titleL.textAlignment = NSTextAlignmentCenter;
    [view addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(view);
        make.height.offset((166 *kScale - 2) * 0.33 );
    }];
    _titleL = titleL;

    
    UIView *textV = [[UIView alloc] init];
    textV.backgroundColor = [UIColor whiteColor];
    [view addSubview:textV];
    [textV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.equalTo(titleL.mas_bottom).offset(1);
        make.height.offset((166 *kScale - 2) * 0.33 );
    }];
    
    UIImageView *imageV = [[UIImageView alloc] init];
    [textV addSubview:imageV];
//    imageV.backgroundColor = [UIColor redColor];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(textV.mas_centerY);
        make.left.equalTo(textV).offset(27 *kScale);
        make.size.mas_equalTo(CGSizeMake(22 * kScale, 22 * kScale));
    }];
    _imageV = imageV;
    
    UITextField *textField = [[UITextField alloc] init];
    textField.font = [UIFont systemFontOfSize:16];
    [textV addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(textV.mas_centerY);
        make.left.equalTo(imageV.mas_right).offset(7);
        make.right.equalTo(textV).offset(-10);
        make.height.offset(17);
    }];
    _textField = textField;
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.tag = 3;
    [cancleBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cancleBtn setBackgroundColor:[UIColor whiteColor]];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [view addSubview:cancleBtn];
    [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(view);
        make.top.equalTo(textV.mas_bottom).offset(1);
        make.width.offset(321 *kScale *0.5 - 1);
        
    }];
    _cancleBtn = cancleBtn;
    
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finishBtn.tag = 4;
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [finishBtn setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:finishBtn];
    [finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(view);
        make.top.equalTo(textV.mas_bottom).offset(1);
        make.left.equalTo(cancleBtn.mas_right).offset(1);
        
    }];
    _finishBtn = finishBtn;
    
}

-(void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)btnClicked: (UIButton *)btn{
    if (btn.tag == 3) {
        [self removeFromSuperview];
    }else if (btn.tag == 4){
        NSString *strtemp = _textField.text;
        strtemp = [strtemp stringByReplacingOccurrencesOfString:@" " withString:@""];
        if(strtemp.length<1)
        {
            [MDB_UserDefault showNotifyHUDwithtext:@"请输入正确的昵称" inView:self.viewController.view];
            return;
        }
        if ([self.delegate respondsToSelector:@selector(finishBtnClicked:view:)]) {
            [self.delegate finishBtnClicked:_textField.text view:self];
        }
        [self removeFromSuperview];
    }
}

- (void)setTitle:(NSString *)title placeholder:(NSString *)placeholder text:(NSString *)text image:(UIImage *)image{
    _textField.placeholder = placeholder;
    _textField.text = text;
    _titleL.text = title;
    _imageV.image = image;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textField endEditing:YES];
}


@end
