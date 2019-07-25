//
//  FindCouponCollectionViewCell.m
//  Meidebi
//
//  Created by mdb-admin on 2017/7/7.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "FindCouponCollectionViewCell.h"
#import "MDB_UserDefault.h"
@interface FindCouponCollectionViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation FindCouponCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    _iconImageView = [UIImageView new];
    [self.contentView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(6, 6, 6, 6));
    }];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)bindDataWithModel:(NSDictionary *)dict{
    if(![dict isKindOfClass:[NSDictionary class]] || dict == nil)
    {
        return;
    }
    NSString *strurl = [NSString stringWithFormat:@"%@",[NSString nullToString:[dict objectForKey:@"image"]]];
    [[MDB_UserDefault defaultInstance]setViewWithImage:_iconImageView url:strurl];
}
@end
