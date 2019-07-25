//
//  CollectionHeaderReusableView.m
//  Meidebi
//
//  Created by mdb-admin on 16/4/7.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "CollectionHeaderReusableView.h"
#import "HistoryCollectionViewCell.h"

@interface CollectionHeaderReusableView ()

@property (nonatomic, strong) UILabel           *categoryLabel;
@property (nonatomic, strong) UIView            *topLineView;
@end

@implementation CollectionHeaderReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
 
    _categoryLabel = ({
        UILabel *lable = [UILabel new];
        [self addSubview:lable];
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self.mas_centerY);
        }];
        lable.textColor = [UIColor colorWithHexString:@"#333333"];
        lable.font = [UIFont systemFontOfSize:17];
        lable;
    });
    
    UIView *bottomLineView = [UIView new];
    [self addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.offset(1);
    }];
    bottomLineView.backgroundColor = [UIColor colorWithRed:0.8706 green:0.8745 blue:0.8706 alpha:1.0];

    _topLineView = ({
        UIView *view = [UIView new];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.offset(1);
        }];
        view.backgroundColor = bottomLineView.backgroundColor;
        view;
    });

}

#pragma mark - getters and setters

- (void)setCategoryStr:(NSString *)categoryStr{
    _categoryStr = categoryStr;
    _categoryLabel.text = _categoryStr;
}

- (void)setIsShowTopLineView:(BOOL)isShowTopLineView{
    _isShowTopLineView = isShowTopLineView;
    _topLineView.hidden = !_isShowTopLineView;
}


@end
