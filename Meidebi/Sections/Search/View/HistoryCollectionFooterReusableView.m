//
//  HistoryCollectionFooterReusableView.m
//  Meidebi
//
//  Created by mdb-admin on 16/4/22.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "HistoryCollectionFooterReusableView.h"
#import "UIColor+Hex.h"
@implementation HistoryCollectionFooterReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.offset(42);
    }];
    [button setTitle:@"删除搜索记录" forState:UIControlStateNormal];
     button.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [button setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(respondesToButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"clearSearchHistory"] forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, -6)];
    
    UIView *lineView = ({
        UIView *view = [UIView new];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(button);
            make.bottom.equalTo(button.mas_top);
            make.height.offset(1);
        }];
        view;
    });
    lineView.backgroundColor = [UIColor colorWithRed:0.9207 green:0.9307 blue:0.9307 alpha:1.0];
    
    UIView *bottomLineView = ({
        UIView *view = [UIView new];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(button);
            make.top.equalTo(button.mas_bottom);
            make.height.offset(1);
        }];
        view;
    });
    bottomLineView.backgroundColor = [UIColor colorWithHexString:@"#E4E4E4"];
    
}


- (void)respondesToButton:(id)sender{
    if ([self.delegate respondsToSelector:@selector(deleteHistory)]) {
        [self.delegate deleteHistory];
    }
}
@end
