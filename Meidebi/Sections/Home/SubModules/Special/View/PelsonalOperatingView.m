//
//  PelsonalOperatingView.m
//  Meidebi
//
//  Created by mdb-admin on 2017/5/18.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "PelsonalOperatingView.h"
#import "PelsonalHandleButton.h"
#import "MDB_UserDefault.h"
#import "CompressImage.h"
static NSString * const kButtonSelectStatueColor = @"#F77210";
static NSString * const kButtonNormalStatueColor = @"#999999";

@interface PelsonalOperatingView ()

@property (nonatomic, strong) PelsonalHandleButton *likeBtn;
@property (nonatomic, strong) PelsonalHandleButton *readBtn;
@property (nonatomic, strong) PelsonalHandleButton *collectBtn;
@property (nonatomic, assign) BOOL isZan;

@property (nonatomic , retain) UIControl *commentHandle;
@end

@implementation PelsonalOperatingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
   
    PelsonalHandleButton *collectBtn = [PelsonalHandleButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:collectBtn];
    [collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.mas_top).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
    collectBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    collectBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [collectBtn setTitleColor:[UIColor colorWithHexString:kButtonNormalStatueColor]
                  forState:UIControlStateNormal];
    [collectBtn setImage:[UIImage imageNamed:@"pelsonal_collect_normal"] forState:UIControlStateNormal];
    [collectBtn addTarget:self action:@selector(respondsToBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    _collectBtn = collectBtn;
    
    ////****
    
    UIView *lineView1 = [UIView new];
    [self addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(collectBtn.mas_left).offset(-10);
        make.centerY.equalTo(collectBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(1, 10));
    }];
    lineView1.backgroundColor = [UIColor colorWithHexString:kButtonNormalStatueColor];
    
//    PelsonalHandleButton *readBtn = [PelsonalHandleButton buttonWithType:UIButtonTypeCustom];
//    [self addSubview:readBtn];
//    [readBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(lineView1.mas_left).offset(-13);
//        make.top.bottom.equalTo(collectBtn);
//    }];
//    readBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
//    readBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
//    [readBtn setTitleColor:[UIColor colorWithHexString:kButtonNormalStatueColor]
//                  forState:UIControlStateNormal];
//    [readBtn setImage:[UIImage imageNamed:@"pelsonal_look_normal"] forState:UIControlStateNormal];
//    [readBtn addTarget:self action:@selector(respondsToBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
//    _readBtn = readBtn;
//
//    UIView *lineView = [UIView new];
//    [self addSubview:lineView];
//    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(readBtn.mas_left).offset(-10);
//        make.centerY.equalTo(readBtn.mas_centerY);
//        make.size.mas_equalTo(CGSizeMake(1, 10));
//    }];
//    lineView.backgroundColor = [UIColor colorWithHexString:kButtonNormalStatueColor];
    
    PelsonalHandleButton *likeBtn = [PelsonalHandleButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:likeBtn];
    [likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lineView1.mas_left).offset(-13);
        make.top.bottom.equalTo(_collectBtn);
    }];
    likeBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    likeBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [likeBtn setTitleColor:[UIColor colorWithHexString:kButtonNormalStatueColor]
                  forState:UIControlStateNormal];
    [likeBtn setImage:[UIImage imageNamed:@"pelsonal_linke_normal"] forState:UIControlStateNormal];
    [likeBtn addTarget:self action:@selector(respondsToBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    _likeBtn = likeBtn;

    ////***
    
    
    UIControl *commentHandleControl = [UIControl new];
    [self addSubview:commentHandleControl];
    [commentHandleControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.bottom.equalTo(collectBtn);
        make.right.equalTo(likeBtn.mas_left).offset(-10);
        
    }];
    commentHandleControl.backgroundColor = [UIColor whiteColor];
    commentHandleControl.layer.cornerRadius = 7.f;
    [commentHandleControl addTarget:self action:@selector(respondsToControlEvent:) forControlEvents:UIControlEventTouchUpInside];
    _commentHandle = commentHandleControl;
    
    UIImageView *iconImageView = [UIImageView new];
    [commentHandleControl addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(commentHandleControl.mas_centerY);
        make.left.equalTo(commentHandleControl.mas_left).offset(17);
        make.size.mas_equalTo(CGSizeMake(9, 9));
    }];
    iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    iconImageView.image = [UIImage imageNamed:@"pelsonal_input_normal"];
    
    UILabel *titleLabel = [UILabel new];
    [commentHandleControl addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.mas_right).offset(9);
        make.centerY.equalTo(iconImageView.mas_centerY);
        make.right.equalTo(commentHandleControl.mas_right).offset(-15);
    }];
    titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    titleLabel.font = [UIFont systemFontOfSize:13.f];
    titleLabel.text = @"我来说两句";

}

