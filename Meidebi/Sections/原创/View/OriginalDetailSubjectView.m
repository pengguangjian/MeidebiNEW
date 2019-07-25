//
//  OriginalDetailSubjectView.m
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/22.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "HTTPManager.h"

@interface OriginalAppraiseLivelView : UIView
- (void)appraiseLivel:(NSInteger)livel;
@end

@interface OriginalAppraiseLivelView ()
@property (nonatomic, retain) NSArray <UIImageView *>*levelIcons;
@end

@implementation OriginalAppraiseLivelView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    NSMutableArray *icons = [NSMutableArray array];
    UIImageView *lastIcon = nil;
    for (NSInteger i = 0; i<6; i++) {
        UIImageView *imageView = [UIImageView new];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            if (lastIcon) {
                make.left.equalTo(lastIcon.mas_right).offset(4);
            }else{
                make.left.equalTo(self.mas_left);
            }
            make.size.mas_equalTo(CGSizeMake(12, 12));
        }];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:@"original_appraise_star"];
        lastIcon = imageView;
        [icons addObject:imageView];
    }
    _levelIcons = icons.mutableCopy;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastIcon.mas_right);
        make.bottom.equalTo(lastIcon.mas_bottom);
    }];
}

- (void)appraiseLivel:(NSInteger)livel{
    for (NSInteger i = 0; i < _levelIcons.count; i++) {
        UIImageView *icon = _levelIcons[i];
        if (i<livel) {
            icon.hidden = NO;
        }else{
            icon.hidden = YES;
        }
    }
    if (livel>0) {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            if (livel > _levelIcons.count) {
                make.right.equalTo((UIImageView *)_levelIcons.lastObject.mas_right);
            }else{
                make.right.equalTo((UIImageView *)_levelIcons[livel-1].mas_right);
            }
        }];
    }
    
}
@end

#import "CompressImage.h"
@protocol OriginalBottomHandelViewDelegate <NSObject>
@optional - (void)tabBarViewDidPressShouBton;
@optional - (void)tabBarViewDidPressZanBton;
@optional - (void)tabBarViewDidPressComBton;
@end
@interface OriginalBottomHandelView : UIView
@property (nonatomic, weak) id<OriginalBottomHandelViewDelegate> delegate;
@property (nonatomic, retain) NSString *remarkNumber;
@property (nonatomic, retain) NSString *likeNumber;
@property (nonatomic, retain) NSString *collectNumber;
@end

static NSString * const kButtonSelectStatueColor = @"#F77210";
static NSString * const kButtonNormalStatueColor = @"#999999";

@interface OriginalBottomHandelView ()
@property (nonatomic, retain) UIButton *zanBtn;
@property (nonatomic, retain) UIButton *shouBtn;
@property (nonatomic, retain) UIButton *comBtn;
@end

@implementation OriginalBottomHandelView{
    BOOL _isZan;
}

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
    
    _comBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_comBtn];
    [_comBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-11);
        make.top.bottom.equalTo(self);
    }];
    _comBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _comBtn.tag = 33;
    _comBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [_comBtn setTitleColor:[UIColor colorWithHexString:kButtonNormalStatueColor]
                  forState:UIControlStateNormal];
    [_comBtn setImage:[UIImage imageNamed:@"discount_comment_normal"] forState:UIControlStateNormal];
    [_comBtn addTarget:self action:@selector(respondEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_comBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];

    UIView *lineView2 = [UIView new];
    [self addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_comBtn.mas_left).offset(-2);
        make.centerY.equalTo(_comBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(1, 15));
    }];
    lineView2.backgroundColor = [UIColor colorWithHexString:kButtonNormalStatueColor];
    
    _shouBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_shouBtn];
    [_shouBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lineView2.mas_left).offset(-2);
        make.top.bottom.width.equalTo(_comBtn);
    }];
    _shouBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _shouBtn.tag = 22;
    _shouBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [_shouBtn setTitleColor:[UIColor colorWithHexString:kButtonNormalStatueColor]
                   forState:UIControlStateNormal];
    [_shouBtn setImage:[UIImage imageNamed:@"discount_collect_normal"] forState:UIControlStateNormal];
    [_shouBtn addTarget:self action:@selector(respondEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_shouBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];

    UIView *lineView1 = [UIView new];
    [self addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_shouBtn.mas_left).offset(-2);
        make.centerY.equalTo(_shouBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(1, 15));
    }];
    lineView1.backgroundColor = [UIColor colorWithHexString:kButtonNormalStatueColor];
    
    _zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_zanBtn];
    [_zanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lineView1.mas_left).offset(-2);
        make.top.width.bottom.equalTo(_shouBtn);
        make.left.equalTo(self.mas_left).offset(11);
    }];
    _zanBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _zanBtn.tag = 11;
    _zanBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [_zanBtn setTitleColor:[UIColor colorWithHexString:kButtonNormalStatueColor]
                  forState:UIControlStateNormal];
    [_zanBtn setImage:[UIImage imageNamed:@"discount_like_normal"] forState:UIControlStateNormal];
    [_zanBtn addTarget:self action:@selector(respondEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_zanBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];

}

