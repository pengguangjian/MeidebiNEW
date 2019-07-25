//
//  RewardHomeSubjectView.m
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/4.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "RewardHomeSubjectView.h"
#import "RemarkStatusHelper.h"
#import "RewardCommentView.h"
#import "MDB_UserDefault.h"
#import "UUKeyboardInputView.h"
@interface RewardHomeSubjectView ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *confirmNumberLabel;
@property (nonatomic, strong) UILabel *currentCionsLabel;
@property (nonatomic, strong) UILabel *describleLabel;
@property (nonatomic, strong) UILabel *appreciateWordLabel;
@property (nonatomic, strong) UIButton *rewardBtn;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) RewardCommentView *commentView;
@property (nonatomic, strong) NSArray *commentContents;
@property (nonatomic, strong) NSMutableArray *rewardSumButtons;
@property (nonatomic, strong) NSString *amountStr;
@property (nonatomic, strong) NSString *contentStr;
@property (nonatomic, strong) NSString *currentCionStr;

@end

@implementation RewardHomeSubjectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _rewardSumButtons = [NSMutableArray array];
        [self setupSubviews];
        [self initDefaultValue];
    }
    return self;
}

- (void)setupSubviews{
    UIView *bottomView = [UIView new];
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.offset(70);
    }];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    UIButton *rewardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:rewardBtn];
    [rewardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomView.mas_right).offset(-18);
        make.centerY.equalTo(bottomView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(100*kScale, 38*kScale));
    }];
    rewardBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [rewardBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rewardBtn.layer.masksToBounds = YES;
    rewardBtn.layer.cornerRadius = 4.f;
    [rewardBtn addTarget:self action:@selector(respondsToConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    _rewardBtn = rewardBtn;
    
    UILabel *confirmNumberLabel = [UILabel new];
    [bottomView addSubview:confirmNumberLabel];
    [confirmNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.mas_left).offset(18);
        make.bottom.equalTo(bottomView.mas_centerY).offset(-3);
    }];
    _confirmNumberLabel = confirmNumberLabel;
    
    UILabel *describleLabel = [UILabel new];
    [bottomView addSubview:describleLabel];
    [describleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(confirmNumberLabel.mas_left);
        make.top.equalTo(bottomView.mas_centerY).offset(3);
    }];
    describleLabel.font = [UIFont systemFontOfSize:10.f];
    describleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _describleLabel = describleLabel;
    
    UIView *lineBottomView = [UIView new];
    [self addSubview:lineBottomView];
    [lineBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(bottomView.mas_top);
        make.height.offset(10);
    }];
    lineBottomView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
   
    UIScrollView *mainScrollView = [UIScrollView new];
    [self addSubview:mainScrollView];
    [mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(lineBottomView.mas_top);
    }];
    mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView = mainScrollView;
    
    _containerView = [UIView new];
    [mainScrollView addSubview:_containerView];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(mainScrollView);
        make.width.equalTo(mainScrollView);
    }];
    _containerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *appreciateWordLabel = [UILabel new];
    [_containerView addSubview:appreciateWordLabel];
    [appreciateWordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_containerView.mas_top).offset(30*kScale);
        make.centerX.equalTo(_containerView.mas_centerX);
    }];
    appreciateWordLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    appreciateWordLabel.font = [UIFont systemFontOfSize:16.f];
    _appreciateWordLabel = appreciateWordLabel;
    
    UIView *lineView = [UIView new];
    [_containerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_containerView);
        make.top.equalTo(appreciateWordLabel.mas_bottom).offset(30*kScale);
        make.height.offset(10);
    }];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    
    UIView *currentCoinsView = [UIView new];
    [_containerView addSubview:currentCoinsView];
    [currentCoinsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.left.right.equalTo(_containerView);
        make.height.offset(56*kScale);
    }];
    currentCoinsView.backgroundColor = [UIColor colorWithHexString:@"#F16944"];
    
    UILabel *currentCionsLabel = [UILabel new];
    [currentCoinsView addSubview:currentCionsLabel];
    [currentCionsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(currentCoinsView);
    }];
    currentCionsLabel.textColor = [UIColor whiteColor];
    currentCionsLabel.text = @"铜币（0）";
    _currentCionsLabel  =currentCionsLabel;
    
    UIView *line1View = [UIView new];
    [_containerView addSubview:line1View];
    [line1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_containerView);
        make.top.equalTo(currentCoinsView.mas_bottom);
        make.height.offset(10);
    }];
    line1View.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    
    UIView *title1HeaderView = [UIView new];
    [_containerView addSubview:title1HeaderView];
    [title1HeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_containerView.mas_left).offset(20);
        make.top.equalTo(line1View.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake(3, 13));
    }];
    title1HeaderView.backgroundColor = [UIColor colorWithHexString:@"#F16944"];
    
    UILabel *titleName1Label = [UILabel new];
    [_containerView addSubview:titleName1Label];
    [titleName1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(title1HeaderView.mas_right).offset(8);
        make.centerY.equalTo(title1HeaderView.mas_centerY);
    }];
    titleName1Label.textColor = [UIColor colorWithHexString:@"#999999"];
    titleName1Label.font = [UIFont systemFontOfSize:12.f];
    titleName1Label.text = @"请选择打赏金额：";
    
    UIButton *lastBtn = nil;
    NSArray *rewardSums = @[@"10铜币",@"20铜币",@"30铜币",@"50铜币"];
    for (NSInteger i = 0; i<rewardSums.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_containerView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastBtn) {
                make.width.equalTo(lastBtn.mas_width);
                make.left.equalTo(lastBtn.mas_right).offset(18*kScale);
            }else{
                make.left.equalTo(_containerView.mas_left).offset(20*kScale);
            }
            if (i==rewardSums.count-1) {
                make.right.equalTo(_containerView.mas_right).offset(-20*kScale);
            }
            make.top.equalTo(title1HeaderView.mas_bottom).offset(18);
            make.height.equalTo(button.mas_width).multipliedBy(0.65);
        }];
        [button addTarget:self action:@selector(respondsToRewardBtn:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:rewardSums[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#F13044"] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:16.f];
        button.layer.masksToBounds = YES;
        button.layer.borderWidth = 1.f;
        button.layer.borderColor = [UIColor colorWithHexString:@"#777777"].CGColor;
        lastBtn = button;
        [_rewardSumButtons addObject:button];
    }
    UIView *line2View = [UIView new];
    [_containerView addSubview:line2View];
    [line2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_containerView.mas_left).offset(20);
        make.right.equalTo(_containerView.mas_right).offset(-20);
        make.top.equalTo(lastBtn.mas_bottom).offset(28*kScale);
        make.height.offset(1);
    }];
    line2View.backgroundColor = [UIColor colorWithHexString:@"#D5D5D5"];

    UIView *title2HeaderView = [UIView new];
    [_containerView addSubview:title2HeaderView];
    [title2HeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_containerView.mas_left).offset(20);
        make.top.equalTo(line2View.mas_bottom).offset(30*kScale);
        make.size.mas_equalTo(CGSizeMake(3, 13));
    }];
    title2HeaderView.backgroundColor = [UIColor colorWithHexString:@"#F16944"];
    
    UILabel *titleName2Label = [UILabel new];
    [_containerView addSubview:titleName2Label];
    [titleName2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(title2HeaderView.mas_right).offset(8);
        make.centerY.equalTo(title2HeaderView.mas_centerY);
    }];
    titleName2Label.textColor = [UIColor colorWithHexString:@"#999999"];
    titleName2Label.font = [UIFont systemFontOfSize:12.f];
    titleName2Label.text = @"给TA捎句话：";
    
    RewardCommentView *commentView = [RewardCommentView new];
    [_containerView addSubview:commentView];
    [commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_containerView);
        make.top.equalTo(title2HeaderView.mas_bottom).offset(15);
        make.height.offset(self.commentContents.count*commentView.tableViewRowHeight);
    }];
    __weak __typeof__ (self) weakSelef = self;
    commentView.didSelctComment = ^(NSString *selctCommentStr) {
        __strong __typeof__ (weakSelef) strongSelf = weakSelef;
        strongSelf.contentStr = selctCommentStr;
    };
    [commentView bindDataWithComments:self.commentContents];
    _commentView = commentView;
    
    UIControl *customCommentWordContainerView = [UIControl new];
    [_containerView addSubview:customCommentWordContainerView];
    [customCommentWordContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(title1HeaderView.mas_left);
        make.top.equalTo(commentView.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake(180, 35));
    }];
    customCommentWordContainerView.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    [customCommentWordContainerView addTarget:self action:@selector(respondsToControlEvent:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *customCommentWordLabel = [UILabel new];
    [_containerView addSubview:customCommentWordLabel];
    [customCommentWordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(customCommentWordContainerView.mas_left).offset(14);
        make.centerY.equalTo(customCommentWordContainerView.mas_centerY);
    }];
    customCommentWordLabel.text = @"自己写两句试试...";
    customCommentWordLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    customCommentWordLabel.font = [UIFont systemFontOfSize:12.f];
    
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(customCommentWordContainerView.mas_bottom).offset(33);
    }];
    
}

