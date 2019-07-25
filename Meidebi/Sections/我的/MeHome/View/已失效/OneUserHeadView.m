//
//  oneUserHeadView.m
//  Meidebi
//
//  Created by fishmi on 2017/6/19.
//  Copyright © 2017年 meidebi. All rights reserved.
//



#import "OneUserHeadView.h"
#import "OneUserHeadTopView.h"
#import "MDB_UserDefault.h"


@interface OneUserHeadView ()<OneUserHeadFunctionViewDelegate,OneUserHeadTopViewDelegate>


@end

@implementation OneUserHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpSubView];
    }
    return self;
}

- (void)setUpSubView{
    UIView *view = [[UIView alloc] init];
    [self addSubview:view];
    view.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    OneUserHeadTopView *topView = [[OneUserHeadTopView alloc] init];
    topView.delegate = self;
    [view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(view);
    }];
    topView.backgroundColor = [UIColor whiteColor];
    _topView = topView;
    
    OneUserHeadFunctionView *fucV = [[OneUserHeadFunctionView alloc] init];
    fucV.delegate = self;
    [view addSubview:fucV];
    [fucV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.equalTo(topView.mas_bottom).offset(10);
        if (iPhone4 || iPhone5) {
            make.height.offset(120*kScale);
        }else{
            make.height.offset(120);
        }
        make.bottom.equalTo(view.mas_bottom).offset(-10);
    }];
    _fucV = fucV;
}

#pragma mark - OneUserHeadFunctionViewDelegate

- (void)functionSelectbyButton:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(functionSelectbyButton:)]) {
        [self.delegate functionSelectbyButton:btn];
    }
}

#pragma mark - OneUserHeadFunctionViewDelegate,OneUserHeadTopViewDelegate

- (void)clickToViewController:(UIViewController *)targetVc{
    if ([self.delegate respondsToSelector:@selector(clickToViewController:)]) {
        [self.delegate clickToViewController:targetVc];
    }
}


- (void)setUpheadViewData{
    [self.topView setUpheadViewData];
    if (![MDB_UserDefault showAppPersonalInfoFansGuide] && [MDB_UserDefault getIsLogin]) {
        if ([self.delegate respondsToSelector:@selector(headerViewShowGuideElementRects:)]) {
            CGRect fansBtnFrame = self.topView.fansBtn.frame;
            CGRect followBtnFrame = self.topView.concernBtn.frame;
            CGRect frame = CGRectMake(CGRectGetMinX(fansBtnFrame)-8, CGRectGetMinY(fansBtnFrame)+64-8, CGRectGetMaxX(followBtnFrame)-CGRectGetMinX(fansBtnFrame)+16, CGRectGetHeight(fansBtnFrame)+12);
            [self.delegate headerViewShowGuideElementRects:@[[NSValue valueWithCGRect:frame]]];
        }
    }
}

- (void)setUpImageV: (UIImage *)image{
    _topView.picV.image = image;
}



@end
