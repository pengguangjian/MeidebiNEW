//
//  DailyLottoSubjectView.m
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/8/28.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "DailyLottoSubjectView.h"
#import "LottoTableViewCell.h"
#import "MDB_UserDefault.h"
#import "DailyLottoAlertView.h"

static NSString * kTableViewCellIdentifier = @"cell";
static CGFloat kTableViewSectionHeaderHeight = 45.f;
static NSInteger const kLottoItemImageTag = 10000000;
static NSInteger const kLottoItemLabelTag = 10000001;
static NSInteger const kLottoItemBgImageTag = 10000002;

@interface DailyLottoSubjectView ()
<
UITableViewDataSource,
UITableViewDelegate,
UIAlertViewDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *topBgView;
@property (nonatomic, strong) UIView *lottoHandleView;
@property (nonatomic, strong) NSArray *cellColors;
@property (nonatomic, strong) UILabel *currentCionLabel;
@property (nonatomic, strong) UILabel *subDescribleLabel;
@property (nonatomic, strong) NSArray *lottoItems;
@property (nonatomic, strong) NSArray *lottoLists;
@property (nonatomic, strong) NSArray *lotteries;
@property (nonatomic, strong) NSString *currentCionStr;
@property (nonatomic, strong) NSString *lotteryToDayCount;
@property (nonatomic, strong) UIControl *currentSelectItem;
@property (nonatomic, assign) NSUInteger winningIndex;
@property (nonatomic, strong) DailyLottoAlertView *lottoAlertView;
@property (nonatomic, assign) BOOL lottoState;
@property (nonatomic, assign) BOOL isFreeLotto;
@end

