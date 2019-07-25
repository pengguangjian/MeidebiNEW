//
//  RewardCommentView.h
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/5.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RewardCommentView : UIView
@property (nonatomic, assign, readonly) CGFloat tableViewRowHeight;
@property (nonatomic, copy) void (^didSelctComment) (NSString *selctCommentStr);
- (void)bindDataWithComments:(NSArray *)comments;
- (void)updateDataWithcomments:(NSArray *)comments;
@end
