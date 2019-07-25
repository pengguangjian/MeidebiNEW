//
//  ImagePlayerView.h
//  Meidebi
//
//  Created by 杜非 on 15/1/7.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol ImagePlayerViewDelegate;

@interface ImagePlayerView : UIView
@property(nonatomic,weak)id<ImagePlayerViewDelegate>imagePlayerViewDelegate;
@property(nonatomic,strong)UIPageControl *pageControl;
@property(nonatomic,strong)UIScrollView  *scrollView;
@property(nonatomic,assign)int            pagei;

- (void)setDelagateCount:(NSInteger)count delegate:(id<ImagePlayerViewDelegate>)delegate;

@end

@protocol ImagePlayerViewDelegate <NSObject>

@required

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index;

@optional

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index;
@end