//
//  TKExploreTableViewCell.m
//  TaokeSecretary
//
//  Created by mdb-losaic on 2018/1/15.
//  Copyright © 2018年 leecool. All rights reserved.
//

#import "TKExploreTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YYControl.h"
#import <YYKit/UIImage+YYAdd.h>

#import "PGGMoviePlayer.h"

#import "MDB_UserDefault.h"

@implementation TKTopicItemProfileView {
    BOOL _trackingTouch;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kScreenWidth;
        frame.size.height = 56;
    }
    self = [super initWithFrame:frame];
    self.exclusiveTouch = YES;
    
    _avatarView = [[UIImageView alloc] initWithRoundingRectImageView];
    [_avatarView zy_attachBorderWidth:CGFloatFromPixel(1) color:[UIColor colorWithWhite:0.000 alpha:0.090]];
    _avatarView.size = CGSizeMake(40, 40);
    _avatarView.origin = CGPointMake(kTopicCellPadding, kTopicCellPadding-3);
    _avatarView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_avatarView];
    
    _nameLabel = [YYLabel new];
    _nameLabel.size = CGSizeMake(kTopicCellNameWidth, 15);
    _nameLabel.left = _avatarView.right + 8;
    _nameLabel.centerY = _avatarView.centerY-8;
    _nameLabel.displaysAsynchronously = YES;
    _nameLabel.ignoreCommonProperties = YES;
    _nameLabel.fadeOnAsynchronouslyDisplay = NO;
    _nameLabel.fadeOnHighlight = NO;
    _nameLabel.lineBreakMode = NSLineBreakByClipping;
    _nameLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _nameLabel.preferredMaxLayoutWidth = kTopicCellContentWidth;
    [self addSubview:_nameLabel];
    
    _sourceLabel = [YYLabel new];
    _sourceLabel.frame = _nameLabel.frame;
    _sourceLabel.top = _nameLabel.bottom+4;
    _sourceLabel.displaysAsynchronously = YES;
    _sourceLabel.ignoreCommonProperties = YES;
    _sourceLabel.fadeOnAsynchronouslyDisplay = NO;
    _sourceLabel.fadeOnHighlight = NO;
    _sourceLabel.preferredMaxLayoutWidth = kTopicCellContentWidth;
    [self addSubview:_sourceLabel];
    
    _topImageView = [UIImageView new];
    [self addSubview:_topImageView];
    [_topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(1);
        make.right.equalTo(self.mas_right).offset(-13);
        make.size.mas_equalTo(CGSizeMake(47, 47));
    }];
    
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    _trackingTouch = NO;
    UITouch *t = touches.anyObject;
    CGPoint p = [t locationInView:_avatarView];
    if (CGRectContainsPoint(_avatarView.bounds, p)) {
        _trackingTouch = YES;
    }
    p = [t locationInView:_nameLabel];
    if (CGRectContainsPoint(_nameLabel.bounds, p) && _nameLabel.textLayout.textBoundingRect.size.width > p.x) {
        _trackingTouch = YES;
    }
    if (!_trackingTouch) {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!_trackingTouch) {
        [super touchesEnded:touches withEvent:event];
    } else {
        if ([_cell.delegate respondsToSelector:@selector(cell:didClickUser:)]) {
            [_cell.delegate cell:_cell didClickUser:_cell.statusView.layout.topic.userID];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!_trackingTouch) {
        [super touchesCancelled:touches withEvent:event];
    }
}


@end

