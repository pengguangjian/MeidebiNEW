//
//  RemarkTableViewMyRemarkCell.h
//  Meidebi
//
//  Created by mdb-admin on 2017/2/13.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalRemarkLayout.h"

@class RemarkTableViewMyRemarkCell;
@protocol RemarkTableViewMyRemarkCellDelegate <NSObject>
/// 点击了 Cell
- (void)cellDidClick:(RemarkTableViewMyRemarkCell *)cell;
/// 点击了图片
- (void)cell:(RemarkTableViewMyRemarkCell *)cell didClickImageAtIndex:(NSUInteger)index;
/// 点击了 Label 的链接
- (void)cell:(RemarkTableViewMyRemarkCell *)cell didClickInLabel:(YYLabel *)label textRange:(NSRange)textRange;

@end


@interface PersonalRemarkStatusProfileView : UIView
@property (nonatomic, strong) YYLabel *nameLabel;
@property (nonatomic, strong) YYLabel *sourceLabel;
@property (nonatomic, strong) UIView *septalLineView;
@property (nonatomic, weak) RemarkTableViewMyRemarkCell *cell;

@end


@interface PersonalRemarkCellStatusView : UIView
@property (nonatomic, strong) UIView *contentView;              // 容器
@property (nonatomic, strong) PersonalRemarkStatusProfileView *profileView; // 用户资料
@property (nonatomic, strong) YYLabel *textLabel;               // 文本
@property (nonatomic, strong) YYLabel *textRemarkLabel;               // 文本
@property (nonatomic, strong) NSArray<UIView *> *picViews;      // 图片
@property (nonatomic, strong) UIView *retweetBackgroundView;    //转发容器
@property (nonatomic, strong) YYLabel *retweetTextLabel;        // 转发文本
@property (nonatomic, strong) UIImageView *avatarView; ///< 头像
@property (nonatomic, strong) YYLabel *nameLabel;
@property (nonatomic, strong) YYLabel *sourceLabel;

@property (nonatomic, strong) PersonalRemarkLayout *layout;
@property (nonatomic, weak) RemarkTableViewMyRemarkCell *cell;
@end

@interface RemarkTableViewMyRemarkCell : UITableViewCell

@property (nonatomic, weak) id<RemarkTableViewMyRemarkCellDelegate> delegate;
@property (nonatomic, strong) PersonalRemarkCellStatusView *statusView;
- (void)setLayout:(PersonalRemarkLayout *)layout;

@end
