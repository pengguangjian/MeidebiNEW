//
//  RewardCommentTableViewCell.m
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/5.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "RewardCommentTableViewCell.h"

@interface RewardCommentTableViewCell ()

@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UILabel *commentWordLabel;
@end

@implementation RewardCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_commentButton];
    [_commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(8);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [_commentButton setImage:[UIImage imageNamed:@"reward_word_normal"] forState:UIControlStateNormal];
    [_commentButton setImage:[UIImage imageNamed:@"reward_word_normal"] forState:UIControlStateHighlighted];
    [_commentButton setImage:[UIImage imageNamed:@"reward_word_select"] forState:UIControlStateSelected];
    [_commentButton addTarget:self action:@selector(respondsToCommentWordBtn:) forControlEvents:UIControlEventTouchUpInside];
    _commentButton.hidden = YES;
    
    _commentWordLabel = [UILabel new];
    [self.contentView addSubview:_commentWordLabel];
    [_commentWordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_commentButton.mas_right);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.centerY.equalTo(_commentButton.mas_centerY);
    }];
    _commentWordLabel.numberOfLines = 2;
    _commentWordLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    _commentWordLabel.font = [UIFont systemFontOfSize:12.f];

}


- (void)bindDataWithModel:(NSString *)model withRowSelect:(BOOL)select{
    if (!model) return;
    _commentWordLabel.text = model;
    _commentButton.hidden = NO;
    if (select) {
        _commentButton.selected = YES;
    }else{
        _commentButton.selected = NO;
    }
}

- (void)respondsToCommentWordBtn:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(commentButtonDidClickWithTableViewCell:)]) {
        [self.delegate commentButtonDidClickWithTableViewCell:self];
    }
}




@end