#pragma mark - respond events
- (void)respondEvent:(UIButton *)sender{
    switch (sender.tag) {
        case 11:
        {
            if ([self.delegate respondsToSelector:@selector(tabBarViewDidPressZanBton)]) {
                [self.delegate tabBarViewDidPressZanBton];
            }
        }
            break;
        case 22:
        {
            if ([self.delegate respondsToSelector:@selector(tabBarViewDidPressShouBton)]) {
                [self.delegate tabBarViewDidPressShouBton];
            }
        }
            break;
        case 33:
        {
            if ([self.delegate respondsToSelector:@selector(tabBarViewDidPressComBton)]) {
                [self.delegate tabBarViewDidPressComBton];
            }
        }
            break;
            
        default:
            break;
    }
    
}

- (void)updateTabBarLinkBtnState{
    
    UILabel * _labelCommend=[[UILabel alloc] init];
    _labelCommend.text = @"+1";
    _labelCommend.alpha=0.0;
    _labelCommend.textColor=[UIColor redColor];
    [self addSubview:_labelCommend];
    [_labelCommend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_zanBtn);
    }];
    self.likeNumber = [NSString stringWithFormat:@"%@",@([_zanBtn.titleLabel.text integerValue]+1)];
    [_zanBtn setImage:[UIImage imageNamed:@"discount_like_select"] forState:UIControlStateNormal];
    [self layoutIfNeeded];
    CAAnimation *animation =[CompressImage groupAnimation:_labelCommend];
    [_labelCommend.layer addAnimation:animation forKey:@"animation"];
}

- (void)updateTabBarCollectBtnState:(BOOL)state{
    UILabel * _labelCommend=[[UILabel alloc] init];
    _labelCommend.text = @"+1";
    _labelCommend.alpha=0.0;
    _labelCommend.textColor=[UIColor redColor];
    [self addSubview:_labelCommend];
    [_labelCommend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_shouBtn);
    }];
    if (!state) {
        if ([_shouBtn.titleLabel.text isEqualToString:@"0"]) return;
        _labelCommend.text = @"-1";
        self.collectNumber = [NSString stringWithFormat:@"%@",@([_shouBtn.titleLabel.text integerValue]-1)];
        [_shouBtn setImage:[UIImage imageNamed:@"discount_collect_normal"] forState:UIControlStateNormal];
    }else{
        self.collectNumber = [NSString stringWithFormat:@"%@",@([_shouBtn.titleLabel.text integerValue]+1)];
        [_shouBtn setImage:[UIImage imageNamed:@"discount_collect_select"] forState:UIControlStateNormal];
    }
    [self layoutIfNeeded];
    CAAnimation *animation =[CompressImage groupAnimation:_labelCommend];
    [_labelCommend.layer addAnimation:animation forKey:@"animation"];
}

#pragma mark - setters and getters
- (void)setLikeNumber:(NSString *)likeNumber{
    _likeNumber = likeNumber;
    [_zanBtn setTitle:[self numberChangeStringValue:[NSNumber numberWithInt:likeNumber.intValue]] forState:UIControlStateNormal];
}

- (void)setRemarkNumber:(NSString *)remarkNumber{
    _remarkNumber = remarkNumber;
    [_comBtn setTitle:[self numberChangeStringValue:[NSNumber numberWithInt:remarkNumber.intValue]] forState:UIControlStateNormal];
}

- (void)setCollectNumber:(NSString *)collectNumber{
    _collectNumber = collectNumber;
    [_shouBtn setTitle:[self numberChangeStringValue:[NSNumber numberWithInt:collectNumber.intValue]] forState:UIControlStateNormal];
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

#import "OriginalDetailSubjectView.h"
#import "NJFlagView.h"
#import "MDBwebVIew.h"
#import "MDBEmptyView.h"
#import "MDB_UserDefault.h"
#import "RemarkStatusHelper.h"
#import "ReadMoreTableViewCell.h"
#import "RemarkHomeTableViewCell.h"
#import "OriginalMoreTableViewCell.h"
static CGFloat const kTableSectionHeaderViewHeight = 62;
static CGFloat const kTableSectionOtherWorksRowHeight = 150;
static NSString * const kHotCommentTableViewCellIdentifier = @"hotComment";
static NSString * const kOtherWorksTableViewCellIdentifier = @"OtherWorks";
static NSString * const kReadMoreTableViewCellIdentifier = @"readMore";
@interface OriginalDetailSubjectView ()
<
MDBwebDelegate,
NJFlagViewDelegate,
UITableViewDelegate,
UITableViewDataSource,
RemarkHomeTableViewCellDelegate,
OriginalMoreTableViewCellDelegate,
OriginalBottomHandelViewDelegate
>
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIView *tableHeaderView;
@property (nonatomic, retain) MDBEmptyView *emptyView;
@property (nonatomic, retain) UIImageView *avaterImageView;
@property (nonatomic, retain) UILabel *nikNameLabel;
@property (nonatomic, retain) UILabel *createTimeLabel;
@property (nonatomic, retain) UIImageView *livelBgImageView;
@property (nonatomic, retain) UILabel *livelLabel;
@property (nonatomic, retain) UIButton *followBtn;
@property (nonatomic, retain) UIImageView *iconImageView;
@property (nonatomic, retain) UITextView *titleLabel;
@property (nonatomic, retain) NJFlagView *flagView;
@property (nonatomic, retain) MDBwebVIew *originalWebview;
@property (nonatomic, retain) UIControl *rewardUserContainerView;
@property (nonatomic, retain) UILabel *rewardUserSumLabel;
@property (nonatomic, retain) NSArray *rewardUserIcons;
@property (nonatomic, retain) OriginalAppraiseLivelView *appraiseView;
@property (nonatomic, retain) OriginalBottomHandelView *bottomHandelView;
@property (nonatomic, retain) UILabel *rewardsMoneyLabel;
@property (nonatomic, retain) UILabel *appraiseDescribeLabel;
@property (nonatomic, retain) UIView *originalDetailView;
@property (nonatomic, retain) UIView *supplementView;
@property (nonatomic, retain) UIView *rewardContainerView;
@property (nonatomic, retain) OriginalDetailViewModel *model;
@property (nonatomic, retain) UIButton *rewardButton;
@property (nonatomic, retain) NSArray *otherWorks;
@property (nonatomic, retain) NSMutableArray *remarks;
@property (nonatomic, assign) CGFloat webViewHeight;

@property (nonatomic, assign) BOOL isbackfinally;
@end

@implementation OriginalDetailSubjectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _remarks = [NSMutableArray array];
        _webViewHeight = 100;
        [self setupSubviews];
    }
    return self;
}

