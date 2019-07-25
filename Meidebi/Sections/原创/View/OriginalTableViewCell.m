//
//  OriginalTableViewCell.m
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/21.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "OriginalTableViewCell.h"
#import "MDB_UserDefault.h"
@interface OriginalTableViewCell ()
<
NJFlagViewDelegate
>
@property (nonatomic, strong) UIImageView *avaterImageView;
@property (nonatomic, strong) UILabel *nikNameLabel;
@property (nonatomic, strong) UIImageView *livelBgImageView;
@property (nonatomic, strong) UILabel *livelLabel;
@property (nonatomic, strong) UIButton *followBtn;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NJFlagView *flagView;
@property (nonatomic, strong) UILabel *describeLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *likeNumberLabel;
@property (nonatomic, strong) UILabel *remarkNumberLabel;
@property (nonatomic, strong) UIImageView *remarkImageView;
@property (nonatomic, strong) UIImageView *likeIconImageView;
@property (nonatomic, assign) CGFloat flagViewHeight;
@end

@implementation OriginalTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _flagViewHeight = 1;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    _avaterImageView = ({
        UIImageView *imageView = [UIImageView new];
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(16);
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 30.0/2;
        imageView.userInteractionEnabled = YES;
        imageView;
    });
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToAvaterView:)];
    [_avaterImageView addGestureRecognizer:tapGesture];
    
    _nikNameLabel = ({
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avaterImageView.mas_right).offset(9);
            make.centerY.equalTo(_avaterImageView.mas_centerY);
        }];
        label.textColor = [UIColor colorWithHexString:@"#666666"];
        label.font = [UIFont systemFontOfSize:12];
        label;
    });
    
    UIImageView *livelBgImageView = [UIImageView new];
    [self.contentView addSubview:livelBgImageView];
    [livelBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nikNameLabel.mas_right).offset(10);
        make.centerY.equalTo(_nikNameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(17, 17));
    }];
    livelBgImageView.image = [UIImage imageNamed:@"dengji.jpg"];
    livelBgImageView.hidden = YES;
    _livelBgImageView = livelBgImageView;
    
    _livelLabel = [UILabel new];
    [livelBgImageView addSubview:_livelLabel];
    [_livelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(livelBgImageView.mas_right).offset(-0.5);
        make.bottom.equalTo(livelBgImageView.mas_bottom).offset(-1);
    }];
    _livelLabel.textColor = [UIColor whiteColor];
    _livelLabel.font = [UIFont systemFontOfSize:5.5];
    _livelLabel.textAlignment = NSTextAlignmentRight;
    
    UIButton *followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:followBtn];
    [followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-16);
        make.centerY.equalTo(_avaterImageView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(51, 20));
    }];
    followBtn.titleLabel.font = [UIFont systemFontOfSize:11.f];
    [followBtn setTitleColor:[UIColor colorWithHexString:@"#F27A30"] forState:UIControlStateNormal];
    [followBtn setTitle:@"+ 关注" forState:UIControlStateNormal];
    [followBtn addTarget:self action:@selector(respondsToFollowBtn:) forControlEvents:UIControlEventTouchUpInside];
    followBtn.layer.masksToBounds = YES;
    followBtn.layer.cornerRadius = 4.f;
    followBtn.layer.borderWidth = 1.f;
    followBtn.layer.borderColor = [UIColor colorWithHexString:@"#F27A30"].CGColor;
    followBtn.hidden = YES;
    _followBtn = followBtn;
    
    UIImageView *iconImageView = [UIImageView new];
    [self.contentView addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(_avaterImageView.mas_bottom).offset(10);
        make.height.equalTo(iconImageView.mas_width).multipliedBy(0.463);
    }];
    iconImageView.layer.masksToBounds = YES;
    iconImageView.layer.cornerRadius = 4.f;
    iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    _iconImageView = iconImageView;
    
    UILabel *titleLabel = [UILabel new];
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_iconImageView);
        make.top.equalTo(_iconImageView.mas_bottom).offset(16);
        make.height.offset(35);
    }];
    titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
    titleLabel.numberOfLines = 2;
    titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    _titleLabel  = titleLabel;
    
    _flagView = [NJFlagView new];
    [self.contentView addSubview:_flagView];
    [_flagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(5);
        make.left.right.equalTo(self.contentView);
        make.height.offset(_flagViewHeight);
    }];
    _flagView.titleType = FlagTitleTypeNoTitle;
    _flagView.delegate = self;

    
    UILabel *describeLabel = [UILabel new];
    [self.contentView addSubview:describeLabel];
    [describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_iconImageView);
        make.top.equalTo(_flagView.mas_bottom);
