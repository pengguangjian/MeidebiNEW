//
//  HomeSepcialProtalView.m
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/8/22.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "HomeSepcialProtalView.h"
#import "SpecialTableViewCell.h"

static NSString * const kTableViewCellIdentifier = @"cell";

@interface CustomPaddLabel : UILabel

@property (nonatomic, assign) UIEdgeInsets edgeInsets;

@end

@implementation CustomPaddLabel
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

@interface HomeSepcialProtalView ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) CustomPaddLabel *messageNumberLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, assign) CGFloat kSpecialTableCellRowHeight;
@property (nonatomic, strong) NSArray *specials;
@end

@implementation HomeSepcialProtalView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _kSpecialTableCellRowHeight = IS_IPHONE_WIDE_SCREEN ? (kMainScreenW*.61) : (kMainScreenW*.63);
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    UILabel *titleLabel = [UILabel new];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(20);
    }];
    titleLabel.font = [UIFont systemFontOfSize:14.f];
    titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    titleLabel.text = @"热门专题";
    
    UIView *leftLineView = [UIView new];
    [self addSubview:leftLineView];
    [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel.mas_centerY);
        make.right.equalTo(titleLabel.mas_left).offset(-8);
        make.size.mas_equalTo(CGSizeMake(16, 1));
    }];
    leftLineView.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    
    _messageNumberLabel = [CustomPaddLabel new];
    [self addSubview:_messageNumberLabel];
    [_messageNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right).offset(4);
        make.centerY.equalTo(titleLabel.mas_centerY);
    }];
    _messageNumberLabel.textAlignment = NSTextAlignmentCenter;
    _messageNumberLabel.backgroundColor = [UIColor colorWithHexString:@"#CB0000"];
    _messageNumberLabel.textColor = [UIColor whiteColor];
    _messageNumberLabel.font = [UIFont systemFontOfSize:10.f];
    _messageNumberLabel.layer.masksToBounds = YES;
    _messageNumberLabel.layer.cornerRadius = 2;
    
    UIView *rightLineView = [UIView new];
    [self addSubview:rightLineView];
    [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel.mas_centerY);
        make.left.equalTo(_messageNumberLabel.mas_right).offset(6);
        make.size.mas_equalTo(CGSizeMake(16, 1));
    }];
    rightLineView.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-11);
        make.centerY.equalTo(titleLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    [moreBtn setTitle:@"更多 >>" forState:UIControlStateNormal];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:10.f];
    [moreBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [moreBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateHighlighted];
    moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [moreBtn addTarget:self action:@selector(respondsToEvent:) forControlEvents:UIControlEventTouchUpInside];
    moreBtn.hidden = YES;
    _moreBtn = moreBtn;
    
    _tableView = [UITableView new];
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(titleLabel.mas_bottom).offset(5);
        make.height.offset(_kSpecialTableCellRowHeight);
    }];
    _tableView.scrollEnabled = NO;
    [_tableView registerClass:[SpecialTableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor colorWithHexString:@"#E7E7E7"];
    _tableView.tableFooterView = [UIView new];
    
    [self layoutIfNeeded];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(CGRectGetMaxY(_tableView.frame));
    }];
}

- (void)respondsToEvent:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(homeSepcialProtalViewDidClickMoreBtn)]) {
        [self.delegate homeSepcialProtalViewDidClickMoreBtn];
    }
}

- (void)bindDataWithModel:(NSArray *)models{
    _specials = models;
    if (_specials.count <= 0) {
        self.hidden = YES;
        _moreBtn.hidden = YES;
        [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
    }else{
        _moreBtn.hidden = NO;
        self.hidden = NO;
//        _messageNumberLabel.edgeInsets = UIEdgeInsetsMake(1, 3, 1, 3);
//        _messageNumberLabel.text = @"8";
        [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(_kSpecialTableCellRowHeight * _specials.count);
        }];
        [_tableView reloadData];
        [self layoutIfNeeded];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(CGRectGetMaxY(_tableView.frame)+10);
        }];
      
    }
    
}

#pragma mark - UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _specials.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SpecialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier];
    [cell bindSpeicalWithModel:_specials[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _kSpecialTableCellRowHeight;
}

#pragma mark - UITableView Delegate methods
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    if (indexPath.row==1/*_specials.count*/) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, self.bounds.size.width, 0, 0)];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, self.bounds.size.width, 0, 0)];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([(SpecialViewModel *)_specials[indexPath.row] style] == SpecialSourceStyleInner) {
        if ([self.delegate respondsToSelector:@selector(sepcialProtalTableViewDidSelectSpecial:)]) {
            [self.delegate sepcialProtalTableViewDidSelectSpecial:[(SpecialViewModel *)_specials[indexPath.row] specialID]];
        }
    }else if ([(SpecialViewModel *)_specials[indexPath.row] style] == SpecialSourceStyleTaobao) {
        if ([self.delegate respondsToSelector:@selector(sepcialProtalTableViewDidSelectTBSpecial:)]) {
            [self.delegate sepcialProtalTableViewDidSelectTBSpecial:[(SpecialViewModel *)_specials[indexPath.row] tbContent]];
        }
    }
   
}






@end
