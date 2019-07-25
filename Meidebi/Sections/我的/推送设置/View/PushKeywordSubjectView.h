//
//  PushKeywordSubjectView.h
//  Meidebi
//
//  Created by mdb-admin on 16/9/21.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PushKeywordSubjectView;
@protocol PushKeywordSubjectViewDelegate <NSObject>

@optional
- (void)updateViewHeight:(CGFloat)height;
- (void)keywordSubjectView:(PushKeywordSubjectView *)subjectView
         didChangeKeywords:(NSArray *)keys;

@end

@interface PushKeywordSubjectView : UIView

@property (nonatomic, weak) id<PushKeywordSubjectViewDelegate> delegate;
@property (nonatomic, strong) NSArray  *dataHistorySource;
@property (nonatomic, readonly, assign) CGFloat viewHeight;

@end
