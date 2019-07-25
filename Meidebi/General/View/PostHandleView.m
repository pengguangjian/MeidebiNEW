//
//  PostHandleView.m
//  Meidebi
//
//  Created by leecool on 2017/5/16.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "PostHandleView.h"

@interface PostHandleView ()

@property (nonatomic, strong) NSMutableArray *btns;

@end

@implementation PostHandleView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, kMainScreenW, kMainScreenH-50/*tabbar height*/);
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.99];
        self.btns = [NSMutableArray array];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    UIButton *experiencePublishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:experiencePublishBtn];
    [experiencePublishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-71);
        make.left.equalTo(self.mas_left).offset(64);
        make.size.mas_equalTo(CGSizeMake(87, 115));
    }];
    experiencePublishBtn.tag = 100;
    experiencePublishBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [experiencePublishBtn setTitle:@"发原创" forState:UIControlStateNormal];
    [experiencePublishBtn.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
    [experiencePublishBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [experiencePublishBtn setImage:[UIImage imageNamed:@"experience_publish"] forState:UIControlStateNormal];
    [experiencePublishBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -131, -97, 0)];
    [experiencePublishBtn setImageEdgeInsets:UIEdgeInsetsMake(-35, 0, 0, 0)];
    [experiencePublishBtn addTarget:self action:@selector(respondsToBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.btns addObject:experiencePublishBtn];
    
    UIButton *brokePublishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:brokePublishBtn];
    [brokePublishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-71);
        make.right.equalTo(self.mas_right).offset(-64);
        make.size.mas_equalTo(CGSizeMake(87, 115));
    }];
    brokePublishBtn.tag = 110;
    brokePublishBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [brokePublishBtn setTitle:@"发爆料" forState:UIControlStateNormal];
    [brokePublishBtn.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
    [brokePublishBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [brokePublishBtn setImage:[UIImage imageNamed:@"broke_publish"] forState:UIControlStateNormal];
    [brokePublishBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -131, -97, 0)];
    [brokePublishBtn setImageEdgeInsets:UIEdgeInsetsMake(-35, 0, 0, 0)];
    [brokePublishBtn addTarget:self action:@selector(respondsToBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.btns addObject:brokePublishBtn];

}

- (void)beginAnimate{
    [self layoutIfNeeded];
    [self.btns enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL*stop) {
        UIButton* btn = obj;
        CGFloat x = btn.frame.origin.x;
        CGFloat y = btn.frame.origin.y;
        CGFloat width = btn.frame.size.width;
        CGFloat height = btn.frame.size.height;
        btn.frame=CGRectMake(x, [UIScreen mainScreen].bounds.size.height+ y -self.frame.origin.y, width, height);
        btn.alpha=0.0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(idx *0.03*NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:25 options:UIViewAnimationOptionCurveEaseIn animations:^{
                btn.alpha=1;
                btn.frame=CGRectMake(x, y, width, height);
            } completion:^(BOOL finished) {
                
            }];
            
        });
    }];
}

- (void)removeAnimation{
    [self.btns enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton * btn = obj;
        CGFloat x = btn.frame.origin.x;
        CGFloat y = btn.frame.origin.y;
        CGFloat width = btn.frame.size.width;
        CGFloat height = btn.frame.size.height;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((self.btns.count - idx) * 0.03 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:5 options:0 animations:^{
                btn.alpha = 0;
                btn.frame = CGRectMake(x, [UIScreen mainScreen].bounds.size.height - self.frame.origin.y + y, width, height);
            } completion:^(BOOL finished) {
                if ([btn isEqual:[self.btns firstObject]]) {
                    self.superview.superview.userInteractionEnabled = YES;
                }
            }];
        });
        
    }];
    
}

- (void)respondsToBtnEvent:(UIButton *)sender{
    PulishType type;
    if (sender.tag == 100) {
        type = PulishTypeExperience;
    }else if (sender.tag == 110){
        type = PulishTypeBroke;
    }
    else{
        type = PulishTypeBroke;
    }
    if (_didClickPublishBtn) {
        _didClickPublishBtn(type);
    }
    
}
@end