#pragma mark - View Layout
- (void)setupSubviews{
    _bottomHandelView = [OriginalBottomHandelView new];
    [self addSubview:_bottomHandelView];
    [_bottomHandelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.offset(50);
    }];
    _bottomHandelView.hidden = YES;
    _bottomHandelView.delegate = self;
    
    
    
    
    
    _tableView = [UITableView new];
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_bottomHandelView.mas_top);
        make.top.left.right.equalTo(self);
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[RemarkHomeTableViewCell class] forCellReuseIdentifier:kHotCommentTableViewCellIdentifier];
    [_tableView registerClass:[ReadMoreTableViewCell class] forCellReuseIdentifier:kReadMoreTableViewCellIdentifier];
    [_tableView registerClass:[OriginalMoreTableViewCell class] forCellReuseIdentifier:kOtherWorksTableViewCellIdentifier];
    _tableView.tableFooterView = [UIView new];
    [self setupTableHeaderView];
    
    _emptyView = [[MDBEmptyView alloc] init];
    [self addSubview:_emptyView];
    [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    _emptyView.remindStr = @"未查到相应数据～";
    _emptyView.hidden = YES;
}

- (void)setupTableHeaderView{
    UIView *headerView = [UIView new];
    headerView.hidden = YES;
    _tableView.tableHeaderView = headerView;
    _tableHeaderView = headerView;
    
    UIImageView *imageView = [UIImageView new];
    [headerView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left).offset(16);
        make.top.equalTo(headerView.mas_top).offset(16);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 30.0/2;
    imageView.layer.borderWidth = 2.f;
    imageView.layer.borderColor = [UIColor colorWithHexString:@"#F27A30"].CGColor;
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToAvaterView:)];
    [imageView addGestureRecognizer:tapGesture];
    _avaterImageView = imageView;
    
    _nikNameLabel = ({
        UILabel *label = [UILabel new];
        [headerView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avaterImageView.mas_right).offset(9);
            make.bottom.equalTo(_avaterImageView.mas_centerY).offset(-3);
        }];
        label.textColor = [UIColor colorWithHexString:@"#666666"];
        label.font = [UIFont systemFontOfSize:13];
        label;
    });
    
    UIImageView *livelBgImageView = [UIImageView new];
    [headerView addSubview:livelBgImageView];
    [livelBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nikNameLabel.mas_right).offset(10);
        make.centerY.equalTo(_nikNameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(17, 17));
    }];
    livelBgImageView.image = [UIImage imageNamed:@"dengji.jpg"];
    livelBgImageView.hidden = YES;
    _livelBgImageView = livelBgImageView;
    
    _livelLabel = [UILabel new];
    [livelBgImageView addSubview:_livelLabel];
    [_livelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(livelBgImageView.mas_right).offset(-0.5);
        make.bottom.equalTo(livelBgImageView.mas_bottom).offset(-1);
    }];
    _livelLabel.textColor = [UIColor whiteColor];
    _livelLabel.font = [UIFont systemFontOfSize:5.5];
    _livelLabel.textAlignment = NSTextAlignmentRight;
    
    _createTimeLabel = [UILabel new];
    [headerView addSubview:_createTimeLabel];
    [_createTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avaterImageView.mas_right).offset(9);
        make.top.equalTo(_avaterImageView.mas_centerY).offset(3);
    }];
    _createTimeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    _createTimeLabel.font = [UIFont systemFontOfSize:13];
    
    UIButton *followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerView addSubview:followBtn];
    [followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView.mas_right).offset(-16);
        make.centerY.equalTo(_avaterImageView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(51, 20));
    }];
    followBtn.titleLabel.font = [UIFont systemFontOfSize:11.f];
    [followBtn setTitleColor:[UIColor colorWithHexString:@"#F27A30"] forState:UIControlStateNormal];
    [followBtn setTitle:@"+ 关注" forState:UIControlStateNormal];
    [followBtn addTarget:self action:@selector(respondsToFollowBtn:) forControlEvents:UIControlEventTouchUpInside];
    followBtn.layer.masksToBounds = YES;
    followBtn.layer.cornerRadius = 4.f;
    followBtn.layer.borderWidth = 1.f;
    followBtn.layer.borderColor = [UIColor colorWithHexString:@"#F27A30"].CGColor;
    _followBtn = followBtn;

    _supplementView = [self setupOriginalSupplement];
    [headerView addSubview:_supplementView];
    [_supplementView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avaterImageView.mas_bottom).offset(18);
        make.left.right.equalTo(headerView);
    }];
    _supplementView.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];
   
    _originalDetailView = [self setupOriginalDetail];
    [headerView addSubview:_originalDetailView];
    [_originalDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_supplementView.mas_bottom).offset(8);
        make.left.right.equalTo(headerView);
    }];
    
    UIView *spanLineView = [UIView new];
    [headerView addSubview:spanLineView];
    [spanLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_originalDetailView.mas_bottom);
        make.left.right.equalTo(headerView);
        make.height.offset(15);
        make.bottom.equalTo(headerView.mas_bottom);
    }];
    spanLineView.backgroundColor = [UIColor whiteColor];
    [self updateTableHeaderView];
}

