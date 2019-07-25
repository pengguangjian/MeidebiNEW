//
//  CouponLiveSubjectView.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/29.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "CouponLiveSubjectView.h"
#import "NJScrollTableView.h"
#import "CouponSimpleViewController.h"
#import "MDB_UserDefault.h"
@interface CouponLiveSubjectView ()
<
ScrollTabViewDataSource,
CouponSimpleViewControllerDelegate
>
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) NSMutableArray *allVCs;
@property (nonatomic, assign) CouponSubViewType type;
@property (nonatomic, strong) UILabel *emptyAlertLabel;
@property (nonatomic, strong) UIView *emptyView;
@property (nonatomic, strong) NSMutableArray *requestResults;

@end

@implementation CouponLiveSubjectView

- (instancetype)initWithType:(CouponSubViewType)type{
    _type = type;
    _requestResults = [NSMutableArray array];
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    UIView *topHeaderView = [UIView new];
    [self addSubview:topHeaderView];
    [topHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        if (_type == CouponSubViewTypeReult) {
            make.height.offset(0);
        }else{
        }
        make.height.offset(66);

    }];
    topHeaderView.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    

    UIView *searchContainerView = [UIView new];
    [topHeaderView addSubview:searchContainerView];
    [searchContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(topHeaderView).insets(UIEdgeInsetsMake(13, 13, 13, 13));
    }];
    searchContainerView.backgroundColor = [UIColor whiteColor];
    searchContainerView.layer.cornerRadius = 41/2.f;
    searchContainerView.layer.masksToBounds = YES;
    searchContainerView.layer.borderWidth = .8f;
    searchContainerView.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:searchBtn];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(searchContainerView.mas_right).offset(-8);
        make.top.equalTo(searchContainerView.mas_top).offset(5);
        make.bottom.equalTo(searchContainerView.mas_bottom).offset(-5);
        make.width.equalTo(searchBtn.mas_height);
    }];
    [searchBtn setImage:[UIImage imageNamed:@"coupon_searchBtn"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(respondsToSearchBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    _searchTextField = [UITextField new];
    [searchContainerView addSubview:_searchTextField];
    [_searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchContainerView.mas_left).offset(24);
        make.right.equalTo(searchBtn.mas_left).offset(-15);
        make.top.equalTo(searchContainerView.mas_top).offset(8);
        make.bottom.equalTo(searchContainerView.mas_bottom).offset(-8);
    }];
    _searchTextField.textColor = [UIColor colorWithHexString:@"#999999"];
    _searchTextField.font = [UIFont systemFontOfSize:14.f];
    
    CouponSimpleViewController *couponBestNewVC = [[CouponSimpleViewController alloc] init];
    couponBestNewVC.title = @"最新";
    couponBestNewVC.type = @"1";
    couponBestNewVC.delegate = self;
    [self.allVCs addObject:couponBestNewVC];
    CouponSimpleViewController *couponPriceVC = [[CouponSimpleViewController alloc] init];
    couponPriceVC.title = @"价格";
    couponPriceVC.type = @"2";
    couponPriceVC.delegate = self;
    [self.allVCs addObject:couponPriceVC];
    CouponSimpleViewController *couponDenominationVC = [[CouponSimpleViewController alloc] init];
    couponDenominationVC.title = @"券面额";
    couponDenominationVC.type = @"3";
    couponDenominationVC.delegate = self;
    [self.allVCs addObject:couponDenominationVC];

    [self layoutIfNeeded];
    NJScrollTableView *scrollTableView = [[NJScrollTableView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(topHeaderView.frame), kMainScreenW,kMainScreenH-CGRectGetHeight(topHeaderView.frame)-kTopHeight)];
    [self addSubview:scrollTableView];
    scrollTableView.backgroundColor = [UIColor whiteColor];
    scrollTableView.selectedLineWidth = 45;
    scrollTableView.tabButtonTitleColorForNormal = [UIColor colorWithHexString:@"#333333"];
    scrollTableView.dataSource = self;
    [scrollTableView buildUI];
    [scrollTableView selectTabWithIndex:0 animate:NO];

    if (_type == CouponSubViewTypeReult) {
        [self setupEmpityView];
    }
}


- (void)setupEmpityView{
    _emptyView = [UIView new];
    _emptyView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_emptyView];
    [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    _emptyView.hidden = YES;
    UILabel *emptyAlertLabel = [UILabel new];
    [_emptyView addSubview:emptyAlertLabel];
    [emptyAlertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_emptyView.mas_top).offset(50);
        make.left.equalTo(_emptyView.mas_left).offset(35);
        make.right.equalTo(_emptyView.mas_right).offset(-35);
    }];
    emptyAlertLabel.numberOfLines = 0;
    emptyAlertLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    emptyAlertLabel.font = [UIFont systemFontOfSize:14.f];
    emptyAlertLabel.textAlignment = NSTextAlignmentCenter;
    _emptyAlertLabel = emptyAlertLabel;
}

- (void)respondsToSearchBtnEvent:(UIButton *)sender{
    if (_searchTextField.text.length<=0) {
        [MDB_UserDefault showNotifyHUDwithtext:@"搜索内容不能为空！" inView:self];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(couponLiveSubjectViewDidClickSearchBtn:)]) {
        [self.delegate couponLiveSubjectViewDidClickSearchBtn:_searchTextField.text];
    }
    [_searchTextField resignFirstResponder];
    _searchTextField.text = nil;
}

#pragma mark - ScrollTabViewDataSource
- (NSUInteger)numberOfPagers:(NJScrollTableView *)view{
    return self.allVCs.count;
}

- (UITableViewController *)scrollTableViewOfPagers:(NJScrollTableView *)view
                                     indexOfPagers:(NSUInteger)index{
    return self.allVCs[index];
}


#pragma mark - CouponSimpleViewControllerDelegate
- (void)couponSimpleTableViewDidScroll{
    [_searchTextField resignFirstResponder];
}

- (void)couponSimpleTableViewDidIndexRowWithProductID:(NSString *)productid{
    if ([self.delegate respondsToSelector:@selector(couponLiveSubjectViewDidSelectProduct:)]) {
        [self.delegate couponLiveSubjectViewDidSelectProduct:productid];
    }
}

- (void)couponSimpleTableViewInquireResult:(BOOL)status{
    if (_type == CouponSubViewTypeReult) {
        [_requestResults addObject:@(status)];
        if (_requestResults.count == 3) {
            if ([_requestResults containsObject:@(YES)]) {
                _emptyView.hidden = YES;
            }else{
                _emptyView.hidden = NO;
            }
            [_requestResults removeAllObjects];
        }
    }
}

#pragma mark - setters and getters
- (NSMutableArray *)allVCs{
    if (!_allVCs) {
        _allVCs = [NSMutableArray array];
    }
    return _allVCs;
}

- (void)setSearchKey:(NSString *)searchKey{
    _searchKey = searchKey;
    for (CouponSimpleViewController *vc in self.allVCs) {
        vc.keyword = searchKey;
    }
    _emptyAlertLabel.text = [NSString stringWithFormat:@"没找到与 \"%@\" 相关的商品哦 要不您换个关键词再找找看",_searchKey];
}

@end