@implementation TKTopicItemCellToolBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kScreenWidth;
        frame.size.height = kTopicCellToolbarBottomHeight;
    }
    self = [super initWithFrame:frame];
    self.exclusiveTouch = YES;
    
    _timeLabel = [YYLabel new];
    _timeLabel.size = CGSizeMake(100, 15);
    _timeLabel.left = kTopicCellPadding;
    _timeLabel.centerY = 15/2;
    _timeLabel.displaysAsynchronously = YES;
    _timeLabel.ignoreCommonProperties = YES;
    _timeLabel.fadeOnAsynchronouslyDisplay = NO;
    _timeLabel.fadeOnHighlight = NO;
    _timeLabel.lineBreakMode = NSLineBreakByClipping;
    _timeLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _timeLabel.preferredMaxLayoutWidth = kTopicCellContentWidth;
    [self addSubview:_timeLabel];
    
    _priseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _priseButton.right = self.width-100-kTopicCellPadding;
    _priseButton.size = CGSizeMake(100, _timeLabel.height);
    _priseButton.centerY = _timeLabel.centerY;
    [_priseButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [_priseButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateHighlighted];
    [_priseButton.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
    [_priseButton setImageEdgeInsets:UIEdgeInsetsMake(0, -4, 0, 4)];
    [_priseButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [_priseButton addTarget:self action:@selector(respondsToPriseEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_priseButton];
    
    _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _commentButton.right = self.width-150-kTopicCellPadding;
    _commentButton.size = CGSizeMake(100, _timeLabel.height+3);
    _commentButton.centerY = _timeLabel.centerY;
    [_commentButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [_commentButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateHighlighted];
    [_commentButton.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
    [_commentButton setImageEdgeInsets:UIEdgeInsetsMake(0, -4, 0, 4)];
    [_commentButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [_commentButton addTarget:self action:@selector(respondsToPriseEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_commentButton];
    
    return self;
}

- (void)respondsToPriseEvent:(id)sender{
    //    if ([self.cell.delegate respondsToSelector:@selector(cell:didClickInAgainBtn:)]) {
    //        [self.cell.delegate cell:self.cell didClickInAgainBtn:sender];
    //    }
}
@end

@implementation TKTopicItemCellStatusView
- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kScreenWidth;
        frame.size.height = 1;
    }
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    self.exclusiveTouch = YES;
    @weakify(self);

    _contentView = [UIView new];
    _contentView.width = kScreenWidth;
    _contentView.height = 1;
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_contentView];
    
    _profileView = [TKTopicItemProfileView new];
    [_contentView addSubview:_profileView];
    
    _toolBarView = [TKTopicItemCellToolBarView new];
    [_contentView addSubview:_toolBarView];
    
    _titleTextLabel = [YYLabel new];
    _titleTextLabel.left = kTopicCellPadding;
    _titleTextLabel.width = kTopicCellContentWidth;
    _titleTextLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    _titleTextLabel.displaysAsynchronously = YES;
    _titleTextLabel.ignoreCommonProperties = YES;
    _titleTextLabel.fadeOnAsynchronouslyDisplay = NO;
    _titleTextLabel.fadeOnHighlight = NO;
    _titleTextLabel.preferredMaxLayoutWidth = kTopicCellContentWidth;
    [_contentView addSubview:_titleTextLabel];

    _textLabel = [YYLabel new];
    _textLabel.left = kTopicCellPadding;
    _textLabel.width = kTopicCellContentWidth;
    _textLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    _textLabel.displaysAsynchronously = YES;
    _textLabel.ignoreCommonProperties = YES;
    _textLabel.fadeOnAsynchronouslyDisplay = NO;
    _textLabel.fadeOnHighlight = NO;
    _textLabel.preferredMaxLayoutWidth = kTopicCellContentWidth;
    _textLabel.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
//        if ([weak_self.cell.delegate respondsToSelector:@selector(cell:didClickInLabel:textRange:)]) {
//            [weak_self.cell.delegate cell:weak_self.cell didClickInLabel:(YYLabel *)containerView textRange:range];
//        }
    };
    [_contentView addSubview:_textLabel];
    NSMutableArray *picViews = [NSMutableArray new];
    for (int i = 0; i < 3; i++) {
        YYControl *imageView = [YYControl new];
        imageView.size = CGSizeMake(100, 100);
        imageView.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
        imageView.hidden = YES;
        imageView.clipsToBounds = YES;
        imageView.exclusiveTouch = YES;
        imageView.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
            if (![weak_self.cell.delegate respondsToSelector:@selector(cell:didClickImageAtIndex:)]) return;
            if (state == YYGestureRecognizerStateEnded) {
                UITouch *touch = touches.anyObject;
                CGPoint p = [touch locationInView:view];
                if (CGRectContainsPoint(view.bounds, p)) {
                    [weak_self.cell.delegate cell:weak_self.cell didClickImageAtIndex:i];
                }
            }
        };
        
        CALayer *imageViewBorder = [CALayer layer];
        imageViewBorder.frame = imageView.bounds;
        imageViewBorder.cornerRadius = 3;
        imageViewBorder.shouldRasterize = YES;
        imageViewBorder.rasterizationScale = kScreenScale;
        [imageView.layer addSublayer:imageViewBorder];
        
        UILabel *badge = [UILabel new];
        badge.size = CGSizeMake(34, 21);
        badge.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        badge.right = imageView.width;
        badge.bottom = imageView.height;
        badge.hidden = YES;
        badge.backgroundColor = RGBAlpha(0, 0, 0, 0.7);
        badge.textColor = [UIColor whiteColor];
        badge.font = [UIFont systemFontOfSize:12.f];
        badge.textAlignment = NSTextAlignmentCenter;
        [imageView addSubview:badge];
        
        [picViews addObject:imageView];
        
        
        UIButton *btVedioi = [[UIButton alloc] init];
        [btVedioi setTag:10001+i];
        [btVedioi addTarget:self action:@selector(vedioAction:) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:btVedioi];
        UIImageView *_imgvVedio = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40*kScale, 40*kScale)];
        [_imgvVedio setImage:[UIImage imageNamed:@"vedio_play_list"]];
        [btVedioi addSubview:_imgvVedio];
        [_imgvVedio setTag:1001];
        [btVedioi setHidden:YES];
        
        [_contentView addSubview:imageView];
        
        
        
        
    }
    _picViews = picViews;
    
//    _btVedio = [[UIButton alloc] init];
//    [_btVedio addTarget:self action:@selector(vedioAction) forControlEvents:UIControlEventTouchUpInside];
//    [_contentView addSubview:_btVedio];
//    _imgvVedio = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//    [_imgvVedio setImage:[UIImage imageNamed:@"vedio_play_list"]];
//    [_btVedio addSubview:_imgvVedio];
//    [_btVedio setHidden:YES];
   
    
    return self;
}