- (UIView *)setupOriginalSupplement{
    UIView *containerView = [UIView new];

    UILabel *appraiseTitleLabel = [UILabel new];
    [containerView addSubview:appraiseTitleLabel];
    [appraiseTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containerView.mas_top).offset(16);
        make.left.equalTo(containerView.mas_left).offset(16);
        make.height.offset(13);
    }];
    appraiseTitleLabel.text = @"原创评星：";
    appraiseTitleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    appraiseTitleLabel.font = [UIFont systemFontOfSize:11.f];
    
    _appraiseView = [OriginalAppraiseLivelView new];
    [containerView addSubview:_appraiseView];
    [_appraiseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(appraiseTitleLabel.mas_right).offset(3);
        make.centerY.equalTo(appraiseTitleLabel.mas_centerY);
    }];
    
    UILabel *rewardsMoneyLabel = [UILabel new];
    [containerView addSubview:rewardsMoneyLabel];
    [rewardsMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containerView.mas_top).offset(16);
        make.left.equalTo(_appraiseView.mas_right).offset(25);
    }];
    rewardsMoneyLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    rewardsMoneyLabel.font = [UIFont systemFontOfSize:11.f];
    _rewardsMoneyLabel = rewardsMoneyLabel;

    UILabel *appraiseDescribeLabel = [UILabel new];
    [containerView addSubview:appraiseDescribeLabel];
    [appraiseDescribeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_appraiseView.mas_bottom).offset(11);
        make.left.equalTo(appraiseTitleLabel.mas_left);
        make.right.equalTo(containerView.mas_right).offset(-16);
        make.height.offset(20);
    }];
    appraiseDescribeLabel.numberOfLines = 0;
    appraiseDescribeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    appraiseDescribeLabel.font = [UIFont systemFontOfSize:11.f];
    [appraiseDescribeLabel setContentCompressionResistancePriority:997 forAxis:UILayoutConstraintAxisVertical];
    [appraiseDescribeLabel setContentHuggingPriority:997 forAxis:UILayoutConstraintAxisVertical];
    _appraiseDescribeLabel = appraiseDescribeLabel;
    
    return containerView;
}

- (UIView *)setupOriginalDetail{
    UIView *containerView = [UIView new];
    UIImageView *iconImageView = [UIImageView new];
    [containerView addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containerView.mas_top);
        make.left.right.equalTo(containerView);
        make.height.equalTo(iconImageView.mas_width).multipliedBy(0.463);
    }];
    iconImageView.clipsToBounds = YES;
    iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    _iconImageView = iconImageView;
    
    
    UITextView *titleLabel = [UITextView new];
    [containerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView.mas_bottom).offset(16);
        make.left.equalTo(containerView.mas_left).offset(8);
        make.right.equalTo(containerView.mas_right).offset(-8);
        make.height.offset(25);
    }];
    titleLabel.scrollEnabled = NO;
    titleLabel.showsVerticalScrollIndicator = NO;
    titleLabel.showsHorizontalScrollIndicator = NO;
    titleLabel.editable = NO;
    titleLabel.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    titleLabel.font = [UIFont boldSystemFontOfSize:17.f];
    titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [titleLabel setContentCompressionResistancePriority:998 forAxis:UILayoutConstraintAxisVertical];
    [titleLabel setContentHuggingPriority:998 forAxis:UILayoutConstraintAxisVertical];
    [titleLabel setContentCompressionResistancePriority:998 forAxis:UILayoutConstraintAxisHorizontal];
    [titleLabel setContentHuggingPriority:998 forAxis:UILayoutConstraintAxisHorizontal];
    _titleLabel  = titleLabel;

    _flagView = [NJFlagView new];
    [containerView addSubview:_flagView];
    [_flagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(5);
        make.left.right.equalTo(containerView);
        make.height.offset(40);
    }];
    _flagView.titleType = FlagTitleTypeNoTitle;
    _flagView.delegate = self;
    __weak typeof (self) weakSelf = self;
    _flagView.callback = ^(CGFloat height) {
        [weakSelf.flagView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(height);
        }];
    };
    [self layoutIfNeeded];
    MDBwebVIew *webview = [[MDBwebVIew alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(_flagView.frame)+5, kMainScreenW-10, _webViewHeight)];
    [containerView addSubview:webview];
//    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_flagView.mas_bottom).offset(5);
//        make.left.equalTo(containerView.mas_left).offset(5);
//        make.right.equalTo(containerView.mas_right).offset(-5);
////        make.right.left.equalTo(containerView);
//        make.height.offset(300);
//
//    }];
    webview.delegate = self;
    _originalWebview = webview;