@implementation DailyLottoSubjectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _lottoState = NO;
        _isFreeLotto = YES;
        _currentCionStr = @"0";
        _lotteryToDayCount = @"0";
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    
    UIScrollView *mainScrollView = [UIScrollView new];
    [self addSubview:mainScrollView];
    [mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    mainScrollView.showsVerticalScrollIndicator = NO;
    UIView *containerView = [UIView new];
    [mainScrollView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(mainScrollView);
        make.width.equalTo(mainScrollView);
    }];
    
    //top view
    UIView *topBgView = [UIView new];
    [containerView addSubview:topBgView];
    MASAttachKeys(topBgView);
    [topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(containerView);
        make.height.offset(120*kScale);
    }];
    _topBgView = topBgView;
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, kMainScreenW, 120*kScale);
    [topBgView.layer addSublayer:gradientLayer];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#EC6154"].CGColor,
                             (__bridge id)[UIColor colorWithHexString:@"#F9752B"].CGColor];
    gradientLayer.locations = @[@(0.2f), @(1.0f)];
    _currentCionLabel = [UILabel new];
    [topBgView addSubview:_currentCionLabel];
    MASAttachKeys(_currentCionLabel);
    [_currentCionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(topBgView.mas_centerY).offset(-9);
        make.centerX.equalTo(topBgView.mas_centerX);
    }];
    _currentCionLabel.textColor = [UIColor whiteColor];
    _currentCionLabel.font = [UIFont boldSystemFontOfSize:18.f];
    _currentCionLabel.text = @"我的铜币：0";
    
    _subDescribleLabel = [UILabel new];
    [topBgView addSubview:_subDescribleLabel];
    MASAttachKeys(_subDescribleLabel);
    [_subDescribleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topBgView.mas_left).offset(10);
        make.right.equalTo(topBgView.mas_right).offset(-10);
        make.top.equalTo(topBgView.mas_centerY).offset(9);
    }];
    _subDescribleLabel.numberOfLines = 0;
    _subDescribleLabel.font = [UIFont systemFontOfSize:13.f];
    _subDescribleLabel.textColor = [UIColor whiteColor];
    _subDescribleLabel.textAlignment = NSTextAlignmentCenter;
    _subDescribleLabel.text = @"会员每日享受1次免费抽奖，再次抽奖10铜币/次";
    
    if (![MDB_UserDefault getIsLogin]) {
        _currentCionLabel.text = nil;
        [_subDescribleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topBgView.mas_centerY);
        }];
    }
    
    UIView *lottoHandleView = [self setupLottoHandleView];
    [containerView addSubview:lottoHandleView];
    MASAttachKeys(lottoHandleView);
    [lottoHandleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(containerView);
        make.top.equalTo(topBgView.mas_bottom).offset(20*kScale);
    }];
    _lottoHandleView = lottoHandleView;
    
    UIButton *winningRecordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [containerView addSubview:winningRecordBtn];
    [winningRecordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(containerView.mas_left).offset(12);
        make.top.equalTo(lottoHandleView.mas_bottom).offset(20*kScale);
        make.right.equalTo(containerView.mas_centerX).offset(-10);
        make.height.offset(45);
    }];
    winningRecordBtn.tag = 100;
    winningRecordBtn.backgroundColor = [UIColor colorWithHexString:@"#ED6353"];
    winningRecordBtn.layer.masksToBounds = YES;
    winningRecordBtn.layer.cornerRadius = 4.f;
    winningRecordBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [winningRecordBtn setTitle:@"我的中奖纪录" forState:UIControlStateNormal];
    [winningRecordBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [winningRecordBtn addTarget:self action:@selector(respondsToBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [containerView addSubview:addressBtn];
    [addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(containerView.mas_right).offset(-12);
        make.left.equalTo(containerView.mas_centerX).offset(10);
        make.height.top.equalTo(winningRecordBtn);
    }];
    addressBtn.backgroundColor = [UIColor colorWithHexString:@"#ED6353"];
    addressBtn.layer.masksToBounds = YES;
    addressBtn.layer.cornerRadius = 4.f;
    addressBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [addressBtn setTitle:@"我的收货地址" forState:UIControlStateNormal];
    [addressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addressBtn addTarget:self action:@selector(respondsToBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [UIView new];
    [containerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(winningRecordBtn.mas_bottom).offset(25*kScale);
        make.left.right.equalTo(containerView);
        make.height.offset(1);
    }];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#DADADA"];
    
    _tableView = [UITableView new];
    [containerView addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.height.offset(4*50+kTableViewSectionHeaderHeight);
        make.left.right.bottom.equalTo(containerView);
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[LottoTableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];

}

- (UIView *)setupLottoHandleView{
    UIView *containerView = [UIView new];
    NSMutableArray *items = [NSMutableArray array];
    UIControl *lastControl = nil;
    for (NSInteger i = 0; i<8; i++) {
        UIControl *handleItemControl = [self customLottoItemControl];
        [containerView addSubview:handleItemControl];
        [handleItemControl addTarget:self
                              action:@selector(respondsLottoItemControl:)
                    forControlEvents:UIControlEventTouchUpInside];
        [handleItemControl mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i==0 || i==4) {
                make.left.equalTo(containerView.mas_left).offset(12);
            }else{
                if (i==3 || i==7) {
                    make.right.equalTo(containerView.mas_right).offset(-12);
                }
                make.left.equalTo(lastControl.mas_right).offset(14*kScale);
            }
            if (i==0) {
                make.top.equalTo(containerView.mas_top);
            }else if (i==4) {
                make.top.equalTo(lastControl.mas_bottom).offset(17*kScale);
            }else{
                make.top.equalTo(lastControl.mas_top);
            }
            if (lastControl) {
                make.width.equalTo(lastControl.mas_width);
            }
            make.height.equalTo(handleItemControl.mas_width).multipliedBy(1.12);
        }];
        lastControl = handleItemControl;
        [items addObject:handleItemControl];
    }
    _lottoItems = items.mutableCopy;
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastControl.mas_bottom);
    }];
    return containerView;
}

