//
//  ActivityDetailCommentView.m
//  Meidebi
//
//  Created by fishmi on 2017/5/15.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "ActivityDetailCommentTextFiledView.h"
#import "RemarkHomeViewController.h"
#import "MDB_UserDefault.h"
#import "CompressImage.h"

@implementation ActivityDetailCommentTextFiledView{
    BOOL isZan;
}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
         self.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        [self setSubView];
       
    }
    return self;
}

- (void)setModel:(CommentRewardsModel *)model{
    _model = model;
    [_watchBtn setTitle:[self numberChangeStringValue:[NSNumber numberWithInt:model.browsecount.intValue]] forState:UIControlStateNormal];
    [_collectBtn setTitle:[self numberChangeStringValue:[NSNumber numberWithInt:model.commentcount.intValue]] forState:UIControlStateNormal];
    [_praiseBtn setTitle:[self numberChangeStringValue:[NSNumber numberWithInt:model.praisecount.intValue]] forState:UIControlStateNormal];
    
    
    
//    if ([model.userissigned isEqualToString:@"1"]) {
//        _praiseBtn.selected = YES;
//    }else{
//        _praiseBtn.selected = NO;
//    }
}
- (void)setSubView{
    
    float fwidth = 0.85*kScale;
    
    UIButton *watchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    watchBtn.tag = 12;
    [watchBtn setTitle:@"0" forState:UIControlStateNormal];
    [watchBtn setTitleColor:[UIColor colorWithHexString:@"#A6A6A6"] forState:UIControlStateNormal];
    [watchBtn setTitleColor:[UIColor colorWithHexString:@"#F77210"] forState:UIControlStateSelected];
    [watchBtn setImage:[UIImage imageNamed:@"pelsonal_look_normal"] forState:UIControlStateNormal];
    [watchBtn setImage:[UIImage imageNamed:@"pelsonal_look_select"] forState:UIControlStateSelected];
    watchBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [watchBtn addTarget:self action:@selector(respondEvent:) forControlEvents:UIControlEventTouchUpInside];
    [watchBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    [self addSubview:watchBtn];
    watchBtn.userInteractionEnabled = NO;
    
    [watchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-2);
        make.bottom.equalTo(self.mas_bottom);
        make.top.equalTo(self.mas_top);
        make.width.equalTo(watchBtn.mas_height).multipliedBy(fwidth).offset(13);
    }];
    _watchBtn = watchBtn;
    
    UIView *lineV1 = [[UIView alloc] init];
    lineV1.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [self addSubview:lineV1];
    [lineV1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(watchBtn.mas_left).offset(-5);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(1, 10));
        
    }];
    
    UIButton *colletBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    colletBtn.tag = 11;
    [colletBtn setTitle:@"0" forState:UIControlStateNormal];
    [colletBtn setTitleColor:[UIColor colorWithHexString:@"#A6A6A6"] forState:UIControlStateNormal];
    [colletBtn setTitleColor:[UIColor colorWithHexString:@"#F77210"] forState:UIControlStateSelected];
    [colletBtn setImage:[UIImage imageNamed:@"discount_comment_normal"] forState:UIControlStateNormal];
    [colletBtn setImage:[UIImage imageNamed:@"discount_comment_normal"] forState:UIControlStateSelected];
    colletBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [colletBtn addTarget:self action:@selector(respondEvent:) forControlEvents:UIControlEventTouchUpInside];
    [colletBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    [self addSubview:colletBtn];
    
    [colletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lineV1.mas_left).offset(-5);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.width.equalTo(colletBtn.mas_height).multipliedBy(fwidth).offset(10);
    }];
    _collectBtn = colletBtn;
    
    UIView *lineV = [[UIView alloc] init];
    lineV.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [self addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(colletBtn.mas_left).offset(-5);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(1, 10));
    }];
    _lineV = lineV;

    
    
    
    UIButton *praiseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    praiseBtn.tag = 14;
    [praiseBtn setTitle:@"0" forState:UIControlStateNormal];
    [praiseBtn setTitleColor:[UIColor colorWithHexString:@"#A6A6A6"] forState:UIControlStateNormal];
    [praiseBtn setTitleColor:[UIColor colorWithHexString:@"#F77210"] forState:UIControlStateSelected];
    [praiseBtn setImage:[UIImage imageNamed:@"discount_like_normal"] forState:UIControlStateNormal];
    [praiseBtn setImage:[UIImage imageNamed:@"discount_like_select"] forState:UIControlStateSelected];
    praiseBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [praiseBtn addTarget:self action:@selector(respondEvent:) forControlEvents:UIControlEventTouchUpInside];
    [praiseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    [self addSubview:praiseBtn];
    
    [praiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lineV.mas_left).offset(-5);
        make.bottom.equalTo(self.mas_bottom);
        make.top.equalTo(self.mas_top);
        make.width.equalTo(praiseBtn.mas_height).multipliedBy(fwidth).offset(10);
    }];
    _praiseBtn = praiseBtn;

    
    UIControl *textBtn = [[UIControl alloc] init];
    textBtn = ({
        UIControl *control = [self setupSubControlWithTitle:@"我来说两句"
                                           stateNormalImage:[UIImage imageNamed:@"write"]];
        [self addSubview:control];
        control.tag = 13;
        [control addTarget:self action:@selector(respondEvent:) forControlEvents:UIControlEventTouchUpInside];
        control;
    });
    [textBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(14);
        make.top.equalTo(self).offset(10);
        make.right.equalTo(praiseBtn.mas_left).offset(-6);
        make.bottom.equalTo(self).offset(-10);
        
    }];
    
    _textBtn = textBtn;

}

