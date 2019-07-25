//
//  ActivityConcernView.h
//  Meidebi
//
//  Created by fishmi on 2017/5/15.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ActivityConcernViewDelegate <NSObject>

- (void)detailSubjectViewDidCickAddFollowdidComplete:(void (^)(BOOL))didComplete;
- (void)imageViewClicked;
@end

@interface ActivityConcernView : UIView
@property (nonatomic ,weak) id <ActivityConcernViewDelegate> delegate;
@property (nonatomic ,strong) UILabel *nameLabel;
@property (nonatomic ,strong) UILabel *subLabel;
@property (nonatomic ,strong) UIImageView *imageV;
@property (nonatomic ,strong) UIButton *concernBtn;

@end