- (void)setLayout:(TKTopicItemLayout *)layout {
    _layout = layout;
    self.height = layout.height;
    _contentView.top = layout.marginTop;
    _contentView.height = layout.height - layout.marginTop - layout.marginBottom;
    CGFloat top = 0;
    
    /// 圆角头像
    [_profileView.avatarView setImageWithURL:[NSURL URLWithString:layout.topic.avatar] //profileImageURL
                                 placeholder:[UIImage imageNamed:@"head_default"]
                                     options:kNilOptions
                                     manager:[RemarkStatusHelper avatarImageManager] //< 圆角头像manager，内置圆角处理
                                    progress:nil
                                   transform:nil
                                  completion:nil];
    
    _profileView.nameLabel.textLayout = layout.nameTextLayout;
    _profileView.sourceLabel.textLayout = layout.sourceTextLayout;
    _profileView.height = layout.profileHeight;
    if (layout.topic.hasSticky) {
        _profileView.topImageView.image = [UIImage imageNamed:@"topic_sticky"];
    }else{
        if (layout.topic.hasHighlight) {
            _profileView.topImageView.image = [UIImage imageNamed:@"topic_highlight"];
        }else{
            _profileView.topImageView.image = nil;
        }
    }
    
    _profileView.top = top;
    top += layout.profileHeight+layout.marginTop-kTopicCellTopMargin;
    
    if (layout.picHeight == 0 ) {
        [self _hideImageViews];
    }
    if (layout.titleTextHeight > 0) {
        _titleTextLabel.hidden = NO;
        _titleTextLabel.top = top;
        _titleTextLabel.height = layout.titleTextHeight;
        _titleTextLabel.textLayout = layout.titleTextLayout;
        top += layout.titleTextHeight + kTopicCellTopMargin;
    }else{
        _titleTextLabel.hidden = YES;
    }
    _textLabel.top = top;
    _textLabel.height = layout.textHeight;
    _textLabel.textLayout = layout.textLayout;
    
    if (_layout.topic.images.count == 1) {
        _textLabel.top = top + (layout.picHeight/2-layout.textHeight/2);
        _textLabel.numberOfLines = 4;
        [self _setImageViewWithTop:top];
        top += layout.picHeight;
        top += kTopicCellToolbarBottomMargin;
    }else{
        _textLabel.numberOfLines = 3;
        top += layout.textHeight;
        if (layout.topic.images.count > 1) {
            [self _setImageViewWithTop:top];
            top += layout.picHeight;
            top += kTopicCellPadding;
        }
//        else if(layout.topic.images.count == 1&&_layout.topic.is_video.intValue>0)
//        {
//            [self _setImageViewWithTop:top];
//            top += layout.picHeight;
//            top += kTopicCellPadding;
//        }
    }
    top += kTopicCellToolbarBottomMargin;
    top += layout.marginTop;
    top += layout.marginTop;
    _toolBarView.top = top;
    _toolBarView.timeLabel.textLayout = layout.timeTextLayout;
    [_toolBarView.priseButton setTitle:layout.topic.thumb forState:UIControlStateNormal];
    [_toolBarView.priseButton setImage:[UIImage imageNamed:@"topic_prise_normal"] forState:UIControlStateNormal];
    [_toolBarView.commentButton setTitle:layout.topic.commentCount forState:UIControlStateNormal];
    [_toolBarView.commentButton setImage:[UIImage imageNamed:@"comment_ico_explore1"] forState:UIControlStateNormal];

}