- (UIControl *)setupSubControlWithTitle:(NSString *)title
                       stateNormalImage:(UIImage *)normalImage{
    
    UIControl *control = [UIControl new];
    control.backgroundColor = [UIColor whiteColor];
    control.layer.cornerRadius = 7;
    control.clipsToBounds = YES;
    
    UIImageView *headerImageView = [UIImageView new];
    [control addSubview:headerImageView];
    
    headerImageView.contentMode = UIViewContentModeScaleAspectFit;
    headerImageView.tag = 2222;
    headerImageView.image = normalImage;
    
    UILabel *label = [UILabel new];
    [control addSubview:label];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor colorWithHexString:@"#666666"];
    label.tag = 1100;
    label.text = title;
    
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(control).offset(17);
        make.centerY.equalTo(control);
        make.size.mas_equalTo(CGSizeMake(14, 15));
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(control).offset(-11);
        make.centerY.equalTo(control);
        make.left.equalTo(headerImageView.mas_right).offset(9);
    }];
    
    
    return control;
}


- (void)respondEvent: (UIButton *)sender{
    if (sender.tag == 11) {
        RemarkHomeViewController *vc = [[RemarkHomeViewController alloc] init];
        vc.type = RemarkTypeAccumulate;
        vc.linkid = _linkId;
        if ([self.delegate respondsToSelector:@selector(clickToRemarkHomeViewController:)]) {
            [self.delegate clickToRemarkHomeViewController:vc];
        }
//        if ([self.delegate respondsToSelector:@selector(tabBarViewDidPressShouBton)]) {
//            [self.delegate tabBarViewDidPressShouBton];
//        }
        
        }else if (sender.tag == 12){
            
            
        }else if (sender.tag == 13){
            if ([self.delegate respondsToSelector:@selector(tabBarViewDidPressCommentBtonWithType:linkID:)]) {
                [self.delegate tabBarViewDidPressCommentBtonWithType:@"5" linkID:_linkId];
            }
        }else if(sender.tag == 14){
            if ([self.delegate respondsToSelector:@selector(tabBarViewDidPressZanBton)]) {
                [self.delegate tabBarViewDidPressZanBton];
            }
        }

}

- (void)updateTabBarStatuesWithType:(UpdateViewType)type
                            isMinus:(BOOL)minus{
    
    UILabel * _labelCommend=[[UILabel alloc] init];
    _labelCommend.text = @"+1";
    _labelCommend.alpha=0.0;
    _labelCommend.textColor=[UIColor redColor];
    [self addSubview:_labelCommend];
    if (type == UpdateViewTypeZan) {
        if (isZan) {
            [MDB_UserDefault showNotifyHUDwithtext:@"你已经投过票了" inView:self.superview];
            return;
        }
        [_labelCommend mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_praiseBtn);
        }];
        self.praiseNumberStr = [NSString stringWithFormat:@"%@",@([_praiseBtn.titleLabel.text integerValue]+1)];
        [_praiseBtn setImage:[UIImage imageNamed:@"discount_like_select"] forState:UIControlStateNormal];
        isZan = YES;
        [self layoutIfNeeded];
    }else{
        [_labelCommend mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_collectBtn);
        }];
        if (minus) {
            if ([_collectBtn.titleLabel.text isEqualToString:@"0"]) return;
            _labelCommend.text = @"-1";
            self.collectNumberStr = [NSString stringWithFormat:@"%@",@([_collectBtn.titleLabel.text integerValue]-1)];
            [_collectBtn setImage:[UIImage imageNamed:@"discount_collect_normal"] forState:UIControlStateNormal];
        }else{
            self.collectNumberStr = [NSString stringWithFormat:@"%@",@([_collectBtn.titleLabel.text integerValue]+1)];
            [_collectBtn setImage:[UIImage imageNamed:@"discount_collect_select"] forState:UIControlStateNormal];
        }
        [self layoutIfNeeded];
    }
    CAAnimation *animation =[CompressImage groupAnimation:_labelCommend];
    [_labelCommend.layer addAnimation:animation forKey:@"animation"];
   
}

- (void)setCollectNumberStr:(NSString *)collectNumberStr{
    _collectNumberStr = collectNumberStr;
    [_collectBtn setTitle:_collectNumberStr forState:UIControlStateNormal];
}

- (void)setPraiseNumberStr:(NSString *)praiseNumberStr{
    _praiseNumberStr = praiseNumberStr;
    [_praiseBtn setTitle:_praiseNumberStr forState:UIControlStateNormal];
}


-(NSString *)numberChangeStringValue:(NSNumber *)value
{
    NSString *strtemp = @"";
    if(value.integerValue>=1000&&value.integerValue<10000)
    {
        strtemp = [NSString stringWithFormat:@"%dk+",value.intValue/1000];
    }
    else if (value.integerValue>=10000)
    {
        strtemp = [NSString stringWithFormat:@"%dw+",value.intValue/10000];
    }
    else
    {
        strtemp = [NSString stringWithFormat:@"%d",value.intValue];
    }
    return strtemp;
}


@end
