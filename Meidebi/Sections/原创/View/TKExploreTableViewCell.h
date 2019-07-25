//
//  TKExploreTableViewCell.h
//  TaokeSecretary
//
//  Created by mdb-losaic on 2018/1/15.
//  Copyright © 2018年 leecool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKExploreViewModel.h"
#import "TKTopicItemLayout.h"
@class TKExploreTableViewCell;

@protocol TKExploreTableViewCellDelegate <NSObject>
@optional - (void)cellDidClick:(TKExploreTableViewCell *)cell;
@optional - (void)cell:(TKExploreTableViewCell *)cell didClickImageAtIndex:(NSInteger)index;
/// 点击了用户
- (void)cell:(TKExploreTableViewCell *)cell didClickUser:(NSString *)userid;
@end

@interface TKTopicItemProfileView : UIView
@property (nonatomic, strong) UIImageView *avatarView;              ///< 头像
@property (nonatomic, strong) YYLabel *nameLabel;
@property (nonatomic, strong) YYLabel *sourceLabel;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, weak) TKExploreTableViewCell *cell;
@end

@interface TKTopicItemCellToolBarView : UIView
@property (nonatomic, strong) UIButton *priseButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) YYLabel *timeLabel;
@property (nonatomic, weak) TKExploreTableViewCell *cell;
@end

@interface TKTopicItemCellStatusView : UIView
@property (nonatomic, strong) UIView *contentView;                  // 容器
@property (nonatomic, strong) TKTopicItemProfileView *profileView;  // 用户资料
@property (nonatomic, strong) TKTopicItemCellToolBarView *toolBarView;  // tool bar view
@property (nonatomic, strong) YYLabel *titleTextLabel;                   // 文本
@property (nonatomic, strong) YYLabel *textLabel;                    // 文本
@property (nonatomic, strong) NSArray<UIView *> *picViews;           // 图片
@property (nonatomic, strong) TKTopicItemLayout *layout;
@property (nonatomic, strong) UIButton *btVedio;  ///视频播放
@property (nonatomic, strong) UIImageView *imgvVedio;  ///视频播放
@property (nonatomic, weak) TKExploreTableViewCell *cell;



@end

@interface TKExploreTableViewCell : UITableViewCell
@property (nonatomic, weak) id<TKExploreTableViewCellDelegate> delegate;
@property (nonatomic, strong) TKTopicItemCellStatusView *statusView;
- (void)setLayout:(TKTopicItemLayout *)layout;
@end
