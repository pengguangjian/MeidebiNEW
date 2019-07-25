//
//  ProductInfoSubjectsView.m
//  Meidebi
//
//  Created by mdb-admin on 16/4/28.
//  Copyright © 2016年 meidebi. All rights reserved.
//


#import "ProductInfoSubjectsView.h"
#import "MDB_UserDefault.h"
#import "MDBwebVIew.h"
#import "CompressImage.h"
#import "PelsonalHandleButton.h"
#import "RelevanceTableViewCell.h"
#import "ReadMoreTableViewCell.h"
#import "RemarkHomeTableViewCell.h"
#import "RelevanceCellViewModel.h"
#import "RemarkStatusHelper.h"
#import "HotShowdanTableViewCell.h"

#import <UMAnalytics/MobClick.h>

#import "DaiGouPinDanTableViewCell.h"

#import "DaiGouXiaDanViewController.h"

#import "VKLoginViewController.h"

#import "HTTPManager.h"

#import "GuanLianYuDuViewController.h"

#import "ProductInfoQiuKaiTuanView.h"

#import "TaoLiJinHongBaoView.h"

#import "SelectColorAndSizeView.h"

#import "ZheXianTuView.h"

typedef NS_ENUM(NSInteger, TableViewSectionType) {
    TableViewSectionTypeOriginal,
    TableViewSectionTypeLike,
    TableViewSectionTypeRmark
};

@interface CustomLabel : UILabel

@property (nonatomic, assign) UIEdgeInsets edgeInsets;

@end

@implementation CustomLabel
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
    
}
- (CGSize)intrinsicContentSize{
    CGSize size = [super intrinsicContentSize];
    size.width  += self.edgeInsets.left + self.edgeInsets.right;
    size.height += self.edgeInsets.top + self.edgeInsets.bottom;
    return size;
}

@end

static NSString * const kButtonSelectStatueColor = @"#F77210";
static NSString * const kButtonNormalStatueColor = @"#999999";

@interface ProductInfoTabBarView ()

@property (nonatomic, retain) PelsonalHandleButton *zanBtn;
@property (nonatomic, retain) PelsonalHandleButton *shouBtn;
@property (nonatomic, retain) PelsonalHandleButton *comBtn;
//@property (nonatomic, retain) PelsonalHandleButton *reportBtn;

@end

@implementation ProductInfoTabBarView{
    
    UIButton *GoBtn;
    BOOL isZan;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    
    UIView *lineView = [UIView new];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.offset(0.5);
    }];
    lineView.backgroundColor = [UIColor colorWithRed:0.9102 green:0.9102 blue:0.9102 alpha:1.0];
    
    GoBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(5);
            make.bottom.equalTo(self.mas_bottom).offset(-5);
            make.right.equalTo(self.mas_right).offset(-5);
            //            make.width.greaterThanOrEqualTo(@80);
            make.width.offset(90);
        }];
        button.tag = 11111;
        button.titleLabel.textColor = [UIColor whiteColor];
        button.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [button setBackgroundImage:[UIImage imageNamed:@"open_url_btn_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"open_url_btn_normal"] forState:UIControlStateHighlighted];
        [button setTitle:@"直达链接" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(respondsToBtnEvents:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    //    _reportBtn = [PelsonalHandleButton buttonWithType:UIButtonTypeCustom];
    //    [self addSubview:_reportBtn];
    //    [_reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.equalTo(GoBtn.mas_left).offset(-11);
    //        make.top.equalTo(self.mas_top).offset(10);
    //        make.bottom.equalTo(self.mas_bottom).offset(-10);
    //        make.width.lessThanOrEqualTo(@100);
    //
    //    }];
    //    _reportBtn.tag = 44;
    //    _reportBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    //    [_reportBtn setTitleColor:[UIColor colorWithHexString:kButtonNormalStatueColor]
    //                    forState:UIControlStateNormal];
    //    [_reportBtn setImage:[UIImage imageNamed:@"discount_report_normal"] forState:UIControlStateNormal];
    //    [_reportBtn setTitle:@"过期" forState:UIControlStateNormal];
    //    [_reportBtn addTarget:self action:@selector(respondEvent:) forControlEvents:UIControlEventTouchUpInside];
    //
    //
    //    UIView *lineView3 = [UIView new];
    //    [self addSubview:lineView3];
    //    [lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.equalTo(GoBtn.mas_left).offset(-11);
    //        make.top.equalTo(self.mas_top).offset(10);
    //        make.size.mas_equalTo(CGSizeMake(1, 15));
    //    }];
    //    lineView3.backgroundColor = [UIColor colorWithHexString:kButtonNormalStatueColor];
    float fbtwidth = (BOUNDS_WIDTH - 93)/3.0;
    _comBtn = [PelsonalHandleButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_comBtn];
    [_comBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(GoBtn.mas_left);
        make.top.equalTo(self.mas_top).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        //        make.width.lessThanOrEqualTo(@100);
        make.width.offset(fbtwidth);
        
    }];
    _comBtn.tag = 33;
    _comBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [_comBtn setTitleColor:[UIColor colorWithHexString:kButtonNormalStatueColor]
                  forState:UIControlStateNormal];
    [_comBtn setImage:[UIImage imageNamed:@"discount_comment_normal"] forState:UIControlStateNormal];
    [_comBtn addTarget:self action:@selector(respondEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *lineView2 = [UIView new];
    [self addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_comBtn.mas_left);
        make.centerY.equalTo(_comBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(1, 15));
    }];
    lineView2.backgroundColor = [UIColor colorWithHexString:kButtonNormalStatueColor];
    
    _shouBtn = [PelsonalHandleButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_shouBtn];
    [_shouBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lineView2.mas_left);
        make.top.bottom.equalTo(_comBtn);
        make.width.offset(fbtwidth);
        
    }];
    _shouBtn.tag = 22;
    _shouBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [_shouBtn setTitleColor:[UIColor colorWithHexString:kButtonNormalStatueColor]
                   forState:UIControlStateNormal];
    [_shouBtn setImage:[UIImage imageNamed:@"discount_collect_normal"] forState:UIControlStateNormal];
    [_shouBtn addTarget:self action:@selector(respondEvent:) forControlEvents:UIControlEventTouchUpInside];
//    [_shouBtn setBackgroundColor:[UIColor brownColor]];
//    [_shouBtn.imageView setBackgroundColor:[UIColor yellowColor]];
    
    
    UIView *lineView1 = [UIView new];
    [self addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_shouBtn.mas_left);
        make.centerY.equalTo(_shouBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(1, 15));
    }];
    lineView1.backgroundColor = [UIColor colorWithHexString:kButtonNormalStatueColor];
    
    _zanBtn = [PelsonalHandleButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_zanBtn];
    [_zanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lineView1.mas_left);
        make.top.bottom.equalTo(_shouBtn);
        make.left.equalTo(self.mas_left).offset(15);
    }];
    _zanBtn.tag = 11;
    _zanBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [_zanBtn setTitleColor:[UIColor colorWithHexString:kButtonNormalStatueColor]
                  forState:UIControlStateNormal];
    [_zanBtn setImage:[UIImage imageNamed:@"discount_like_normal"] forState:UIControlStateNormal];
    [_zanBtn addTarget:self action:@selector(respondEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

#pragma mark - respond events
- (void)respondEvent:(PelsonalHandleButton *)sender{
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
        case 44:
        {
            if ([self.delegate respondsToSelector:@selector(tabBarViewDidPressReportItem)]) {
                [self.delegate tabBarViewDidPressReportItem];
            }
        }
            break;
            
        default:
            break;
    }
    
}

- (void)respondsToBtnEvents:(id)sender{
    if ([self.delegate respondsToSelector:@selector(tabBarViewDidPressNonstopBton)]) {
        ///zhidalianjie
        [MobClick event:@"zhidalianjie" label:@"直达链接"];
        [self.delegate tabBarViewDidPressNonstopBton];
        
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
            make.center.equalTo(_zanBtn);
        }];
        self.zanNumberStr = [NSString stringWithFormat:@"%@",@([_zanBtn.titleLabel.text integerValue]+1)];
        [_zanBtn setImage:[UIImage imageNamed:@"discount_like_select"] forState:UIControlStateNormal];
        isZan = YES;
        [self layoutIfNeeded];
    }else{
        [_labelCommend mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_shouBtn);
        }];
        if (minus) {
            if ([_shouBtn.titleLabel.text isEqualToString:@"0"]) return;
            _labelCommend.text = @"-1";
            self.shouNumberStr = [NSString stringWithFormat:@"%@",@([_shouBtn.titleLabel.text integerValue]-1)];
            [_shouBtn setImage:[UIImage imageNamed:@"discount_collect_normal"] forState:UIControlStateNormal];
        }else{
            self.shouNumberStr = [NSString stringWithFormat:@"%@",@([_shouBtn.titleLabel.text integerValue]+1)];
            [_shouBtn setImage:[UIImage imageNamed:@"discount_collect_select"] forState:UIControlStateNormal];
        }
        [self layoutIfNeeded];
    }
    CAAnimation *animation =[CompressImage groupAnimation:_labelCommend];
    [_labelCommend.layer addAnimation:animation forKey:@"animation"];
}

#pragma mark - getters and setters
- (void)setShouNumberStr:(NSString *)shouNumberStr{
    _shouNumberStr = shouNumberStr;
    
    [_shouBtn setTitle:[self numberChangeStringValue:[NSNumber numberWithInt:shouNumberStr.intValue]] forState:UIControlStateNormal];
    
    
    
    
}
- (void)setZanNumberStr:(NSString *)zanNumberStr{
    _zanNumberStr = zanNumberStr;
    [_zanBtn setTitle:[self numberChangeStringValue:[NSNumber numberWithInt:zanNumberStr.intValue]] forState:UIControlStateNormal];
}
- (void)setComNumberStr:(NSString *)comNumberStr{
    _comNumberStr = comNumberStr;
    [_comBtn setTitle:[self numberChangeStringValue:[NSNumber numberWithInt:comNumberStr.intValue]] forState:UIControlStateNormal];
}

- (void)setIsEnshrine:(BOOL)isEnshrine{
    _isEnshrine = isEnshrine;
    if (isEnshrine) {
        [_shouBtn setImage:[UIImage imageNamed:@"discount_collect_select"] forState:UIControlStateNormal];
        [_shouBtn setImage:[UIImage imageNamed:@"discount_collect_select"] forState:UIControlStateHighlighted];
    }
}

