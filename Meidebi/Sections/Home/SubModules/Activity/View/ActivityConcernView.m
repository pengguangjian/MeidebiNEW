//
//  ActivityConcernView.m
//  Meidebi
//
//  Created by fishmi on 2017/5/15.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "ActivityConcernView.h"

@implementation ActivityConcernView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#FBF4EF"];
        [self setSubView];
        
    }
    return self;
}

- (void)setSubView{
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
//    imageV.backgroundColor = [UIColor blueColor];
    imageV.layer.cornerRadius = 30 *kScale;
    imageV.clipsToBounds = YES;
    [self addSubview:imageV];
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(60 *kScale, 60 *kScale));
    }];
    imageV.userInteractionEnabled = YES;
    _imageV = imageV;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClicked)];
    [imageV addGestureRecognizer:gesture];
    
    UIButton *concernBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    concernBtn.layer.cornerRadius = 4;
    concernBtn.clipsToBounds = YES;
    concernBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [concernBtn setTitle:@"+关注" forState:UIControlStateNormal];
    [concernBtn setTitle:@"已关注" forState:UIControlStateSelected];
    [concernBtn setBackgroundImage:[UIImage imageNamed:@"btnBackgroundImage"] forState:UIControlStateNormal];
    concernBtn.tag = 11;
    [self addSubview:concernBtn];
    [concernBtn addTarget:self action:@selector(respondsToFollowBtn:) forControlEvents:UIControlEventTouchUpInside];
    [concernBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-16);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(61, 25));
    }];
    _concernBtn = concernBtn;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = [UIFont systemFontOfSize:12];
    nameLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageV.mas_right).offset(16);
        make.top.equalTo(self).offset(24);
        make.size.mas_equalTo(CGSizeMake(100, 13));
    }];
    
    _nameLabel = nameLabel;
    
    UILabel *subLabel = [[UILabel alloc] init];
    subLabel.text = @"最近发布爆料 篇";
    subLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    subLabel.font = [UIFont systemFontOfSize:12];
    subLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:subLabel];
    [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageV.mas_right).offset(16);
        make.top.equalTo(nameLabel.mas_bottom).offset(7);
        make.size.mas_equalTo(CGSizeMake(200, 14));
        
    }];
    _subLabel = subLabel;
    
}

- (UIControl *)setupSubControlWithTitle:(NSString *)title
                       stateNormalImage:(UIImage *)normalImage{
    
    UIControl *control = [UIControl new];
    control.backgroundColor = [UIColor clearColor];
    
    UIImageView *backGroundV = [UIImageView new];
    [control addSubview:backGroundV];

    backGroundV.contentMode = UIViewContentModeScaleAspectFit;
    backGroundV.tag = 2222;
    backGroundV.image = normalImage;
    
    UILabel *label = [UILabel new];
    [control addSubview:label];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    label.tag = 1100;
    label.text = title;
    
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(control);
        make.size.mas_equalTo(CGSizeMake(33, 12));
    }];
    
    [backGroundV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(control);
        make.size.mas_equalTo(control);
    }];
    
    return control;
}

- (void)respondsToFollowBtn:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(detailSubjectViewDidCickAddFollowdidComplete:)]) {
        [self.delegate detailSubjectViewDidCickAddFollowdidComplete:^(BOOL state) {
           
        }];
        _concernBtn.userInteractionEnabled = NO;
        _concernBtn.selected = YES;
    }
}

- (void)imageViewClicked{
    if ([self.delegate respondsToSelector:@selector(imageViewClicked)]) {
        [self.delegate imageViewClicked];
    }
}


@end
