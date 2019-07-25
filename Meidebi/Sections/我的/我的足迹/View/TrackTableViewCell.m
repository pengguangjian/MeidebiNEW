//
//  TrackTableViewCell.m
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/8.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "TrackTableViewCell.h"
#import "MDB_UserDefault.h"
@interface TrackTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *siteLabel;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *flagImageView;
@property (nonatomic, strong) UIView *verticalLineView;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@end

@implementation TrackTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (UIImageView *)extracted {
    return [UIImageView new];
}

- (void)setupSubviews{
    UIImageView *flagImageView = [UIImageView new];
    [self.contentView addSubview:flagImageView];
    [flagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(50);
        make.top.equalTo(self.contentView.mas_top).offset(1);
        make.size.mas_equalTo(CGSizeMake(13, 13));
    }];
    flagImageView.image = [UIImage imageNamed:@"foot_print_flag"];
    flagImageView.hidden = YES;
    _flagImageView = flagImageView;
    
    _stateLabel = [UILabel new];
    [self.contentView addSubview:_stateLabel];
    [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(flagImageView.mas_right).offset(12);
        make.centerY.equalTo(flagImageView.mas_centerY);
    }];
    _stateLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    _stateLabel.font = [UIFont systemFontOfSize:14.f];

    UIView *verticalLineView = [UIView new];
    [self.contentView addSubview:verticalLineView];
    [verticalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(flagImageView.mas_centerX);
        make.top.equalTo(flagImageView.mas_bottom).offset(1);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.width.offset(1);
    }];
    verticalLineView.backgroundColor = [UIColor colorWithHexString:@"#BABABA"];
    verticalLineView.hidden = YES;
    _verticalLineView = verticalLineView;
    
    _dateLabel = [UILabel new];
    [self.contentView addSubview:_dateLabel];
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(8);
        make.right.equalTo(flagImageView.mas_left).offset(-5);
        make.top.equalTo(flagImageView.mas_top);
    }];
    _dateLabel.numberOfLines = 0;
    _dateLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    _dateLabel.font = [UIFont systemFontOfSize:12.f];
    
    UIView *containerView = [UIView new];
    [self.contentView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(27);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
        make.left.equalTo(_verticalLineView.mas_left).offset(20);
    }];
    containerView.backgroundColor = [UIColor whiteColor];
    _containerView = containerView;
    
    _iconImageView = [self extracted];
    [containerView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(containerView.mas_left).offset(18);
        make.top.equalTo(containerView.mas_top).offset(10);
        make.bottom.equalTo(containerView.mas_bottom).offset(-10);
        make.width.equalTo(_iconImageView.mas_height);
    }];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _titleLabel = [UILabel new];
    [containerView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.mas_right).offset(10);
        make.right.equalTo(containerView.mas_right).offset(-15);
        make.top.equalTo(containerView.mas_top).offset(12);
    }];
    _titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    _titleLabel.font = [UIFont systemFontOfSize:14.f];
    _titleLabel.numberOfLines = 2;
    
    _priceLabel = [UILabel new];
    [containerView addSubview:_priceLabel];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.mas_right).offset(10);
        make.right.equalTo(containerView.mas_right).offset(-15);
        make.top.equalTo(_titleLabel.mas_bottom).offset(7);
    }];
    _priceLabel.textColor = [UIColor colorWithHexString:@"#F2463A"];
    _priceLabel.font = [UIFont systemFontOfSize:12.f];
    
    _siteLabel = [UILabel new];
    [containerView addSubview:_siteLabel];
    [_siteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.mas_right).offset(10);
        make.right.equalTo(containerView.mas_right).offset(-15);
        make.top.equalTo(_priceLabel.mas_bottom).offset(7);
    }];
    _siteLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _siteLabel.font = [UIFont systemFontOfSize:12.f];
}

- (void)bindDataWithModel:(TrackEventModel *)model{
    if (!model) return;
    _flagImageView.hidden = NO;
    _verticalLineView.hidden = NO;
    [[MDB_UserDefault defaultInstance] setViewWithImage:_iconImageView url:model.iconImageLink];
    _stateLabel.text = model.handle;
    [_iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_containerView.mas_left).offset(18);
        make.top.equalTo(_containerView.mas_top).offset(10);
        make.bottom.equalTo(_containerView.mas_bottom).offset(-10);
        make.width.equalTo(_iconImageView.mas_height);
    }];
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.mas_right).offset(10);
        make.right.equalTo(_containerView.mas_right).offset(-15);
        make.top.equalTo(_containerView.mas_top).offset(12);
    }];

    if (model.type == TrackEventTypeSigin) {
        _titleLabel.hidden = YES;
        _siteLabel.hidden = YES;
        _priceLabel.hidden = YES;
        _containerView.hidden = YES;
    }else if (model.type == TrackEventTypeShowdan) {
        _titleLabel.text = model.title;
        _titleLabel.hidden = NO;
        _siteLabel.hidden = YES;
        _priceLabel.hidden = YES;
        _containerView.hidden = NO;
        [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_containerView.mas_left).offset(18);
            make.right.equalTo(_containerView.mas_right).offset(-15);
            make.top.equalTo(_containerView.mas_top).offset(12);
        }];
        [_iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_containerView.mas_left).offset(18);
            make.bottom.equalTo(_containerView.mas_bottom).offset(-10);
            make.top.equalTo(_titleLabel.mas_bottom).offset(10);
            make.right.equalTo(_containerView.mas_right).offset(-10);
        }];
    }else if (model.type == TrackEventTypeBeginUse){
        _titleLabel.hidden = YES;
        _siteLabel.hidden = YES;
        _priceLabel.hidden = YES;
        _containerView.hidden = YES;
        _verticalLineView.hidden = YES;
    }else{
        _titleLabel.text = model.title;
        _siteLabel.text = model.siteName;
        _priceLabel.text = model.orginprice;
        _titleLabel.hidden = NO;
        _siteLabel.hidden = NO;
        _priceLabel.hidden = NO;
        _containerView.hidden = NO;
    }
    
}

- (void)bindTimeDataWithContent:(NSString *)time{
    _dateLabel.text = time;
}

- (void)showSpanLineView:(BOOL)show{
    _verticalLineView.hidden = !show;
}

@end