-(void)dealloc
{
    _zanBtn = nil;
    _shouBtn = nil;
    _comBtn = nil;
    //    _reportBtn = nil;
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

static NSString * const kTableViewHeaderName = @"name";
static NSString * const kTableViewHeaderImage = @"image";
static NSString * const kRelevanceTableViewCellIdentifier = @"relevanceCell";
static NSString * const kHotCommentTableViewCellIdentifier = @"hotComment";
static NSString * const kReadMoreTableViewCellIdentifier = @"readMore";
static NSString * const kHotShownTableViewCellIdentifier = @"hotshowdan";
static float const kTableViewSectionHeaderHeight              = 44;

@interface ProductInfoSubjectsView ()
<
MDBwebDelegate,
NJFlagViewDelegate,
UITableViewDelegate,
UITableViewDataSource,
RemarkHomeTableViewCellDelegate,
ProductInfoTabBarViewDelegate,
RelevanceTableViewCellDelegate,
UIAlertViewDelegate,
ProductInfoQiuKaiTuanViewDelegate,
TaoLiJinHongBaoViewDelegate,
SelectColorAndSizeViewDelegate
>
//main
@property (nonatomic, retain) ProductInfoSubjectsViewModel *subjuectViewModel;
@property (nonatomic, retain) ProductInfoTabBarView *tabBarView;
@property (nonatomic, retain) NSMutableArray *tableSectionTypes;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIView *tableHeaderView;
@property (nonatomic, retain) UIView *contairView;
@property (nonatomic, retain) UIImageView *productImageView;
@property (nonatomic, retain) UILabel *productNameLabel;
@property (nonatomic, retain) UILabel *productPriceLabel;
@property (nonatomic, retain) UILabel *ProductOriginalPriceLabel;
@property (nonatomic, retain) UILabel *ProductSupplyLabel;
@property (nonatomic, retain) UIButton *courseButton;
///亚马逊免邮教程
@property (nonatomic, retain) UIButton *mianyoujiaochengButton;

@property (nonatomic, retain) UIView *disburseDetailView;
@property (nonatomic, retain) UILabel *burseDetailPriceLabel;
@property (nonatomic, retain) UIButton *examineDisbursBtn;
@property (nonatomic, retain) UIButton *transitcompanyBtn;
@property (nonatomic, retain) UILabel *commoditySupplyAreaLabel;
@property (nonatomic, retain) UILabel *postageLabel;
////代购或拼单模块
@property (nonatomic, retain) UITableView *daiGouTabView;
@property (nonatomic, retain) NSMutableArray *arrDaiGouData;

// privilege
@property (nonatomic, retain) UIView *privilegeContainerView;
@property (nonatomic, retain) CustomLabel *privilegeTypeLabel;
@property (nonatomic, retain) UILabel *privilegeDescribeLabel;
@property (nonatomic, retain) UILabel *privilegeTitleLabel;

// banner
@property (nonatomic, retain) UIImageView *image_bannnerView;
// tax reference
@property (nonatomic, retain) UIView *contentContairView;
@property (nonatomic, retain) UIView *taxContairView;
@property (nonatomic, retain) UIView *tariffContairView;
@property (nonatomic, retain) UIView *transportInfoView;
@property (nonatomic, retain) UIButton *transferBtn;
@property (nonatomic, retain) UIButton *transferForeignBtn;
@property (nonatomic, retain) UIButton *transferPriceBtn;
@property (nonatomic, retain) UIButton *transportTypeBtn;
@property (nonatomic, retain) UIButton *transferSumPriceBtn;
@property (nonatomic, retain) UIButton *tariffInfoBtn;
@property (nonatomic, retain) MDBwebVIew *taxWebView;
@property (nonatomic, assign) BOOL isShowTaxReference;
@property (nonatomic, assign) CGFloat taxWebHeight;
// user info
@property (nonatomic, retain) UIView *personalInfoView;
@property (nonatomic, retain) UIView *userInfoView;
@property (nonatomic, retain) UIImageView *iconImageView;
@property (nonatomic, retain) UILabel *nikNameLabel;
@property (nonatomic, retain) UILabel *livelLabel;
@property (nonatomic, retain) UILabel *userShareLabel;
@property (nonatomic, retain) UIImageView *livelBgImageView;
@property (nonatomic, retain) UIButton *levelNickButton;
@property (nonatomic, retain) UILabel *discountPublishDateLabel;
@property (nonatomic, retain) UIButton *fellowBtn;
@property (nonatomic, retain) UIView *handleContainerView;
@property (nonatomic, retain) UIButton *purchasedBtn;
@property (nonatomic, retain) UIButton *wantBuyBtn;
@property (nonatomic, retain) UIControl *rewardUserContainerView;
@property (nonatomic, retain) NSArray *rewardUserIcons;
@property (nonatomic, retain) UILabel *rewardUserSumLabel;
@property (nonatomic, retain) UIButton *rewardButton;
// describe
@property (nonatomic, retain) MDBwebVIew *detailWebView;
// flag
@property (nonatomic, retain) NJFlagView *flagView;
@property (nonatomic, retain) NSMutableArray *layouts;
@property (nonatomic, retain) NSArray *tableViewHeaders;
@property (nonatomic, retain) NSArray *relevances;
@property (nonatomic, retain) NSArray *hotshowdans;

@property (nonatomic, retain) UIView *viewpggline;


@property (nonatomic , retain) ProductInfoSubjectsDaiGouViewModel *daigoumodel;

@property (nonatomic, retain) UILabel *lbjiagezs;
///价格走势
@property (nonatomic, retain) ZheXianTuView *viewjiagezs;

///关联阅读
@property (nonatomic, retain) UIView *viewGuanLianYueDu;

///举报
@property (nonatomic, retain) UIView *viewjubao;

@property (nonatomic, assign) int idaigoutype;
@property (nonatomic, retain) SelectColorAndSizeView *ggView;

@property (nonatomic, assign) BOOL isbackfinally;

///引导收藏
@property (nonatomic, retain)UIView *viewyindao;

///相关晒单
@property (nonatomic, retain) UIView *viewSaiDan;


@end

@implementation ProductInfoSubjectsView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _layouts = [NSMutableArray array];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    
    _tabBarView = [ProductInfoTabBarView new];
    [self addSubview:_tabBarView];
    [_tabBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.offset(50);
    }];
    _tabBarView.delegate = self;
    
    _tableView = [UITableView new];
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(_tabBarView.mas_top);
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[RemarkHomeTableViewCell class] forCellReuseIdentifier:kHotCommentTableViewCellIdentifier];
    [_tableView registerClass:[RelevanceTableViewCell class] forCellReuseIdentifier:kRelevanceTableViewCellIdentifier];
    [_tableView registerClass:[ReadMoreTableViewCell class] forCellReuseIdentifier:kReadMoreTableViewCellIdentifier];
    [_tableView registerClass:[HotShowdanTableViewCell class] forCellReuseIdentifier:kHotShownTableViewCellIdentifier];
    _tableView.separatorColor = [UIColor colorWithHexString:@"#EDEDED"];
    [self setExtraCellLineHidden:_tableView];
    
    _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, -450, kMainScreenW, 450)];
    _tableView.tableHeaderView = _tableHeaderView;
    
    _contairView = ({
        UIView *view = [UIView new];
        [_tableHeaderView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_tableHeaderView);
        }];
        [view setBackgroundColor:[UIColor whiteColor]];
        view;
    });
    [self setupProductInfoSubView];
    
    
}

-(void)disyindaoAction:(UIGestureRecognizer *)gesture
{
    [gesture.view removeFromSuperview];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"shoucangyingdao"];
}

#pragma mark - 商品信息
- (void)setupProductInfoSubView{
    //    _productImageView = ({
    //        UIImageView *imageView = [UIImageView new];
    //        [_contairView addSubview:imageView];
    //        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.top.equalTo(_contairView.mas_top).with.offset(15);
    //            make.left.equalTo(_contairView.mas_left).with.offset(15);
    //            make.right.equalTo(_contairView.mas_right).with.offset(-15);
    //            make.height.offset(125);
    //        }];
    //        [imageView setContentMode:UIViewContentModeScaleAspectFit];
    //        imageView;
    //    });
    _productImageView = [UIImageView new];
    [_contairView addSubview:_productImageView];
    [_productImageView setFrame:CGRectMake(10, 10, BOUNDS_WIDTH-30, 125)];
    [_productImageView setContentMode:UIViewContentModeScaleAspectFit];
    
    
    _productNameLabel = [UILabel new];
    [_contairView addSubview:_productNameLabel];
    [_productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_productImageView);
        make.top.equalTo(_productImageView.mas_bottom).with.offset(20);
    }];
    _productNameLabel.numberOfLines = 4;
    _productNameLabel.font = [UIFont systemFontOfSize:17.f];
    _productNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    
    _productPriceLabel = [UILabel new];
    [_contairView addSubview:_productPriceLabel];
    [_productPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_productNameLabel.mas_left);
        make.top.equalTo(_productNameLabel.mas_bottom).offset(5);
        make.width.offset(BOUNDS_WIDTH-30);
        make.height.offset(30);
    }];
    _productPriceLabel.numberOfLines = 2;
    _productPriceLabel.font = [UIFont systemFontOfSize:20.f];
    _productPriceLabel.textColor = [UIColor colorWithHexString:@"#fd6e00"];
    
    _ProductOriginalPriceLabel = [UILabel new];
    [_contairView addSubview:_ProductOriginalPriceLabel];
    [_ProductOriginalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_productPriceLabel.mas_right).with.offset(5);
        make.right.lessThanOrEqualTo(_productImageView.mas_right);
        make.bottom.equalTo(_productPriceLabel.mas_bottom).offset(-1);
        make.width.offset(1);
    }];
    _ProductOriginalPriceLabel.font = [UIFont systemFontOfSize:13.f];
    _ProductOriginalPriceLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    
    UIView *thickLineView = [UIView new];
    [_ProductOriginalPriceLabel addSubview:thickLineView];
    [thickLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_ProductOriginalPriceLabel);
        make.left.right.equalTo(_ProductOriginalPriceLabel);
        make.height.offset(1);
        make.width.offset(1);
    }];
    thickLineView.backgroundColor = [UIColor colorWithRed:0.6668 green:0.6668 blue:0.6668 alpha:1.0];
    
    _ProductSupplyLabel = [UILabel new];
    [_contairView addSubview:_ProductSupplyLabel];
    [_ProductSupplyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_productPriceLabel.mas_left);
        make.top.equalTo(_productPriceLabel.mas_bottom).offset(5);
        make.width.offset(BOUNDS_WIDTH-120);
        make.height.offset(20);
    }];
    _ProductSupplyLabel.font = [UIFont systemFontOfSize:14.f];
    _ProductSupplyLabel.textColor = [UIColor colorWithRed:0.6452 green:0.6452 blue:0.6452 alpha:1.0];
    [_ProductSupplyLabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapProductSupplyLabel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shangchengdianjiAction)];
    [_ProductSupplyLabel addGestureRecognizer:tapProductSupplyLabel];
    
    
    
    _transitcompanyBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_contairView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_ProductSupplyLabel.mas_right).with.offset(1);
            make.centerY.equalTo(_ProductSupplyLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(50, 20));
        }];
        button.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [button setTitleColor:[UIColor colorWithRed:0.6452 green:0.6452 blue:0.6452 alpha:1.0]
                     forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"recommend"] forState:UIControlStateNormal];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -13)];
        button.userInteractionEnabled = NO;
        button.hidden =YES;
        button;
    });
    
    _courseButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_contairView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_transitcompanyBtn.mas_right).offset(5);
            make.right.lessThanOrEqualTo(_productImageView.mas_right);
            make.centerY.equalTo(_transitcompanyBtn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(70, 20));
        }];
        [button addTarget:self action:@selector(respondesToCourseBtnEvents:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [button setTitle:@"海淘教程" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithHexString:@"#cfa47b"];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 2.f;
        button.hidden = YES;
        button;
    });
    
    
    ////免邮教程
    _mianyoujiaochengButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_contairView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_contairView.mas_right).offset(-10);
            make.centerY.equalTo(_transitcompanyBtn.mas_centerY).offset(-10);
            make.size.mas_equalTo(CGSizeMake(125*kScale, 35*kScale));
        }];
        [button addTarget:self action:@selector(yamaxunmianyouBtnEvents) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [button setImage:[UIImage imageNamed:@"dianjibangnimianyoufei"] forState:UIControlStateNormal];
        [button.imageView setContentMode:UIViewContentModeScaleAspectFit];
        button.hidden = YES;
        button;
    });
    
    
    
    
    [self setupDisburseSubView];
}

- (void)setupDisburseSubView{
    /*
    UIView *lineView = ({
        UIView *view = [UIView new];
        [_contairView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_ProductSupplyLabel.mas_bottom).offset(8);
            make.left.right.equalTo(_contairView);
            make.height.offset(1);
        }];
        view.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
        view;
    });
    */
    
    _contentContairView = ({
        UIView *view = [UIView new];
        [_contairView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_ProductSupplyLabel.mas_bottom).with.offset(16);
            make.left.right.equalTo(_contairView);
        }];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    /*
    _disburseDetailView = ({
        UIView *view = [UIView new];
        [_contentContairView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentContairView.mas_top);
            make.left.right.equalTo(_contentContairView);
        }];
        view.backgroundColor = [UIColor whiteColor];
        view.hidden = YES;
        view;
    });
    
    _burseDetailPriceLabel = ({
        UILabel *label = [UILabel new];
        [_disburseDetailView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_disburseDetailView.mas_left).with.offset(15);
            make.top.equalTo(_disburseDetailView.mas_top);
        }];
        label.font = [UIFont boldSystemFontOfSize:14.f];
        label.textColor = [UIColor colorWithHexString:@"#333333"];
        label;
    });
    
    _examineDisbursBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_disburseDetailView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_burseDetailPriceLabel.mas_left);
            make.top.equalTo(_burseDetailPriceLabel.mas_bottom).offset(2);
            make.size.mas_equalTo(CGSizeMake(120, 25));
        }];
        [button setTitle:@"参考运费及关税" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setTitleColor:[UIColor colorWithHexString:@"#9b6a3a"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"taxreference_dis"] forState:UIControlStateNormal];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 103, 0, 4)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -9, 0, 0)];
        button;
    });
    [_examineDisbursBtn addTarget:self action:@selector(respondesToButtonEvents:) forControlEvents:UIControlEventTouchUpInside
     ];
    
    
    
    [_disburseDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_examineDisbursBtn.mas_bottom);
    }];
     */
    
    [self setupTaxSubView];
}

- (void)setupTaxSubView{
    
    /*
    _taxContairView = ({
        UIView *view = [UIView new];
        [_contentContairView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_disburseDetailView.mas_bottom);
            make.left.right.equalTo(_productImageView);
            make.height.offset(1);
        }];
        view.backgroundColor = [UIColor colorWithHexString:@"#999999"];
        view.hidden = !_isShowTaxReference;
        view.clipsToBounds = YES;
        view.hidden = NO;
        view;
    });
    _taxWebView = ({
        MDBwebVIew *webView = [[MDBwebVIew alloc] init];
        [_taxContairView addSubview:webView];
        [webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(_taxContairView);
            make.bottom.equalTo(_taxContairView);
        }];
        webView.backgroundColor = [UIColor whiteColor];
        webView.delegate = self;
        webView.tag = 1111;
        webView;
    });
    
    ////
    UIView *viewline = [[UIView alloc] init];
    [viewline setBackgroundColor:RGB(234, 234, 234)];
    [_taxContairView addSubview:viewline];
    [viewline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_taxWebView.mas_bottom).offset(-1);
        make.left.right.equalTo(_productImageView);
        make.height.offset(1);
    }];
    _viewpggline = viewline;
     */
    ////peng123
    //    1234567890
    ///在这里添加拼单和代购模块
    UIView *viewdaigouback = [[UIView alloc] init];
    [viewdaigouback setBackgroundColor:RGB(253,237,224)];
    [_contentContairView addSubview:viewdaigouback];
    [viewdaigouback.layer setMasksToBounds:YES];
    
    _daiGouTabView = [[UITableView alloc] init];
    [_daiGouTabView setScrollEnabled:NO];
    [_daiGouTabView setBackgroundColor:[UIColor clearColor]];
    //    [_daiGouTabView setDelegate:self];
    //    [_daiGouTabView setDataSource:self];
    [_daiGouTabView setTag:1234];
    [_daiGouTabView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_contentContairView addSubview:_daiGouTabView];
    [_daiGouTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentContairView.mas_top);
        make.left.right.equalTo(self);
        make.height.offset(0);
    }];
    [self setExtraCellLineHidden:_daiGouTabView];
    
    
    [viewdaigouback mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_daiGouTabView.mas_top);
        make.left.offset(5);
        make.right.equalTo(_daiGouTabView.mas_right).offset(-5);
        make.bottom.equalTo(_daiGouTabView.mas_bottom).offset(-2);
        [viewdaigouback.layer setCornerRadius:4];
    }];
    
    ///完
    
    [self setupPrivilegeInfoView];
}