- (UIControl *)customLottoItemControl{
    UIControl *handleItemControl = [UIControl new];
    handleItemControl.layer.borderWidth = 1.f;
    handleItemControl.layer.borderColor = [UIColor colorWithHexString:@"#BBB09C"].CGColor;
    handleItemControl.backgroundColor = [UIColor colorWithHexString:@"#F6EFE8"];
    
    UILabel *titleLabel = [UILabel new];
    [handleItemControl addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(handleItemControl);
        make.height.offset(25*kScale);
    }];
    titleLabel.tag = kLottoItemLabelTag;
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:13.f];
    titleLabel.textColor = [UIColor colorWithHexString:@"#9D7A4F"];
    titleLabel.text = @"翻开";
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.minimumScaleFactor = 0.5f;
    titleLabel.numberOfLines = 2;
    
    UIView *lineView = [UIView new];
    [handleItemControl addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(titleLabel.mas_top);
        make.left.right.equalTo(handleItemControl);
        make.height.offset(1);
    }];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#BBB09C"];
    
    UIImageView *bgIconImageView = [UIImageView new];
    [handleItemControl addSubview:bgIconImageView];
    [bgIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(handleItemControl);
        make.bottom.equalTo(lineView.mas_top);
    }];
    bgIconImageView.hidden = YES;
    bgIconImageView.clipsToBounds = YES;
    bgIconImageView.tag = kLottoItemBgImageTag;
    bgIconImageView.userInteractionEnabled = YES;
    bgIconImageView.contentMode = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToGesture:)];
    [bgIconImageView addGestureRecognizer:gesture];
    
    UIImageView *iconImageView = [UIImageView new];
    [handleItemControl addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(handleItemControl.mas_centerX);
        make.top.equalTo(handleItemControl.mas_top).offset(13*kScale);
        make.size.mas_equalTo(CGSizeMake(35*kScale, 35*kScale));
    }];
    iconImageView.clipsToBounds = YES;
    iconImageView.tag = kLottoItemImageTag;
    iconImageView.userInteractionEnabled = YES;
    iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    iconImageView.image = [UIImage imageNamed:@"lotto_icon"];
    UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToGesture:)];
    [iconImageView addGestureRecognizer:gesture1];
    
    return handleItemControl;
}

- (void)bindCurrentCionsDataWithModel:(NSDictionary *)model{
    _currentCionStr = [NSString nullToString:model[@"copper"] preset:@"0"];
    _currentCionLabel.text = [NSString stringWithFormat:@"我的铜币：%@",_currentCionStr];
    if ([MDB_UserDefault getIsLogin]) {
        [_subDescribleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_topBgView.mas_centerY).offset(9);
        }];
    }else{
        [_subDescribleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_topBgView.mas_centerY);
        }];
    }
}
- (void)bindLottoListDataWithModel:(NSDictionary *)model{
    if (!model) return;
    _lottoLists = model[@"list"];
    [_tableView reloadData];
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(_lottoLists.count*50+kTableViewSectionHeaderHeight);
    }];
    if ([@"0" isEqualToString:[NSString nullToString:model[@"is_free"]]]) {
        _isFreeLotto = NO;
    }else{
        _isFreeLotto = YES;
    }
    _lotteryToDayCount = [NSString nullToString:model[@"lotteryToDayCount"]];

}
- (void)bindLottoResultDataWithModel:(NSDictionary *)model{
    self.userInteractionEnabled = YES;
    if (!model) {
        _lottoState = NO;
        return;
    }
    _lottoState = YES;
    _lotteries = model[@"lotteries"];
    __block NSString *lottoAward = nil;
    NSString *winingSort = [NSString stringWithFormat:@"%@",[NSString nullToString:model[@"sort"]]];
    [_lotteries enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj) {
            if ([winingSort isEqualToString:obj[@"sort"]]) {
                _winningIndex = idx;
                lottoAward = obj[@"prize"];
                *stop = YES;
            }
        }
    }];
    [self beginLottoAnimation:_currentSelectItem];
    _currentCionStr = [NSString nullToString:model[@"copper"] preset:@"0"];
    _currentCionLabel.text = [NSString stringWithFormat:@"我的铜币：%@",_currentCionStr];
    NSString *type = [NSString stringWithFormat:@"%@",[NSString nullToString:model[@"type"]]];
    if ([@"0" isEqualToString:type]) {
        [MDB_UserDefault showNotifyHUDwithtext:@"谢谢参与！再抽一次吧~ " inView:self];
    }else if ([@"1" isEqualToString:type]){
        [self.lottoAlertView showAlertWithAward:lottoAward type:type];
    }else if ([@"2" isEqualToString:type]){
        [MDB_UserDefault showNotifyHUDwithtext:[NSString stringWithFormat:@"恭喜获得%@，已入账，注意查收！",lottoAward] inView:self];
    }else if ([@"3" isEqualToString:type]){
        [self.lottoAlertView showAlertWithAward:lottoAward type:type];
    }
}
#pragma mark - Events
- (void)respondsToGesture:(UIGestureRecognizer *)gesture{
    UIControl *control = (UIControl *)gesture.view.superview;
    [self respondsLottoItemControl:control];
}

