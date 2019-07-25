//
//  TKTopicSubjectView.h
//  TaokeSecretary
//
//  Created by mdb-losaic on 2018/1/16.
//  Copyright © 2018年 leecool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKTopicModuleConstant.h"
#import "TKExploreViewModel.h"
#import "YYPhotoGroupView.h"

@protocol TKTopicSubjectViewDelegate <NSObject>
@optional - (void)topicSubjectDidSelectItem:(NSString *)itemID;
@optional - (void)topicSubjectDidChangSort:(TopicSortStyle)style;
@optional - (void)topicSubjectDidClickPosteTopicButton;
@optional - (void)topicSubjectViewDidCickAvaterViewWithUserid:(NSString *)userid;
@optional - (void)photoGroupView:(YYPhotoGroupView *)photoGroupView
               didClickImageView:(UIView *)fromeView;

@optional - (void)lastPage;
@optional - (void)nextPage;
@end

@interface TKTopicSubjectView : UIView
@property (nonatomic, strong) NSString *posteCount;
@property (nonatomic, strong) NSString *commentCount;
@property (nonatomic, weak) id<TKTopicSubjectViewDelegate> delegate;

- (instancetype)initWithTopicType:(TKTopicType)type;
- (void)bindDataWithModel:(NSArray<TKTopicListViewModel *> *)models;

@end
