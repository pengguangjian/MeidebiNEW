//
//  HomeNavTitleView.m
//  Meidebi
//
//  Created by mdb-admin on 2017/9/18.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "HomeNavTitleView.h"

@interface HomeNavTitleView()
{
    UIControl *searchControl;
}
@property (nonatomic, strong) UILabel *hotSearchLabel;

@end

@implementation HomeNavTitleView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    searchControl = [UIControl new];
    [self addSubview:searchControl];
    [searchControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(-10);
        make.right.equalTo(self.mas_right).offset(10);
        make.height.offset(30);
    }];
    searchControl.backgroundColor = [UIColor colorWithHexString:@"#ECECEC"];
    [searchControl.layer setBorderColor:[UIColor colorWithHexString:@"#ECECEC"].CGColor];
    [searchControl.layer setBorderWidth:1];
    searchControl.layer.masksToBounds = YES;
    searchControl.layer.cornerRadius = (30/2.f);
    [searchControl addTarget:self
                      action:@selector(searchHandle:)
            forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *searchIconImageView = [UIImageView new];
    [searchControl addSubview:searchIconImageView];
    [searchIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(searchControl.mas_centerY);
        make.left.equalTo(searchControl.mas_left).offset(13);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    searchIconImageView.image = [UIImage imageNamed:@"searchIcon"];
    
    _hotSearchLabel = [UILabel new];
    [searchControl addSubview:_hotSearchLabel];
    [_hotSearchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(searchIconImageView.mas_centerY);
        make.left.equalTo(searchIconImageView.mas_right).offset(8);
        make.right.equalTo(searchControl.mas_right).offset(-10);
    }];
    _hotSearchLabel.textColor = RGBAlpha(190, 190, 190, 0.9);
    _hotSearchLabel.font = [UIFont systemFontOfSize:14.f];
    _hotSearchLabel.text = kDefaultHotSearchStr;
}

- (void)searchHandle:(id)sender{
    if ([self.delegate respondsToSelector:@selector(titleViewDidClickSearchWithHotWord:)]) {
        [self.delegate titleViewDidClickSearchWithHotWord:_hotSearchLabel.text];
    }
}

//- (CGSize)intrinsicContentSize{
//    return CGSizeMake(self.width, self.height);
//}

- (void)setSearchHotKeyWord:(NSString *)searchHotKeyWord{
    _searchHotKeyWord = searchHotKeyWord;
    _hotSearchLabel.text = searchHotKeyWord;
}

///设置搜索的背景颜色
-(void)setbackColor:(UIColor *)color
{
    [searchControl setBackgroundColor:color];
    
}

@end
