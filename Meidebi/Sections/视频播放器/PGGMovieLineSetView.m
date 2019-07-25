//
//  PGGMovieLineSetView.m
//  MoviePlayer
//
//  Created by mdb-losaic on 2018/5/17.
//  Copyright © 2018年 mcxzfa. All rights reserved.
//

#import "PGGMovieLineSetView.h"

@interface PGGMovieLineSetView ()
{
    NSTimer *timer;
}

@property (nonatomic , retain)UIView *viewbottom;
///播放、暂停
@property (nonatomic , retain)UIButton *btplay;
///进度条
@property (nonatomic , retain)UISlider *slider;
///全屏
@property (nonatomic , retain)UIButton *btquanpin;
///
@property (nonatomic , retain)UILabel *lbstart;
@property (nonatomic , retain)UILabel *lbend;

@property (nonatomic , assign) int inumbers;

@property (nonatomic , retain)UIButton *btallplay;

/////头部
@property (nonatomic , retain)UIView *viewtop;
///返回
@property (nonatomic , retain)UIButton *btback;
///标题
@property (nonatomic , retain)UILabel *lbtitle;


@end

@implementation PGGMovieLineSetView

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
        _viewbottom = [[UIView alloc] initWithFrame:CGRectZero];
        [_viewbottom setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]];
        [self addSubview:_viewbottom];
        
        _btplay = [[UIButton alloc] initWithFrame:CGRectZero];
        [_btplay setImage:[UIImage imageNamed:@"vedio_puse"] forState:UIControlStateNormal];
        [_viewbottom addSubview:_btplay];
        [_btplay addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
        
        _slider = [[UISlider alloc] initWithFrame:CGRectZero];
        [_slider setMinimumValue:0];
        [_slider setMinimumTrackTintColor:[UIColor whiteColor]];
        [_slider setMaximumTrackTintColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.35]];
        [_slider setThumbImage:[UIImage imageNamed:@"slider_nomo.png"] forState:UIControlStateNormal];
        [_slider setThumbImage:[UIImage imageNamed:@"slider_select.png"] forState:UIControlStateHighlighted];
        [_viewbottom addSubview:_slider];
        
        
//        _btquanpin = [[UIButton alloc] initWithFrame:CGRectZero];
//        [_btquanpin setBackgroundColor:[UIColor redColor]];
//        [_viewbottom addSubview:_btquanpin];
//        [_btquanpin addTarget:self action:@selector(quanpinAction) forControlEvents:UIControlEventTouchUpInside];
//
        
        _lbstart = [[UILabel alloc] initWithFrame:CGRectZero];
        [_lbstart setText:@"00:00"];
        [_lbstart setTextColor:[UIColor whiteColor]];
        [_lbstart setTextAlignment:NSTextAlignmentCenter];
        [_lbstart setFont:[UIFont systemFontOfSize:12]];
        [_viewbottom addSubview:_lbstart];
        
        _lbend = [[UILabel alloc] initWithFrame:CGRectZero];
        [_lbend setText:@"00:00"];
        [_lbend setTextColor:[UIColor whiteColor]];
        [_lbend setTextAlignment:NSTextAlignmentCenter];
        [_lbend setFont:[UIFont systemFontOfSize:12]];
        [_viewbottom addSubview:_lbend];
        
        
        _viewtop = [[UIView alloc] initWithFrame:CGRectZero];
        [_viewtop setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_viewtop];
        
        _btback = [[UIButton alloc] initWithFrame:CGRectZero];
        [_viewtop addSubview:_btback];
        [_btback addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [_btback setImage:[UIImage imageNamed:@"shipin_del"] forState:UIControlStateNormal];
//        
//        _lbtitle = [[UILabel alloc] initWithFrame:CGRectZero];
//        [_lbtitle setText:@""];
//        [_lbtitle setTextColor:[UIColor blackColor]];
//        [_lbtitle setTextAlignment:NSTextAlignmentCenter];
//        [_lbtitle setFont:[UIFont systemFontOfSize:14]];
//        [_viewtop addSubview:_lbtitle];
        
        _btallplay = [[UIButton alloc] init];
        [_btallplay setImage:[UIImage imageNamed:@"vedio_play_list"] forState:UIControlStateNormal];
        [_btallplay addTarget:self action:@selector(allPlayAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btallplay];
        [_btallplay setHidden:YES];
        
        UITapGestureRecognizer *gesview = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction)];
        [self addGestureRecognizer:gesview];
        
        
