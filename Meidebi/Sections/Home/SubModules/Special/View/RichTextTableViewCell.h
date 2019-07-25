//
//  RichTextTableViewCell.h
//  Meidebi
//
//  Created by mdb-admin on 2017/5/16.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString * const kWebviewDidFinishLoadNotification = @"finishload";
@protocol RichTextTableViewCellDelegate <NSObject>

@optional - (void)webViewDidPreseeUrlWithLink:(NSString *)link;

@end

@interface RichTextTableViewCell : UITableViewCell
@property (nonatomic, weak) id<RichTextTableViewCellDelegate> delegate;
@property (nonatomic, readonly, assign) CGFloat cellHeight;
@property (nonatomic, copy) void(^webViewLoadFinished)(CGFloat cellHeight);
- (void)openRichTextWithUrl:(NSString *)linkUrl;
- (void)openRichTextWithLocalSource:(NSString *)source;

@end