- (void)bindDataWithModel:(NSDictionary *)model{
    if (![@"" isEqualToString:[NSString nullToString:model[@"copper"]]]) {
        _currentCionStr = [NSString nullToString:model[@"copper"]];
    }
    _currentCionsLabel.text = [NSString stringWithFormat:@"铜币(%@)",_currentCionStr];
    [self layoutConfirmRewardBtn:_currentCionStr];
}

- (void)initDefaultValue{
    _currentCionStr = @"0";
    UIButton *button = _rewardSumButtons.firstObject;
    button.selected = YES;
    button.layer.borderColor = [UIColor colorWithHexString:@"#F13044"].CGColor;
    _confirmNumberLabel.attributedText = [self afreshDescribe:[NSString stringWithFormat:@"已选%@支持爆料人",button.currentTitle]];
}

- (void)layoutConfirmRewardBtn:(NSString *)cion{
    if (cion.integerValue > _currentCionStr.integerValue) {
        [_rewardBtn setTitle:@"余额不足" forState:UIControlStateNormal];
        _rewardBtn.backgroundColor = [UIColor colorWithHexString:@"#9E9E9E"];
        _rewardBtn.userInteractionEnabled = NO;
    }else{
        _rewardBtn.backgroundColor = [UIColor colorWithHexString:@"#F97C17"];
        [_rewardBtn setTitle:@"立即打赏" forState:UIControlStateNormal];
        _rewardBtn.userInteractionEnabled = YES;
    }
}