//        UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipes:)];
//        left.direction=UISwipeGestureRecognizerDirectionLeft;
//        [self addGestureRecognizer:left];
//
//        UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipes:)];
//        right.direction=UISwipeGestureRecognizerDirectionRight;
//        [self addGestureRecognizer:right];
//
//        UISwipeGestureRecognizer *up = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipes:)];
//        up.direction=UISwipeGestureRecognizerDirectionUp;
//        [self addGestureRecognizer:up];
//
//        UISwipeGestureRecognizer *down = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipes:)];
//        down.direction=UISwipeGestureRecognizerDirectionLeft;
//        [self addGestureRecognizer:down];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self setBackgroundColor:[UIColor clearColor]];
    
    [_btallplay setFrame:CGRectMake(0, 0, 100, 100)];
    [_btallplay setCenter:self.center];
    [self bottomViewDraw];
    [self topViewDraw];
    
    
    
    
}

-(void)topViewDraw
{
    [_viewtop setFrame:CGRectMake(0, 0, self.bounds.size.width, 40)];
    [_viewtop setHidden:NO];
    
    [_btback setFrame:CGRectMake(0, 0, _viewtop.bounds.size.height, _viewtop.bounds.size.height)];
    
//    [_lbtitle setFrame:CGRectMake(_viewtop.bounds.size.height, 0, _viewtop.bounds.size.width-50, _viewtop.bounds.size.height)];
    
    [self tophiden];
}

-(void)bottomViewDraw
{
    [_viewbottom setFrame:CGRectMake(0, self.bounds.size.height-40, self.bounds.size.width, 40)];
    
    [_btplay setFrame:CGRectMake(0, 0, _viewbottom.bounds.size.height, _viewbottom.bounds.size.height)];
    
    [_lbstart setFrame:CGRectMake(_btplay.bounds.size.width, 0, 60, _viewbottom.bounds.size.height)];
    
    [_slider setFrame:CGRectMake(_viewbottom.bounds.size.height+60, 0, _viewbottom.bounds.size.width-_viewbottom.bounds.size.height-120, _viewbottom.bounds.size.height)];
    [_slider setCenter:CGPointMake(_viewbottom.bounds.size.width/2.0, _viewbottom.bounds.size.height/2.0)];
    [_slider setLeft:_lbstart.right];
    
    
    [_lbend setFrame:CGRectMake(_slider.bounds.size.width+_viewbottom.bounds.size.height+60, 0, 60, _viewbottom.bounds.size.height)];
    
    
//    [_btquanpin setFrame:CGRectMake(_viewbottom.bounds.size.width-_viewbottom.bounds.size.height, 0, _viewbottom.bounds.size.height, _viewbottom.bounds.size.height)];
    
}

-(void)tapViewAction
{
    if(_viewbottom.hidden == YES)
    {
        [_viewtop setHidden:NO];
        [_viewbottom setHidden:NO];
    }
    else
    {
        [_viewtop setHidden:YES];
        [_viewbottom setHidden:YES];
    }
    
    [self tophiden];
}


-(void)tophiden
{
    if(timer==nil)
    {
        timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(ttophiden) userInfo:nil repeats:NO];
    }
    
}

-(void)ttophiden
{
    timer = nil;
    [_viewtop setHidden:YES];
    [_viewbottom setHidden:YES];
}

