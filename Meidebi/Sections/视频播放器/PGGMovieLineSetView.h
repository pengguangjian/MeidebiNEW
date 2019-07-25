//
//  PGGMovieLineSetView.h
//  MoviePlayer
//
//  Created by mdb-losaic on 2018/5/17.
//  Copyright © 2018年 mcxzfa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PGGMovieLineSetViewDelegate <NSObject>
///播放进度改变
- (void)videoBottomBarDidEndChangeSliderValue:(float)fsliderValue;
///开始和暂停
-(void)btstartAction;
///全屏
-(void)btquanpinAction;
///返回
-(void)btbackAction;

///重新播放
-(void)btAutostartAction;

@end

@interface PGGMovieLineSetView : UIView
///设置视频的长度
-(void)startValue:(NSString *)strvalue;

///时间自动更细
-(void)timeAuto:(NSString *)strvalue;

///yes播放 no暂停
-(void)changeplayBottonState:(BOOL)isstate;

///设置标题
-(void)titleValue:(NSString *)strtitle;

@property (nonatomic , retain) id<PGGMovieLineSetViewDelegate>delegate;

///是否全屏
@property (nonatomic , assign) BOOL isfullss;

@end
