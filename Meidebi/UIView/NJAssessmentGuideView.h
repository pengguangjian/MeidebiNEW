//
//  NJAssessmentGuideView.h
//  Meidebi
//
//  Created by mdb-admin on 16/6/1.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NJAssessmentGuideView;
@protocol NJAssessmentGuideViewDelegate <NSObject>

@optional - (void)assessmentGuideViewDidPressLinkBtn;

@end

@interface NJAssessmentGuideView : UIView

@property (nonatomic, weak) id<NJAssessmentGuideViewDelegate> delegate;
- (void)show;

@end
