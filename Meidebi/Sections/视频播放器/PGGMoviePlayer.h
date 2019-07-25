//
//  PGGMoviePlayer.h
//  MoviePlayer
//
//  Created by mdb-losaic on 2018/5/17.
//  Copyright © 2018年 mcxzfa. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>

#import <AVKit/AVKit.h>

@interface PGGMoviePlayer : UIView

@property (nonatomic , retain) AVPlayerViewController *avc;

///该页面的父页面
@property (nonatomic , retain)UIView *playerSuperView;

///该页面的Frame
@property (nonatomic , assign)CGRect playerViewOriginalRect;

///该页面的中心点
@property (nonatomic , assign)CGPoint playerpoint;

///标题
@property (nonatomic , retain)NSString *strtitle;

///视频路径
-(void)playUrl:(NSString *)strurl;

@end