- (void)bindViewData:(NSDictionary *)modelDict{
    if (!modelDict) return;
    
    [_likeBtn setTitle:modelDict[kPelsonalLikeNumberKey] forState:UIControlStateNormal];
    [_readBtn setTitle:modelDict[kPelsonalReadNumberKey] forState:UIControlStateNormal];
    [_collectBtn setTitle:modelDict[kPelsonalCollectNumberKey] forState:UIControlStateNormal];
    
}

- (void)respondsToBtnEvent:(PelsonalHandleButton *)sender{
    PelsonalHandleButtonType type;
    if (sender == _collectBtn) {
        type = PelsonalHandleButtonTypeCollect;
    }else if (sender == _likeBtn){
        type = PelsonalHandleButtonTypeLike;
    }else if (sender == _readBtn){
        type = PelsonalHandleButtonTypeRead;
    }
    else
    {
        type = PelsonalHandleButtonTypeRead;
    }
    if ([self.delegate respondsToSelector:@selector(operatingViewDidClickHandleButtonWithType:)]) {
        [self.delegate operatingViewDidClickHandleButtonWithType:type];
    }
}

- (void)respondsToControlEvent:(UIControl *)sender{
    if ([self.delegate respondsToSelector:@selector(operatingViewDidClickInputView)]) {
        [self.delegate operatingViewDidClickInputView];
    }
}

- (void)updatePelsonalStatuesWithType:(PelsonalUpdateViewType)type
                              isMinus:(BOOL)minus{
    
    UILabel * _labelCommend=[[UILabel alloc] init];
    _labelCommend.text = @"+1";
    _labelCommend.alpha=0.0;
    _labelCommend.textColor=[UIColor redColor];
    [self addSubview:_labelCommend];
    if (type == PelsonalUpdateViewTypeZan) {
        if (_isZan) {
            [MDB_UserDefault showNotifyHUDwithtext:@"你已经投过票了" inView:self.superview];
            return;
        }
        [_labelCommend mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_likeBtn);
        }];
        NSString *zanNumberStr = [NSString stringWithFormat:@"%@",@([_likeBtn.titleLabel.text integerValue]+1)];
        [_likeBtn setImage:[UIImage imageNamed:@"pelsonal_linke_select"] forState:UIControlStateNormal];
        [_likeBtn setTitle:zanNumberStr forState:UIControlStateNormal];
        [_likeBtn setTitleColor:[UIColor colorWithHexString:kButtonSelectStatueColor] forState:UIControlStateNormal];

        _isZan = YES;
        [self layoutIfNeeded];
    }else{
        [_labelCommend mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_collectBtn);
        }];
        if (minus) {
            if ([_collectBtn.titleLabel.text isEqualToString:@"0"]) return;
            _labelCommend.text = @"-1";
            NSString *shouNumberStr = [NSString stringWithFormat:@"%@",@([_collectBtn.titleLabel.text integerValue]-1)];
            [_collectBtn setImage:[UIImage imageNamed:@"pelsonal_collect_normal"] forState:UIControlStateNormal];
            [_collectBtn setTitle:shouNumberStr forState:UIControlStateNormal];
            [_collectBtn setTitleColor:[UIColor colorWithHexString:kButtonNormalStatueColor] forState:UIControlStateNormal];
        }else{
            NSString *shouNumberStr = [NSString stringWithFormat:@"%@",@([_collectBtn.titleLabel.text integerValue]+1)];
            [_collectBtn setImage:[UIImage imageNamed:@"pelsonal_collect_select"] forState:UIControlStateNormal];
             [_collectBtn setTitle:shouNumberStr forState:UIControlStateNormal];
            [_collectBtn setTitleColor:[UIColor colorWithHexString:kButtonSelectStatueColor] forState:UIControlStateNormal];
        }
        [self layoutIfNeeded];
    }
    CAAnimation *animation =[CompressImage groupAnimation:_labelCommend];
    [_labelCommend.layer addAnimation:animation forKey:@"animation"];
}

@end
