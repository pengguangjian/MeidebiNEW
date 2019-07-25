//
//  HomeNavTitleView.h
//  Meidebi
//
//  Created by mdb-admin on 2017/9/18.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeNavTitleViewDelegate<NSObject>

@optional - (void)titleViewDidClickSearchWithHotWord:(NSString *)keyword;

@end

@interface HomeNavTitleView : UIView
@property (nonatomic, weak) id<HomeNavTitleViewDelegate> delegate;
@property (nonatomic, strong) NSString *searchHotKeyWord;
@property(nonatomic, assign) CGSize intrinsicContentSize;
///设置搜索的背景颜色
-(void)setbackColor:(UIColor *)color;

@end