///红包抖动动画
-(void)imgvhongbaoview:(UIView *)imgvhongbao
{
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];    //设置抖动幅度
    shake.fromValue = [NSNumber numberWithFloat:+0.1];
    shake.toValue = [NSNumber numberWithFloat:-0.1];
    shake.duration = 0.1;
    shake.autoreverses = YES; //是否重复
    shake.repeatCount = 4;
    [imgvhongbao.layer addAnimation:shake forKey:@"imageView"];
    imgvhongbao.alpha = 1.0;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        for(UIViewController *vc in self.viewController.navigationController.viewControllers)
        {
            if([vc isKindOfClass:[self.viewController class]])
            {
                [imgvhongbao.layer removeAllAnimations];
                [self imgvhongbaoview:imgvhongbao];
                break;
            }
        }
    });
    
}

///红包点击
-(void)hongbaoAction
{
    
    TaoLiJinHongBaoView *view = [[TaoLiJinHongBaoView alloc] init];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(30);
        make.right.equalTo(self.mas_right).offset(-30);
        make.height.offset(240);
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [view setDelegate:self];
}

-(void)fenxianghongbao
{
    [self.delegate fenxianghongbaov];
}

#pragma mark - 代购或拼单header
-(void)drawdaigouHeader:(ProductInfoSubjectsDaiGouViewModel *)modelValue
{
    if(_subjuectViewModel.tljurl.length>6)
    {
        ////红包抖动效果
        UIImageView *imgvhongbao = [[UIImageView alloc] init];
        [self addSubview:imgvhongbao];
        [imgvhongbao mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.mas_top).offset(30);
            make.right.equalTo(self.mas_right).offset(-15);
            make.size.sizeOffset(CGSizeMake(40, 50));
        }];
        [imgvhongbao setImage:[UIImage imageNamed:@"hongbao_yaodong"]];
        [imgvhongbao setContentMode:UIViewContentModeScaleAspectFit];
        [imgvhongbao setUserInteractionEnabled:YES];
        UITapGestureRecognizer *taphongbao = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hongbaoAction)];
        [imgvhongbao addGestureRecognizer:taphongbao];
        
        [self imgvhongbaoview:imgvhongbao];
        
        UILabel *lblhb = [[UILabel alloc] init];
        [lblhb setText:@"领红包"];
        [lblhb setTextColor:[UIColor whiteColor]];
        [lblhb setTextAlignment:NSTextAlignmentCenter];
        [lblhb setFont:[UIFont systemFontOfSize:10]];
        [imgvhongbao addSubview:lblhb];
        [lblhb mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.equalTo(imgvhongbao);
            make.height.offset(15);
            make.bottom.equalTo(imgvhongbao.mas_bottom).offset(-5);
        }];
        
    }
    
    
    
    
    //    [NSTimer scheduledTimerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
    //
    //    }];
    //
    //    [UIView animateWithDuration:2 delay:2 options:UIViewAnimationOptionCurveEaseIn animations:^{
    //        CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];    //设置抖动幅度
    //        shake.fromValue = [NSNumber numberWithFloat:+0.1];
    //        shake.toValue = [NSNumber numberWithFloat:-0.1];
    //        shake.duration = 0.1;
    //        shake.autoreverses = YES; //是否重复
    //        shake.repeatCount = 4;
    //        [imgvhongbao.layer addAnimation:shake forKey:@"imageView"];
    //        imgvhongbao.alpha = 1.0;
    //    } completion:^(BOOL finished) {
    //
    //    }];
    
    
    if(_subjuectViewModel.wishBtn.intValue == 1)
    {
        ///求开团
        UIButton *btkt = [[UIButton alloc] init];
        [self addSubview:btkt];
        [btkt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(35);
            make.width.offset(90);
            make.bottom.equalTo(self.mas_bottom).offset(-110);
            make.right.equalTo(self.mas_right).offset(5);
            
        }];
        [btkt setImage:[UIImage imageNamed:@"productinfo_qiukaituan"] forState:UIControlStateNormal];
        [btkt setTitle:@"求 开 团" forState:UIControlStateNormal];
        [btkt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btkt.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [btkt setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
        [btkt setBackgroundColor:RadMenuColor];
        [btkt.layer setMasksToBounds:YES];
        [btkt.layer setCornerRadius:4];
        [btkt addTarget:self action:@selector(kaituanAction) forControlEvents:UIControlEventTouchUpInside];
    }
    /*
     ///处理是否显示求开团
     if(_subjuectViewModel.linkType.integerValue == 1 && _subjuectViewModel.site_can_order.integerValue == 1)
     {
     if(modelValue != nil)
     {
     if([modelValue.status intValue] == 1 && [modelValue.isend intValue] == 1)
     {
     ///求开团
     UIButton *btkt = [[UIButton alloc] init];
     [self addSubview:btkt];
     [btkt mas_makeConstraints:^(MASConstraintMaker *make) {
     make.height.offset(35);
     make.width.offset(90);
     make.bottom.equalTo(self.mas_bottom).offset(-110);
     make.right.equalTo(self.mas_right).offset(5);
     
     }];
     [btkt setImage:[UIImage imageNamed:@"productinfo_qiukaituan"] forState:UIControlStateNormal];
     [btkt setTitle:@"求 开 团" forState:UIControlStateNormal];
     [btkt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [btkt.titleLabel setFont:[UIFont systemFontOfSize:13]];
     [btkt setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
     [btkt setBackgroundColor:RadMenuColor];
     [btkt.layer setMasksToBounds:YES];
     [btkt.layer setCornerRadius:4];
     [btkt addTarget:self action:@selector(kaituanAction) forControlEvents:UIControlEventTouchUpInside];
     
     }
     
     
     }
     else
     {
     ///求开团
     UIButton *btkt = [[UIButton alloc] init];
     [self addSubview:btkt];
     [btkt mas_makeConstraints:^(MASConstraintMaker *make) {
     make.height.offset(35);
     make.width.offset(90);
     make.bottom.equalTo(self.mas_bottom).offset(-110);
     make.right.equalTo(self.mas_right).offset(5);
     
     }];
     [btkt setImage:[UIImage imageNamed:@"productinfo_qiukaituan"] forState:UIControlStateNormal];
     [btkt setTitle:@"求 开 团" forState:UIControlStateNormal];
     [btkt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [btkt.titleLabel setFont:[UIFont systemFontOfSize:13]];
     [btkt setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
     [btkt setBackgroundColor:RadMenuColor];
     [btkt.layer setMasksToBounds:YES];
     [btkt.layer setCornerRadius:4];
     [btkt addTarget:self action:@selector(kaituanAction) forControlEvents:UIControlEventTouchUpInside];
     }
     
     }
     */
    if(modelValue == nil)
    {
        return;
    }
    
    ///1代购 2拼单
    int itype = modelValue.daigoutype.intValue;
    if(itype !=1 && itype !=2)
    {
        return;
    }
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _daiGouTabView.width, 50)];
    [view setBackgroundColor:[UIColor clearColor]];
    
    //    UIView *viewrgbback = [[UIView alloc] initWithFrame:CGRectMake(5, 0, view.width-10, 50)];
    //    [viewrgbback setBackgroundColor:RGB(253,237,224)];
    //    [viewrgbback.layer setMasksToBounds:YES];
    //    [viewrgbback.layer setCornerRadius:4];
    //    [view addSubview:viewrgbback];
    
    UILabel *lbtype = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, 29, 17)];
    [lbtype.layer setBorderColor:RGB(230, 56, 47).CGColor];
    [lbtype.layer setBorderWidth:1];
    [lbtype.layer setMasksToBounds:YES];
    [lbtype.layer setCornerRadius:2];
    [lbtype setTextColor:RGB(230, 56, 47)];
    [lbtype setTextAlignment:NSTextAlignmentCenter];
    [lbtype setFont:[UIFont systemFontOfSize:11]];
    [view addSubview:lbtype];
    
    UILabel *lbtitle = [[UILabel alloc] initWithFrame:CGRectMake(lbtype.right+10, lbtype.top, view.width-lbtype.right-20, lbtype.height)];
    [lbtitle setTextColor:RGB(10, 10, 10)];
    [lbtitle setTextAlignment:NSTextAlignmentLeft];
    [lbtitle setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:lbtitle];
    
    float fleft = 10.0;
    if(itype == 1)
    {
        
        for(int i= 0; i < modelValue.purchased_nums.intValue; i++)
        {
            if(i>=4)break;
            UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(12+24*i, lbtype.bottom+10, 22, 22)];
            [imgv.layer setMasksToBounds:YES];
            [imgv.layer setCornerRadius:imgv.height/2.0];
            if(modelValue.zhixia.count>0)
            {
                if(i<=modelValue.zhixia.count-1)
                {
                    [[MDB_UserDefault defaultInstance] setViewWithImage:imgv url:modelValue.zhixia[i]];
                }
                else
                {
                    [imgv setImage:[UIImage imageNamed:@"noavatar.png"]];
                }
            }
            else
            {
                [imgv setImage:[UIImage imageNamed:@"noavatar.png"]];
            }
            
            [view addSubview:imgv];
            fleft = imgv.right+10;
            
        }
        
    }
    
    
    UILabel *lbcount = [[UILabel alloc] initWithFrame:CGRectMake(fleft, lbtype.bottom+10, 100, 22)];
    [lbcount setTextColor:RGB(153, 153, 153)];
    [lbcount setTextAlignment:NSTextAlignmentLeft];
    [lbcount setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:lbcount];
    
    UIButton *btAction = [[UIButton alloc] initWithFrame:CGRectMake(0, lbtype.bottom+10, 93, 27)];
    [btAction.layer setMasksToBounds:YES];
    [btAction.layer setCornerRadius:2];
    [btAction setBackgroundColor:RGB(254, 122, 14)];
    [btAction setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btAction.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:btAction];
    [btAction addTarget:self action:@selector(daiGouAction:) forControlEvents:UIControlEventTouchUpInside];
    [btAction setUserInteractionEnabled:YES];
    
    
    //    NSString *strprice = [NSString stringWithFormat:@"%.2lf",modelValue.price.floatValue+modelValue.tariff.floatValue+modelValue.transfermoney.floatValue+modelValue.hpostage.floatValue+modelValue.directmailmoney.floatValue];
    ///
    if(itype == 1)
    {
        
        [lbtype setText:@"代购"];
        [lbtitle setText:@"此商品可代购，立即下单坐等收货"];
        if([modelValue.purchased_nums intValue] > 0)
        {
            [lbcount setAttributedText:[self arrstring:[NSString stringWithFormat:@"已下单%@件",modelValue.purchased_nums] andstart:3 andend:(int)modelValue.purchased_nums.length andfont:12 andcolor:RGB(230, 56, 47)]];
        }
        else
        {
            [lbcount setText:@"快去抢第一单吧"];
        }
        
        
        //        [btAction setTitle:[NSString stringWithFormat:@"￥%@下单",strprice] forState:UIControlStateNormal];
        [btAction setTitle:[NSString stringWithFormat:@"帮我买"] forState:UIControlStateNormal];
        [btAction sizeToFit];
        [btAction setHeight:27];
        [btAction setWidth:btAction.width+25];
        [btAction setTag:1];
        
        [self drawDaiGouFooter];
        
        [_daiGouTabView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(90);
        }];
        
    }
    else if(itype == 2)
    {
        [lbtype setText:@"拼单"];
        [lbtitle setText:@"此商品正在拼单，拼单更便宜"];
        
        if([modelValue.purchased_nums intValue]>0)
        {
            [lbcount setText:[NSString stringWithFormat:@"已拼单%@件",modelValue.purchased_nums]];
        }
        else
        {
            [lbcount setText:[NSString stringWithFormat:@"开团赢¥5.00奖励金哦"]];////开团赢¥5.00奖励金哦 还没有人发起拼单哦
        }
        
        [lbcount sizeToFit];
        [lbcount setHeight:22];
        
        //        [btAction setTitle:[NSString stringWithFormat:@"￥%@发起拼单",strprice] forState:UIControlStateNormal];
        [btAction setTitle:[NSString stringWithFormat:@"帮我买"] forState:UIControlStateNormal];
        [btAction sizeToFit];
        [btAction setHeight:27];
        [btAction setWidth:btAction.width+25];
        [btAction setTag:2];
        
        
        UILabel *lbnumber = [[UILabel alloc] initWithFrame:CGRectMake(lbcount.right+10, lbcount.top, 70, lbcount.height)];
        [lbnumber setTextColor:RGB(230, 56, 47)];
        [lbnumber setTextAlignment:NSTextAlignmentLeft];
        [lbnumber setFont:[UIFont systemFontOfSize:12]];
        [lbnumber setText:[NSString stringWithFormat:@"%@件/团",modelValue.pindannum]];
        [view addSubview:lbnumber];
        [self drawDaiGouFooter];
        
        _arrDaiGouData = modelValue.pindan;
        _daigoumodel = modelValue;
        
    }
    else
    {
        [_daiGouTabView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
        return;
    }
    
    if(modelValue.isspotgoods.integerValue == 1)
    {
        [lbtype setText:@"现货"];
        [btAction setTitle:[NSString stringWithFormat:@"我要买"] forState:UIControlStateNormal];
        [lbtitle setText:@"海淘现货不用等，下单当天即发国内快递"];
        
    }
    
    if([modelValue.status intValue] == 0 ||  [modelValue.isend intValue] == 1)
    {
        [btAction setUserInteractionEnabled:NO];
        [btAction setBackgroundColor:[UIColor grayColor]];
        [btAction setTitle:[NSString stringWithFormat:@"已截单"] forState:UIControlStateNormal];
    }
    
    [btAction setRight:view.width-10];
    [view setHeight:btAction.bottom+12];
    //    [viewrgbback setHeight:view.height];
    [_viewpggline setBackgroundColor:[UIColor whiteColor]];
    
    [_daiGouTabView setTableHeaderView:view];
    
    [_daiGouTabView mas_updateConstraints:^(MASConstraintMaker *make) {
        if(itype == 1)
        {
            make.height.offset(view.height+12);
        }
        else
        {
            make.height.offset(view.height+12);///+52*_arrDaiGouData.count
        }
    }];
    
    [_daiGouTabView reloadData];
    
}

