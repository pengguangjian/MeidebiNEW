//
//  WelfareStrategySubjectView.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/27.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "WelfareStrategySubjectView.h"
#import "WelfareStrategyViewCell.h"
#import "ZLJCollectionViewFlowLayout.h"
#import "WelfareStrategyCollectionHeaderView.h"
#import "MDB_UserDefault.h"
#import <MJRefresh/MJRefresh.h>
@interface WelfareCollectionFooterView : UICollectionReusableView

@end
@implementation WelfareCollectionFooterView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
    }
    return self;
}
@end

static NSString *collectionCellIdentifier = @"cell";
static NSString *collectionHeaderViewIdentifier = @"headerView";
static NSString *collectionFooterViewIdentifier = @"footerView";

@interface WelfareStrategySubjectView ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
ZLJCollectionViewFlowLayout,
WelfareStrategyCollectionHeaderViewDelegate
>
@property (nonatomic, assign) NSInteger currentHeaderViewHeight;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ZLJCollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) WelfareStrategyCollectionHeaderView *headerView;
@property (nonatomic, strong) NSArray *strategys;
@property (nonatomic, strong) NSDictionary *adInfoDict;

@end

@implementation WelfareStrategySubjectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _currentHeaderViewHeight = BOUNDS_WIDTH*0.376+145;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    ZLJCollectionViewFlowLayout *flowLayout = [[ZLJCollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _flowLayout = flowLayout;
    [self addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    [collectionView registerClass:[WelfareStrategyViewCell class]
       forCellWithReuseIdentifier:collectionCellIdentifier];
    [collectionView registerClass:[WelfareStrategyCollectionHeaderView class]
       forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
              withReuseIdentifier:collectionHeaderViewIdentifier];
    [collectionView registerClass:[WelfareCollectionFooterView class]
       forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
              withReuseIdentifier:collectionFooterViewIdentifier];
    _collectionView = collectionView;
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if ([self.delegate respondsToSelector:@selector(welfareStrategyCollectionViewRefreshHeader)]) {
            [self.delegate welfareStrategyCollectionViewRefreshHeader];
        }
    }];
}

- (void)bindAdDataWithModel:(NSDictionary *)dict{
    if (!dict)
    {
        _currentHeaderViewHeight = 65;
        [_collectionView reloadData];
        [_headerView bindDataWithModel:dict];
        return;
    }
    _adInfoDict = dict[@"advertise"];
    [_headerView bindDataWithModel:dict];
    CGFloat headerViewHeight = 0.f;
    // 防止后台在没数据时给的数据类型不正常
    if ([[NSString nullToString:dict[@"notice"]] isKindOfClass:[NSString class]]) {
        if (![@"" isEqualToString:dict[@"notice"]]) {
            headerViewHeight += 43;
        }
    }
    // 防止后台在没数据时给的数据类型不正常
    if ([dict[@"advertise"] isKindOfClass:[NSDictionary class]]) {
        if (![@"" isEqualToString:[NSString nullToString:_adInfoDict[@"imgurl"]]]) {
//            headerViewHeight += 198;
//            headerViewHeight += 8;
            
            headerViewHeight += BOUNDS_WIDTH*0.376;
            headerViewHeight += 8;
            headerViewHeight += 86;
            headerViewHeight += 8;
            
        }
    }
    _currentHeaderViewHeight = headerViewHeight;
    [_collectionView reloadData];
}

- (void)bindDynamicWithModel:(NSDictionary *)model{
    if (!model) return;
    _headerView.receivedNumStr = [NSString nullToString:model[@"mynum"]];
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.strategys];
    NSMutableDictionary *dailyTaskDict = [NSMutableDictionary dictionaryWithDictionary:tempArr.firstObject];
    NSMutableDictionary *noviceTaskDict = [NSMutableDictionary dictionaryWithDictionary:tempArr.lastObject];
    NSMutableArray *dailyTasks = [NSMutableArray arrayWithArray:dailyTaskDict[@"data"]];
    NSMutableArray *noviceTasks = [NSMutableArray arrayWithArray:noviceTaskDict[@"data"]];
    for (NSDictionary *dict in model[@"task"]) {
        for (NSInteger i = 0; i<dailyTasks.count; i++) {
            NSMutableDictionary *strategyDict = [NSMutableDictionary dictionaryWithDictionary:dailyTasks[i]];
            if ([[NSString nullToString:dict[@"task_id"]] isEqualToString:@"2"] &&
                [[NSString nullToString:strategyDict[kWelfareStrategyName]] isEqualToString:@"绑定手机"]) {
                [strategyDict setObject:@"0" forKey:kWelfareStrategyStatus];
                [dailyTasks replaceObjectAtIndex:i withObject:strategyDict.mutableCopy];
            }
        }
    }
    [dailyTaskDict setObject:dailyTasks.mutableCopy forKey:@"data"];
    [tempArr replaceObjectAtIndex:0 withObject:dailyTaskDict.mutableCopy];
    [noviceTaskDict setObject:noviceTasks.mutableCopy forKey:@"data"];
    [tempArr replaceObjectAtIndex:1 withObject:noviceTaskDict.mutableCopy];
    self.strategys = tempArr.mutableCopy;
    [_collectionView reloadData];
    [_collectionView.mj_header endRefreshing];
}

