//
//  FilterTypeHomeSubjectsView.m
//  Meidebi
//
//  Created by mdb-admin on 2016/11/21.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "FilterTypeHomeSubjectsView.h"
#import "ZLMultiLevelMenuView.h"

@interface FilterTypeHomeSubjectsView ()
<
ZLMultiLevelMenuViewDelegate
>
@property (nonatomic, strong) ZLMultiLevelMenuView *menuView;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) NSArray *selectItems;
@end

@implementation FilterTypeHomeSubjectsView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubjectsView];
    }
    return self;
}

- (void)setupSubjectsView{
    
    _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_confirmButton];
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.offset(50);
    }];
    [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [_confirmButton setTitleColor:[UIColor colorWithHexString:@"#FD7A0F"] forState:UIControlStateNormal];
    [_confirmButton.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
    [_confirmButton addTarget:self action:@selector(respondsToConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    _confirmButton.hidden = YES;
    
    UIView *lineView = [UIView new];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(_confirmButton.mas_top);
        make.height.offset(0.7);
    }];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    
    _menuView = [[ZLMultiLevelMenuView alloc] init];
    [self addSubview:_menuView];
    [_menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(lineView.mas_top);
    }];
    _menuView.delegate = self;


}

- (void)bindFilterTypeData:(NSArray *)model{
    if(!model) return;
    [_menuView bindDataWithViewModel:[ZLMultiLevelMenuViewModel multiLevelMenuViewModel:model]];
    _confirmButton.hidden = NO;
}


- (void)respondsToConfirmBtn:(id)sender{
    if ([self.delegate respondsToSelector:@selector(resultFilterTypes:)]) {
        [self.delegate resultFilterTypes:_selectItems];
    }
}

#pragma mark - ZLMultiLevelMenuViewDelegate
- (void)multiLevelMenuView:(ZLMultiLevelMenuView *)menuView didSeleteTypes:(NSArray *)types{
    _selectItems = types;
}
@end