#pragma mark - 代购footer
-(void)drawDaiGouFooter
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _daiGouTabView.width, 12)];
    [view setBackgroundColor:[UIColor clearColor]];
    
    [_daiGouTabView setTableFooterView:view];
}

///设置一行显示不同字体 颜色
-(NSMutableAttributedString *)arrstring:(NSString *)str andstart:(int)istart andend:(int)length andfont:(float)ff andcolor:(UIColor *)color
{
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc]initWithString:str];
    @try {
        [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:ff] range:NSMakeRange(istart, length)];
        
        [noteStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(istart, length)];
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    
    return noteStr;
}

#pragma mark - 求开团
-(void)kaituanAction
{
    if ([MDB_UserDefault getIsLogin] == NO)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请登录后再试"
                                                           delegate:self
                                                  cancelButtonTitle:Nil
                                                  otherButtonTitles:@"登录",@"取消", nil];
        [alertView setTag:111];
        [alertView show];
        return;
    }
    ///查看是否有同款代购商品
    [self.delegate qiukaituanItemsPushAction];
    
}
///求开团获取同款商品
-(void)qiukaituanItemsPushAction:(NSArray *)arrmessage
{
    int itype = 0;
    if(arrmessage.count>0)
    {
        itype = 1;
    }
    ProductInfoQiuKaiTuanView *pview = [[ProductInfoQiuKaiTuanView alloc] initWithFrame:CGRectMake(0, 0, BOUNDS_WIDTH, self.height) andtype:itype];
    [pview setDelegate:self];
    [self addSubview:pview];
    if(arrmessage.count>0)
    {
        [pview drawTkItems:[[NSMutableArray alloc] initWithArray:arrmessage]];
    }
    
    
}
-(void)qiukaituanAction:(NSString *)strmessage
{
    [self.delegate qiukaituanPushAction:strmessage];
}

-(void)yamaxunmianyouBtnEvents
{
    //_subjuectViewModel.free_freight_url
    
    [self.delegate mianyoujiaochengPushAction:_subjuectViewModel.free_freight_url];
    
}

#pragma mark - 代购或发起拼单点击
-(void)daiGouAction:(UIButton *)sender
{
    
    if ([MDB_UserDefault getIsLogin] == NO)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请登录后再试"
                                                           delegate:self
                                                  cancelButtonTitle:Nil
                                                  otherButtonTitles:@"登录",@"取消", nil];
        [alertView setTag:111];
        [alertView show];
        return;
    }
    
    if(_subjuectViewModel.daigouModel.isspiderorder.integerValue == 1)
    {
        ///有规格
        NSMutableDictionary *dicinfo = [NSMutableDictionary new];
        [dicinfo setObject:_subjuectViewModel.daigouModel.goods_id forKey:@"id"];
        [dicinfo setObject:_subjuectViewModel.commodityImageLink forKey:@"image"];
        [dicinfo setObject:_subjuectViewModel.commodityName forKey:@"title"];
        
        SelectColorAndSizeView *svc = [[SelectColorAndSizeView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, kMainScreenH) andvalue:dicinfo andtype:1];
        [svc setDelegate:self];
        [self.window addSubview:svc];
        [svc showView];
        _idaigoutype = (int)sender.tag;
        _ggView = svc;
    }
    else
    {
        [MobClick event:@"dgxiangqingxiadan" label:@"代购详情一键下单"];
        [self.delegate bindPinDanOrder:_idaigoutype andgoodsid:_subjuectViewModel.daigouModel.goods_id andgeid:@"" andnum:@"1"];
    }
    
//    [self.delegate bindPinDanOrder:(int)sender.tag andgoodsid:_subjuectViewModel.daigouModel.goods_id];
    
    
    
    
    
    //    if(sender.tag == 1)
    //    {///代购
    //
    //
    //
    //        ////需要判断是否还有代购数量
    //        DaiGouXiaDanViewController *dvc = [[DaiGouXiaDanViewController alloc] init];
    //        dvc.strid = _subjuectViewModel.daigouModel.goods_id;/////
    //        dvc.itype = 1;
    //        [self.viewController.navigationController pushViewController:dvc animated:YES];
    //    }
    //    else
    //    {///拼单
    //
    //        ////需要判断是否还能发起拼单
    //        DaiGouXiaDanViewController *dvc = [[DaiGouXiaDanViewController alloc] init];
    //        dvc.strid = _subjuectViewModel.daigouModel.goods_id;/////
    //        dvc.itype = 2;
    //        [self.viewController.navigationController pushViewController:dvc animated:YES];
    //
    //    }
    
}

#pragma mark - 相关晒单点击
-(void)glycAction:(UIGestureRecognizer *)gesture
{
    
    ///跳转原创详情页面
    
    
}

#pragma mark - SelectColorAndSizeViewDelegate
///购买商品
-(void)buyGoods:(NSString *)strid andnum:(NSString *)strnum
{
    [MobClick event:@"dgxiangqingxiadan" label:@"代购详情一键下单"];
    [self.delegate bindPinDanOrder:_idaigoutype andgoodsid:_subjuectViewModel.daigouModel.goods_id andgeid:strid andnum:strnum];
    [_ggView dismisAction];
}
///添加购物车
-(void)addGouWuChe:(NSString *)strid andnum:(NSString *)strnum
{
    [MobClick event:@"dgxiangqingjiagouwuche" label:@"代购详情加购物车"];
    
    [self.delegate bindPinDanAddCar:_idaigoutype andgoodsid:_subjuectViewModel.daigouModel.goods_id andgeid:strid andnum:strnum];
    [_ggView dismisAction];
}

- (void)setupPrivilegeInfoView{
    _privilegeContainerView = [UIView new];
    [_contentContairView addSubview:_privilegeContainerView];
    [_privilegeContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_daiGouTabView.mas_bottom);
        make.left.right.equalTo(_contentContairView);
        make.height.offset(0);
    }];
    _privilegeContainerView.backgroundColor = [UIColor whiteColor];
    
    _privilegeTitleLabel = [UILabel new];
    [_privilegeContainerView addSubview:_privilegeTitleLabel];
    [_privilegeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_privilegeContainerView.mas_left).offset(15);
        make.top.equalTo(_privilegeContainerView.mas_top).offset(2);
    }];
    _privilegeTitleLabel.font = [UIFont systemFontOfSize:12.f];
    _privilegeTitleLabel.textColor = [UIColor colorWithRed:0.6198 green:0.6198 blue:0.6198 alpha:1.0];
    
    _privilegeTypeLabel = [CustomLabel new];
    [_privilegeContainerView addSubview:_privilegeTypeLabel];
    [_privilegeTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_privilegeTitleLabel.mas_right).offset(2);
        make.centerY.equalTo(_privilegeTitleLabel.mas_centerY);
    }];
    _privilegeTypeLabel.textAlignment = NSTextAlignmentCenter;
    _privilegeTypeLabel.textColor = [UIColor colorWithHexString:@"#fd6e00"];
    _privilegeTypeLabel.edgeInsets = UIEdgeInsetsMake(1, 6, 1, 6);
    _privilegeTypeLabel.font = [UIFont systemFontOfSize:12];
    _privilegeTypeLabel.layer.masksToBounds = YES;
    _privilegeTypeLabel.layer.cornerRadius = 3.f;
    _privilegeTypeLabel.layer.borderWidth = 1.f;
    _privilegeTypeLabel.layer.borderColor = _privilegeTypeLabel.textColor.CGColor;
    _privilegeTypeLabel.hidden = YES;
    
    _privilegeDescribeLabel = [UILabel new];
    [_privilegeContainerView addSubview:_privilegeDescribeLabel];
    [_privilegeDescribeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_privilegeTypeLabel.mas_right).offset(5);
        make.right.equalTo(_privilegeContainerView.mas_right).offset(-5);
        make.top.equalTo(_privilegeTitleLabel.mas_top);
    }];
    _privilegeDescribeLabel.font = [UIFont systemFontOfSize:12.f];
    _privilegeDescribeLabel.textColor = [UIColor colorWithRed:0.6198 green:0.6198 blue:0.6198 alpha:1.0];
    [_privilegeDescribeLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    
    //    [self setupTransportInfoView];
    [self setupBannerView];
    [_contentContairView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_privilegeContainerView.mas_bottom);
    }];
    
}

- (void)setupTransportInfoView{
    _transportInfoView = ({
        UIView *view = [UIView new];
        [_contentContairView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_privilegeContainerView.mas_bottom);
            make.left.right.equalTo(_contentContairView);
        }];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    
    _commoditySupplyAreaLabel = ({
        UILabel *label = [UILabel new];
        [_transportInfoView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_transportInfoView.mas_left).offset(15);
            make.right.equalTo(_transportInfoView.mas_right).offset(-10);
            make.top.equalTo(_transportInfoView.mas_top);
        }];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithRed:0.6198 green:0.6198 blue:0.6198 alpha:1.0];
        label;
    });
    
    _postageLabel = ({
        UILabel *label = [UILabel new];
        [_transportInfoView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(_commoditySupplyAreaLabel);
            make.top.equalTo(_commoditySupplyAreaLabel.mas_bottom).offset(3);
        }];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithRed:0.6198 green:0.6198 blue:0.6198 alpha:1.0];
        label;
    });
    
    [_transportInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_postageLabel.mas_bottom);
    }];
    [_contentContairView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_transportInfoView.mas_bottom).offset(4);
    }];
    
}

- (void)setupBannerView{
    
    //    UIView *lineView =({
    //        UIView *view = [UIView new];
    //        [_contairView addSubview:view];
    //        [view mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.top.equalTo(_contentContairView.mas_bottom).offset(3);
    //            make.left.right.equalTo(_contairView);
    //            make.height.offset(1);
    //        }];
    //        view.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    //        view;
    //    });
    
    _image_bannnerView = [[UIImageView alloc] init];
    [_contairView addSubview:_image_bannnerView];
    [_image_bannnerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_contairView);
        //        make.top.equalTo(_contentContairView.mas_bottom).offset(3);
        make.top.equalTo(_privilegeContainerView.mas_bottom);
        make.height.offset(0);
    }];
    _image_bannnerView.userInteractionEnabled = YES;
    [_image_bannnerView setImage:[UIImage imageNamed:@"banner_task"]];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToBannerViewEvent:)];
    [_image_bannnerView addGestureRecognizer:tapGesture];
    
    [self setupCommodityDetailsView];
}

- (void)setupCommodityDetailsView{
    
    _detailWebView = ({
        MDBwebVIew *webview = [[MDBwebVIew alloc] init];
        [_contairView addSubview:webview];
        [webview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_image_bannnerView.mas_bottom).offset(2);
            make.left.equalTo(_contairView.mas_left).offset(5);
            make.right.equalTo(_contairView.mas_right).offset(-5);
            make.height.offset(150);
        }];
        webview.delegate = self;
        [webview setBackgroundColor:[UIColor whiteColor]];
        webview;
    });
    
    ///这里添加价格走势
    
    [self drawjiagezoushi];
    
    ///相关晒单
    [self drawSaiDan];
    
    
    ///、、、、
    ///在这里添加关联阅读
    
    [self drawGuanLianYuedu];
    
    
    /////相关标签
    _flagView = [NJFlagView new];
    [_contairView addSubview:_flagView];
    [_flagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_viewGuanLianYueDu.mas_bottom).offset(10);
        make.left.right.equalTo(_contairView);
    }];
    _flagView.delegate = self;
    __weak typeof (self) weakSelf = self;
    _flagView.callback = ^(CGFloat height) {
        [weakSelf.flagView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(height);
        }];
        [weakSelf updateTableHeaderView];
    };
    
    ///举报
    _viewjubao = [[UIView alloc] init];
    [_contairView addSubview:_viewjubao];
    [_viewjubao mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_contairView);
        make.top.equalTo(_flagView.mas_bottom);
        make.height.offset(0);
    }];
    [_viewjubao setBackgroundColor:RGB(250, 250, 250)];
    
    
    [self setupUserInfoWithHandleSubviews];
}

-(void)drawjubaoview
{
    UILabel *lbjbtext = [[UILabel alloc] init];
    [_viewjubao addSubview:lbjbtext];
    [lbjbtext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.height.offset(50*kScale);
        make.left.offset((BOUNDS_WIDTH-210)/2.0);
        make.width.offset(130);
    }];
    [lbjbtext setText:@"价格已上涨或过期？"];
    [lbjbtext setTextColor:RGB(161, 161, 161)];
    [lbjbtext setTextAlignment:NSTextAlignmentRight];
    [lbjbtext setFont:[UIFont systemFontOfSize:14]];
    
    
    UIImageView *imgvjb = [[UIImageView alloc] init];
    [_viewjubao addSubview:imgvjb];
    [imgvjb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbjbtext.mas_right);
        make.width.height.offset(15);
        make.centerY.equalTo(_viewjubao);
    }];
    [imgvjb setImage:[UIImage imageNamed:@"jubao_gantanhao"]];
    
    UIButton *btjb = [[UIButton alloc] init];
    [_viewjubao addSubview:btjb];
    [btjb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(imgvjb.mas_right);
        make.height.offset(20);
        make.width.offset(70);
        make.centerY.equalTo(_viewjubao);
        
    }];
    [btjb setTitle:@"立即举报" forState:UIControlStateNormal];
    [btjb setTitleColor:RadMenuColor forState:UIControlStateNormal];
    [btjb.titleLabel setFont:[UIFont systemFontOfSize:14]];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"立即举报"
                                                                                attributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)}];
    btjb.titleLabel.attributedText = attrStr;
    [btjb addTarget:self action:@selector(jubaoAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}



#pragma mark - ////关联阅读
-(void)drawGuanLianYuedu
{
    _viewGuanLianYueDu = [[UIView alloc] init];
    //    [_viewGuanLianYueDu setClipsToBounds:YES];
    [_contairView addSubview:_viewGuanLianYueDu];
    
    [_viewGuanLianYueDu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_viewSaiDan.mas_bottom).offset(1);
        make.left.right.equalTo(_contairView);
        make.height.offset(0);
    }];
}

