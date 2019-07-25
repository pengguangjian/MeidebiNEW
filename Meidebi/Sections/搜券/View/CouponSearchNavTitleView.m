//
//  CouponSearchNavTitleView.m
//  Meidebi
//
//  Created by mdb-admin on 2017/9/18.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "CouponSearchNavTitleView.h"

@interface CouponSearchNavTitleView()
@property (nonatomic, strong) UITextField *searchTextField;
@end

@implementation CouponSearchNavTitleView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (CGSize)intrinsicContentSize{
    return  UILayoutFittingExpandedSize;
}

- (void)setupSubviews{
    UIView *searchContainerView = [UIView new];
    [self addSubview:searchContainerView];
    [searchContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(5, 0, 5, 10));
    }];
    searchContainerView.backgroundColor = [UIColor whiteColor];
    searchContainerView.layer.cornerRadius =35/2.f;
    searchContainerView.layer.masksToBounds = YES;
    searchContainerView.layer.borderWidth = .8f;
    searchContainerView.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchContainerView addSubview:searchBtn];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(searchContainerView.mas_right).offset(-8);
        make.top.equalTo(searchContainerView.mas_top).offset(5);
        make.bottom.equalTo(searchContainerView.mas_bottom).offset(-5);
        make.width.equalTo(searchBtn.mas_height);
    }];
    [searchBtn setImage:[UIImage imageNamed:@"coupon_searchBtn"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(respondsToSearchBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    _searchTextField = [UITextField new];
    [searchContainerView addSubview:_searchTextField];
    [_searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchContainerView.mas_left).offset(17);
        make.right.equalTo(searchBtn.mas_left).offset(-15);
        make.top.equalTo(searchContainerView.mas_top).offset(8);
        make.bottom.equalTo(searchContainerView.mas_bottom).offset(-8);
    }];
    _searchTextField.textColor = [UIColor colorWithHexString:@"#999999"];
    _searchTextField.font = [UIFont systemFontOfSize:14.f];
}

- (void)respondsToSearchBtnEvent:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(searchNavTitleViewDidRespondsSearch:)]) {
        [self.delegate searchNavTitleViewDidRespondsSearch:_searchTextField.text];
    }
    [_searchTextField resignFirstResponder];
}

- (void)setTextFieldPlaceholder:(NSString *)textFieldPlaceholder{
    _searchTextField.placeholder = textFieldPlaceholder;
}

- (void)textFieldResignFirstResponder{
    [_searchTextField resignFirstResponder];
}
@end