//        make.height.offset(30);
    }];
    describeLabel.font = [UIFont systemFontOfSize:13.f];
    describeLabel.numberOfLines = 3;
    describeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    _describeLabel = describeLabel;
    UIView *originalInfoView = [UIView new];
    [self.contentView addSubview:originalInfoView];
    [originalInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_describeLabel.mas_bottom).offset(14);
        make.left.right.equalTo(_iconImageView);
        make.height.offset(15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-20);
    }];
    
    _timeLabel = [UILabel new];
    [originalInfoView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(originalInfoView);
    }];
    _timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _timeLabel.font = [UIFont systemFontOfSize:12.f];
    
    _remarkNumberLabel = [UILabel new];
    [originalInfoView addSubview:_remarkNumberLabel];
    [_remarkNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(originalInfoView.mas_right);
        make.centerY.equalTo(originalInfoView.mas_centerY);
    }];
    _remarkNumberLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _remarkNumberLabel.font = [UIFont systemFontOfSize:12.f];

    UIImageView *remarkImageView = [UIImageView new];
    [originalInfoView addSubview:remarkImageView];
    [remarkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_remarkNumberLabel.mas_left).offset(-5);
        make.centerY.equalTo(originalInfoView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    remarkImageView.hidden = YES;
    remarkImageView.contentMode = UIViewContentModeScaleAspectFit;
    remarkImageView.image = [UIImage imageNamed:@"discount_comment_normal"];
    _remarkImageView = remarkImageView;
    
    UIView *lineView = [UIView new];
    [originalInfoView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(remarkImageView.mas_left).offset(-10);
        make.top.bottom.equalTo(_remarkNumberLabel);
        make.width.offset(1);
    }];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    
    _likeNumberLabel = [UILabel new];
    [originalInfoView addSubview:_likeNumberLabel];
    [_likeNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lineView.mas_left).offset(-10);
        make.centerY.equalTo(originalInfoView.mas_centerY);
    }];
    _likeNumberLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _likeNumberLabel.font = [UIFont systemFontOfSize:12.f];

    UIImageView *likeIconImageView = [UIImageView new];
    [originalInfoView addSubview:likeIconImageView];
    [likeIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_likeNumberLabel.mas_left).offset(-5);
        make.centerY.equalTo(originalInfoView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    likeIconImageView.hidden = YES;
    likeIconImageView.contentMode = UIViewContentModeScaleAspectFit;
    likeIconImageView.image = [UIImage imageNamed:@"home_like_normal"];
    _likeIconImageView = likeIconImageView;
    
    for (UILabel *view in @[_titleLabel, _describeLabel]) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [view setContentHuggingPriority:250.f forAxis:UILayoutConstraintAxisHorizontal];
        [view setContentHuggingPriority:250.f forAxis:UILayoutConstraintAxisVertical];
        [view setContentCompressionResistancePriority:998.f forAxis:UILayoutConstraintAxisHorizontal];
        [view setContentCompressionResistancePriority:998.f forAxis:UILayoutConstraintAxisVertical];
    }
}

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (void)updateConstraints{
    [self.flagView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(_flagViewHeight);
    }];
    [super updateConstraints];
}