#pragma mark - 价格走势
-(void)drawjiagezoushi
{
    _lbjiagezs = [[UILabel alloc] init];
    [_lbjiagezs setTextAlignment:NSTextAlignmentLeft];
    [_lbjiagezs setTextColor:RGB(80, 80, 80)];
    [_lbjiagezs setText:@"价格走势"];
    [_lbjiagezs setFont:[UIFont systemFontOfSize:13]];
    [_contairView addSubview:_lbjiagezs];
    [_lbjiagezs mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_detailWebView.mas_bottom).offset(1);
        make.left.equalTo(_contairView).offset(10);
        make.height.offset(20);
    }];
    [_lbjiagezs setHidden:YES];
    
    _viewjiagezs = [[ZheXianTuView alloc] initWithFrame:CGRectMake(10, _lbjiagezs.bottom, kMainScreenW-20, 200)];
    [_contairView addSubview:_viewjiagezs];
    [_viewjiagezs mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lbjiagezs.mas_bottom);
        make.left.right.equalTo(_contairView);
        make.height.offset(1);
    }];
}

#pragma mark - 相关晒单
-(void)drawSaiDan
{
    float ftempheight = 155;
    ftempheight = 250;
    _viewSaiDan = [[UIView alloc] init];
    [_contairView addSubview:_viewSaiDan];
    [_viewSaiDan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_viewjiagezs.mas_bottom).offset(1);
        make.left.right.equalTo(_contairView);
//        make.height.offset(150*kScale);
        make.height.offset(0);
    }];
    ///隐藏
    [_viewSaiDan setHidden:YES];
    [_viewSaiDan mas_makeConstraints:^(MASConstraintMaker *make) {

        make.height.offset(0);
    }];
    
    
}

#pragma mark - 相关晒单数据x展示
-(void)drawSaiDanItemsView
{
    float ftempheight = 155;
    ftempheight = 250;
    for(UIView *view in _viewSaiDan.subviews)
    {
        [view removeFromSuperview];
    }
    [_viewSaiDan setHidden:NO];
    [_viewSaiDan mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.offset(ftempheight);
    }];
    
    UIView *viewline0 = [[UIView alloc] init];
    [_viewSaiDan addSubview:viewline0];
    [viewline0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.right.equalTo(_viewSaiDan);
        make.height.offset(1);
    }];
    [viewline0 setBackgroundColor:RGB(232, 232, 232)];
    
    
    
    UILabel *lbtitle = [[UILabel alloc] init];
    [_viewSaiDan addSubview:lbtitle];
    [lbtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.left.offset(15);
        make.height.offset(15);
    }];
    [lbtitle setText:@"相关晒单"];
    [lbtitle setTextColor:RGB(153,153,153)];
    [lbtitle setTextAlignment:NSTextAlignmentLeft];
    [lbtitle setFont:[UIFont systemFontOfSize:12]];
    
    
    UIScrollView *scvsaidan = [[UIScrollView alloc] init];
    [scvsaidan setShowsVerticalScrollIndicator:NO];
    [scvsaidan setShowsHorizontalScrollIndicator:NO];
    [_viewSaiDan addSubview:scvsaidan];
    [scvsaidan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbtitle.mas_bottom).offset(15);
        make.left.right.equalTo(_viewSaiDan);
        make.height.offset(ftempheight-60);
    }];
    
    //////
    //    UIView *viewitemOne = [[UIView alloc] init];
    //    [scvsaidan addSubview:viewitemOne];
    //    [viewitemOne mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.offset(15);
    //        make.top.equalTo(scvsaidan);
    //        make.bottom.equalTo(_viewSaiDan.mas_bottom).offset(-15);
    //        make.right.equalTo(_viewSaiDan.mas_right).offset(-15);
    //    }];
    //    [self drawsaidanItemOne:viewitemOne];
    //    [viewitemOne setUserInteractionEnabled:YES];
    //    [viewitemOne setTag:0];
    //    UITapGestureRecognizer *tapyc = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(glycAction:)];
    //    [viewitemOne addGestureRecognizer:tapyc];
    /////
    UIView *viewtemp = nil;
    for(int i = 0; i < 4; i++)
    {
        UIView *viewitems = [[UIView alloc] init];
        [scvsaidan addSubview:viewitems];
        [viewitems mas_makeConstraints:^(MASConstraintMaker *make) {
            if(viewtemp != nil)
            {
                make.left.equalTo(viewtemp.mas_right).offset(25);
            }
            else
            {
                make.left.offset(15);
            }
            make.top.equalTo(scvsaidan);
            make.bottom.equalTo(_viewSaiDan.mas_bottom).offset(-15);
            make.width.equalTo(scvsaidan.mas_height).multipliedBy(0.9);
        }];
        viewtemp = viewitems;
        [self drawsaidanItems:viewitems];
        [viewitems setUserInteractionEnabled:YES];
        [viewitems setTag:i];
        UITapGestureRecognizer *tapyc = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(glycAction:)];
        [viewitems addGestureRecognizer:tapyc];
        
    }
    
    [scvsaidan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewtemp).offset(15);
    }];
    
    
    
    
    UIView *viewline = [[UIView alloc] init];
    [_viewSaiDan addSubview:viewline];
    [viewline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_viewSaiDan.mas_bottom).offset(-1);
        make.left.right.equalTo(_viewSaiDan);
        make.height.offset(1);
    }];
    [viewline setBackgroundColor:RGB(232, 232, 232)];
}

///晒单只有一个的时候的样式
-(void)drawsaidanItemOne:(UIView *)view
{
    UIImageView *imgv = [[UIImageView alloc] init];
    [imgv setContentMode:UIViewContentModeScaleAspectFill];
    [view addSubview:imgv];
    [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(view);
        make.width.equalTo(view.mas_height).multipliedBy(1.3);
    }];
    [imgv setBackgroundColor:[UIColor grayColor]];
    [imgv.layer setMasksToBounds:YES];
    [imgv.layer setCornerRadius:3];
    
    UILabel *lbtitle = [[UILabel alloc] init];
    [lbtitle setTextColor:RGB(150, 150, 150)];
    [lbtitle setTextAlignment:NSTextAlignmentLeft];
    [lbtitle setNumberOfLines:2];
    [lbtitle setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbtitle];
    [lbtitle mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(imgv.mas_right).offset(10);
        make.top.equalTo(imgv);
        make.right.equalTo(view);
        make.height.offset(40);
    }];
    [lbtitle setText:@"标题大健康打飞机啊克里斯多夫拉伸的看法按理说法阿斯兰的"];
    
    
    UILabel *lbbiaoqian = [[UILabel alloc] init];
    [lbbiaoqian setTextColor:RGB(150, 150, 150)];
    [lbbiaoqian setTextAlignment:NSTextAlignmentCenter];
    [lbbiaoqian setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:lbbiaoqian];
    [lbbiaoqian.layer setMasksToBounds:YES];
    [lbbiaoqian.layer setCornerRadius:2];
    [lbbiaoqian.layer setBorderColor:RGB(200, 200, 200).CGColor];
    [lbbiaoqian.layer setBorderWidth:1];
    [lbbiaoqian setText:@"服饰鞋包"];
    float fw = [MDB_UserDefault countTextSize:CGSizeMake(200, 20) andtextfont:lbbiaoqian.font andtext:lbbiaoqian.text].width+20;
    [lbbiaoqian mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(imgv.mas_right).offset(10);
        make.bottom.equalTo(imgv);
        make.height.offset(20);
        make.width.offset(fw);
    }];
    
}

///晒单有多个的时候的样式
-(void)drawsaidanItems:(UIView *)view
{
    UIImageView *imgv = [[UIImageView alloc] init];
    [imgv setContentMode:UIViewContentModeScaleAspectFill];
    [view addSubview:imgv];
    [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(view);
        make.height.equalTo(view).offset(-85);
        
    }];
    [imgv setBackgroundColor:[UIColor grayColor]];
    [imgv.layer setMasksToBounds:YES];
    [imgv.layer setCornerRadius:3];
    
    
    UILabel *lbtitle = [[UILabel alloc] init];
    [lbtitle setTextColor:RGB(150, 150, 150)];
    [lbtitle setTextAlignment:NSTextAlignmentLeft];
    [lbtitle setNumberOfLines:2];
    [lbtitle setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:lbtitle];
    [lbtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(view);
        make.top.equalTo(imgv.mas_bottom).offset(10);
        make.height.offset(30);
    }];
    [lbtitle setText:@"标题大健康打飞机啊克里斯多夫拉伸的看法按理说法阿斯兰的"];
    
    UILabel *lbbiaoqian = [[UILabel alloc] init];
    [lbbiaoqian setTextColor:RGB(150, 150, 150)];
    [lbbiaoqian setTextAlignment:NSTextAlignmentCenter];
    [lbbiaoqian setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:lbbiaoqian];
    [lbbiaoqian.layer setMasksToBounds:YES];
    [lbbiaoqian.layer setCornerRadius:2];
    [lbbiaoqian.layer setBorderColor:RGB(200, 200, 200).CGColor];
    [lbbiaoqian.layer setBorderWidth:1];
    [lbbiaoqian setText:@"服饰鞋包"];
    float fw = [MDB_UserDefault countTextSize:CGSizeMake(200, 20) andtextfont:lbbiaoqian.font andtext:lbbiaoqian.text].width+20;
    [lbbiaoqian mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(imgv);
        make.top.equalTo(lbtitle.mas_bottom).offset(10);
        make.height.offset(20);
        make.width.offset(fw);
    }];
    
}



-(void)guanLianYueDuSetData:(NSMutableArray *)arrvalue
{
    if(arrvalue.count<1)return;
    
    UIView *viewline0 = [[UIView alloc] init];
    [_viewGuanLianYueDu addSubview:viewline0];
    [viewline0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.right.equalTo(_viewGuanLianYueDu);
        make.height.offset(1);
    }];
    [viewline0 setBackgroundColor:RGB(232, 232, 232)];
    
    if(_viewSaiDan.hidden==NO)
    {
        [viewline0 setHidden:YES];
    }
    
    UILabel *lbtitle = [[UILabel alloc] init];
    [_viewGuanLianYueDu addSubview:lbtitle];
    [lbtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.left.offset(15);
        make.height.offset(15);
    }];
    [lbtitle setText:@"关联阅读"];
    [lbtitle setTextColor:RGB(153,153,153)];
    [lbtitle setTextAlignment:NSTextAlignmentLeft];
    [lbtitle setFont:[UIFont systemFontOfSize:12]];
    
    UIButton *btlast;
    for(int i = 0 ; i < arrvalue.count; i++)
    {
        
        UIButton *btitem = [[UIButton alloc] init];
        [_viewGuanLianYueDu addSubview:btitem];
        [btitem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lbtitle.mas_bottom).offset(30*i);
            make.left.offset(20);
            make.height.offset(30);
            make.right.equalTo(_viewGuanLianYueDu).offset(-20);
        }];
        ProductInfoSubjectsGuanLianYueDuViewModel *model = arrvalue[i];
        [btitem setImage:[UIImage imageNamed:@"guanlianyuedu_item"] forState:UIControlStateNormal];
        [btitem setTitle:model.title forState:UIControlStateNormal];
        [btitem setTitleColor:RGB(102,102,102) forState:UIControlStateNormal];
        [btitem.titleLabel setFont:[UIFont systemFontOfSize:12]];
        btitem.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
        btitem.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [btitem setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
        [btitem setTag:i];
        [btitem addTarget:self action:@selector(guanlianyueduItemAction:) forControlEvents:UIControlEventTouchUpInside];
        btitem.titleLabel.lineBreakMode =  NSLineBreakByTruncatingTail;
        btlast = btitem;
    }
    
    
    UIView *viewline = [[UIView alloc] init];
    [_viewGuanLianYueDu addSubview:viewline];
    [viewline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btlast.mas_bottom).offset(15);
        make.left.right.equalTo(_viewGuanLianYueDu);
        make.height.offset(1);
    }];
    [viewline setBackgroundColor:RGB(232, 232, 232)];
    
    [_viewGuanLianYueDu mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(46+30*arrvalue.count);
    }];
    //    [_viewGuanLianYueDu mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.height.offset(46+30*arrvalue.count);
    //    }];
}

-(void)guanlianyueduItemAction:(UIButton *)sender
{
    ProductInfoSubjectsGuanLianYueDuViewModel *model = _subjuectViewModel.articles[sender.tag];
    
    
    GuanLianYuDuViewController *gvc = [[GuanLianYuDuViewController alloc] init];
    gvc.strurl = model.content;
    gvc.title = model.title;
    [self.viewController.navigationController pushViewController:gvc animated:YES];
    
}