- (void)respondsToRewardBtn:(UIButton *)sender{
    for (UIButton *button in _rewardSumButtons) {
        if (button == sender) {
            button.selected = YES;
            button.layer.borderColor = [UIColor colorWithHexString:@"#F13044"].CGColor;
            _confirmNumberLabel.attributedText = [self afreshDescribe:[NSString stringWithFormat:@"已选%@支持爆料人",sender.currentTitle]];
            [self layoutConfirmRewardBtn:_amountStr];
        }else{
            button.selected = NO;
            button.layer.borderColor = [UIColor colorWithHexString:@"#777777"].CGColor;
        }
    }
}

- (void)respondsToConfirmBtn:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(rewardSubjectViewSubmitRewardWithContent:amount:)]) {
        [self.delegate rewardSubjectViewSubmitRewardWithContent:_contentStr amount:_amountStr];
    }
}

- (void)respondsToControlEvent:(UIControl *)sender{
    __weak __typeof__ (self) weakSelef = self;
    [UUKeyboardInputView showKeyboardConfige:^(UUInputConfiger * _Nonnull configer) {
        configer.keyboardType = UIKeyboardTypeDefault;
    }block:^(NSString * _Nonnull contentStr) {
        __strong __typeof__ (weakSelef) strongSelf = weakSelef;
        if (contentStr.length < 5) {
            [MDB_UserDefault showNotifyHUDwithtext:@"内容不足5个字！" inView:self];
            return ;
        }
        [MDB_UserDefault setRewardComment:contentStr];
        strongSelf.commentContents = nil;
        [_commentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(strongSelf.commentContents.count*_commentView.tableViewRowHeight);
        }];
        [_commentView updateDataWithcomments:strongSelf.commentContents];
        
        [strongSelf layoutIfNeeded];
        CGPoint bottomOffset = CGPointMake(0, strongSelf.mainScrollView.contentSize.height - strongSelf.mainScrollView.bounds.size.height);
        [strongSelf.mainScrollView setContentOffset:bottomOffset animated:YES];
    }];

}

- (NSAttributedString *)afreshDescribe:(NSString *)dscribe{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:dscribe];
    [attributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:14.f]
                          range:NSMakeRange(0, dscribe.length)];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor colorWithHexString:@"#333333"]
                          range:NSMakeRange(0, dscribe.length)];
    NSArray<NSTextCheckingResult *> *results = [[RemarkStatusHelper regexWelfareStrategy] matchesInString:dscribe options:kNilOptions range:dscribe.rangeOfAll];
    for (NSTextCheckingResult *result in results) {
        _amountStr = [dscribe substringWithRange:NSMakeRange(result.range.location, result.range.length)];

        [attributedStr addAttribute:NSForegroundColorAttributeName
                              value:[UIColor colorWithHexString:@"#F13044"]
                              range:NSMakeRange(result.range.location, result.range.length)];
        [attributedStr addAttribute:NSFontAttributeName
                              value:[UIFont systemFontOfSize:16.f]
                              range:NSMakeRange(result.range.location, result.range.length)];
        
    }
    return attributedStr.mutableCopy;
}

#pragma mark -  setters and getters
- (NSArray *)commentContents{
    if (!_commentContents) {
        if ([MDB_UserDefault getRewardComments].count<=0) {
            _commentContents = @[@"水土不服就服你！写的太棒了！10铜币不成敬意！",
                                 @"我对你的敬仰如滔滔江水，好文，看赏，10铜币奉上!"];
            [MDB_UserDefault setRewardComment:_commentContents.firstObject];
            [MDB_UserDefault setRewardComment:_commentContents.lastObject];
        }else{
            _commentContents = [MDB_UserDefault getRewardComments];
        }
    
    }
    return _commentContents;
}

- (void)setType:(NSString *)type{
    _type = type;
    if ([@"1" isEqualToString:type]) {
        _describleLabel.text = @"打赏铜币将直接进入原创人账户";
        _appreciateWordLabel.text = @"您的支持将鼓励我继续写原创哦~";
    }else{
        _describleLabel.text = @"打赏铜币将直接进入爆料人账户";
        _appreciateWordLabel.text = @"您的支持将鼓励我继续爆料哦~";
    }
}


@end
