//
//  ProductInfoJBAalterView.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/8/13.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "ProductInfoJBAalterView.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"

#import "MDB_UserDefault.h"
@interface ProductInfoJBAalterView ()

@property (nonatomic, strong) UIView *contairView;
@property (nonatomic, strong) UIWindow *showWindow;
@property (nonatomic, strong) UIButton *continueBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *title;

///当前选中
@property (nonatomic , retain) UIButton *btNowSelect;

@end

@implementation ProductInfoJBAalterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView{
    _contairView = [UIView new];
    [self addSubview:_contairView];
    [_contairView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.offset(300*kScale);
    }];
    _contairView.backgroundColor = [UIColor whiteColor];
    _contairView.layer.masksToBounds = YES;
    _contairView.layer.cornerRadius = 3.f;
    
    UILabel *title = [UILabel new];
    [_contairView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_contairView.mas_centerX);
        make.top.equalTo(_contairView.mas_top).offset(23);
    }];
    title.font = [UIFont boldSystemFontOfSize:17.f];
    title.textColor = [UIColor colorWithHexString:@"#333333"];
    title.text = @"是否确认举报该信息？";
    _title = title;
    
    
    ///
    NSArray *arrtitle = [NSArray arrayWithObjects:@"价格上调    ",@"商品售罄    ",@"优惠券过期",@"其他           ", nil];
    UIButton *btlastitem;
    for(int i = 0 ; i < 2; i++)
    {
        for (int j = 0 ; j < 2; j++)
        {
            UIButton *btitem = [[UIButton alloc] init];
            [_contairView addSubview:btitem];
            [btitem mas_makeConstraints:^(MASConstraintMaker *make) {
               
                if(j==1)
                {
                    make.right.equalTo(_contairView);
                }
                else
                {
                   make.left.equalTo(_contairView);
                }
                
                make.top.equalTo(title.mas_bottom).offset(20+i*45*kScale);
                make.width.equalTo(_contairView.mas_width).multipliedBy(0.5);
                make.height.offset(45*kScale);
            }];
            [btitem setImage:[UIImage imageNamed:@"yuan_select_no"] forState:UIControlStateNormal];
            [btitem setTitle:arrtitle[j+i*2] forState:UIControlStateNormal];
            [btitem setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
            [btitem.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [btitem.titleLabel setTextAlignment:NSTextAlignmentLeft];
            [btitem setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
            [btitem addTarget:self action:@selector(itemSelect:) forControlEvents:UIControlEventTouchUpInside];
            [btitem setTag:j+i*2];
            
            btlastitem = btitem;
            
            
            
        }
    }
    
    ///
    
    
    UILabel *contentLabel = [UILabel new];
    [_contairView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btlastitem.mas_bottom).offset(20);
        make.left.equalTo(_contairView.mas_left).offset(18);
        make.right.equalTo(_contairView.mas_right).offset(-18);
    }];
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    contentLabel.font = [UIFont systemFontOfSize:13.f];
    contentLabel.text = @"确定商品已过期，恶意举报将扣除双倍铜币";
    _contentLabel = contentLabel;
    
    UIView *lineView = [UIView new];
    [_contairView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_contairView);
        make.top.equalTo(contentLabel.mas_bottom).offset(25);
        make.height.offset(1);
    }];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#DCDCDC"];
    
    UIView *midlineView = [UIView new];
    [_contairView addSubview:midlineView];
    [midlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_contairView.mas_centerX);
        make.top.equalTo(lineView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(1, 50));
    }];
    midlineView.backgroundColor = lineView.backgroundColor;
    
    UIButton *continueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_contairView addSubview:continueBtn];
    [continueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contairView.mas_left);
        make.top.equalTo(lineView.mas_bottom);
        make.right.equalTo(midlineView.mas_left);
        make.height.equalTo(midlineView.mas_height);
    }];
    [continueBtn setTag:100];
    [continueBtn setTitle:@"取消" forState:UIControlStateNormal];
    [continueBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    continueBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [continueBtn addTarget:self action:@selector(respondsToBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    _continueBtn = continueBtn;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_contairView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(midlineView.mas_right);
        make.top.equalTo(lineView.mas_bottom);
        make.right.equalTo(_contairView.mas_right);
        make.height.equalTo(midlineView.mas_height);
    }];
    [cancelBtn setTag:110];
    [cancelBtn setTitle:@"确认举报" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#FD7A0F"] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [cancelBtn addTarget:self action:@selector(respondsToBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    _cancelBtn = cancelBtn;
    [_contairView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cancelBtn.mas_bottom);
    }];
    
}

- (void)showAlert{
    _showWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
    _showWindow.windowLevel = UIWindowLevelAlert;
    _showWindow.backgroundColor = [UIColor clearColor];
    [_showWindow addSubview:self];
    [_showWindow makeKeyAndVisible];
    
}

- (void)hiddenAlert{
    [self removeFromSuperview];
    _contairView = nil;
    [_showWindow resignKeyWindow];
    _showWindow.hidden = YES;
    _showWindow = nil;
}

-(void)itemSelect:(UIButton *)sender
{
    if(self.btNowSelect!=nil)
    {
        [self.btNowSelect setImage:[UIImage imageNamed:@"yuan_select_no"] forState:UIControlStateNormal];
    }
    self.btNowSelect = sender;
    [self.btNowSelect setImage:[UIImage imageNamed:@"yuan_select_yes"] forState:UIControlStateNormal];
    
}

-(void)respondsToBtnEvent:(UIButton *)sender
{
    
    
    if(sender.tag == 110)
    {
        if(self.btNowSelect==nil)
        {
            [MDB_UserDefault showNotifyHUDwithtext:@"请选择举报原因" inView:self];
            return;
        }
        [self.delegate ProductInfoJBAalterViewDelegateDidPressEnsureBtnWithAlertViewItem:self.btNowSelect.tag];
    }
    else
    {
        [self hiddenAlert];
    }
    
}


@end