- (void)setupUserInfoWithHandleSubviews{
    UIView *handleContainerView = [UIView new];
    [_contairView addSubview:handleContainerView];
    [handleContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_contairView);
        make.top.equalTo(_viewjubao.mas_bottom);
    }];
    handleContainerView.hidden = YES;
    _handleContainerView = handleContainerView;
    
    //    UIButton *purchasedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [handleContainerView addSubview:purchasedBtn];
    //    [purchasedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(handleContainerView.mas_top).offset(10);
    //        make.left.equalTo(handleContainerView.mas_left).offset(16);
    //        make.height.offset(45);
    //    }];
    //    purchasedBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    //    [purchasedBtn setTitle:@"已买" forState:UIControlStateNormal];
    //    [purchasedBtn setTitleColor:[UIColor colorWithHexString:@"#F35D00"] forState:UIControlStateNormal];
    //    purchasedBtn.layer.masksToBounds = YES;
    //    purchasedBtn.layer.cornerRadius = 4.f;
    //    purchasedBtn.layer.borderWidth = 1.f;
    //    purchasedBtn.layer.borderColor = [UIColor colorWithHexString:@"#FCAF78"].CGColor;
    //    [purchasedBtn addTarget:self action:@selector(respondsToPayBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    //    _purchasedBtn = purchasedBtn;
    //
    //    UIButton *wantBuyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [handleContainerView addSubview:wantBuyBtn];
    //    [wantBuyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(purchasedBtn.mas_top);
    //        make.left.equalTo(purchasedBtn.mas_right).offset(26);
    //        make.right.equalTo(handleContainerView.mas_right).offset(-16);
    //        make.size.equalTo(purchasedBtn);
    //    }];
    //    wantBuyBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    //    [wantBuyBtn setTitle:@"想买" forState:UIControlStateNormal];
    //    [wantBuyBtn setTitleColor:[UIColor colorWithHexString:@"#F35D00"] forState:UIControlStateNormal];
    //    wantBuyBtn.layer.masksToBounds = YES;
    //    wantBuyBtn.layer.cornerRadius = 4.f;
    //    wantBuyBtn.layer.borderWidth = 1.f;
    //    wantBuyBtn.layer.borderColor = [UIColor colorWithHexString:@"#FCAF78"].CGColor;
    //    [wantBuyBtn addTarget:self action:@selector(respondsToPayBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    //    _wantBuyBtn = wantBuyBtn;
    
    UIView *lineView = [UIView new];
    [handleContainerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(handleContainerView);
        make.height.offset(1);
        make.top.equalTo(handleContainerView.mas_top).offset(10);
    }];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    // user info view
    UIView *userInfoView = [UIView new];
    [handleContainerView addSubview:userInfoView];
    [userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(handleContainerView);
        make.top.equalTo(lineView.mas_bottom).offset(10);
        make.height.offset(75);
    }];
    _userInfoView = userInfoView;
    
    _iconImageView = ({
        UIImageView *imageView = [UIImageView new];
        [userInfoView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(userInfoView.mas_left).offset(16);
            make.top.equalTo(userInfoView.mas_top).offset(6);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 30.0/2;
        imageView.userInteractionEnabled = YES;
        imageView;
    });
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToAvaterView:)];
    [_iconImageView addGestureRecognizer:tapGesture];
    
    _nikNameLabel = ({
        UILabel *label = [UILabel new];
        [userInfoView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconImageView.mas_right).offset(9);
            make.centerY.equalTo(_iconImageView.mas_centerY);
        }];
        label.textColor = [UIColor colorWithHexString:@"#666666"];
        label.font = [UIFont systemFontOfSize:12];
        label;
    });
    
    UIImageView *livelBgImageView = [UIImageView new];
    [userInfoView addSubview:livelBgImageView];
    [livelBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nikNameLabel.mas_right).offset(5);
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
    
    _levelNickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [userInfoView addSubview:_levelNickButton];
    [_levelNickButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_livelBgImageView.mas_right).offset(4);
        make.centerY.equalTo(_livelBgImageView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(61, 18));
    }];
    _levelNickButton.userInteractionEnabled = NO;
    _levelNickButton.titleLabel.font = [UIFont systemFontOfSize:11.f];
    [_levelNickButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_levelNickButton setTitle:@"时尚达人" forState:UIControlStateNormal];
    [_levelNickButton setBackgroundImage:[UIImage imageNamed:@"open_url_btn_normal"] forState:UIControlStateNormal];
    [_levelNickButton setBackgroundImage:[UIImage imageNamed:@"open_url_btn_normal"] forState:UIControlStateHighlighted];
    _levelNickButton.hidden = YES;
    
    UIButton *fellowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [userInfoView addSubview:fellowBtn];
    [fellowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.greaterThanOrEqualTo(livelBgImageView.mas_right).offset(10);
        make.right.equalTo(userInfoView.mas_right).offset(-16);
        make.centerY.equalTo(_iconImageView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60, 25));
    }];
    fellowBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [fellowBtn setTitleColor:[UIColor colorWithHexString:@"#F27A30"] forState:UIControlStateNormal];
    [fellowBtn setTitle:@"+ 关注" forState:UIControlStateNormal];
    [fellowBtn addTarget:self action:@selector(respondsToFollowBtn:) forControlEvents:UIControlEventTouchUpInside];
    fellowBtn.hidden = YES;
    fellowBtn.layer.masksToBounds = YES;
    fellowBtn.layer.cornerRadius = 4.f;
    fellowBtn.layer.borderWidth = 1.f;
    fellowBtn.layer.borderColor = [UIColor colorWithHexString:@"#F27A30"].CGColor;
    _fellowBtn = fellowBtn;
    
    _userShareLabel = [UILabel new];
    [userInfoView addSubview:_userShareLabel];
    [_userShareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.mas_left);
        make.top.equalTo(_iconImageView.mas_bottom).offset(15);
    }];
    _userShareLabel.textColor = [UIColor colorWithHexString:@"#504F4E"];
    _userShareLabel.font = [UIFont systemFontOfSize:12.f];
    
    _discountPublishDateLabel = [UILabel new];
    [userInfoView addSubview:_discountPublishDateLabel];
    [_discountPublishDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(fellowBtn.mas_right);
        make.centerY.equalTo(_userShareLabel.mas_centerY);
    }];
    _discountPublishDateLabel.textColor = [UIColor colorWithHexString:@"#504F4E"];
    _discountPublishDateLabel.font = [UIFont systemFontOfSize:12.f];
    
    // 打赏
    UIView *rewardContainerView = [UIView new];
    [handleContainerView addSubview:rewardContainerView];
    [rewardContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(handleContainerView);
        make.top.equalTo(userInfoView.mas_bottom);
    }];
    rewardContainerView.backgroundColor = [UIColor colorWithHexString:@"#FBF4EF"];
    
    UILabel *rewardTitleLabel = [UILabel new];
    [rewardContainerView addSubview:rewardTitleLabel];
    [rewardTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rewardContainerView.mas_left).offset(16.f);
        make.top.equalTo(rewardContainerView.mas_top).offset(21);
    }];
    rewardTitleLabel.font = [UIFont systemFontOfSize:14.f];
    rewardTitleLabel.textColor = [UIColor colorWithHexString:@"#8A6449"];
    rewardTitleLabel.text = @"价格很便宜，打赏犒劳一下爆料人~";
    
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
                make.left.equalTo(lastImageView.mas_right).offset(-10);
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
    
    [rewardContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(rewardUserContainerView.mas_bottom).offset(7);
    }];
    [handleContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(rewardContainerView.mas_bottom);
    }];
    [_contairView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(handleContainerView.mas_bottom);
    }];
    [self updateTableHeaderView];
}


- (void)setExtraCellLineHidden:(UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma mark -///页面消失
-(void)backNavAction
{
    _isbackfinally = YES;
//    [_taxWebView finalyLoadWKWebView];
    [_detailWebView finalyLoadWKWebView];
}


#pragma mark - Layout subviews
- (void)bindDataWithViewModel:(ProductInfoSubjectsViewModel *)viewModel{
    if(_isbackfinally)return;
    
    
    _subjuectViewModel = viewModel;
    [self bindCommentData:_subjuectViewModel.comments];
    [self bindRelevanceData:_subjuectViewModel.relateShares];
    
    ///peng123
    [self drawdaigouHeader:_subjuectViewModel.daigouModel];
    
    [self guanLianYueDuSetData:_subjuectViewModel.articles];
    
    if(_subjuectViewModel.free_freight_url.length>6)
    {
        [_mianyoujiaochengButton setHidden:NO];
    }
    
    if(viewModel.historyPrice.count>0)
    {
        [_lbjiagezs mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_detailWebView.mas_bottom).offset(10);
        }];
        [_lbjiagezs setHidden:NO];
        [_viewjiagezs mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(200);
        }];
        [_viewjiagezs drawLineChartViewWithValues:viewModel.historyPrice];
    }
    
    ////
//    [self drawSaiDanItemsView];
    
    
    //    [self bindHotShowdanData:_subjuectViewModel.hotshowdans];
    [[MDB_UserDefault defaultInstance] setViewWithImage:_productImageView url:viewModel.commodityImageLink];
    
    _productNameLabel.text = viewModel.commodityName;
    CGRect productNameTextContentRect = [self calculateTextHeightWithText:_productNameLabel.text fontSize:21.f];
    [_productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (productNameTextContentRect.size.height>80) {
            make.height.offset(80);
        }else{
            make.height.offset(productNameTextContentRect.size.height);
        }
    }];
    _productPriceLabel.attributedText = viewModel.commodityPirce;
//    NSLog(@"+++++++%@",viewModel.commodityPirce);
    CGRect textContentRect = [self calculateTextHeightWithText:_productPriceLabel.text fontSize:22.f];
    [_productPriceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(textContentRect.size.height+10);
        if(textContentRect.size.width<kMainScreenW-100&&textContentRect.size.width>50)
        {
            make.width.offset(textContentRect.size.width+10);
        }
        else
        {
            make.width.offset(textContentRect.size.width+5);
        }
        
    }];
    
    //    [_productPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.height.offset(textContentRect.size.height);
    //        make.width.offset(textContentRect.size.width+10);
    //    }];
    
    _ProductSupplyLabel.text = viewModel.commoditySupply;///商城
    CGRect supplyTextContentRect = [self calculateTextHeightWithText:_ProductSupplyLabel.text fontSize:14.f];
    [_ProductSupplyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(supplyTextContentRect.size.height+2);
        make.width.offset(supplyTextContentRect.size.width+5);
    }];
    
    
    ///
    [_viewjubao mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(50*kScale);
    }];
    
    [self drawjubaoview];
    
    
    _personalInfoView.hidden = NO;
    _nikNameLabel.text = viewModel.nickname;
    _tabBarView.zanNumberStr = viewModel.commodityZan;
    _tabBarView.shouNumberStr = viewModel.commodityShou;
    _tabBarView.comNumberStr = viewModel.commodityCom;
    _tabBarView.isEnshrine = viewModel.isEnshrine;
    if (viewModel.isOpenActive) {
        [_image_bannnerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(50);
        }];
        [[MDB_UserDefault defaultInstance] setViewWithImage:_image_bannnerView url:viewModel.activeImageLink options:SDWebImageHighPriority];
    }
    [[MDB_UserDefault defaultInstance] setViewWithImage:_iconImageView url:viewModel.iconImageLink options:SDWebImageHighPriority];
    _detailWebView.webDescription = viewModel.webDescription;
