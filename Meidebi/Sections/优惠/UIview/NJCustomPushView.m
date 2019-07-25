//
//  NJCustomPushView.m
//  Meidebi
//
//  Created by mdb-admin on 16/4/1.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "NJCustomPushView.h"
#import "NJCustomPushViewCell.h"
#import "MDB_UserDefault.h"
#define kSelectColor [UIColor colorWithHexString:@"#ff752a"]

@interface NJCustomPushView ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *headerTitleLabel;
@property (nonatomic, strong) UICollectionView *artCollectionView;
@property (nonatomic, strong) UIButton *artHaiButton;
@property (nonatomic, strong) UIButton *artGuoButton;
@property (nonatomic, strong) UIButton *artTianButton;

@property (nonatomic, strong) NSMutableArray *selectCategory;
@property (nonatomic, strong) NSMutableArray *selectOrgs;
@end

@implementation NJCustomPushView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, BOUNDS_WIDTH, BOUNDS_HEIGHT);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _selectCategory = [NSMutableArray array];
        _selectOrgs = [NSMutableArray array];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    _containerView = ({
        UIView *view = [UIView new];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.left.equalTo(self.mas_left).offset(20);
            make.right.equalTo(self.mas_right).offset(-20);
        }];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 5.f;
        view.backgroundColor = [UIColor colorWithRed:0.7686 green:0.7608 blue:0.7843 alpha:1.0];
        view;
    });
    
    UIView *headerTitleView = ({
        UIView *view = [UIView new];
        [_containerView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(_containerView);
            make.height.offset(51);
        }];
        view.backgroundColor = [UIColor colorWithHexString:@"#ff752a"];
        view;
    });
    
    _headerTitleLabel = ({
        UILabel *label = [UILabel new];
        [headerTitleView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(headerTitleView);
        }];
        label.font = [UIFont systemFontOfSize:19.f];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    
    UIView *topShadeView = ({
        UIView *view = [UIView new];
        [_containerView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerTitleView.mas_bottom);
            make.left.right.equalTo(_containerView);
            make.height.offset(7.6);
        }];
        view.backgroundColor = [UIColor colorWithRed:0.9529 green:0.949 blue:0.9451 alpha:1.0];
        view;
    });
    
    [_containerView addSubview:self.artHaiButton];
    [_containerView addSubview:self.artGuoButton];
    [_containerView addSubview:self.artTianButton];
    [self.artHaiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_containerView.mas_left);
        make.top.equalTo(topShadeView.mas_bottom).offset(0.4);
        make.width.equalTo(self.artGuoButton.mas_width);
        make.height.equalTo(self.artHaiButton.mas_width).multipliedBy(0.4);
    }];
    [self.artGuoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.artHaiButton.mas_right).offset(0.4);
        make.top.bottom.equalTo(self.artHaiButton);
        make.width.equalTo(self.artTianButton.mas_width);
    }];
    [self.artTianButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.artGuoButton.mas_right).offset(0.4);
        make.top.bottom.equalTo(self.artGuoButton);
        make.right.equalTo(_containerView.mas_right);
        make.width.equalTo(self.artHaiButton.mas_width);
    }];

    UIView *centerShadeView = ({
        UIView *view = [UIView new];
        [_containerView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.artHaiButton.mas_bottom).offset(0.4);
            make.left.right.equalTo(_containerView);
            make.height.offset(7.2);
        }];
        view.backgroundColor = [UIColor colorWithRed:0.9529 green:0.949 blue:0.9451 alpha:1.0];
        view;
    });

    [self layoutIfNeeded];
    [_containerView addSubview:self.artCollectionView];
    [self.artCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerShadeView.mas_bottom).offset(0.4);
        make.left.right.equalTo(_containerView);
        make.height.offset((((CGRectGetWidth(self.containerView.frame)-1.3)/3) *0.4)*5+2.2);
    }];
    
    UIView *bottomShadeView = ({
        UIView *view = [UIView new];
        [_containerView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.artCollectionView.mas_bottom);
            make.left.right.equalTo(_containerView);
            make.height.offset(7.6);
        }];
        view.backgroundColor = [UIColor colorWithRed:0.9529 green:0.949 blue:0.9451 alpha:1.0];
        view;
    });
    
    // 下方操作按钮
    {
        UIButton *noPushBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_containerView addSubview:noPushBtn];
        noPushBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [noPushBtn setTitleColor:[UIColor colorWithRed:0.6309 green:0.6309 blue:0.6309 alpha:1.0] forState:UIControlStateNormal];
        [noPushBtn setTitle:@"暂不推送" forState:UIControlStateNormal];
        [noPushBtn setBackgroundColor:[UIColor whiteColor]];
        [noPushBtn setTag:10000];
        [noPushBtn addTarget:self action:@selector(respondsToButtonEvents:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *pushBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_containerView addSubview:pushBtn];
        pushBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [pushBtn setTitleColor:[UIColor colorWithRed:0.9843 green:0.0 blue:0.0235 alpha:1.0] forState:UIControlStateNormal];
        [pushBtn setTitle:@"确定" forState:UIControlStateNormal];
        [pushBtn setBackgroundColor:[UIColor whiteColor]];
        [pushBtn setTag:10001];
        [pushBtn addTarget:self action:@selector(respondsToButtonEvents:) forControlEvents:UIControlEventTouchUpInside];
        
        [noPushBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bottomShadeView.mas_bottom).offset(0.4);
            make.left.equalTo(_containerView.mas_left);
            make.height.offset(52);
            make.width.equalTo(pushBtn.mas_width);
        }];
        [pushBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(noPushBtn.mas_right).offset(0.5);
            make.top.equalTo(noPushBtn);
            make.right.equalTo(_containerView.mas_right);
            make.size.equalTo(noPushBtn);
        }];
        
        [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(noPushBtn.mas_bottom);
        }];
    }

}