//    [webview setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
//    [webview setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    // 打赏
    UIView *rewardContainerView = [UIView new];
    [containerView addSubview:rewardContainerView];
    [rewardContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(containerView);
        make.top.equalTo(webview.mas_bottom);
        make.height.offset(60);
        make.bottom.equalTo(containerView.mas_bottom);
    }];
    rewardContainerView.backgroundColor = [UIColor colorWithHexString:@"#FBF4EF"];
    _rewardContainerView = rewardContainerView;

    UILabel *rewardTitleLabel = [UILabel new];
    [rewardContainerView addSubview:rewardTitleLabel];
    [rewardTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rewardContainerView.mas_left).offset(16.f);
        make.top.equalTo(rewardContainerView.mas_top).offset(20);
        make.height.offset(19);
    }];
    rewardTitleLabel.font = [UIFont systemFontOfSize:14.f];
    rewardTitleLabel.textColor = [UIColor colorWithHexString:@"#8A6449"];
    rewardTitleLabel.text = @"写的太棒了？打赏犒劳作者一下~";
    [rewardTitleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [rewardTitleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];

    UIButton *rewardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rewardContainerView addSubview:rewardButton];
    [rewardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rewardContainerView.mas_right).offset(-16);
        make.centerY.equalTo(rewardTitleLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60, 25));
    }];
    [rewardButton addTarget:self action:@selector(respondesToRewardButtonEvents:) forControlEvents:UIControlEventTouchUpInside];
    rewardButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [rewardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rewardButton setTitle:@"打赏" forState:UIControlStateNormal];
    rewardButton.backgroundColor = [UIColor colorWithHexString:@"#F97C17"];
    rewardButton.layer.masksToBounds = YES;
    rewardButton.layer.cornerRadius = 4.f;
    _rewardButton = rewardButton;

    UIControl *rewardUserContainerView = [UIControl new];
    [rewardContainerView addSubview:rewardUserContainerView];
    [rewardUserContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rewardTitleLabel.mas_left);
        make.right.equalTo(rewardButton.mas_right);
        make.top.equalTo(rewardButton.mas_bottom).offset(7);
        make.height.offset(0);
        make.bottom.equalTo(rewardContainerView.mas_bottom).offset(-7);
    }];
    [rewardUserContainerView addTarget:self action:@selector(respondsToRewardInfoEvent:) forControlEvents:UIControlEventTouchUpInside];
    _rewardUserContainerView = rewardUserContainerView;

    UIImageView *lastImageView = nil;
    NSMutableArray *icons = [NSMutableArray array];
    for (NSInteger i = 0; i<8; i++) {
        UIImageView *imageView = [UIImageView new];
        [rewardUserContainerView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(rewardUserContainerView.mas_top);
            if (lastImageView) {
                make.left.equalTo(lastImageView.mas_right).offset(-6);
            }else{
                make.left.equalTo(rewardUserContainerView.mas_left);
            }
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        imageView.hidden = YES;
        imageView.backgroundColor = [UIColor redColor];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 10.f;
        [icons addObject:imageView];
        lastImageView = imageView;
    }
    _rewardUserIcons = icons.mutableCopy;

    _rewardUserSumLabel = [UILabel new];
    [rewardUserContainerView addSubview:_rewardUserSumLabel];
    [_rewardUserSumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lastImageView.mas_right).offset(10.f);
        make.centerY.equalTo(lastImageView.mas_centerY);
    }];
    _rewardUserSumLabel.font = [UIFont systemFontOfSize:14.f];
    _rewardUserSumLabel.textColor = [UIColor colorWithHexString:@"#8A6449"];
    [_rewardUserSumLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [_rewardUserSumLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];

    return containerView;
}

- (CGRect)calculateTextHeightWithText:(NSString *)text
                             fontSize:(CGFloat)size{
    CGSize maxSize = CGSizeMake(kMainScreenW-32, 1000);
    CGRect contentRect = [text boundingRectWithSize:maxSize
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]}
                                            context:nil];
    return contentRect;
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
        
        [attributedStr addAttribute:NSForegroundColorAttributeName
                              value:[UIColor colorWithHexString:@"#F13044"]
                              range:NSMakeRange(result.range.location, result.range.length)];
        
    }
    return attributedStr.mutableCopy;
}