- (void)respondsToBtnEvent:(UIButton *)sender{
    if (sender.tag == 100) {
        if ([self.delegate respondsToSelector:@selector(lottoSubjectViewDidClickRecordBtn)]) {
            [self.delegate lottoSubjectViewDidClickRecordBtn];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(lottoSubjectViewDidClickAddressBtn)]) {
            [self.delegate lottoSubjectViewDidClickAddressBtn];
        }
    }
}

- (void)respondsLottoItemControl:(UIControl *)sender{
    if (![MDB_UserDefault getIsLogin]) {
        if ([self.delegate respondsToSelector:@selector(lottoSubjectViewToLogin)]) {
            [self.delegate lottoSubjectViewToLogin];
        }
        return;
    }
    if (_currentCionStr.integerValue < 10) {
        [MDB_UserDefault showNotifyHUDwithtext:@"抱歉，您的铜币不足，暂不能抽奖" inView:self];
        if (_lottoState) {
            [self resetLottoItem];
        }
        return;
    }
    _currentSelectItem = sender;
    if (_isFreeLotto) {
        [self beginLotto];
    }else{
        if (_lotteryToDayCount.integerValue+1 == 2 && !_lottoState) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"继续抽奖将扣除10铜币/次" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }else{
            [self beginLotto];
        }
    }
    
    
}
- (void)beginLotto{
    if (_lottoState) {
        [self resetLottoItem];
    }else{
        if ([self.delegate respondsToSelector:@selector(lottoSubjectViewDidClickDoLotto)]) {
            [self.delegate lottoSubjectViewDidClickDoLotto];
        }
        _winningIndex = 0;
        self.userInteractionEnabled = NO;
    }
}

- (void)beginLottoAnimation:(UIControl *)sender{
    [UIView transitionWithView:sender
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        sender.layer.borderColor = [UIColor orangeColor].CGColor;
                        _lottoHandleView.userInteractionEnabled = NO;
                    }
                    completion:^(BOOL finished) {
                        [(UILabel *)[(UIControl *)sender viewWithTag:kLottoItemLabelTag] setText:[NSString nullToString:_lotteries[_winningIndex][@"prize"]]];
                        [(UIImageView *)[(UIControl *)sender viewWithTag:kLottoItemImageTag] setHidden:YES];
                        [(UIImageView *)[(UIControl *)sender viewWithTag:kLottoItemBgImageTag] setHidden:NO];
                        [[MDB_UserDefault defaultInstance] setViewWithImage:(UIImageView *)[(UIControl *)sender viewWithTag:kLottoItemBgImageTag] url:[NSString nullToString:_lotteries[_winningIndex][@"picurl"]]];
                          [(UILabel *)[(UIControl *)sender viewWithTag:kLottoItemLabelTag] setTextColor:[UIColor redColor]];
                        NSMutableArray *lotts = [NSMutableArray arrayWithArray:_lotteries];
                        [lotts removeObjectAtIndex:_winningIndex];
                        NSMutableArray *residues = [NSMutableArray arrayWithArray:_lottoItems];
                        [residues removeObject:sender];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            for (NSInteger i = 0; i<residues.count; i++) {
                                UIControl *item = (UIControl *)residues[i];
                                [UIView transitionWithView:item
                                                  duration:0.5
                                                   options:UIViewAnimationOptionTransitionFlipFromRight
                                                animations:^{
                                                    if (i < lotts.count){
                                                        [(UILabel *)[(UIControl *)residues[i] viewWithTag:kLottoItemLabelTag] setText:[NSString nullToString:lotts[i][@"prize"]]];
                                                        [(UIImageView *)[(UIControl *)residues[i] viewWithTag:kLottoItemImageTag] setHidden:YES];
                                                        [(UIImageView *)[(UIControl *)residues[i] viewWithTag:kLottoItemBgImageTag] setHidden:NO];
                                                        [[MDB_UserDefault defaultInstance] setViewWithImage:(UIImageView *)[(UIControl *)residues[i] viewWithTag:kLottoItemBgImageTag] url:[NSString nullToString:lotts[i][@"picurl"]]];
                                                    }
                                                } completion:^(BOOL finished) {
                                                    _lottoHandleView.userInteractionEnabled = YES;
                                                }];
                            }
                        });
                    }];

    
}