- (void)show{
   
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
}

- (void)dismiss{
    [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *object in touches) {
        if ([object.view isKindOfClass:[self class]]) {
            [super touchesBegan:touches withEvent:event];
            [self.delegate pushCategoryViewDidPressNoPush];
            [self dismiss];
//            if ([self.delegate respondsToSelector:@selector(pushCategoryView:ensureOfCates:orgs:)]) {
//                [_selectCategory removeAllObjects];
//                [_contentArr enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    [_selectCategory addObject:(NSDictionary *)obj[@"id"]];
//                }];
//                [_selectOrgs removeAllObjects];
//                _selectOrgs = [NSMutableArray arrayWithArray:@[@"1",@"2",@"3"]];
//                [self.delegate pushCategoryView:self ensureOfCates:_selectCategory orgs:_selectOrgs];
//            }
            break;
        }
    }
}


- (void)respondsToButtonEvents:(id)sender{
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 10000:
        {
            if ([self.delegate respondsToSelector:@selector(pushCategoryViewDidPressNoPush)]) {
                [self.delegate pushCategoryViewDidPressNoPush];
                [self dismiss];
            }
        }
            break;
        case 10001:
        {
            
            if (_selectOrgs.count == 0 && _selectCategory.count == 0) {

                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请先选择您感兴趣的商品来源，再确定哦！" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
                [alertView show];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertView dismissWithClickedButtonIndex:0 animated:YES];
                });
                
                return;
            }
            
            if ([self.delegate respondsToSelector:@selector(pushCategoryView:ensureOfCates:orgs:)]) {
                
                NSMutableArray *tempArr = [NSMutableArray array];
                [_selectCategory enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj) {
                        if ((NSDictionary *)obj[@"id"]) {
                            @try
                            {
                                [tempArr addObject:(NSDictionary *)obj[@"id"]];
                            }
                            @catch(NSException *exc)
                            {
                                
                            }
                            @finally
                            {
                                
                            }
                            
                        }
                    }
                }];
                [self.delegate pushCategoryView:self ensureOfCates:[tempArr mutableCopy] orgs:[_selectOrgs mutableCopy]];
            }
        }
            break;
        default:
            break;
    }
}

- (void)respondsToCategoryBtnEvents:(UIButton *)sender{
    
    UIImageView *imageView = (UIImageView *)[sender viewWithTag:120];
    sender.layer.masksToBounds = YES;
    sender.layer.borderWidth = 0.4;
    if ([_selectOrgs containsObject:@(sender.tag)]) {
        [_selectOrgs removeObject:@(sender.tag)];
         sender.layer.borderColor = [UIColor whiteColor].CGColor;
         imageView.hidden = YES;
    }else{
        [_selectOrgs addObject:@(sender.tag)];
        sender.layer.borderColor = kSelectColor.CGColor;
        imageView.hidden = NO;

    }

}

