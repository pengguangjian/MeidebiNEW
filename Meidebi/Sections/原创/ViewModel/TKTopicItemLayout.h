//
//  TKTopicItemLayout.h
//  TaokeSecretary
//
//  Created by mdb-losaic on 2018/1/15.
//  Copyright © 2018年 leecool. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYKit/YYKit.h>
#import "TKExploreViewModel.h"
#import "RemarkStatusHelper.h"

#define kTopicCellTopMargin 3      // cell 顶部灰色留白
#define kTopicCellToolbarBottomMargin 5 // cell 下方灰色留白
#define kTopicCellPadding 10       // cell 内边距
#define kTopicCellContentWidth (kScreenWidth - 2 * kTopicCellPadding) // cell 内容宽度
#define kTopicCellNameWidth (kScreenWidth - 110) // cell 名字最宽限制
#define kTopicCellPaddingPic 18     // cell 多张图片中间留白
#define kTopicCellPaddingText 4     // cell 文本与其他元素间留白
#define kTopicCellToolbarBottomHeight 15 // toobar高度

// 字体
#define kTpoicCellNameFontSize 11      // 名字字体大小
#define kTpoicCellSourceFontSize 10    // 来源字体大小
#define kTpoicCellTextFontSize 15      // 文本字体大小

#define kTopicCellNameNormalColor UIColorHex(333333) // 名字颜色
#define kTopicCellTimeNormalColor [UIColor colorWithHexString:@"#999999"] // 时间颜色
#define kTopicCellTextHighlightBackgroundColor UIColorHex(bfdffe) // Link 点击背景色
#define kTopicCellTextHighlightColor UIColorHex(527ead) // Link 文本色

#define kTopicLinkURLName @"url" //WBURL

@interface TKTopicItemLayout : NSObject
// 数据
@property (nonatomic, strong) TKTopicListViewModel *topic;

// 布局结果
// 顶部留白
@property (nonatomic, assign) CGFloat marginTop; //顶部灰色留白

// 个人资料
@property (nonatomic, assign) CGFloat profileHeight; //个人资料高度(包括留白)
@property (nonatomic, strong) YYTextLayout *nameTextLayout; // 名字
@property (nonatomic, strong) YYTextLayout *sourceTextLayout; //来源
@property (nonatomic, strong) YYTextLayout *timeTextLayout; //时间

// 文本
@property (nonatomic, assign) CGFloat textHeight; //文本高度(包括下方留白)
@property (nonatomic, assign) CGFloat titleTextHeight;
@property (nonatomic, strong) YYTextLayout *textLayout; //文本
@property (nonatomic, strong) YYTextLayout *titleTextLayout; //文本

// 图片
@property (nonatomic, assign) CGFloat picHeight; //图片高度，0为没图片
@property (nonatomic, assign) CGSize picSize;

// 操作区域
@property (nonatomic, assign) CGFloat handleHeight; //转发高度，0为没转发

// 下边留白
@property (nonatomic, assign) CGFloat marginBottom; //下边留白

// 总高度
@property (nonatomic, assign) CGFloat height;

- (instancetype)initWithTopics:(TKTopicListViewModel *)topic;
- (void)layout; ///< 计算布局
@end

/**
 文本 Line 位置修改
 将每行文本的高度和位置固定下来，不受中英文/Emoji字体的 ascent/descent 影响
 */
@interface TKTextLinePositionModifier : NSObject <YYTextLinePositionModifier>
@property (nonatomic, strong) UIFont *font; // 基准字体 (例如 Heiti SC/PingFang SC)
@property (nonatomic, assign) CGFloat paddingTop; //文本顶部留白
@property (nonatomic, assign) CGFloat paddingBottom; //文本底部留白
@property (nonatomic, assign) CGFloat lineHeightMultiple; //行距倍数
- (CGFloat)heightForLineCount:(NSUInteger)lineCount;
@end