- (void)resetLottoItem{
    _lottoHandleView.userInteractionEnabled = NO;
    for (UIControl *item in _lottoItems) {
        [UIView transitionWithView:item
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            [(UIImageView *)[item viewWithTag:kLottoItemImageTag] setHidden:NO];
                            [(UIImageView *)[item viewWithTag:kLottoItemBgImageTag] setHidden:YES];
                            [(UIImageView *)[item viewWithTag:kLottoItemImageTag] setImage:[UIImage imageNamed:@"lotto_icon"]];
                            [(UILabel *)[item viewWithTag:kLottoItemLabelTag] setText:@"翻开"];
                            [(UILabel *)[item viewWithTag:kLottoItemLabelTag] setTextColor:[UIColor colorWithHexString:@"#9D7A4F"]];
                            item.backgroundColor = [UIColor colorWithHexString:@"#F6EFE8"];
                            item.layer.borderColor = [UIColor colorWithHexString:@"#BBB09C"].CGColor;
                        }completion:^(BOOL finished) {
                            _lottoHandleView.userInteractionEnabled = YES;
                        }];
    }
    _lottoState = NO;
    _currentSelectItem = nil;
}

#pragma mark - UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _lottoLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LottoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier];
    cell.backgroundColor = self.cellColors[indexPath.row%self.cellColors.count];
    [cell bindDataWithModel:_lottoLists[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_lottoLists.count <= 0)  return 0;
    return kTableViewSectionHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (_lottoLists.count <= 0) return nil;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenW, kTableViewSectionHeaderHeight)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    
    UILabel *titleLabel = [UILabel new];
    [headerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(headerView);
    }];
    titleLabel.font = [UIFont systemFontOfSize:14.f];
    titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    titleLabel.text = @"获奖名单";
    
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
    
    return headerView;
}

//固定头部视图
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UITableView class]]) {
        if (scrollView.contentOffset.y<=kTableViewSectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=kTableViewSectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-kTableViewSectionHeaderHeight, 0, 0, 0);
        }
    }
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self beginLotto];
    }else{
        [MDB_UserDefault setFreeLottoDate:[NSDate date] lottoNumber:@(1)];
    }
}

#pragma mark - setters and getters
- (NSArray *)cellColors{
    if (!_cellColors) {
        _cellColors = @[[UIColor colorWithHexString:@"#EFEFEF"],
                        [UIColor whiteColor]];
    }
    return _cellColors;
}

- (DailyLottoAlertView *)lottoAlertView{
    if (!_lottoAlertView) {
        _lottoAlertView = [DailyLottoAlertView new];
    }
    return _lottoAlertView;
}
//#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if ([scrollView isKindOfClass:[UITableView class]]) {
//        //固定头部视图
//        if (scrollView.contentOffset.y<=kTableViewSectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//        } else if (scrollView.contentOffset.y>=kTableViewSectionHeaderHeight) {
//            scrollView.contentInset = UIEdgeInsetsMake(-kTableViewSectionHeaderHeight, 0, 0, 0);
//        }
//    }
//}



@end
