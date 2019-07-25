//
//  TKTopicComposeSubjectView.h
//  TaokeSecretary
//
//  Created by mdb-losaic on 2018/1/17.
//  Copyright © 2018年 leecool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKTopicModuleConstant.h"

@protocol TKTopicComposeSubjectViewDelegate <NSObject>
@optional - (void)topicComposeSubjectViewStarSelectImageWithTarget:(UIViewController *)vc;
@optional - (void)topicComposeDidSelectPictures:(NSArray *)pictures;
@optional - (void)topicComposeDidWriteContent:(NSString *)content;
@optional - (void)topicComposeDidWriteTitle:(NSString *)title;

- (void)topicComposeBottomActionTag:(NSInteger)tag;

- (void)topicComposeTopicType:(TKTopicType)type;

@end

@interface TKTopicComposeSubjectView : UIView
@property (nonatomic, weak) id<TKTopicComposeSubjectViewDelegate> delegate;
- (instancetype)initWithTopicType:(TKTopicType)type;
- (void)registerKeyWord;

///草稿数据
-(void)caogaoValue:(NSDictionary *)dicvalue;

@end
