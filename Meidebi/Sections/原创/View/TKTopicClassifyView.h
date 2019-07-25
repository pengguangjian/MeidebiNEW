//
//  TKTopicClassifyView.h
//  TaokeSecretary
//
//  Created by mdb-losaic on 2018/1/12.
//  Copyright © 2018年 leecool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKTopicModuleConstant.h"
@protocol TKTopicClassifyViewDelegate <NSObject>

@optional - (void)topicClassifyViewDidSelectType:(TKTopicType)type;

@end

@interface TKTopicClassifyView : UIView
@property (nonatomic, weak) id<TKTopicClassifyViewDelegate> delegate;
- (void)starScroll;
@end
