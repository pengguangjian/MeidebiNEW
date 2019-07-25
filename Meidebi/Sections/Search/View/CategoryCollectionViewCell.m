//
//  CategoryCollectionViewCell.m
//  Meidebi
//
//  Created by mdb-admin on 16/4/7.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "CategoryCollectionViewCell.h"
#import "MDB_UserDefault.h"

static UIEdgeInsets kPadding = {0,2,0,2};

@interface CategoryCollectionViewCell ()

@property (nonatomic, strong) UIView *historyContairView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@end

@implementation CategoryCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}


- (void)setupSubviews{
    
    _iconImageView = ({
        UIImageView *imageView = [UIImageView new];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self).centerOffset(CGPointMake(0, -15));
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        imageView.userInteractionEnabled = YES;
        imageView;
    });
    
    _nameLabel = ({
        UILabel *label = [UILabel new];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_iconImageView.mas_bottom).offset(15);
            make.centerX.equalTo(self.mas_centerX);
        }];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:14.f];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    
}

- (void)setName:(NSString *)name{
    _name = name;
    if ([_name isEqualToString:@""]) {
        _nameLabel.hidden = YES;
        return;
    }else{
        _nameLabel.hidden = NO;
    }
    _nameLabel.text = name;
}

- (void)setIconImageLink:(NSString *)iconImageLink{
    _iconImageLink = iconImageLink;
    if ([iconImageLink isEqualToString:@""]) {
        _iconImageView.hidden = YES;
        return;
    }else{
        _iconImageView.hidden = NO;
    }
    
    
    
}

- (void)setCellType:(CollectionCellType)cellType{
    _cellType = cellType;
    if (_cellType == CollectionCellTypeCategory) {
        [_iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self).centerOffset(CGPointMake(0, -15));
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        [_nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_iconImageView.mas_bottom).offset(15);
            make.centerX.equalTo(self.mas_centerX);
        }];
        
        [[MDB_UserDefault defaultInstance] setViewWithImage:_iconImageView url:_iconImageLink];
    }else{
        [_nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.left.right.equalTo(self);
        }];
        [_iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(kPadding);
        }];
        
        [[MDB_UserDefault defaultInstance] setViewWithImage:_iconImageView url:_iconImageLink image:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                _nameLabel.hidden = YES;
            }
        }];

    }
    [self layoutIfNeeded];
}




@end