//    _taxWebView.webDescription = viewModel.otherprice;
    if (![viewModel.privilegeType isEqualToString:@""]) {
        _privilegeTypeLabel.hidden = NO;
        _privilegeTitleLabel.text = @"优惠：";
        _privilegeTypeLabel.text = viewModel.privilegeType;
        _privilegeDescribeLabel.text = viewModel.prodescription;
        [_privilegeContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(19);
        }];
    }
    if (viewModel.viewType == DetailViewTypeOverseas) {
        
        _ProductOriginalPriceLabel.text = viewModel.commodityPrimeCost;
        
        @try
        {
            if(viewModel.commodityPrimeCost.length>0)
            {
                if(viewModel.commodityPrimeCost.length>1)
                {
                    NSString *strProductOriginalPrice = [viewModel.commodityPrimeCost substringFromIndex:1];
                    if([strProductOriginalPrice floatValue]<=0)
                    {
                        _ProductOriginalPriceLabel.text = @"";
                    }
                }
                else
                {
                    _ProductOriginalPriceLabel.text = @"";
                }
            }
        }
        @finally
        {
            
            
        }
        
        _burseDetailPriceLabel.text = viewModel.totalmoney_dec;
        _disburseDetailView.hidden = NO;
        
        if(_subjuectViewModel.articles.count>0)
        {
            _courseButton.hidden = NO;
        }
        
        if (!viewModel.isDirect && viewModel.commodityTransfer != nil) {
            _transitcompanyBtn.hidden = NO;
            CGSize size=[MDB_UserDefault getStrWightFont:[UIFont systemFontOfSize:14] str:viewModel.commodityTransfer hight:20];
            [_transitcompanyBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(size.width+30, 20));
            }];
            [_transitcompanyBtn setTitle:viewModel.commodityTransfer forState:UIControlStateNormal];
        }else{
            [_transitcompanyBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeZero);
            }];
        }
    }else{
        _commoditySupplyAreaLabel.text = viewModel.commoditySourceArea;
        CGRect postageTextContentRect = [self calculateTextHeightWithText:_commoditySupplyAreaLabel.text fontSize:12.f];
        [_commoditySupplyAreaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(postageTextContentRect.size.height);
        }];
        _postageLabel.text = viewModel.commodityPostage;
        if (viewModel.viewType == DetailViewTypeActivity){
            _postageLabel.text = viewModel.activityDate;
            UIButton *button = [(UIButton *)_tabBarView viewWithTag:11111];
            [button setTitle:@"参加活动" forState:UIControlStateNormal];
        }
        if (viewModel.viewType == DetailViewTypeDiscount) {
            UIButton *button = [(UIButton *)_tabBarView viewWithTag:11111];
            [button setTitle:@"参加领券" forState:UIControlStateNormal];
        }
        [_examineDisbursBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeZero);
        }];
    }
    if (![viewModel.userID isEqualToString:@""]) {
        _fellowBtn.hidden = NO;
    }
    if (_subjuectViewModel.isFollow) {
        _fellowBtn.userInteractionEnabled = NO;
        [_fellowBtn setTitle:@"已关注" forState:UIControlStateNormal];
    }
    [_flagView flag:_subjuectViewModel.flags];
    _livelBgImageView.hidden = NO;
    _handleContainerView.hidden = NO;
    _discountPublishDateLabel.text = viewModel.createtime;
    _livelLabel.text = _subjuectViewModel.user_level;
    _userShareLabel.text = [NSString stringWithFormat:@"爆料%@  |  原创%@",_subjuectViewModel.share_num,_subjuectViewModel.showdan_num];
    [_purchasedBtn setTitle:[NSString stringWithFormat:@"已买(%@)",viewModel.alreadybuy] forState:UIControlStateNormal];
    [_wantBuyBtn setTitle:[NSString stringWithFormat:@"想买(%@)",viewModel.wantbuy] forState:UIControlStateNormal];
    if (viewModel.rewardUsers.count>0) {
        [_rewardUserContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(20);
        }];
        for (NSInteger i = 0; i<_rewardUserIcons.count; i++) {
            UIImageView *iconImageView = (UIImageView *)_rewardUserIcons[i];
            if (i<viewModel.rewardUsers.count) {
                iconImageView.hidden = NO;
                [[MDB_UserDefault defaultInstance] setViewWithImage:iconImageView url:[NSString nullToString:viewModel.rewardUsers[i][@"photo"]]];
            }else{
                iconImageView.hidden = YES;
            }
        }
        if (_rewardUserIcons.count > viewModel.rewardUsers.count) {
            UIImageView *iconImageView = (UIImageView *)_rewardUserIcons[viewModel.rewardUsers.count-1];
            [_rewardUserSumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(iconImageView.mas_right).offset(10);
            }];
        }
        _rewardUserSumLabel.attributedText = [self afreshDescribe: [NSString stringWithFormat:@"%@人打赏",viewModel.rewardCount]];
    }
    if ([MDB_UserDefault getIsLogin] && [MDB_UserDefault defaultInstance].userlevel.integerValue < 2) {
        _rewardButton.userInteractionEnabled = NO;
        _rewardButton.backgroundColor = [UIColor grayColor];
    }
    
    //    if ((![MDB_UserDefault showAppProductGuide] && ![_subjuectViewModel.webDescription isEqualToString:@""]) && ![_subjuectViewModel.userID isEqualToString:@""]) {
    //        if ([self.delegate respondsToSelector:@selector(detailSubjectViewShowGuideElementRects:)]) {
    //            [self layoutIfNeeded];
    //            CGFloat privilegeHeight = 0.f;
    //            if (![_subjuectViewModel.privilegeType isEqualToString:@""]) {
    //                privilegeHeight = 6;
    //            }
    //            CGFloat overseasHeight = 0.f;
    //            if (_subjuectViewModel.viewType == DetailViewTypeOverseas) {
    //                overseasHeight = 13;
    //            }
    //            CGRect frame = _fellowBtn.frame;
    //            frame.origin.x -= 6;
    //            frame.size.width += 12;
    //            frame.size.height += 12;
    //            frame.origin.y = CGRectGetMidY(_userInfoView.frame)-frame.size.height/2;
    //            [self.delegate detailSubjectViewShowGuideElementRects:@[[NSValue valueWithCGRect:frame]]];
    //        }
    //    }
    if(_disburseDetailView.hidden == YES)
    {
        _taxContairView.hidden = YES;
    }
    
    if(viewModel.linkType.integerValue == 1)
    {
        [self.delegate guanzhuButtonShow];
    }
    
    ///收藏提示58000+500+450+300+3600+7300+1700+13000+300+500=85700+17000=102700+14000=116700
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"shoucangyingdao"] intValue] != 1 && viewModel.linkType.integerValue == 1)
    {
        @try {
            NSArray *arrrit = self.viewController.navigationItem.rightBarButtonItems;
            UIBarButtonItem *item = arrrit[1];
            UIButton *btitem = [item customView];
            
            
            CGRect recttemt = [btitem.imageView convertRect:btitem.imageView.frame toView:self.window];
            if(_viewyindao!=nil)[_viewyindao removeFromSuperview];
            
            CGRect rempei = _tabBarView.shouBtn.imageView.frame;
            recttemt.origin.x = kMainScreenW - recttemt.origin.x-15;
            recttemt.origin.y = recttemt.origin.y+rempei.origin.y;
            
            _viewyindao = [MDB_UserDefault drawCollectYinDaoLine:recttemt andimage:nil addview:self.window andtitel:@"加入降价提醒！商品降价将第一时间推送给你，优惠不错过~  "];
            UITapGestureRecognizer *tapyindao = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disyindaoAction:)];
            [_viewyindao addGestureRecognizer:tapyindao];
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
        
    }
    
}

- (void)layoutSubviews{
    
    
    [super layoutSubviews];
}
- (void)updateTableHeaderView{
    [self layoutIfNeeded];
    CGFloat height = [_tableHeaderView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = _tableHeaderView.frame;
    frame.size.height = height;
    _tableHeaderView.frame =frame;
    _tableView.tableHeaderView = _tableHeaderView;
}

- (CGRect)calculateTextHeightWithText:(NSString *)text
                             fontSize:(CGFloat)size{
    CGSize maxSize = CGSizeMake(kMainScreenW-20, MAXFLOAT);
    CGRect contentRect = [text boundingRectWithSize:maxSize
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]}
                                            context:nil];
    return contentRect;
}

- (void)updateSubjectViewWithType:(UpdateViewType)type isMinus:(BOOL)minus{
    [_tabBarView updateTabBarStatuesWithType:type isMinus:minus];
}

- (void)bindCommentData:(NSArray *)models{
    if ([models isKindOfClass:[NSArray class]]){
        if (models.count<=0) return;
        [_layouts removeAllObjects];
        for (NSDictionary *dict in models) {
            Remark *aRemark = [Remark modelWithDictionary:dict];
            aRemark.content = [aRemark.content stringByAppendingString:@" "];
            RemarkStatusLayout *layout = [[RemarkStatusLayout alloc] initWithStatus:aRemark];
            if (layout) {
                [_layouts addObject:layout];
            }
        }
        [_tableView reloadSection:2 withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

- (void)bindRelevanceData:(NSArray *)models{
    if ([models isKindOfClass:[NSArray class]]){
        if (models.count<=0 || !models) return;
        NSMutableArray *modelArr = [NSMutableArray array];
        for (NSDictionary *dict in models) {
            RelevanceCellViewModel *model = [RelevanceCellViewModel viewModelWithSubject:dict];
            if (model) {
                [modelArr addObject:model];
            }
        }
        _relevances = modelArr.mutableCopy;
        [_tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)bindHotShowdanData:(NSArray *)models{
    if ([models isKindOfClass:[NSArray class]]){
        if (models.count<=0 || !models) return;
        _hotshowdans = models;
        [_tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationFade];
    }
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

#pragma mark - Events

- (void)respondsToRewardInfoEvent:(UIControl *)sender{
    if ([self.delegate respondsToSelector:@selector(detailSubjectViewDidCickRewardInfo)]) {
        [self.delegate detailSubjectViewDidCickRewardInfo];
    }
}

- (void)respondsToPayBtnEvent:(UIButton *)sender{
    NSString *type = @"";
    if (sender == _purchasedBtn) {
        type = @"2";
    }else if(sender == _wantBuyBtn){
        type = @"1";
    }
    if ([self.delegate respondsToSelector:@selector(detailSubjectViewDidCickByButtonWithType:didComplete:)]) {
        [self.delegate detailSubjectViewDidCickByButtonWithType:type didComplete:^(BOOL status) {
            if (status) {
                NSString *titleStr = @"";
                if (sender == _purchasedBtn) {
                    titleStr = [NSString stringWithFormat:@"已买(%@)",@(_subjuectViewModel.alreadybuy.integerValue+1)];
                }else if(sender == _wantBuyBtn){
                    titleStr = [NSString stringWithFormat:@"想买(%@)",@(_subjuectViewModel.wantbuy.integerValue+1)];
                }else{
                }
                [sender setTitle:titleStr forState:UIControlStateNormal];
                sender.userInteractionEnabled = NO;
            }
        }];
    }
    
}

- (void)respondesToRewardButtonEvents:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(detailSubjectViewDidCickRewardButton)]) {
        [self.delegate detailSubjectViewDidCickRewardButton];
    }
}

- (void)respondesToButtonEvents:(id)sender{
    _isShowTaxReference = !_isShowTaxReference;
    _taxContairView.hidden = !_isShowTaxReference;
    _taxContairView.hidden = NO;
    if (_isShowTaxReference) {
        [_taxContairView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(_taxWebHeight);
        }];
        
        [(UIButton *)sender setImage:[UIImage imageNamed:@"taxreference_deafault"] forState:UIControlStateNormal];
    }else{
        [_taxContairView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(1);
        }];
        [(UIButton *)sender setImage:[UIImage imageNamed:@"taxreference_dis"] forState:UIControlStateNormal];
    }
    
    ////在这里修改_disburseDetailView的高度
    
    [self updateTableHeaderView];
}

- (void)respondesToCourseBtnEvents:(id)sender{
    if ([self.delegate respondsToSelector:@selector(productInfoSubjectsViewDidPressCourseBtnWithLink:sitName:)]) {
        [self.delegate productInfoSubjectsViewDidPressCourseBtnWithLink:_subjuectViewModel.courselink
                                                                sitName:_subjuectViewModel.commoditySupply];
    }
}

- (void)respondsToBannerViewEvent:(UIGestureRecognizer *)recognizer{
    if([_subjuectViewModel.appactiveopen isEqualToString:@"taobao"]){
        if ([self.delegate respondsToSelector:@selector(tabBarViewdidPressNonstopItemWithTmallUrlStr:)]) {
            
            if(_subjuectViewModel.tljurl.length>5&&_istljshare==YES)
            {
                [self.delegate tabBarViewdidPressNonstopItemWithTmallUrlStr:_subjuectViewModel.tljurl];
            }
            else
            {
                [self.delegate tabBarViewdidPressNonstopItemWithTmallUrlStr:_subjuectViewModel.activeLink];
            }
            
        }
    }else if([_subjuectViewModel.appactiveopen isEqualToString:@"weburl"]){
        if ([self.delegate respondsToSelector:@selector(tabBarViewdidPressNonstopItemWithOutUrlStr:andsafari:)]) {
            [self.delegate tabBarViewdidPressNonstopItemWithOutUrlStr:_subjuectViewModel.activeLink andsafari:_subjuectViewModel.outopen];
        }
    }
    
}

- (void)respondsToFollowBtn:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(detailSubjectViewDidCickAddFollowWithUserid:didComplete:)]) {
        [self.delegate detailSubjectViewDidCickAddFollowWithUserid:_subjuectViewModel.userID didComplete:^(BOOL status) {
            _fellowBtn.userInteractionEnabled = NO;
            [_fellowBtn setTitle:@"已关注" forState:UIControlStateNormal];
        }];
    }
}

- (void)respondsToAvaterView:(UIGestureRecognizer *)gesture{
    if ([self.delegate respondsToSelector:@selector(detailSubjectViewDidCickAvaterViewWithUserid:)]) {
        [self.delegate detailSubjectViewDidCickAvaterViewWithUserid:_subjuectViewModel.userID];
    }
}

#pragma mark - MDBwebDelegate
-(void)webViewDidFinishLoad:(float)h webview:(MDBwebVIew *)webView{
    if (webView.tag == 1111) {
        _taxWebHeight = h;
    }else{
        [webView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(h);
        }];
        [self updateTableHeaderView];
    }
}

- (void)webViewDidPreseeUrlWithLink:(NSString *)link webview:(MDBwebVIew *)webView{
    if ([self.delegate respondsToSelector:@selector(detailViewdidPressNonstopItemWithOutUrlStr:andsafari:)]) {
        [self.delegate detailViewdidPressNonstopItemWithOutUrlStr:link andsafari:_subjuectViewModel.outopen];
    }
}

#pragma mark - ProductInfoTabBarViewDelegate
- (void)tabBarViewDidPressComBton{
    if ([self.delegate respondsToSelector:@selector(tabBarViewdidPressComItem)]) {
        [self.delegate tabBarViewdidPressComItem];
    }
}

- (void)tabBarViewDidPressShouBton{
    if ([self.delegate respondsToSelector:@selector(tabBarViewdidPressShouItemWithLinkType:)]) {
        [self.delegate tabBarViewdidPressShouItemWithLinkType:_subjuectViewModel.linkType];
    }
}

- (void)tabBarViewDidPressZanBton{
    if ([self.delegate respondsToSelector:@selector(tabBarViewdidPressZanItem)]) {
        [self.delegate tabBarViewdidPressZanItem];
    }
}

-(void)zhidalianjiezidong
{
    [self tabBarViewDidPressNonstopBton];
}