- (void)_hideImageViews {
    for (UIImageView *imageView in _picViews) {
        imageView.hidden = YES;
    }
}

- (void)_setImageViewWithTop:(CGFloat)imageTop{
    CGSize picSize =  _layout.picSize;
    NSArray *pics = _layout.topic.thumbnails;
    int picsCount = (int)pics.count;
    [_btVedio setHidden:YES];
    for (int i = 0; i < 3; i++) {
        UIView *imageView = _picViews[i];
        if (i >= picsCount) {
            [imageView.layer cancelCurrentImageRequest];
            imageView.hidden = YES;
        } else {
            
            UIButton *_btVedio = [imageView viewWithTag:10001+i];
            UIImageView *_imgvVedio = [_btVedio viewWithTag:1001];
            
            CGPoint origin = {0};
            switch (picsCount) {
                case 1: {
                    if(_layout.topic.is_video.intValue >0)
                    {
//                        origin.x = kTopicCellPaddingPic + (i % 3) * (picSize.width + kTopicCellPaddingPic);
//                        origin.y = imageTop + (int)(i / 3) * (picSize.height + kTopicCellPaddingPic) + kTopicCellPadding;
                        origin.x = kScreenWidth-picSize.width-kTopicCellPadding;
                        origin.y = imageTop;
                        _btVedio.frame = CGRectMake(0, 0, picSize.width, picSize.height);
                        [_btVedio setHidden:NO];
                        [_imgvVedio setCenter:CGPointMake(_btVedio.width/2.0, _btVedio.height/2.0)];
                    }
                    else
                    {
                        origin.x = kScreenWidth-picSize.width-kTopicCellPadding;
                        origin.y = imageTop;
                        [_btVedio setHidden:YES];
                    }
                    
                } break;
                default: {
                    origin.x = kTopicCellPaddingPic + (i % 3) * (picSize.width + kTopicCellPaddingPic);
                    origin.y = imageTop + (int)(i / 3) * (picSize.height + kTopicCellPaddingPic) + kTopicCellPadding;
                    [_btVedio setHidden:YES];
                    if(_layout.topic.is_video.intValue >0)
                    {
                        _btVedio.frame = CGRectMake(0, 0, picSize.width, picSize.height);
                        [_btVedio setHidden:NO];
                        [_imgvVedio setCenter:CGPointMake(_btVedio.width/2.0, _btVedio.height/2.0)];
                    }
                    
                    
                    
                } break;
            }
            
            
            if(i>=_layout.topic.video.count)
            {
                [_btVedio setHidden:YES];
            }
            imageView.frame = (CGRect){.origin = origin, .size = picSize};
            imageView.hidden = NO;
            [imageView.layer removeAnimationForKey:@"contents"];
            
            UILabel *badge = imageView.subviews.firstObject;
            if (i==2 && _layout.topic.images.count > 3) {
                badge.hidden = NO;
                badge.text = [NSString stringWithFormat:@"%@张",@(_layout.topic.images.count)];
            }else{
                badge.hidden = YES;
            }
            
            if ([pics[i] isKindOfClass:[UIImage class]]) {
                ((YYControl *)imageView).image = pics[i];
            }else{
                NSString *picLink = [MDB_UserDefault getCompleteWebsite:pics[i]];
                @weakify(imageView);
                [imageView.layer setImageWithURL:[NSURL URLWithString:picLink]
                                     placeholder:nil
                                         options:YYWebImageOptionAvoidSetImage
                                      completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                                          @strongify(imageView);
                                          if (!imageView) return;
                                          if (image && stage == YYWebImageStageFinished) {
                                              int width = image.size.width;
                                              int height = image.size.height;
                                              CGFloat scale = (height / width) / (imageView.height / imageView.width);
                                              if (scale < 0.99 || isnan(scale)) { // 宽图把左右两边裁掉
                                                  imageView.contentMode = UIViewContentModeScaleAspectFill;
                                                  imageView.layer.contentsRect = CGRectMake(0, 0, 1, 1);
                                              } else { // 高图只保留顶部
                                                  imageView.contentMode = UIViewContentModeScaleToFill;
                                                  imageView.layer.contentsRect = CGRectMake(0, 0, 1, (float)width / height);
                                              }
                                              ((YYControl *)imageView).image = image;
                                              if (from != YYWebImageFromMemoryCacheFast) {
                                                  CATransition *transition = [CATransition animation];
                                                  transition.duration = 0.15;
                                                  transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                                                  transition.type = kCATransitionFade;
                                                  [imageView.layer addAnimation:transition forKey:@"contents"];
                                              }      
                                          }
                                      }];
                
            }
            
        }
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([_cell.delegate respondsToSelector:@selector(cellDidClick:)]) {
        [_cell.delegate cellDidClick:_cell];
    }
}

