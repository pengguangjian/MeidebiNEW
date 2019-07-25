//
//  PGGMoviePlayer.m
//  MoviePlayer
//
//  Created by mdb-losaic on 2018/5/17.
//  Copyright © 2018年 mcxzfa. All rights reserved.
//

#import "PGGMoviePlayer.h"

#import "PGGMovieLineSetView.h"

@interface PGGMoviePlayer ()<AVPlayerViewControllerDelegate,AVPictureInPictureControllerDelegate,PGGMovieLineSetViewDelegate>
{
    AVPlayer * player;
    CGFloat _viewLength;
    float currenttime;
    BOOL isFullscreen;
    NSURL * videlurl;
    
    UIInterfaceOrientation currentOrientation;
    UIView *playerSuperView;
    CGRect playerViewOriginalRect;
}

@property(nonatomic,retain)AVPlayerItem * playItem;

@property(nonatomic,retain)PGGMovieLineSetView *lineView;

@end

@implementation PGGMoviePlayer

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        
        self.avc = [[AVPlayerViewController alloc] init];
        [self addSubview:self.avc.view];
        
        self.lineView = [[PGGMovieLineSetView alloc] init];
        [self.lineView setDelegate:self];
        [self addSubview:self.lineView];
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.avc.view setFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [self.lineView setFrame:CGRectMake(0, 0, self.avc.view.bounds.size.width, self.avc.view.bounds.size.height)];
    if(_strtitle==nil)_strtitle=@"";
    [self.lineView titleValue:_strtitle];
    
    playerViewOriginalRect = self.playerViewOriginalRect;
    playerSuperView = self.playerSuperView;
    
    
}

-(void)playUrl:(NSString *)strurl
{
    
    NSURL *urlplay = [NSURL URLWithString:strurl];
    
    //确定视频资源 一个视频用一个item
    self.playItem=[AVPlayerItem playerItemWithURL:urlplay];
    //确定视频视频框架
    player = [AVPlayer playerWithPlayerItem: self.playItem];
    
    self.avc.player=player;
    
    //隐藏系统自带的进度条播放界面
    self.avc.showsPlaybackControls = NO;
    
    player.externalPlaybackVideoGravity=AVLayerVideoGravityResizeAspectFill;
    
    //获取视频信息，要用item添加kvo,编程的时候最好使用item 的status，会准确点。
    [ self.playItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
}

///监听播放状态
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        switch (self.playItem.status) {
            case AVPlayerItemStatusReadyToPlay:
            {
                //视频总长度
                _viewLength=self.playItem.duration.value*1/ self.playItem.duration.timescale;
                // 设置播放进度UI
                NSLog(@"%lf",_viewLength);
                [self.lineView startValue:[NSString stringWithFormat:@"%.0lf",_viewLength]];
                [self.avc.player play];
                [self timeauto];
            }
                break;
            case AVPlayerItemStatusFailed:
                NSLog(@"出错了");
                break;
            default:
                NSLog(@"不知道什么问题？");
                break;
        }
        
    }
//    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
//        if (videlurl) {
//            NSTimeInterval timeInterval = [self availableDuration];// 计算缓冲进度
//            NSLog(@"Time Interval:%f",timeInterval);
//            CMTime duration = self.playItem.duration;
//            CGFloat totalDuration = CMTimeGetSeconds(duration);
//            self.setview.schedule.trackTintColor=[UIColor grayColor];
//            self.setview.schedule.progress=timeInterval/totalDuration;
//
//        }
//    }
//
}


///时间自动走
-(void)timeauto
{
    __weak typeof(self) weakSelf = self;
    //设置检查频率，1s更新一次这个block
    CMTime time = CMTimeMake(1.0, 1.0);
    [self.avc.player addPeriodicTimeObserverForInterval:time queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        //当前播放时间
        currenttime =self.playItem.currentTime.value/self.playItem.currentTime.timescale;
        [weakSelf.lineView timeAuto:[NSString stringWithFormat:@"%d",(int)currenttime]];
        if(currenttime == _viewLength)
        {
            ispause=YES;
        }
        
    }];
}

#pragma mark - PGGMovieLineSetViewDelegate
- (void)videoBottomBarDidEndChangeSliderValue:(float)fsliderValue
{
    [self.avc.player seekToTime:CMTimeMakeWithSeconds(fsliderValue, NSEC_PER_SEC) completionHandler:^(BOOL finished) {
        
    }];
    
}
bool ispause=NO;
-(void)btstartAction
{
    ispause=!ispause;
    if (ispause) {
        [self.avc.player pause];
        [self.lineView changeplayBottonState:NO];
    }else{
        
        if(currenttime == _viewLength)
        {
            [self.avc.player seekToTime:CMTimeMakeWithSeconds(0, NSEC_PER_SEC) completionHandler:^(BOOL finished) {
                [self.avc.player play];
            }];
            [self.lineView changeplayBottonState:YES];
        }
        else
        {
            [self.avc.player play];
            [self.lineView changeplayBottonState:YES];
        }
        
    }
    
}

-(void)btquanpinAction
{
    //全屏(横屏frame计算)
    if(isFullscreen)
    {
        [self changeToOrientation:UIInterfaceOrientationPortrait];
    }
    else
    {
        [self changeToOrientation:UIInterfaceOrientationLandscapeLeft];
    }
    self.lineView.isfullss = isFullscreen;
}

bool isquanpin=NO;
///返回
-(void)btbackAction
{
//    if(isquanpin)
//    {
//        [self changeToOrientation:UIInterfaceOrientationPortrait];
//    }
//    else
//    {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self.avc.player pause];
    [self removeFromSuperview];
//    }
    
    
}

///重新播放
-(void)btAutostartAction
{
    [self.avc.player seekToTime:CMTimeMakeWithSeconds(0, NSEC_PER_SEC) completionHandler:^(BOOL finished) {
        [self.avc.player play];
    }];
    
}

#pragma mark - Orientation Methods
- (void)changeToOrientation:(UIInterfaceOrientation)orientation {
    if (currentOrientation == orientation) {
        return;
    }
    currentOrientation = orientation;
    
    [self removeFromSuperview];
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            
            __weak typeof(self) weakSelf = self;
            [weakSelf setFrame:CGRectMake(0, 0, playerViewOriginalRect.size.height, playerViewOriginalRect.size.width)];
            [weakSelf setCenter:self.playerpoint];
            [playerSuperView addSubview:weakSelf];
            isquanpin = NO;
            
            break;
        }
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
        {
            [[UIApplication sharedApplication].keyWindow addSubview:self];
            [self setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width)];
            [self setCenter:[UIApplication sharedApplication].keyWindow.center];
            isquanpin = YES;
            break;
        }
        default:
            break;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = [self getTransformWithOrientation:orientation];
    }];
    
}


- (CGAffineTransform)getTransformWithOrientation:(UIInterfaceOrientation)orientation {
    if (orientation == UIInterfaceOrientationPortrait) {
        [self updateToVerticalOrientation];
        return CGAffineTransformIdentity;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft) {
        [self updateToHorizontalOrientation];
        return CGAffineTransformMakeRotation(M_PI_2);
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        [self updateToHorizontalOrientation];
        return CGAffineTransformMakeRotation(-M_PI_2);
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        [self updateToVerticalOrientation];
        return CGAffineTransformMakeRotation(M_PI);
    }
    return CGAffineTransformIdentity;
}

- (void)updateToVerticalOrientation {
    isFullscreen = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)updateToHorizontalOrientation {
    isFullscreen = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}





@end
