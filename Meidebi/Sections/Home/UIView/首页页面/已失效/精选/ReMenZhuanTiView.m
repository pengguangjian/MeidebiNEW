//
//  ReMenZhuanTiView.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/22.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "ReMenZhuanTiView.h"
#import "SpecialTableViewCell1.h"

static NSString * const kTableViewCellIdentifier = @"cell1";

@interface ReMenZhuanTiView ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, assign) CGFloat kSpecialTableCellRowHeight;
@property (nonatomic, strong) NSArray *specials;
@end
@implementation ReMenZhuanTiView

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
        _kSpecialTableCellRowHeight = IS_IPHONE_WIDE_SCREEN ? (kMainScreenW*.41) : (kMainScreenW*.43);
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 200, 20)];
    [self addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:14.f];
    titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    titleLabel.text = @"热门专题";
    [titleLabel sizeToFit];
    [titleLabel setCenter:CGPointMake(self.width/2.0, 0)];
    [titleLabel setTop:20];
    [titleLabel setHeight:20];
    
    UIView *leftLineView = [[UIView alloc] initWithFrame:CGRectMake(titleLabel.left-16, titleLabel.center.y, 16, 1)];
    [self addSubview:leftLineView];
    leftLineView.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    
    UIView *rightLineView = [[UIView alloc] initWithFrame:CGRectMake(titleLabel.right, titleLabel.center.y, 16, 1)];
    [self addSubview:rightLineView];
    rightLineView.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setFrame:CGRectMake(0, 0, 60, 30)];
    [moreBtn setCenter:CGPointMake(0, titleLabel.center.y)];
    [moreBtn setRight:self.width-11];
    [self addSubview:moreBtn];
    [moreBtn setTitle:@"更多 >>" forState:UIControlStateNormal];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:10.f];
    [moreBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [moreBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateHighlighted];
    moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [moreBtn addTarget:self action:@selector(respondsToEvent:) forControlEvents:UIControlEventTouchUpInside];
    moreBtn.hidden = YES;
    _moreBtn = moreBtn;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, titleLabel.bottom+5, self.width, _kSpecialTableCellRowHeight)];
    [self addSubview:_tableView];
    _tableView.scrollEnabled = NO;
    [_tableView registerClass:[SpecialTableViewCell1 class] forCellReuseIdentifier:kTableViewCellIdentifier];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor colorWithHexString:@"#E7E7E7"];
    _tableView.tableFooterView = [UIView new];
    
//    [self layoutIfNeeded];
}

- (void)respondsToEvent:(UIButton *)sender{
    [self.delegate homeSepcialProtalViewDidClickMoreBtn];
}

- (float)bindDataWithModel:(NSArray *)models{
    if(models==nil||self.tableView ==nil)
    {
        return 0.0;
    }
    _specials = models;
    if (_specials.count <= 0) {
        self.hidden = YES;
        _moreBtn.hidden = YES;
        return 0;
    }else{
        _moreBtn.hidden = NO;
        self.hidden = NO;
        [_tableView setHeight:_kSpecialTableCellRowHeight * _specials.count];
        [_tableView reloadData];
        [self layoutIfNeeded];
        return self.tableView.height+45;
    }
    
}

#pragma mark - UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _specials.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SpecialTableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier];
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
        [self.delegate sepcialProtalTableViewDidSelectSpecial:[(SpecialViewModel *)_specials[indexPath.row] specialID] andtype:1];
    }else if ([(SpecialViewModel *)_specials[indexPath.row] style] == SpecialSourceStyleTaobao) {
        [self.delegate sepcialProtalTableViewDidSelectSpecial:[(SpecialViewModel *)_specials[indexPath.row] tbContent] andtype:2];
    }
    
    
}




@end