- (void)tabBarViewDidPressNonstopBton{
    //    if ([self.delegate respondsToSelector:@selector(tabBarViewdidPressNonstopItemWithOutUrlStr:andsafari:)]) {
    //        [self.delegate tabBarViewdidPressNonstopItemWithOutUrlStr:@"https://h5.m.taobao.com/awp/core/detail.htm?id=520845133820&visa=testvisa" andsafari:@""];
    //    }
    if (_subjuectViewModel.isTianMao) {
        if (![_subjuectViewModel.tmalltWoinOneUrlLink isEqualToString:@""]) {
            if ([self.delegate respondsToSelector:@selector(tabBarViewdidPressNonstopItemWithTmallUrlStr:)]) {
                if(_subjuectViewModel.tljurl.length>5&&_istljshare==YES)
                {
                    [self.delegate tabBarViewdidPressNonstopItemWithTmallUrlStr:_subjuectViewModel.tljurl];
                }
                else
                {
                    [self.delegate tabBarViewdidPressNonstopItemWithTmallUrlStr:_subjuectViewModel.tmalltWoinOneUrlLink];
                }
                
            }
        }else if (![_subjuectViewModel.tmallid isEqualToString:@""]){
            if ([self.delegate respondsToSelector:@selector(tabBarViewdidPressNonstopItemWithTmallidStr:)]) {
                [self.delegate tabBarViewdidPressNonstopItemWithTmallidStr:_subjuectViewModel.tmallid];
            }
        }else{
            if ([self.delegate respondsToSelector:@selector(tabBarViewdidPressNonstopItemWithOutUrlStr:andsafari:)]) {
                [self.delegate tabBarViewdidPressNonstopItemWithOutUrlStr:_subjuectViewModel.outurl andsafari:_subjuectViewModel.outopen];
            }
        }
    }else if (_subjuectViewModel.isJD)
    {
        if([self.delegate respondsToSelector:@selector(tabBarViewdidPressNonstopItemWithOutUrlStrJDPush:)])
        {
            [self.delegate tabBarViewdidPressNonstopItemWithOutUrlStrJDPush:_subjuectViewModel.redirecturl];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(tabBarViewdidPressNonstopItemWithOutUrlStr:andsafari:)]) {
            [self.delegate tabBarViewdidPressNonstopItemWithOutUrlStr:_subjuectViewModel.outurl andsafari:_subjuectViewModel.outopen];
        }
    }
}
- (void)tabBarViewDidPressReportItem{
    if ([self.delegate respondsToSelector:@selector(tabBarViewDidPressReportItem)]) {
        [self.delegate tabBarViewDidPressReportItem];
    }
    
}
///举报
-(void)jubaoAction
{
    if ([self.delegate respondsToSelector:@selector(tabBarViewDidPressReportItem)]) {
        [self.delegate tabBarViewDidPressReportItem];
    }
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(tableView.tag == 1234)
    {
        return 1;
    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView.tag == 1234)
    {
        return _arrDaiGouData.count;
    }
    switch (section) {
        case 0:
            return self.hotshowdans.count;
            break;
        case 1:
            return self.relevances.count;
            break;
        case 2:
            if (_layouts.count > 0) {
                if (_subjuectViewModel.commentSum.integerValue>3) {
                    return _layouts.count + 1;
                }else{
                    return _layouts.count;
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
    if(tableView.tag == 1234)
    {
        static NSString *strcell = @"DaiGouPinDanTableViewCell";
        DaiGouPinDanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strcell];
        if(!cell)
        {
            cell = [[DaiGouPinDanTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strcell];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        //        _arrDaiGouData
        [cell setBackgroundColor:[UIColor clearColor]];
        cell.model0 = _daigoumodel;
        cell.model = _arrDaiGouData[indexPath.row];
        return cell;
    }
    if (indexPath.section == 0) {
        HotShowdanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHotShownTableViewCellIdentifier];
        //        cell.delegate = self;
        [cell bindDataWithModel:self.hotshowdans[indexPath.row]];
        return cell;
    }else if (indexPath.section == 1) {
        RelevanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRelevanceTableViewCellIdentifier];
        cell.delegate = self;
        [cell bindHotRecommendData:self.relevances[indexPath.row]];
        return cell;
    }else if (indexPath.section == 2){
        if(indexPath.row > _layouts.count - 1){
            ReadMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReadMoreTableViewCellIdentifier];
            return cell;
        }else{
            RemarkHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHotCommentTableViewCellIdentifier];
            [cell setLayout:_layouts[indexPath.row]];
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
    @try
    {
        if(tableView.tag == 1234)
        {
            return 52;
        }
        if (indexPath.section==0) {
            return IS_IPHONE_WIDE_SCREEN ? (kMainScreenW*.66) : (kMainScreenW*.7);
        }else if (indexPath.section==1) {
            return ((RelevanceCellViewModel *)_relevances[indexPath.row]).height;
        }else if (indexPath.section == 2){
            if (indexPath.row == 3) {
                return 50;
            }else{
                return ((RemarkStatusLayout *)_layouts[indexPath.row]).height;
            }
        }
    }
    @catch(NSException *esc)
    {
        return 0;
    }
    @finally
    {
        
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
    if (indexPath.section == 2 && indexPath.row==self.layouts.count) {
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
    if(tableView.tag == 1234)
    {
        return 0;
    }
    if (section == 0) {
        if (self.hotshowdans.count > 0) {
            return kTableViewSectionHeaderHeight;
        }
    }else if (section == 1) {
        if (self.relevances.count > 0) {
            return kTableViewSectionHeaderHeight;
        }
    }else if (section == 2){
        if (_layouts.count > 0) {
            return kTableViewSectionHeaderHeight;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(tableView.tag == 1234)
    {
        return nil;
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), kTableViewSectionHeaderHeight)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [UIView new];
    [headerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(headerView);
        make.height.offset(1);
    }];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    
    UIImageView *iconImageView = [UIImageView new];
    [headerView addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top).offset(20);
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
    if (section == 0 || section == 1) {
        if (section == 0){
            lineView.hidden = YES;
        }
        nameLabel.textColor = [UIColor colorWithHexString:@"#959595"];
        nameLabel.font = [UIFont systemFontOfSize:12.f];
        [nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImageView.mas_left);
        }];
        nameLabel.text = self.tableViewHeaders[section][kTableViewHeaderName];
        
    }else{
        lineView.hidden = NO;
        iconImageView.image = self.tableViewHeaders[section][kTableViewHeaderImage];
        nameLabel.textColor = [UIColor colorWithHexString:@"#F77210"];
        nameLabel.font = [UIFont systemFontOfSize:14.f];
        nameLabel.text = [NSString stringWithFormat:@"%@(%@)",self.tableViewHeaders[section][kTableViewHeaderName],_subjuectViewModel.commentSum];
    }
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView.tag == 1234)
    {
        NSLog(@"拼单cell点击");
        return;
    }
    if (indexPath.section == 0) {
        if ([self.delegate respondsToSelector:@selector(hotShowdanCellDidCilckCellWithID:)]) {
            [self.delegate hotShowdanCellDidCilckCellWithID:[NSString nullToString:self.hotshowdans[indexPath.row][@"id"]]];
        }
    }
    if (indexPath.section == 1) {
        RelevanceCellViewModel *model = self.relevances[indexPath.row];
        model.isSelect = YES;
        [tableView reloadData];
        if ([(RelevanceCellViewModel *)self.relevances[indexPath.row] type] == RelevanceTypeRecommend) {
            if ([self.delegate respondsToSelector:@selector(relevanceRecommendCellDidCilckCellWithID:)]) {
                [self.delegate relevanceRecommendCellDidCilckCellWithID:[self.relevances[indexPath.row] relevanceID]];
            }
        }else{
            if (![[self.relevances[indexPath.row] relevanceID] isEqualToString:@""]) {
                if ([self.delegate respondsToSelector:@selector(relevanceCellDidCilckCellWithID:)]) {
                    [self.delegate relevanceCellDidCilckCellWithID:[self.relevances[indexPath.row] relevanceID]];
                }
            }else if (![[self.relevances[indexPath.row] linkurl] isEqualToString:@""]) {
                if ([self.delegate respondsToSelector:@selector(relevanceCellDidCilckCellWithLinkUrl:)]) {
                    [self.delegate relevanceCellDidCilckCellWithLinkUrl:[self.relevances[indexPath.row] linkurl]];
                }
            }
        }
    }
    if (indexPath.section == 2 && indexPath.row > _layouts.count - 1) {
        if ([self.delegate respondsToSelector:@selector(detailSubjectViewDidCickReadMoreRemark)]) {
            [self.delegate detailSubjectViewDidCickReadMoreRemark];
        }
    }
}

#pragma mark - NJFlagViewDelegate
- (void)flageViewDidClickItem:(NSDictionary *)item type:(FlagType)type{
    if (type == FlagTypeNormal) {
        if ([self.delegate respondsToSelector:@selector(detailSubjectViewDidCickFlagViewSimpleSearch:)]) {
            [self.delegate detailSubjectViewDidCickFlagViewSimpleSearch:item[@"name"]];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(detailSubjectViewDidCickFlagViewComplexSearchID:name:type:)]) {
            [self.delegate detailSubjectViewDidCickFlagViewComplexSearchID:item[@"id"] name:item[@"name"] type:type];
        }
    }
}
///头部商城点击
-(void)shangchengdianjiAction
{
    if ([self.delegate respondsToSelector:@selector(detailSubjectViewDidCickFlagViewComplexSearchID:name:type:)]) {
        [self.delegate detailSubjectViewDidCickFlagViewComplexSearchID:_subjuectViewModel.commoditySupplyid name:_subjuectViewModel.commoditySupply type:FlagTypeSite];
    }
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UITableView class]]) {
        //固定头部视图
        if (scrollView.contentOffset.y<=kTableViewSectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=kTableViewSectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-kTableViewSectionHeaderHeight, 0, 0, 0);
        }
    }
}

#pragma mark - RelevanceTableViewCellDelegate
- (void)RelevanceTableViewCellDidClickLikeBtn:(RelevanceTableViewCell *)cell{
    NSIndexPath *path = [_tableView indexPathForCell:cell];
    if ([self.delegate respondsToSelector:@selector(relevanceCellDidCilckLikeBtn:didComplete:)]) {
        __weak typeof(self) weakSelf = self;
        [self.delegate relevanceCellDidCilckLikeBtn:[weakSelf.relevances[path.row] relevanceID] didComplete:^{
            NSMutableArray *tempArr = [NSMutableArray arrayWithArray:weakSelf.relevances];
            RelevanceCellViewModel *model = tempArr[path.row];
            [model updateLikeAmount];
            [tempArr replaceObjectAtIndex:path.row withObject:model];
            weakSelf.relevances = tempArr.mutableCopy;
            [weakSelf.tableView reloadRow:path.row inSection:1 withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
}

#pragma mark - RemarkHomeTableViewCellDelegate

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
        
        NSString *str = [[NSString alloc] initWithData:responceObjct encoding:NSUTF8StringEncoding];
        NSLog(@"===%@",str);
    }];
}

- (void)cellDidClick:(RemarkHomeTableViewCell *)cell{
    if (!cell.statusView.layout.status.comentid) return;
    
}

- (void)cell:(RemarkHomeTableViewCell *)cell didClickImageAtIndex:(NSUInteger)index{
    if (!cell.statusView.layout.status.comentid) return;
    UIView *fromView = nil;
    NSMutableArray *items = [NSMutableArray new];
    Remark *status = cell.statusView.layout.status;
    NSArray *pics = status.pics;
    
    for (NSUInteger i = 0, max = pics.count; i < max; i++) {
        UIView *imgView = cell.statusView.picViews[i];
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        item.thumbView = imgView;
        item.largeImageURL = [NSURL URLWithString:[NSString nullToString:pics[i][@"orgin"]]];
        //        item.largeImageSize = CGSizeMake(meta.width, meta.height);
        [items addObject:item];
        if (i == index) {
            fromView = imgView;
        }
    }
    
    YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:items];
    if ([self.delegate respondsToSelector:@selector(photoGroupView:didClickImageView:)]) {
        [self.delegate photoGroupView:v didClickImageView:fromView];
    }
    
}

- (void)cell:(RemarkHomeTableViewCell *)cell didClickInLabel:(YYLabel *)label textRange:(NSRange)textRange{
    NSAttributedString *text = label.textLayout.text;
    if (textRange.location >= text.length) return;
    YYTextHighlight *highlight = [text attribute:YYTextHighlightAttributeName atIndex:textRange.location];
    NSDictionary *info = highlight.userInfo;
    if (info.count == 0) return;
    if (info[kWBLinkURLName]) {
        NSString *url = info[kWBLinkURLName];
        if ([self.delegate respondsToSelector:@selector(remarkHomeSubjectClickUrl:)]) {
            [self.delegate remarkHomeSubjectClickUrl:url];
        }
    }
}

- (void)cell:(RemarkHomeTableViewCell *)cell didClickUser:(NSString *)userid{
    if ([self.delegate respondsToSelector:@selector(detailSubjectViewDidCickAvaterViewWithUserid:)]) {
        [self.delegate detailSubjectViewDidCickAvaterViewWithUserid:userid];
    }
}

#pragma mark - getter and setter
- (UIImage *)productImage{
    return _productImageView.image;
}

- (NSArray *)tableViewHeaders{
    if (!_tableViewHeaders) {
        _tableViewHeaders = @[@{kTableViewHeaderName:@"热门原创",
                                kTableViewHeaderImage:[UIImage imageNamed:@"introduce_ general_normal"]},
                              @{kTableViewHeaderName:@"猜你喜欢",
                                kTableViewHeaderImage:[UIImage imageNamed:@"introduce_ general_normal"]},
                              @{kTableViewHeaderName:@"评论",
                                kTableViewHeaderImage:[UIImage imageNamed:@"comment_ general_normal"]}];
    }
    return _tableViewHeaders;
}

- (NSMutableArray *)tableSectionTypes{
    if (!_tableSectionTypes) {
        _tableSectionTypes = [NSMutableArray array];
    }
    return _tableSectionTypes;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==111){
        if (buttonIndex==0) {
            
            VKLoginViewController *vkVC = [[VKLoginViewController alloc] init];
            [self.viewController.navigationController pushViewController:vkVC animated:YES];
        }
    }
    
}

//-(void)dealloc
//{
//    _subjuectViewModel = nil;
//    _tabBarView = nil;
//    _tableSectionTypes = nil;
//    _tableHeaderView = nil;
//    _contairView = nil;
//    _productImageView = nil;
//    _disburseDetailView = nil;
//    _daiGouTabView = nil;
//    _image_bannnerView = nil;
//    _taxWebView = nil;
//    _detailWebView = nil;
//    _flagView = nil;
//
//    _tableView = nil;
//    _taxWebView = nil;
//}

@end
