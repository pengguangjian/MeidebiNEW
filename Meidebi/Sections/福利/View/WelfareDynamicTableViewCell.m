//
//  WelfareDynamicTableViewCell.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/26.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "WelfareDynamicTableViewCell.h"
#import "MDB_UserDefault.h"
@interface WelfareDynamicTableViewCell ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *avaterImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *describleLabel;

@end

@implementation WelfareDynamicTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    _containerView = [UIView new];
    [self.contentView addSubview:_containerView];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 12, 0, 12));
    }];
    _containerView.backgroundColor = [UIColor whiteColor];
    
    _avaterImageView = [UIImageView new];
    [_containerView addSubview:_avaterImageView];
    [_avaterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_containerView.mas_top).offset(9);
        make.left.equalTo(_containerView.mas_left).offset(9);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    _avaterImageView.layer.masksToBounds = YES;
    _avaterImageView.layer.cornerRadius = 25;
    _avaterImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToAvaterTap:)];
    [_avaterImageView addGestureRecognizer:gesture];
    
    _nameLabel = [UILabel new];
    [_containerView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avaterImageView.mas_right).offset(11);
        make.bottom.equalTo(_avaterImageView.mas_centerY).offset(-3);
        make.right.equalTo(_containerView.mas_right).offset(-11);
    }];
    _nameLabel.font = [UIFont systemFontOfSize:12.f];
    _nameLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    
    _describleLabel = [UILabel new];
    [_containerView addSubview:_describleLabel];
    [_describleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avaterImageView.mas_right).offset(11);
        make.top.equalTo(_avaterImageView.mas_centerY).offset(3);
        make.right.equalTo(_containerView.mas_right).offset(-11);
    }];
    _describleLabel.font = [UIFont systemFontOfSize:14.f];
    _describleLabel.textColor = [UIColor colorWithHexString:@"#333333"];

}

- (void)respondsToAvaterTap:(UIGestureRecognizer *)gesture{
    if ([self.delegate respondsToSelector:@selector(welfareDynamicTableViewDidClickAvaterWithCell:)]) {
        [self.delegate welfareDynamicTableViewDidClickAvaterWithCell:self];
    }
}

- (void)bindDataWithModel:(NSDictionary *)dict{
    if (!dict) return;
    _describleLabel.text = [NSString nullToString:dict[@"mattername"]];
    _nameLabel.text = [NSString nullToString:dict[@"nickname"]];
    [[MDB_UserDefault defaultInstance] setViewWithImage:_avaterImageView url:[NSString nullToString:dict[@"photo"]]];
}

@end
