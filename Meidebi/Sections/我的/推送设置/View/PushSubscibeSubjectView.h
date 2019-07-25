//
//  PushSubscibeSubjectView.h
//  Meidebi
//
//  Created by mdb-admin on 16/9/18.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PushSubscibeSubjectView;
@protocol PushSubscibeSubjectViewDelegate <NSObject>

@optional;
- (void)subscibeSubjectView:(PushSubscibeSubjectView *)subjectView
            addPushKeywords:(NSArray *)keywords;

@end

@interface PushSubscibeSubjectView : UIView

- (void)bindDataWithPushKeys:(NSString *)keys;

-(void)bindHotKeys:(NSArray *)arrkeys;

@property (nonatomic, weak) id<PushSubscibeSubjectViewDelegate> delegate;

@end



@interface SubscibeKeyWordEmptyView : UIView

@end
