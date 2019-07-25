//
//  RemarkTableViewCell.h
//  Meidebi
//
//  Created by mdb-admin on 2017/2/8.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemarkStatusLayout.h"

@class RemarkHomeTableViewCell;
@protocol RemarkHomeTableViewCellDelegate <NSObject>
@optional
/// 点击了 Cell
- (void)cellDidClick:(RemarkHomeTableViewCell *)cell;
/// 点击了图片
- (void)cell:(RemarkHomeTableViewCell *)cell didClickImageAtIndex:(NSUInteger)index;
/// 点击了 Label 的链接
- (void)cell:(RemarkHomeTableViewCell *)cell didClickInLabel:(YYLabel *)label textRange:(NSRange)textRange;

- (void)cell:(RemarkHomeTableViewCell *)cell didClickInAgainBtn:(UIButton *)button;

- (void)cell:(RemarkHomeTableViewCell *)cell didClickInAbandonBtn:(UIButton *)button;
/// 点击了用户
- (void)cell:(RemarkHomeTableViewCell *)cell didClickUser:(NSString *)userid;

///用户点击了赞
-(void)cell:(RemarkHomeTableViewCell *)cell disClickZan:(Remark *)strid;

@end


@interface RemarkStatusProfileView : UIView
@property (nonatomic, strong) UIImageView *avatarView; ///< 头像
@property (nonatomic, strong) UIImageView *avatarBadgeView; ///< 徽章
@property (nonatomic, strong) YYLabel *nameLabel;
@property (nonatomic, strong) YYLabel *sourceLabel;
@property (nonatomic, strong) UIButton *againBtn;
@property (nonatomic, strong) UIButton *abandonBtn;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, weak) RemarkHomeTableViewCell *cell;

@property (nonatomic, strong) UIButton *btzan;

@end

@interface RemarkGiftProfileView : UIView
@property (nonatomic, strong) UIImageView *giftImageView;
@property (nonatomic, strong) YYLabel *giftDescribeLabel;
@property (nonatomic, weak) RemarkHomeTableViewCell *cell;
@end


@interface RemarkCellStatusView : UIView
@property (nonatomic, strong) UIView *contentView;              // 容器
@property (nonatomic, strong) RemarkStatusProfileView *profileView; // 用户资料
@property (nonatomic, strong) RemarkGiftProfileView *giftProfileView;
@property (nonatomic, strong) YYLabel *textLabel;               // 文本
@property (nonatomic, strong) NSArray<UIView *> *picViews;      // 图片
@property (nonatomic, strong) UIView *retweetBackgroundView;    //转发容器
@property (nonatomic, strong) YYLabel *retweetTextLabel;        // 转发文本
@property (nonatomic, strong) UIImageView *avatarView; ///< 头像
@property (nonatomic, strong) YYLabel *nameLabel;
@property (nonatomic, strong) YYLabel *sourceLabel;

@property (nonatomic, strong) RemarkStatusLayout *layout;
@property (nonatomic, weak) RemarkHomeTableViewCell *cell;
@end


@interface RemarkHomeTableViewCell : UITableViewCell
@property (nonatomic, weak) id<RemarkHomeTableViewCellDelegate> delegate;
@property (nonatomic, strong) RemarkCellStatusView *statusView;
- (void)setLayout:(RemarkStatusLayout *)layout;
@end