- (void)updateTableHeaderView{
    [self layoutIfNeeded];
    _originalWebview.frame = CGRectMake(5, CGRectGetMaxY(_flagView.frame)+5, kMainScreenW-10, _webViewHeight);
    CGFloat height = [_tableHeaderView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = _tableHeaderView.frame;
    frame.size.height = height;
    _tableHeaderView.frame =frame;
    _tableView.tableHeaderView = _tableHeaderView;
}

- (void)bindDataWithModel:(OriginalDetailViewModel *)model{
    if(_isbackfinally)return;
    if (!model) {
        _emptyView.hidden = NO;
        return;
    }
    _model = model;
    _tableHeaderView.hidden = NO;
    _bottomHandelView.hidden = NO;
    [[MDB_UserDefault defaultInstance] setViewWithImage:_avaterImageView url:[MDB_UserDefault getCompleteWebsite:[NSString nullToString:model.avatarLink]]];
    
    if (model.imageLink.length > 0) {
        _iconImageView.hidden = NO;
        [[MDB_UserDefault defaultInstance] setViewWithImage:_iconImageView url:[MDB_UserDefault getCompleteWebsite:model.imageLink] options:0 completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            _originalImage = image;
        }];
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_iconImageView.mas_bottom).offset(16);
        }];
    }else{
        _iconImageView.hidden = YES;
        [_iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_iconImageView.mas_top);
        }];
    }
    NSMutableArray *tags = [NSMutableArray array];
    for (NSString *tagStr in model.tags) {
        if (![@"" isEqualToString:tagStr]) {
            [tags addObject:@{@"name":tagStr,
                              @"type":@"1"}];
        }
    }
    [_flagView flag:tags.mutableCopy];

    _nikNameLabel.text = model.username;
    _createTimeLabel.text = model.createtime;
    if (![@"" isEqualToString:model.userLevel]) {
        _livelBgImageView.hidden = NO;
    }
    _livelLabel.text = model.userLevel;
    _titleLabel.text = model.title;
    _appraiseDescribeLabel.text = [NSString stringWithFormat:@"小编点评：%@",model.reason];
    _rewardsMoneyLabel.text = [NSString stringWithFormat:@"额外奖励：+%@",model.bonus];
    CGRect appraiseTextContentRect = [self calculateTextHeightWithText:_appraiseDescribeLabel.text fontSize:11.f];
    [_appraiseDescribeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(appraiseTextContentRect.size.height+5);
    }];
    
    if(model.reason.length==0)
    {
        _appraiseDescribeLabel.text = @"";
        [_appraiseDescribeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
    }
    
    if (model.bonus.integerValue <= 0) {
        _supplementView.hidden = YES;
        [_supplementView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
        [_originalDetailView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_supplementView.mas_bottom).offset(0);
        }];
    }else{
        _supplementView.hidden = NO;
        [_supplementView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(appraiseTextContentRect.size.height+17+40);
        }];
        [_originalDetailView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_supplementView.mas_bottom).offset(8);
        }];
    }
    CGRect textContentRect = [self calculateTextHeightWithText:model.title fontSize:17.f];
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(textContentRect.size.height+5);
    }];
    [_appraiseView appraiseLivel:model.remarkStar.integerValue];
    _originalWebview.webDescription = model.content;
    if (model.rewardUsers.count>0) {
        [_rewardUserContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(20);
        }];
        [_rewardContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(75);
        }];
        
        for (NSInteger i = 0; i<_rewardUserIcons.count; i++) {
            UIImageView *iconImageView = (UIImageView *)_rewardUserIcons[i];
            if (i<model.rewardUsers.count) {
                iconImageView.hidden = NO;
                [[MDB_UserDefault defaultInstance] setViewWithImage:iconImageView url:[NSString nullToString:model.rewardUsers[i][@"photo"]]];
            }else{
                iconImageView.hidden = YES;
            }
        }
        if (_rewardUserIcons.count > model.rewardUsers.count) {
            UIImageView *iconImageView = (UIImageView *)_rewardUserIcons[model.rewardUsers.count-1];
            [_rewardUserSumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(iconImageView.mas_right).offset(10);
            }];
        }
        _rewardUserSumLabel.attributedText = [self afreshDescribe: [NSString stringWithFormat:@"%@人打赏",model.rewardCount]];
    }
    if ([MDB_UserDefault getIsLogin] && [MDB_UserDefault defaultInstance].userlevel.integerValue < 2) {
        _rewardButton.userInteractionEnabled = NO;
        _rewardButton.backgroundColor = [UIColor grayColor];
    }
    if (model.isFollow) {
        _followBtn.userInteractionEnabled = NO;
        [_followBtn setTitle:@"已关注" forState:UIControlStateNormal];
        [_followBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [_followBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateHighlighted];
        _followBtn.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    }else{
        _followBtn.userInteractionEnabled = YES;
        [_followBtn setTitle:@"+ 关注" forState:UIControlStateNormal];
        [_followBtn setTitleColor:[UIColor colorWithHexString:@"#F27A30"] forState:UIControlStateNormal];
        [_followBtn setTitleColor:[UIColor colorWithHexString:@"#F27A30"] forState:UIControlStateHighlighted];
        _followBtn.layer.borderColor = [UIColor colorWithHexString:@"#F27A30"].CGColor;
    }
    if (model.topicType == TKTopicTypeSpitslot) {
        _followBtn.hidden = YES;
        _avaterImageView.userInteractionEnabled = NO;
    }else{
        _followBtn.hidden = NO;
        _avaterImageView.userInteractionEnabled = YES;
    }
    
    
    _bottomHandelView.collectNumber = model.favnum;
    _bottomHandelView.likeNumber = model.likeCount;
    _bottomHandelView.remarkNumber = model.commentcount;
    [self bindRelevanceData:model.mores];
    [self bindCommentData:model.comments];
    [self updateTableHeaderView];
    

}

