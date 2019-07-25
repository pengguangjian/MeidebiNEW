//
//  ZLJunioMenuCollectionViewCell.m
//  FilterWares
//
//  Created by mdb-admin on 2016/11/21.
//  Copyright © 2016年 losaic. All rights reserved.
//

#import "ZLJuniorMenuCollectionViewCell.h"
#import "ZLMenuItem.h"
#import "MDB_UserDefault.h"
@interface ZLJuniorMenuCollectionViewCell ()

@property (nonatomic, strong) UIImageView *selectedImageView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation ZLJuniorMenuCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    
    _iconImageView = [UIImageView new];
    [self.contentView addSubview:_iconImageView];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;

    _nameLabel = [UILabel new];
    [self.contentView addSubview:_nameLabel];
    _nameLabel.font = [UIFont systemFontOfSize:12.f];
    _nameLabel.textColor = [UIColor colorWithHexString:@"#555555"];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView.mas_bottom).offset(7);
        make.left.right.equalTo(self.contentView);
    }];
    
    UIImageView *imageView = [UIImageView new];
    [self.contentView addSubview:imageView];
    imageView.frame = CGRectMake(CGRectGetWidth(self.contentView.frame)-18, CGRectGetHeight(self.contentView.frame)-22, 18, 22);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:@"pushSelectFlag"];
    imageView.hidden = YES;
    _selectedImageView = imageView;
}

#pragma mark - setters and getters
-  (void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    _selectedImageView.hidden = _isSelect;
}

- (void)setJuniorItem:(ZLMenuSubItem *)juniorItem{
    [[MDB_UserDefault defaultInstance] setViewWithImage:_iconImageView url:[NSString nullToString:juniorItem.itemImageUrl]];
    _nameLabel.text = [NSString nullToString:juniorItem.itemName];
    if ([[NSString nullToString:juniorItem.itemType] isEqualToString:@"1"] || [[NSString nullToString:juniorItem.itemType] isEqualToString:@"2"]) {
        [_iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        _nameLabel.hidden = YES;
    }else{
        _nameLabel.hidden = NO;
        [_iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.centerY.equalTo(self.contentView.mas_centerY).offset(-12);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
    }
}

@end
