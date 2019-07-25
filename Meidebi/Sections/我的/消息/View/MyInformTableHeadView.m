//
//  MyInformTableHeadView.m
//  Meidebi
//
//  Created by fishmi on 2017/6/30.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "MyInformTableHeadView.h"

static NSString * const kItemTitle = @"title";
static NSString * const kItemIcon = @"icon";

@interface MyInformTableHeadView ()
@property (nonatomic, strong) NSArray *titleAdIcons;
@property (nonatomic, strong) NSArray *items;
@end

@implementation MyInformTableHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        [self setUpSubView];
    }
    return self;
}

- (void)setUpSubView{
    NSMutableArray *controls = [NSMutableArray array];
    UIControl *lastControl = nil;
    for (NSInteger i = 0; i<self.titleAdIcons.count; i++) {
        UIControl *handleControl = [self customHandleControlWithTitle:self.titleAdIcons[i][kItemTitle]
                                                                 icon:self.titleAdIcons[i][kItemIcon]];
        [self addSubview:handleControl];
        [handleControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            if (lastControl) {
                make.top.equalTo(lastControl.mas_bottom);
                make.height.equalTo(lastControl.mas_height);
            }else{
                make.top.equalTo(self.mas_top);
            }
            if (i==self.titleAdIcons.count-1) {
                make.bottom.equalTo(self.mas_bottom);
            }else{
                UIView *lineView = [[UIView alloc] init];
                [self addSubview:lineView];
                [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(self);
                    make.bottom.equalTo(handleControl.mas_bottom);
                    make.height.offset(0.8);
                }];
                lineView.backgroundColor = [UIColor colorWithHexString:@"#E2E2E2"];
            }
        }];
        handleControl.tag = 1000+i;
        [handleControl addTarget:self
                          action:@selector(respondsToControlEvent:)
                forControlEvents:UIControlEventTouchUpInside];
        lastControl = handleControl;
        [controls addObject:handleControl];
    }
    _items = controls.mutableCopy;
}

- (UIControl *)customHandleControlWithTitle:(NSString *)title icon:(UIImage *)image{
    UIControl *handleControl = [UIControl new];
    
    UIImageView *imageV = [[UIImageView alloc] init];
    [handleControl addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(handleControl.mas_centerY);
        make.left.equalTo(handleControl).offset(30 *kScale);
        make.size.mas_equalTo(CGSizeMake(40*kScale, 40*kScale));
    }];
    imageV.image = image;

    UILabel *label  = [[UILabel alloc] init];
    [handleControl addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(handleControl.mas_centerY);
        make.left.equalTo(imageV.mas_right).offset(23 *kScale);
    }];
    label.text = title;
    label.textColor = [UIColor colorWithHexString:@"#444444"];
    label.font = [UIFont systemFontOfSize:16];

    UIView *remindV = [[UIView alloc] init];
    [handleControl addSubview:remindV];
    [remindV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(handleControl).offset(-10);
        make.left.equalTo(label.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(10, 10));
        
    }];
    remindV.tag = 9999;
    remindV.layer.cornerRadius = 5;
    remindV.clipsToBounds = YES;
    remindV.backgroundColor = [UIColor redColor];
    remindV.hidden = YES;
    
    UIImageView *rightImageV = [[UIImageView alloc] init];
    [handleControl addSubview:rightImageV];
    [rightImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(handleControl).offset(-21 *kScale);
        make.centerY.equalTo(handleControl.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(8*kScale, 14 *kScale));
    }];
    rightImageV.contentMode = UIViewContentModeScaleAspectFit;
    rightImageV.image = [UIImage imageNamed:@"right"];
    
    return handleControl;
}

- (void)reamrkRemindViewShow:(BOOL)show{
    UIControl *item = _items.firstObject;
    [(UIView *)item viewWithTag:9999].hidden = show;
}

- (void)zanRemindViewShow:(BOOL)show{
    UIControl *item = _items.lastObject;
    [(UIView *)item viewWithTag:9999].hidden = show;
}
- (void)orderRemindViewShow:(BOOL)show
{
    UIControl *item = _items.lastObject;
    [(UIView *)item viewWithTag:9999].hidden = show;
}
- (void)respondsToControlEvent:(UIControl *)sender{
    HeaderViewClickControlType type = HeaderViewClickControlTypeUnkown;
    if (sender.tag == 1000) {
        type = HeaderViewClickControlTypeRemark;
    }else if (sender.tag == 1001){
        type = HeaderViewClickControlTypeZan;
    }else if (sender.tag == 1002){
        type = HeaderViewClickControlTypeOrder;
    }
    
    
    
    if ([self.delegate respondsToSelector:@selector(tableHeaderViewDidClickItemWithType:)]) {
        [self.delegate tableHeaderViewDidClickItemWithType:type];
    }
}

#pragma mark -  setters adn getters
- (NSArray *)titleAdIcons{
    if (!_titleAdIcons) {
        _titleAdIcons = @[@{kItemIcon:[UIImage imageNamed:@"comment"],
                            kItemTitle:@"评论"},
                          @{kItemIcon:[UIImage imageNamed:@"zan_news"],
                            kItemTitle:@"赞"},
                          @{kItemIcon:[UIImage imageNamed:@"wodexiaoxi_dingdan"],
                            kItemTitle:@"订单"}];
    }
    return _titleAdIcons;
}


@end