- (void)bindCommentData:(NSArray *)models{
    if ([models isKindOfClass:[NSArray class]]){
        if (models.count<=0) return;
        [_remarks removeAllObjects];
        for (NSDictionary *dict in models) {
            Remark *aRemark = [Remark modelWithDictionary:dict];
            aRemark.content = [NSString stringWithFormat:@"%@ ",aRemark.content];
            RemarkStatusLayout *layout = [[RemarkStatusLayout alloc] initWithStatus:aRemark];
            if (layout) {
                [_remarks addObject:layout];
            }
        }
        [_tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

- (void)bindRelevanceData:(NSArray *)models{
    if ([models isKindOfClass:[NSArray class]]){
        if (models.count<=0 || !models) return;
         _otherWorks = models;
        [_tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)backNavAction
{
    _isbackfinally = YES;
    [_originalWebview finalyLoadWKWebView];
}


#pragma mark - Events
- (void)respondsToAvaterView:(UIGestureRecognizer *)gesture{
    if ([self.delegate respondsToSelector:@selector(originalDetailSubjectViewDidClickAvaterWithUserID:)]) {
        [self.delegate originalDetailSubjectViewDidClickAvaterWithUserID:_model.userId];
    }
}

- (void)respondsToFollowBtn:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(originalDetailSubjectViewDidClickFollowBtn:complete:)]) {
        [self.delegate originalDetailSubjectViewDidClickFollowBtn:_model.userId complete:^(BOOL state) {
            if (state) {
                _followBtn.userInteractionEnabled = NO;
                [_followBtn setTitle:@"已关注" forState:UIControlStateNormal];
                [_followBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
                [_followBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateHighlighted];
                _followBtn.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
            }
        }];
    }
}

- (void)respondesToRewardButtonEvents:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(originalDetailSubjectViewDidCickRewardButton)]) {
        [self.delegate originalDetailSubjectViewDidCickRewardButton];
    }
}

- (void)respondsToRewardInfoEvent:(UIControl *)sender{
    if ([self.delegate respondsToSelector:@selector(originalDetailSubjectViewDidCickRewardInfo)]) {
        [self.delegate originalDetailSubjectViewDidCickRewardInfo];
    }
}
#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return _otherWorks.count;
            break;
        case 1:
            if (_remarks.count > 0) {
                if (_model.commentcount.integerValue>30) {
                    return _remarks.count + 1;
                }else{
                    return _remarks.count;
                }
            }
            break;
            
        default:
            return 0;
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        OriginalMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOtherWorksTableViewCellIdentifier];
//        cell.delegate = self;
        if(indexPath.row<_otherWorks.count)
        {
            [cell bindDataWithModel:_otherWorks[indexPath.row]];
        }
        
        return cell;
    }else if (indexPath.section == 1){
        if(indexPath.row > _remarks.count - 1){
            ReadMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReadMoreTableViewCellIdentifier];
            return cell;
        }else{
            RemarkHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHotCommentTableViewCellIdentifier];
            if(indexPath.row<_remarks.count)
            {
                [cell setLayout:_remarks[indexPath.row]];
            }
            
            cell.delegate = self;
            return cell;
        }
    }else{
        static NSString *cellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return kTableSectionOtherWorksRowHeight*kScale;
    }else if (indexPath.section == 1){
        if (indexPath.row == 30) {
            return 50;
        }else{
            
            if(indexPath.row>=_remarks.count)
            {
                return 0;
            }
            return ((RemarkStatusLayout *)_remarks[indexPath.row]).height;
        }
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 调整Separator位置
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    // 移除tableviewcell最后一行的Separator
    if (indexPath.section == 1 && indexPath.row==_remarks.count) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, self.bounds.size.width, 0, 0)];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, self.bounds.size.width, 0, 0)];
        }
    }
    
}

#pragma mark - UITableView Delegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (self.otherWorks.count > 0) {
            return kTableSectionHeaderViewHeight;
        }
    }else if (section == 1){
        if (_remarks.count > 0) {
            return kTableSectionHeaderViewHeight;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), kTableSectionHeaderViewHeight)];
    headerView.backgroundColor = [UIColor whiteColor];

    UIView *lineView = [UIView new];
    [headerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(headerView);
        make.height.offset(10);
    }];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    
   
    if (section == 0) {
        UILabel *titleLabel = [UILabel new];
        [headerView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(headerView.mas_centerX);
            make.centerY.equalTo(headerView.mas_centerY).offset(10);
        }];
        titleLabel.font = [UIFont systemFontOfSize:14.f];
        titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        titleLabel.text = @"TA还写了";
        
        UIView *leftLineView = [UIView new];
        [headerView addSubview:leftLineView];
        [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleLabel.mas_centerY);
            make.right.equalTo(titleLabel.mas_left).offset(-8);
            make.size.mas_equalTo(CGSizeMake(16, 1));
        }];
        leftLineView.backgroundColor = [UIColor colorWithHexString:@"#999999"];
        
        UIView *rightLineView = [UIView new];
        [headerView addSubview:rightLineView];
        [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleLabel.mas_centerY);
            make.left.equalTo(titleLabel.mas_right).offset(8);
            make.size.mas_equalTo(CGSizeMake(16, 1));
        }];
        rightLineView.backgroundColor = [UIColor colorWithHexString:@"#999999"];

    }else{
        
        UIImageView *iconImageView = [UIImageView new];
        [headerView addSubview:iconImageView];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerView.mas_centerY).offset(10);
            make.left.equalTo(headerView.mas_left).offset(16);
            make.size.mas_equalTo(CGSizeMake(14, 14));
        }];
        iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        UILabel *nameLabel = [UILabel new];
        [headerView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImageView.mas_right).offset(5);
            make.centerY.equalTo(iconImageView.mas_centerY);
        }];
        iconImageView.image = [UIImage imageNamed:@"comment_ general_normal"];
        nameLabel.textColor = [UIColor colorWithHexString:@"#F77210"];
        nameLabel.font = [UIFont systemFontOfSize:14.f];
        nameLabel.text = [NSString stringWithFormat:@"评论(%@)",_model.commentcount];
    }
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if(indexPath.row>=_otherWorks.count)return;
        if ([self.delegate respondsToSelector:@selector(originalDetailSubjectViewDidSelectTableViewCellWithID:)]) {
            [self.delegate originalDetailSubjectViewDidSelectTableViewCellWithID:[NSString nullToString:_otherWorks[indexPath.row][@"id"]]];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row > _remarks.count-1) {
            if ([self.delegate respondsToSelector:@selector(originalDetailSubjectViewDidCickReadMoreRemark)]) {
                [self.delegate originalDetailSubjectViewDidCickReadMoreRemark];
            }
        }
    }
}