- (void)respondsToAvaterView:(UIGestureRecognizer *)gesture{
    if ([self.delegate respondsToSelector:@selector(tableViewCellDidClickAvaterImageView:)]) {
        [self.delegate tableViewCellDidClickAvaterImageView:self];
    }
}

- (void)respondsToFollowBtn:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(tableViewCellDidClickFollowBtn:)]) {
        [self.delegate tableViewCellDidClickFollowBtn:self];
    }
}

- (void)bindDataWithModel:(Sharecle *)model{
    if (!model) return;
    _remarkImageView.hidden = NO;
    _likeIconImageView.hidden = NO;
    _followBtn.hidden = NO;
    [[MDB_UserDefault defaultInstance] setViewWithImage:_avaterImageView url:model.headphoto];
    [[MDB_UserDefault defaultInstance] setViewWithImage:_iconImageView url:model.pic];
    _nikNameLabel.text = model.name;
    if (![@"" isEqualToString:model.userLevel]) {
        _livelBgImageView.hidden = NO;
    }
    _livelLabel.text = model.userLevel;
    _titleLabel.text = model.title;
    NSMutableArray *tags = [NSMutableArray array];
    for (NSString *tagStr in model.tags) {
        if (![@"" isEqualToString:tagStr]) {
            [tags addObject:@{@"name":tagStr,
                              @"type":@"1"}];
        }
    }
    [_flagView flag:tags.mutableCopy];
    if (tags.count > 0) {
        _flagViewHeight = 50.f;
        _flagView.hidden = NO;
    }else{
        _flagViewHeight = 1.f;
        _flagView.hidden = YES;
    }
    _describeLabel.text = model.content;
    _timeLabel.text = [MDB_UserDefault strTimefromDatas:[NSDate dateWithTimeIntervalSince1970:[model.createtime integerValue]] dataFormat:@"yyyy-MM-dd HH:mm"];
    _likeNumberLabel.text = [NSString stringWithFormat:@"%@",model.votesp];
    _remarkNumberLabel.text =[NSString stringWithFormat:@"%@",model.commentcount];
    if (model.isFllow) {
        _followBtn.userInteractionEnabled = NO;
        [_followBtn setTitle:@"已关注" forState:UIControlStateNormal];
        [_followBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [_followBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateHighlighted];
        _followBtn.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
        
    }else{
        _followBtn.userInteractionEnabled = YES;
        [_followBtn setTitle:@"+ 关注" forState:UIControlStateNormal];
        [_followBtn setTitleColor:[UIColor colorWithHexString:@"#F27A30"] forState:UIControlStateNormal];
        [_followBtn setTitleColor:[UIColor colorWithHexString:@"#F27A30"] forState:UIControlStateHighlighted];
        _followBtn.layer.borderColor = [UIColor colorWithHexString:@"#F27A30"].CGColor;
    }
    // tell constraints they need updating
    [self setNeedsUpdateConstraints];
    // update constraints now so we can animate the change
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
    __weak __typeof__(self) weakSelf = self;
    _flagView.callback = ^(CGFloat height) {
        _flagViewHeight = height;
        // tell constraints they need updating
        [weakSelf setNeedsUpdateConstraints];
        // update constraints now so we can animate the change
        [weakSelf updateConstraintsIfNeeded];
        [weakSelf layoutIfNeeded];
    };
}

- (CGRect)calculateTextHeightWithText:(NSString *)text
                             fontSize:(CGFloat)size{
    CGSize maxSize = CGSizeMake(kMainScreenW-30, MAXFLOAT);
    CGRect contentRect = [text boundingRectWithSize:maxSize
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]}
                                            context:nil];
    return contentRect;
}

#pragma mark - NJFlagViewDelegate
- (void)flageViewDidClickItem:(NSDictionary *)item type:(FlagType)type{
    if ([self.delegate respondsToSelector:@selector(tableViewCellDidClickFlageWithItem:)]){
        [self.delegate tableViewCellDidClickFlageWithItem:item];
    }
}

@end
