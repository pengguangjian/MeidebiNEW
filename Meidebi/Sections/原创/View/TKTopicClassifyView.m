//
//  TKTopicClassifyView.m
//  TaokeSecretary
//
//  Created by mdb-losaic on 2018/1/12.
//  Copyright © 2018年 leecool. All rights reserved.
//

#import "TKTopicClassifyView.h"

#import "MDB_UserDefault.h"

static NSString * const kTopicItemName = @"name";
static NSString * const kTopicItemIcon = @"image";
static NSString * const kTopicItemType = @"type";

@interface TKTopicClassifyCollectionViewCell: UICollectionViewCell
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@end

@implementation TKTopicClassifyCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configurUI];
    }
    return self;
}

- (void)configurUI{
    _iconImageView = [UIImageView new];
    [self.contentView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.left.equalTo(self.contentView.mas_left).offset(11);
        make.right.equalTo(self.contentView.mas_right).offset(-11);
        make.height.equalTo(_iconImageView.mas_width);
    }];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _nameLabel = [UILabel new];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView.mas_bottom).offset(8);
        make.left.equalTo(self.contentView.mas_left).offset(3*kScale);
        make.right.equalTo(self.contentView.mas_right).offset(-(3*kScale));
    }];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    _nameLabel.font = [UIFont systemFontOfSize:11.f];
}

- (void)bindDataWithModel:(NSDictionary *)model{
    _nameLabel.text = model[kTopicItemName];
    _iconImageView.image = model[kTopicItemIcon];
}
@end

static NSString * const kCollectionViewCellIndentifier = @"cell";

@interface TKTopicClassifyView ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>
{
    UIView *viewyindao;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSArray *topicClassifys;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation TKTopicClassifyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configurUI];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _flowLayout.itemSize = CGSizeMake(CGRectGetWidth(self.frame)/5, CGRectGetHeight(self.frame));
    
//    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"yindaoyuanchuan"] intValue] != 1)
//    {
//        [viewyindao removeFromSuperview];
//        viewyindao = [MDB_UserDefault drawYinDaoLine:CGRectMake(0, 0, self.width, self.height) addview:self andtitel:@"晒单入口在分类里面哦"];
//        UITapGestureRecognizer *tapyindao = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disyindaoAction)];
//        [viewyindao addGestureRecognizer:tapyindao];
//    }
    
    
}

-(void)disyindaoAction
{
    [viewyindao removeFromSuperview];
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"yindaoyuanchuan"];
}

- (void)configurUI{
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)starScroll{
    [self layoutIfNeeded];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSIndexPath *path = [NSIndexPath indexPathForRow:self.topicClassifys.count-1 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.collectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        });
    });
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.topicClassifys.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TKTopicClassifyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellIndentifier forIndexPath:indexPath];
    [cell bindDataWithModel:self.topicClassifys[indexPath.row]];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    TKTopicType type = [self.topicClassifys[indexPath.row][kTopicItemType] integerValue];
    if ([self.delegate respondsToSelector:@selector(topicClassifyViewDidSelectType:)]) {
        [self.delegate topicClassifyViewDidSelectType:type];
    }
}


#pragma mark - setters and getters
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_flowLayout];
        [_collectionView registerClass:[TKTopicClassifyCollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCellIndentifier];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
    }
    return _collectionView;
}

- (NSArray *)topicClassifys{
    if (!_topicClassifys) {
        _topicClassifys = @[
                            @{kTopicItemName:@"生活经验",
                              kTopicItemIcon:[UIImage imageNamed:@"topic_enable"],
                              kTopicItemType:@(TKTopicTypeEnable)
                              },
                            @{kTopicItemName:@"服饰鞋包",
                              kTopicItemIcon:[UIImage imageNamed:@"topic_looks"],
                              kTopicItemType:@(TKTopicTypeLooks)
                              },
                            @{kTopicItemName:@"美妆护肤",
                              kTopicItemIcon:[UIImage imageNamed:@"yuanchuang_meizhuanghufu"],
                              kTopicItemType:@(TKTopicTypeBeauty)
                              },
                            @{kTopicItemName:@"数码家电",
                              kTopicItemIcon:[UIImage imageNamed:@"yuanchuang_3Cshuma"],
                              kTopicItemType:@(TKTopicType3C)
                              },
                            @{kTopicItemName:@"美食旅游",
                              kTopicItemIcon:[UIImage imageNamed:@"yuanchuang_meishilvyou"],
                              kTopicItemType:@(TKTopicTypeDeliciousfood)
                              },
                            @{kTopicItemName:@"评测试用",
                              kTopicItemIcon:[UIImage imageNamed:@"topic_evaluation"],
                              kTopicItemType:@(TKTopicTypeEvaluation)
                              },
                            @{kTopicItemName:@"匿名吐槽",
                              kTopicItemIcon:[UIImage imageNamed:@"topic_spitslot"],
                              kTopicItemType:@(TKTopicTypeSpitslot)
                              },
                            @{kTopicItemName:@"日常话题",
                              kTopicItemIcon:[UIImage imageNamed:@"topic_daily"],
                              kTopicItemType:@(TKTopicTypeDaily)
                              },
                            @{kTopicItemName:@"其他",
                              kTopicItemIcon:[UIImage imageNamed:@"yuanchuang_other"],
                              kTopicItemType:@(TKTopicTypeOther)
                              }];
    }
    return _topicClassifys;
}
@end