#pragma mark - UICollectionViewDataSource && UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.strategys.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.strategys[section][@"data"] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WelfareStrategyViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellIdentifier forIndexPath:indexPath];
    [cell bindDataWithModel:self.strategys[indexPath.section][@"data"][indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kMainScreenW-40)/2, 67);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(CGRectGetWidth(self.frame), _currentHeaderViewHeight);
    }else{
        return CGSizeMake(0, 0);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section < self.strategys.count - 1) {
        return CGSizeMake(CGRectGetWidth(self.frame), 8);
    }else{
        return CGSizeMake(0, 0);
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        _headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:collectionHeaderViewIdentifier forIndexPath:indexPath];
        _headerView.delegate = self;
        return _headerView;
    }else if (kind == UICollectionElementKindSectionFooter){
        WelfareCollectionFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:collectionFooterViewIdentifier forIndexPath:indexPath];
        return footerView;
    }
    return nil;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(45, 15, 15, 15);//分别为上、左、下、右
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(welfareStrategyCollectionViewDidSelectCellWithType:)]) {
        [self.delegate welfareStrategyCollectionViewDidSelectCellWithType:[self.strategys[indexPath.section][@"data"][indexPath.row][kWelfareStrategyType] integerValue]];
    }
}

#pragma mark - ZLJCollectionViewFlowLayout
- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout colorForSectionAtIndex:(NSInteger)section{
    return  [UIColor colorWithHexString:@"#F8F8F8"];
}

- (NSString *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout titleForSectionAtIndex:(NSInteger)section{
    return self.strategys[section][kWelfareStrategySectionTitle];
}

- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout titleColorForSectionAtIndex:(NSInteger)section{
    return [UIColor colorWithHexString:@"#F35D00"];
}

#pragma mark - WelfareStrategyCollectionHeaderViewDelegate
- (void)didClickCloseAdBtn{
    _currentHeaderViewHeight -= 43;
    [_collectionView reloadData];
}

- (void)didClickMyWelfareBtn{
    if ([self.delegate respondsToSelector:@selector(welfareStrategyCollectionViewDidClickMyWelfareBtn)]) {
        [self.delegate welfareStrategyCollectionViewDidClickMyWelfareBtn];
    }
}

- (void)didClickMyWelfareAd{
    if ([self.delegate respondsToSelector:@selector(welfareStrategyCollectionViewDidClickMyWelfareBtn)]) {
        [self.delegate welfareStrategyCollectionViewDidClickMyWelfareAd:_adInfoDict];
    }
}
#pragma mark - setters and getters
- (NSArray *)strategys{
    if (!_strategys) {
        _strategys = @[@{kWelfareStrategySectionTitle:@"新手福利",
                         @"data":@[@{kWelfareStrategyName:@"注册会员",
                                     kWelfareStrategyDescribe:@"+100铜币",
                                     kWelfareStrategyType:@(WelfareStrategyJumpTypeRegister),
                                     kWelfareStrategyStatus:[MDB_UserDefault getIsLogin] ? @"1" : @"0"},
                                   @{kWelfareStrategyName:@"绑定手机",
                                     kWelfareStrategyDescribe:@"+300铜币，+5积分",
                                     kWelfareStrategyType:@(WelfareStrategyJumpTypePhoneAuthentication),
                                     kWelfareStrategyStatus:@"1"},
                                   @{kWelfareStrategyName:@"完善基础资料",
                                     kWelfareStrategyDescribe:@"+2积分/项",
                                     kWelfareStrategyType:@(WelfareStrategyJumpTypePerfectInfo),
                                     kWelfareStrategyStatus:@"0"},
                                   @{kWelfareStrategyName:@"绑定QQ/微博",
                                     kWelfareStrategyDescribe:@"+5积分",
                                     kWelfareStrategyType:@(WelfareStrategyJumpTypeBoundOtherAccout),
                                     kWelfareStrategyStatus:@"0"},
                                   @{kWelfareStrategyName:@"开启订阅",
                                     kWelfareStrategyDescribe:@"+10铜币，+2积分",
                                     kWelfareStrategyType:@(WelfareStrategyJumpTypeSubscribe),
                                     kWelfareStrategyStatus:@"0"}]},
                       @{kWelfareStrategySectionTitle:@"勤劳的小蜜蜂",
                         @"data":@[@{kWelfareStrategyName:@"邀请好友",
                                     kWelfareStrategyDescribe:@"+20积分",
                                     kWelfareStrategyType:@(WelfareStrategyJumpTypeInvite),
                                     kWelfareStrategyStatus:@"0"},
                                   @{kWelfareStrategyName:@"每日签到",
                                     kWelfareStrategyDescribe:@"+2铜币，+1积分",
                                     kWelfareStrategyType:@(WelfareStrategyJumpTypeAttendance),
                                     kWelfareStrategyStatus:@"0"},
                                   @{kWelfareStrategyName:@"点赞/评论/收藏",
                                     kWelfareStrategyDescribe:@"+1积分",
                                     kWelfareStrategyStatus:@"0"},
                                   @{kWelfareStrategyName:@"爆料/爆料加精",
                                     kWelfareStrategyDescribe:@"+10/+50铜币，+5积分",
                                     kWelfareStrategyType:@(WelfareStrategyJumpTypeBroke),
                                     kWelfareStrategyStatus:@"0"},
                                   @{kWelfareStrategyName:@"原创/原创加精",
                                     kWelfareStrategyDescribe:@"+300铜币/300/额外，+5积分",
                                     kWelfareStrategyType:@(WelfareStrategyJumpTypeShaidan),
                                     kWelfareStrategyStatus:@"0"},
                                   @{kWelfareStrategyName:@"分享到社交网站",
                                     kWelfareStrategyDescribe:@"+5铜币，+50积分",
                                     kWelfareStrategyStatus:@"0"},
                                   @{kWelfareStrategyName:@"参与平台活动",
                                     kWelfareStrategyDescribe:@"+10铜币",
                                     kWelfareStrategyStatus:@"0"}]}
                       ];
    }
    return _strategys;
}

@end