#pragma mark - RemarkHomeTableViewCell
///用户点击了赞
-(void)cell:(RemarkHomeTableViewCell *)cell disClickZan:(Remark *)strid
{
    
    if (![MDB_UserDefault defaultInstance].usertoken){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请登录后再试"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"登录",@"取消", nil];
        [alertView setTag:111];
        [alertView show];
        return;
    }
    
    NSDictionary *pramr=@{@"id":[NSString stringWithFormat:@"%@",strid.comentid],
                          @"type":[NSString stringWithFormat:@"%@",@(1)],
                          @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    
    
    [HTTPManager sendRequestUrlToService:URL_commentvote withParametersDictionry:pramr view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        
        
    }];
}
- (void)cellDidClick:(RemarkHomeTableViewCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSString *userid = [[(RemarkStatusLayout *)_remarks[indexPath.row] status] userid];
    if ([self.delegate respondsToSelector:@selector(originalDetailSubjectViewDidPressCommentItemWithToUserID:)]) {
        [self.delegate originalDetailSubjectViewDidPressCommentItemWithToUserID:userid];
    }
}

- (void)cell:(RemarkHomeTableViewCell *)cell didClickUser:(NSString *)userid{
    if ([self.delegate respondsToSelector:@selector(originalDetailSubjectViewDidClickAvaterWithUserID:)]) {
        [self.delegate originalDetailSubjectViewDidClickAvaterWithUserID:userid];
    }
}

#pragma mark - NJFlagViewDelegate
- (void)flageViewDidClickItem:(NSDictionary *)item type:(FlagType)type{
    if ([self.delegate respondsToSelector:@selector(originalDetailSubjectViewDidClickTage:)]) {
        [self.delegate originalDetailSubjectViewDidClickTage:item[@"name"]];
    }
}

#pragma mark - MDBwebDelegate
-(void)webViewDidFinishLoad:(float)h webview:(MDBwebVIew *)webView{
//    [webView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.offset(h);
//    }];
    _webViewHeight = h;
    [self updateTableHeaderView];
}

- (void)webViewDidPreseeUrlWithLink:(NSString *)link webview:(MDBwebVIew *)webView{
    if ([self.delegate respondsToSelector:@selector(originalDetailSubjectViewDidPressNonstopItemWithOutUrlStr:)]) {
        [self.delegate originalDetailSubjectViewDidPressNonstopItemWithOutUrlStr:link];
    }
}

#pragma mark - OriginalMoreTableViewCellDelegate
- (void)OriginalMoreTableViewCellDidClickLikeBtnWithCell:(OriginalMoreTableViewCell *)cell{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    if ([self.delegate respondsToSelector:@selector(originalDetailSubjectViewOtherWorkCellDidCilckLikeBtn:didComplete:)]) {
        [self.delegate originalDetailSubjectViewOtherWorkCellDidCilckLikeBtn:[NSString nullToString:_otherWorks[indexPath.row][@"id"]]
                                                                 didComplete:^{
                     NSMutableArray *tempArr = [NSMutableArray arrayWithArray:_otherWorks];
                     NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:tempArr[indexPath.row]];
                     [dict setObject:[NSString stringWithFormat:@"%@",@([dict[@"votesp"] integerValue]+1)] forKey:@"votesp"];
                     [dict setObject:@"1" forKey:@"isLike"];
                     [tempArr replaceObjectAtIndex:indexPath.row withObject:dict];
                     _otherWorks = tempArr.mutableCopy;
                     [_tableView reloadRow:indexPath.row inSection:0 withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
}


#pragma mark - OriginalBottomHandelViewDelegate
- (void)tabBarViewDidPressComBton{
    if ([self.delegate respondsToSelector:@selector(originalDetailSubjectViewDidPressRemarkBtn)]) {
        [self.delegate originalDetailSubjectViewDidPressRemarkBtn];
    }
}
- (void)tabBarViewDidPressShouBton{
    if ([self.delegate respondsToSelector:@selector(originalDetailSubjectViewDidPressCollectBtnDidComplete:)]) {
        [self.delegate originalDetailSubjectViewDidPressCollectBtnDidComplete:^(BOOL state) {
            [_bottomHandelView updateTabBarCollectBtnState:state];
        }];
    }
}
- (void)tabBarViewDidPressZanBton{
    if ([self.delegate respondsToSelector:@selector(originalDetailSubjectViewDidPressLikeBtnComplete:)]) {
        [self.delegate originalDetailSubjectViewDidPressLikeBtnComplete:^{
            [_bottomHandelView updateTabBarLinkBtnState];
        }];
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UITableView class]]) {
        //固定头部视图
        if (scrollView.contentOffset.y<=kTableSectionHeaderViewHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=kTableSectionHeaderViewHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-kTableSectionHeaderViewHeight, 0, 0, 0);
        }
    }
}

@end
