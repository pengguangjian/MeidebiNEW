//
//  MDBShareActionSheet.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/22.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "MDBShareActionSheet.h"

@interface MDBShareActionSheet ()

@property (nonatomic, strong) NSArray *shareItems;

@end

@implementation MDBShareActionSheet

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, kMainScreenW, kMainScreenH);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    closeBtn.backgroundColor = [UIColor clearColor];
    [closeBtn addTarget:self action:@selector(respondsToBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *containerView = [UIView new];
    [self addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(containerView.mas_width).multipliedBy(0.77);
    }];
    containerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [UILabel new];
    [containerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containerView.mas_top).offset(kMainScreenW*0.054);
        make.centerX.equalTo(containerView.mas_centerX);
    }];
    titleLabel.font = [UIFont systemFontOfSize:14.f];
    titleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    titleLabel.text = @"分享给好友";
    [titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    UIView *leftLineView = [UIView new];
    [containerView addSubview:leftLineView];
    [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel.mas_centerY);
        make.right.equalTo(titleLabel.mas_left).offset(-12);
        make.left.equalTo(containerView.mas_left).offset(kMainScreenW*.11);
        make.height.offset(1);
    }];
    leftLineView.backgroundColor = [UIColor colorWithHexString:@"#D3D3D3"];
    
    UIView *rightLineView = [UIView new];
    [containerView addSubview:rightLineView];
    [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel.mas_centerY);
        make.right.equalTo(containerView.mas_right).offset(-kMainScreenW*.11);
        make.left.equalTo(titleLabel.mas_right).offset(12);
        make.height.offset(1);
    }];
    rightLineView.backgroundColor = [UIColor colorWithHexString:@"#D3D3D3"];
    
    UIControl *lastItem = nil;
    for (NSInteger i = 0; i < self.shareItems.count; i++) {
        UIControl *item = [self setupShareItem:self.shareItems[i]];
        [containerView addSubview:item];
        item.tag = 10000 + i;
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i==0 || i==3) {
                if (i== 0) {
                    make.top.equalTo(titleLabel.mas_bottom).offset(kMainScreenW*0.061);
                }else{
                    make.top.equalTo(lastItem.mas_bottom).offset(12);
                }
                make.left.equalTo(containerView.mas_left).offset(kMainScreenW*.11);
            }else{
                make.top.equalTo(lastItem.mas_top);
                make.left.equalTo(lastItem.mas_right).offset(kMainScreenW*.11);
                if ( i==2) {//i==self.shareItems.count-1 ||
                    make.right.equalTo(containerView.mas_right).offset(-kMainScreenW*.11);
                }
            }
            make.height.equalTo(item.mas_width);
            if (lastItem) {
                make.size.mas_equalTo(lastItem);
            }
        }];
        lastItem = item;
        [item addTarget:self action:@selector(respondsToControlEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [containerView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(containerView);
        make.top.equalTo(lastItem.mas_bottom).offset(19);
    }];
    cancelBtn.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(respondsToBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)respondsToBtnEvent:(UIButton *)sender{
    [self removeFromSuperview];
}

- (void)respondsToControlEvent:(UIControl *)sender{
    MDBShareType type;
    switch (sender.tag) {
        case MDBShareTypeWeChat:
            type = MDBShareTypeWeChat;
            break;
        case MDBShareTypeWeMoments:
            type = MDBShareTypeWeMoments;
            break;
        case MDBShareTypeQQ:
            type = MDBShareTypeQQ;
            break;
        case MDBShareTypeSpace:
            type = MDBShareTypeSpace;
            break;
        case MDBShareTypeSinaWeibo:
            type = MDBShareTypeSinaWeibo;
            break;
        case MDBShareTypeTencentWeibo:
            type = MDBShareTypeTencentWeibo;
            break;
        default:
            type = MDBShareTypeTencentWeibo;
            break;
    }
    if ([self.delegate respondsToSelector:@selector(shareActionSheetDidClickedSharButtonAtType:)]) {
        [self.delegate shareActionSheetDidClickedSharButtonAtType:type];
    }
    [self removeFromSuperview];
}

- (UIControl *)setupShareItem:(UIImage *)image{
    UIControl *control = [UIControl new];
    control.layer.masksToBounds = YES;
    control.layer.cornerRadius = 4.f;
    control.layer.borderWidth = 1.f;
    control.layer.borderColor = [UIColor colorWithHexString:@"#E0E0E0"].CGColor;
    
    UIImageView *imageView = [UIImageView new];
    [control addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(control).insets(UIEdgeInsetsMake(kMainScreenW*.049, kMainScreenW*.049, kMainScreenW*.049, kMainScreenW*.049));
    }];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = image;
    
    return control;
}

#pragma mark - setters and getters
- (NSArray *)shareItems{
    if (!_shareItems) {
        _shareItems = @[[UIImage imageNamed:@"invite_weChat"],
                        [UIImage imageNamed:@"invite_weMoments"],
                        [UIImage imageNamed:@"invite_tencentQQ"],
                        [UIImage imageNamed:@"invite_tencentSpace"],
                        [UIImage imageNamed:@"invite_sinaWeibo"],
//                        [UIImage imageNamed:@"invite_tencentWeibo"]
                        ];
    }
    return _shareItems;
}

@end
