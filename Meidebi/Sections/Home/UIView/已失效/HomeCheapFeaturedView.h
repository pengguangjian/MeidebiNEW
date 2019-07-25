//
//  HomeCheapFeaturedView.h
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/8/22.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeCheapFeaturedViewDelegate <NSObject>

@optional - (void)cheapFeaturedViewDidSelectFeature:(NSString *)featureID;

@end

@interface HomeCheapFeaturedView : UIView
@property (nonatomic, weak) id<HomeCheapFeaturedViewDelegate> delegate;
- (void)bindDataWithModel:(NSArray *)model;

@end
