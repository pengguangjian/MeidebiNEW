//
//  HomeHotView.m
//  Meidebi
//  暂未使用
//  Created by mdb-admin on 2017/8/22.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "HomeHotView.h"
@interface HomeHotView ()
<ZlJTextBannerViewDelegate>
@property (nonatomic, strong) ZlJTextBannerView *texBannerView;

@end

@implementation HomeHotView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:titleButton];
    [titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 22));
    }];
    titleButton.backgroundColor = [UIColor colorWithHexString:@"#DC5229"];
    titleButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [titleButton setTitle:@"热门推荐" forState:UIControlStateNormal];
    titleButton.layer.masksToBounds = YES;
    titleButton.layer.cornerRadius = 2.f;
    titleButton.userInteractionEnabled = NO;
    
    _texBannerView = [ZlJTextBannerView new];
    [self addSubview:_texBannerView];
    [_texBannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleButton.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.mas_top).offset(5);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
    }];
    _texBannerView.textColor = [UIColor colorWithHexString:@"#DC5229"];
    _texBannerView.fontSize = 14.f;
    _texBannerView.delegate = self;
}

- (void)textBnnanerViewDidSelectItem:(HomeHotSticksViewModel *)itemModel{
    if ([self.delegate respondsToSelector:@selector(homeHotViewDidClichkCurrentHotWithItem:)]) {
        [self.delegate homeHotViewDidClichkCurrentHotWithItem:itemModel];
    }
}

- (void)bindDataWithModel:(NSArray *)model{
    [_texBannerView textBannerPages:model];
}

- (void)stopScroll{
    [_texBannerView stop];
}

- (void)starScroll{
    [_texBannerView star];
}



@end
