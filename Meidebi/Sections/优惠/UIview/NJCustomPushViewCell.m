//
//  NJCustomPushViewCell.m
//  Meidebi
//
//  Created by mdb-admin on 16/4/12.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "NJCustomPushViewCell.h"

@interface NJCustomPushViewCell ()

@property (nonatomic, strong) UILabel *typeNameLabel;
@property (nonatomic, strong) UIImageView *selectFlagImageView;

@end

@implementation NJCustomPushViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    
    _typeNameLabel = ({
        UILabel *label = [UILabel new];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        label.font = [UIFont systemFontOfSize:14.f];
        label;
    });
    
    _selectFlagImageView = ({
        UIImageView *imageView = [UIImageView new];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(18, 22));
        }];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:@"pushSelectFlag"];
        imageView.hidden = YES;
        imageView;
    });
    
}

- (void)setTypeName:(NSString *)typeName{
    _typeName = typeName;
    _typeNameLabel.text = typeName;
}

- (void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    _selectFlagImageView.hidden = !_isSelect;
}




@end