///设置视频的长度
-(void)startValue:(NSString *)strvalue
{
    self.inumbers = strvalue.intValue;
    [_slider setMaximumValue:strvalue.floatValue];
    [_lbend setText:[self lengthchangetotime:strvalue]];
    
    if(strvalue.integerValue>1)
    {
        [_slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    }
    
}

-(NSString *)lengthchangetotime:(NSString *)strlength
{
    NSString *strtime = @"00:00";
    
    int iss = strlength.intValue;
    if(iss>=60)
    {
        int imints = strlength.intValue/60;
        NSString *strtemp = [NSString stringWithFormat:@"%d",imints];
        if(imints<10)
        {
            strtemp = [NSString stringWithFormat:@"0%d",imints];
        }
        
        NSString *strtemp1 = [NSString stringWithFormat:@"%d",strlength.intValue%60];
        if(strlength.intValue%60<10)
        {
            strtemp1 = [NSString stringWithFormat:@"0%d",strlength.intValue%60];
        }
        
        strtime = [NSString stringWithFormat:@"%@:%@",strtemp,strtemp1];
    }
    else
    {
        NSString *strtemp = [NSString stringWithFormat:@"%d",iss];
        if(iss<10)
        {
            strtemp = [NSString stringWithFormat:@"0%d",iss];
        }
        strtime = [NSString stringWithFormat:@"00:%@",strtemp];
    }
    
    
    return strtime;
}


-(void)sliderAction:(UISlider *)sender
{
    CGFloat currt= sender.value;
    [_slider setValue:currt];
    [_lbstart setText:[self lengthchangetotime:[NSString stringWithFormat:@"%.0lf",currt]]];
    
    ///去更改视屏的播放进度
    [self.delegate videoBottomBarDidEndChangeSliderValue:currt];
}

-(void)playAction
{
    [self.delegate btstartAction];
}

-(void)quanpinAction
{
    [self.delegate btquanpinAction];
}
///yes播放 no暂停
-(void)changeplayBottonState:(BOOL)isstate
{
    if(isstate)
    {
        [_btplay setImage:[UIImage imageNamed:@"vedio_puse"] forState:UIControlStateNormal];
    }
    else
    {
        [_btplay setImage:[UIImage imageNamed:@"vedio_play_list"] forState:UIControlStateNormal];
    }
    
    
}

///时间自动更细
-(void)timeAuto:(NSString *)strvalue
{
    NSString *strtime = strvalue;
    
    [_lbstart setText:[self lengthchangetotime:strtime]];
    
    [_slider setValue:strtime.floatValue];
    if(_slider.value == _slider.maximumValue)
    {///
        [_viewtop setHidden:NO];
        [_viewbottom setHidden:NO];
        [_btallplay setHidden:NO];
        [_btplay setImage:[UIImage imageNamed:@"vedio_play_list"] forState:UIControlStateNormal];
    }
    else
    {
        [_btallplay setHidden:YES];
//        [_btplay setImage:[UIImage imageNamed:@"vedio_puse"] forState:UIControlStateNormal];
    }
}

-(void)titleValue:(NSString *)strtitle
{
    if(strtitle == nil)strtitle = @"";
    
    [_lbtitle setText:strtitle];
    
}

-(void)allPlayAction
{
    [self.delegate btAutostartAction];
    [_btplay setImage:[UIImage imageNamed:@"vedio_puse"] forState:UIControlStateNormal];
}

-(void)backAction
{
    
    [self.delegate btbackAction];
    
}

//-(void)handleSwipes:(UISwipeGestureRecognizer *)recognizer
//{
//
//    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft){
//        NSLog(@"向左边滑动了!!!!!!");
//    }
//    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
//        NSLog(@"向右边滑动了!!!!!!");
//    }
//    if (recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
//        NSLog(@"向上边滑动了!!!!!!");
//    }
//    if (recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
//        NSLog(@"向下边滑动了!!!!!!");
//    }
//
//}

- (void)panAction:(UIPanGestureRecognizer *)pan
{
    //点相对于上一个点的位置
    
    CGPoint moviePoint = [pan translationInView:pan.view];
    
    if(fabs(moviePoint.x)>moviePoint.y)
    {
        switch (pan.state) {
            case UIGestureRecognizerStateBegan:
            {
//                NSLog(@"开始");
            }
                break;
            case UIGestureRecognizerStateChanged:
            {
//                NSLog(@"改变");
            }
                break;
            default:
            {
//                NSLog(@"结束");
                int imove = moviePoint.x/2;
                float fvalue = _slider.value + imove;
                
                if(fvalue>=self.inumbers)
                {
                    [_lbstart setText:[self lengthchangetotime:[NSString stringWithFormat:@"%d",self.inumbers]]];
                    
                    [_slider setValue:self.inumbers];
                    ///去更改视屏的播放进度
                    [self.delegate videoBottomBarDidEndChangeSliderValue:self.inumbers-1];
                }
                else if (fvalue<=0)
                {
                    [_lbstart setText:[self lengthchangetotime:[NSString stringWithFormat:@"%d",0]]];
                    
                    [_slider setValue:0];
                    ///去更改视屏的播放进度
                    [self.delegate videoBottomBarDidEndChangeSliderValue:0];
                }
                else
                {
                    [_lbstart setText:[self lengthchangetotime:[NSString stringWithFormat:@"%d",(int)fvalue]]];
                    
                    [_slider setValue:fvalue];
                    ///去更改视屏的播放进度
                    [self.delegate videoBottomBarDidEndChangeSliderValue:fvalue];
                }
                
                
                
            }
                break;
        }
    }
    
    
}

@end