-(void)vedioAction:(UIButton *)sender
{
    
    NSLog(@"播放");
    
    PGGMoviePlayer *pplayer = [[PGGMoviePlayer alloc] initWithFrame:CGRectMake(0, 0, BOUNDS_WIDTH, BOUNDS_HEIGHT)];
    [pplayer setBackgroundColor:[UIColor grayColor]];
    [self.viewController.view.window addSubview:pplayer];
    NSString *strurl = @"";
    @try
    {
        strurl = _layout.topic.video[sender.tag-10001];
    }
    @catch(NSException *exc)
    {
        strurl = @"";
    }
    @finally
    {
        
    }
    [pplayer playUrl:[MDB_UserDefault getCompleteWebsite:strurl]];
    pplayer.playerViewOriginalRect = pplayer.frame;
    pplayer.playerSuperView = self.viewController.view.window;
    pplayer.playerpoint = pplayer.center;
    pplayer.strtitle = _layout.topic.title;
    

    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
}

@end

@interface TKExploreTableViewCell ()

@end

@implementation TKExploreTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    for (UIView *view in self.subviews) {
        if([view isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)view).delaysContentTouches = NO; // Remove touch delay for iOS 7
            break;
        }
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundView.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    _statusView = [TKTopicItemCellStatusView new];
    _statusView.cell = self;
    _statusView.profileView.cell = self;
    [self.contentView addSubview:_statusView];
    return self;
}

- (void)setLayout:(TKTopicItemLayout *)layout {
    self.height = layout.height;
    self.contentView.height = layout.height;
    _statusView.layout = layout;
}

@end
