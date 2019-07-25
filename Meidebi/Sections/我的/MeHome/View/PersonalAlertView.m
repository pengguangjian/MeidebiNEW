//
//  PersonalAlertView.m
//  Meidebi
//  性别弹窗
//  Created by fishmi on 2017/6/22.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "PersonalAlertView.h"
@interface PersonalAlertView ()
@property (nonatomic ,weak) UIView *backgrandV;
@property (nonatomic ,weak) UIButton *boyBtn;
@property (nonatomic ,weak) UIButton *girlBtn;
@property (nonatomic ,weak) UIButton *cancleBtn;
@property (nonatomic ,weak) UIButton *finishBtn;
@property (nonatomic ,strong) NSString *sex;

@end


@implementation PersonalAlertView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _sex = @"";
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

    
    
    UIButton *boyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    boyBtn.tag = 1;
    [boyBtn setTitle:@"男" forState:UIControlStateNormal];
    [boyBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    
    [boyBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [boyBtn setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:boyBtn];
    [boyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(view);
        make.height.offset((166 *kScale - 2) * 0.33 );
    }];
    _boyBtn = boyBtn;
    
    UIButton *girlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    girlBtn.tag = 2;
    [girlBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [girlBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [girlBtn setBackgroundColor:[UIColor whiteColor]];
    [girlBtn setTitle:@"女" forState:UIControlStateNormal];
    [view addSubview:girlBtn];
    [girlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.equalTo(boyBtn.mas_bottom).offset(1);
         make.height.offset((166 *kScale - 2) * 0.33 );
    }];
    
    _girlBtn = girlBtn;
    
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.tag = 3;
    [cancleBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cancleBtn setBackgroundColor:[UIColor whiteColor]];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [view addSubview:cancleBtn];
    [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(view);
        make.top.equalTo(girlBtn.mas_bottom).offset(1);
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
        make.top.equalTo(girlBtn.mas_bottom).offset(1);
        make.left.equalTo(cancleBtn.mas_right).offset(1);
        
    }];
    _finishBtn = finishBtn;
    
}

-(void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)btnClicked: (UIButton *)btn{
    if (btn.tag == 1) {
        _boyBtn.selected = YES;
        _boyBtn.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        _girlBtn.selected = NO;
        _girlBtn.backgroundColor = [UIColor whiteColor];
        _sex = @"男";
    }else if (btn.tag == 2){
        _boyBtn.selected = NO;
        _boyBtn.backgroundColor = [UIColor whiteColor];
        _girlBtn.selected = YES;
        _girlBtn.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        _sex = @"女";
    }else if (btn.tag == 3){
        [self removeFromSuperview];
    }else if (btn.tag == 4){
        if ([_sex isEqualToString:@"女"]) {
            _sex = @"1";
        }else if([_sex isEqualToString:@"男"]){
            _sex = @"2";
        }
        if ([self.delegate respondsToSelector:@selector(finishBtnClicked:view:)]) {
            [self.delegate finishBtnClicked:_sex view:self];
        }
        [self removeFromSuperview];
    }
}

@end
