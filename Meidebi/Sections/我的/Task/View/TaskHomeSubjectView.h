//
//  TaskHomeSubjectView.h
//  Meidebi
//
//  Created by mdb-admin on 16/8/18.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TaskHomeSubjectView;
typedef NS_ENUM(NSInteger, HandleTaskType){
    HandleTaskTypeUnknown,
    HandleTaskTypeLogin,
    HandleTaskTypeShare,
    HandleTaskTypeBroke,
    HandleTaskTypeShaiDan,
};

@protocol TaskHomeSubjectViewDelegate <NSObject>

@optional
- (void)taskHomeSubjectViewDelegate:(TaskHomeSubjectView *)subjectView
      didPressHandleTaskBtnWithType:(HandleTaskType)type;

- (void)taskHomeSubjectViewDidPressMoreCardBtn;

@end

@interface TaskHomeSubjectView : UIView

@property (nonatomic, weak) id<TaskHomeSubjectViewDelegate> delegate;

- (void)updateData;
@end