#pragma mark - UICollectionViewDelgate && UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
    return _contentArr.count + (3-(_contentArr.count%3));
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NJCustomPushViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.masksToBounds = YES;
    cell.layer.borderWidth = 0.4;
    cell.layer.borderColor = [UIColor whiteColor].CGColor;
    if (indexPath.row>=_contentArr.count) {
        cell.typeName = @"";
        cell.isSelect = NO;
        return cell;
    }
    
    cell.typeName = _contentArr[indexPath.row][@"name"];
    NSDictionary *dict = _contentArr[indexPath.row];
    if ([_selectCategory containsObject:dict]) {
        cell.layer.borderColor = kSelectColor.CGColor;
        cell.isSelect = YES;
    }else{
        cell.isSelect = NO;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((CGRectGetWidth(self.containerView.frame)-1.3)/3, ((CGRectGetWidth(self.containerView.frame)-1.25)/3) *0.4);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row>=_contentArr.count) return;
    NSDictionary *dict = _contentArr[indexPath.row];
    if ([_selectCategory containsObject:dict]) {
        [_selectCategory removeObject:dict];
    }else{
        [_selectCategory addObject:dict];
    }
    [collectionView reloadData];
}

#pragma mark - getters and setters
- (UICollectionView *)artCollectionView{
    if (!_artCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0.45;
        layout.minimumInteritemSpacing = 0.6;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _artCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _artCollectionView.delegate = self;
        _artCollectionView.dataSource = self;
        [_artCollectionView registerClass:[NJCustomPushViewCell class] forCellWithReuseIdentifier:@"cell"];
        _artCollectionView.backgroundColor = _containerView.backgroundColor;
        _artCollectionView.showsVerticalScrollIndicator = NO;
        _artCollectionView.bounces = NO;
        
    }
    return _artCollectionView;
}

- (UIButton *)artGuoButton{
    if (!_artGuoButton) {
        _artGuoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _artGuoButton.titleLabel.font = [UIFont systemFontOfSize:13.f];
        _artGuoButton.backgroundColor = [UIColor whiteColor];
        [_artGuoButton setTitle:@"国内" forState:UIControlStateNormal];
        [_artGuoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
         _artGuoButton.tag = 2;
        [_artGuoButton addTarget:self action:@selector(respondsToCategoryBtnEvents:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *imageView = [UIImageView new];
        [_artGuoButton addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.equalTo(_artGuoButton);
            make.size.mas_equalTo(CGSizeMake(18, 22));
        }];
        imageView.tag = 120;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:@"pushSelectFlag"];
        imageView.hidden = YES;
    }
    return _artGuoButton;
}

- (UIButton *)artHaiButton{
    if (!_artHaiButton) {
        _artHaiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _artHaiButton.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [_artHaiButton setTitle:@"海淘" forState:UIControlStateNormal];
        _artHaiButton.backgroundColor = [UIColor whiteColor];
        [_artHaiButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
         _artHaiButton.tag = 1;
        [_artHaiButton addTarget:self action:@selector(respondsToCategoryBtnEvents:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *imageView = [UIImageView new];
        [_artHaiButton addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.equalTo(_artHaiButton);
            make.size.mas_equalTo(CGSizeMake(18, 22));
        }];
        imageView.tag = 120;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:@"pushSelectFlag"];
        imageView.hidden = YES;
    }
    return _artHaiButton;
}

- (UIButton *)artTianButton{
    if (!_artTianButton) {
        _artTianButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _artTianButton.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [_artTianButton setTitle:@"猫实惠" forState:UIControlStateNormal];
        _artTianButton.backgroundColor = [UIColor whiteColor];
       [_artTianButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _artTianButton.tag = 3;
       [_artTianButton addTarget:self action:@selector(respondsToCategoryBtnEvents:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *imageView = [UIImageView new];
        [_artTianButton addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.equalTo(_artTianButton);
            make.size.mas_equalTo(CGSizeMake(18, 22));
        }];
        imageView.tag = 120;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:@"pushSelectFlag"];
        imageView.hidden = YES;
    }
    return _artTianButton;
}


- (void)setContentArr:(NSArray *)contentArr{
    _contentArr = contentArr;
    NSMutableArray *tempArray = [NSMutableArray array];
    [_contentArr enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj) {
            if ((NSDictionary *)obj[@"id"]) {
                @try
                {
                    [tempArray addObject:(NSDictionary *)obj[@"id"]];
                }
                @catch(NSException *exc)
                {
                    
                }
                @finally
                {
                    
                }
                
            }
        }
    }];
    [MDB_UserDefault setAllPushCats:tempArray];
    [self.artCollectionView reloadData];
}

- (void)setHeaderTitle:(NSString *)headerTitle{
    _headerTitle = headerTitle;
    _headerTitleLabel.text = _headerTitle;
}

@end
