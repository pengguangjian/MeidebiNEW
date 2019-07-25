//
//  RemarkTableViewMyRemarkCell.m
//  Meidebi
//
//  Created by mdb-admin on 2017/2/13.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "RemarkTableViewMyRemarkCell.h"
#import "YYControl.h"
#import "RemarkStatusHelper.h"

@implementation PersonalRemarkStatusProfileView {
    BOOL _trackingTouch;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kScreenWidth;
        frame.size.height = kWBCellProfileHeight;
    }
    self = [super initWithFrame:frame];
    self.exclusiveTouch = YES;
    @weakify(self);
    
    _nameLabel = [YYLabel new];
    _nameLabel.size = CGSizeMake(0, 24);
    _nameLabel.origin = CGPointMake(kWBCellPadding, 3);
    _nameLabel.displaysAsynchronously = YES;
    _nameLabel.ignoreCommonProperties = YES;
    _nameLabel.fadeOnAsynchronouslyDisplay = NO;
    _nameLabel.fadeOnHighlight = NO;
    _nameLabel.lineBreakMode = NSLineBreakByClipping;
    _nameLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    [self addSubview:_nameLabel];
    
    _septalLineView = [UIView new];
    _septalLineView.backgroundColor = [UIColor colorWithHexString:@"#b7b7b7"];
    [self addSubview:_septalLineView];
    
    _sourceLabel = [YYLabel new];
    _sourceLabel.top = 3;
    _sourceLabel.size = CGSizeMake(kWBCellNameWidth, 24);
    _sourceLabel.displaysAsynchronously = YES;
    _sourceLabel.ignoreCommonProperties = YES;
    _sourceLabel.fadeOnAsynchronouslyDisplay = NO;
    _sourceLabel.fadeOnHighlight = NO;
    _sourceLabel.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        if ([weak_self.cell.delegate respondsToSelector:@selector(cell:didClickInLabel:textRange:)]) {
            [weak_self.cell.delegate cell:weak_self.cell didClickInLabel:(YYLabel *)containerView textRange:range];
        }
    };
    [self addSubview:_sourceLabel];
    
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    _trackingTouch = NO;
    UITouch *t = touches.anyObject;
    CGPoint p = [t locationInView:_sourceLabel];
    if (CGRectContainsPoint(_sourceLabel.bounds, p)) {
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
        //        if ([_cell.delegate respondsToSelector:@selector(cell:didClickUser:)]) {
        //            [_cell.delegate cell:_cell didClickUser:_cell.statusView.layout.status.user];
        //        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!_trackingTouch) {
        [super touchesCancelled:touches withEvent:event];
    }
}

@end


@implementation PersonalRemarkCellStatusView {
    BOOL _touchRetweetView;
}

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
    
    _profileView = [PersonalRemarkStatusProfileView new];
    [_contentView addSubview:_profileView];
    
    _retweetBackgroundView = [UIView new];
    _retweetBackgroundView.backgroundColor = kWBCellInnerViewColor;
    _retweetBackgroundView.width = kScreenWidth;
    [_contentView addSubview:_retweetBackgroundView];
    
    _textLabel = [YYLabel new];
    _textLabel.left = kWBCellPadding;
    _textLabel.width = kWBCellContentWidth;
    _textLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    _textLabel.displaysAsynchronously = YES;
    _textLabel.ignoreCommonProperties = YES;
    _textLabel.fadeOnAsynchronouslyDisplay = NO;
    _textLabel.fadeOnHighlight = NO;
    _textLabel.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        if ([weak_self.cell.delegate respondsToSelector:@selector(cell:didClickInLabel:textRange:)]) {
            [weak_self.cell.delegate cell:weak_self.cell didClickInLabel:(YYLabel *)containerView textRange:range];
        }
    };
    [_contentView addSubview:_textLabel];
    
    _textRemarkLabel = [YYLabel new];
    _textRemarkLabel.left = kWBCellPadding;
    _textRemarkLabel.width = kWBCellContentWidth;
    _textRemarkLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    _textRemarkLabel.displaysAsynchronously = YES;
    _textRemarkLabel.ignoreCommonProperties = YES;
    _textRemarkLabel.fadeOnAsynchronouslyDisplay = NO;
    _textRemarkLabel.fadeOnHighlight = NO;
    _textRemarkLabel.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        if ([weak_self.cell.delegate respondsToSelector:@selector(cell:didClickInLabel:textRange:)]) {
            [weak_self.cell.delegate cell:weak_self.cell didClickInLabel:(YYLabel *)containerView textRange:range];
        }
    };
    [_contentView addSubview:_textRemarkLabel];
    
    _retweetTextLabel = [YYLabel new];
    _retweetTextLabel.left = kWBCellPadding;
    _retweetTextLabel.width = kWBCellContentWidth;
    _retweetTextLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    _retweetTextLabel.displaysAsynchronously = YES;
    _retweetTextLabel.ignoreCommonProperties = YES;
    _retweetTextLabel.fadeOnAsynchronouslyDisplay = NO;
    _retweetTextLabel.fadeOnHighlight = NO;
    _retweetTextLabel.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        if ([weak_self.cell.delegate respondsToSelector:@selector(cell:didClickInLabel:textRange:)]) {
            [weak_self.cell.delegate cell:weak_self.cell didClickInLabel:(YYLabel *)containerView textRange:range];
        }
    };
    [_contentView addSubview:_retweetTextLabel];
    
    NSMutableArray *picViews = [NSMutableArray new];
    for (int i = 0; i < 10; i++) {
        YYControl *imageView = [YYControl new];
        imageView.size = CGSizeMake(100, 100);
        imageView.hidden = YES;
        imageView.clipsToBounds = YES;
        imageView.backgroundColor = kWBCellHighlightColor;
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
        
        [picViews addObject:imageView];
        [_contentView addSubview:imageView];
    }
    _picViews = picViews;
    
    return self;
}


- (void)setLayout:(PersonalRemarkLayout *)layout {
    _layout = layout;
    
    self.height = layout.height;
    _contentView.top = layout.marginTop;
    _contentView.height = layout.height - layout.marginTop - layout.marginBottom;
    
    CGFloat top = 0;
    
    if (layout.style == PersonalRemarkMenuTypeReply) {
        _profileView.nameLabel.textLayout = layout.nameTextLayout;
        _profileView.nameLabel.width = layout.nameTextSize.width;
        _profileView.septalLineView.left = _profileView.nameLabel.right + kWBCellNamePaddingRight;
        _profileView.septalLineView.top = _profileView.nameLabel.top + kWBCellPadding-8;
        _profileView.septalLineView.size = CGSizeMake(1, _profileView.nameLabel.height*0.65);
        _profileView.sourceLabel.left = _profileView.septalLineView.right + kWBCellNamePaddingRight;
    }else{
        _profileView.sourceLabel.left = kWBCellPadding;
    }
    _profileView.sourceLabel.textLayout = layout.sourceTextLayout;
    _profileView.height = layout.profileHeight;
    _profileView.top = top;
    top += layout.profileHeight+layout.marginTop;
    
    _textLabel.top = top;
    _textLabel.height = layout.textHeight;
    _textLabel.textLayout = layout.textLayout;
    top += layout.textHeight;
    if (layout.picHeight > 0) {
        [self _setImageViewWithTop:top isRetweet:NO];
    }
    
    _retweetBackgroundView.hidden = YES;
    _retweetTextLabel.hidden = YES;
    if (layout.picHeight == 0 && layout.retweetPicHeight == 0) {
        [self _hideImageViews];
    }
    
    //优先级是 引用->图片
    if (layout.retweetHeight > 0) {
        _retweetBackgroundView.top = top;
        _retweetBackgroundView.height = layout.retweetHeight;
        _retweetBackgroundView.hidden = NO;
        
        _retweetTextLabel.top = top;
        _retweetTextLabel.height = layout.retweetTextHeight;
        _retweetTextLabel.textLayout = layout.retweetTextLayout;
        _retweetTextLabel.hidden = NO;
        top += layout.retweetTextHeight;
        
        if (layout.retweetPicHeight > 0) {
            [self _setImageViewWithTop:_retweetTextLabel.bottom isRetweet:YES];
            top += layout.retweetPicHeight+kWBCellPadding;
        } else {
            [self _hideImageViews];
        }
    }
    
    _textRemarkLabel.top = top;
    _textRemarkLabel.height = layout.textRemarkHeight;
    _textRemarkLabel.textLayout = layout.textRemarkLayout;
}

- (void)_hideImageViews {
    for (UIImageView *imageView in _picViews) {
        imageView.hidden = YES;
    }
}

- (void)_setImageViewWithTop:(CGFloat)imageTop isRetweet:(BOOL)isRetweet {
    CGSize picSize = isRetweet ? _layout.retweetPicSize : _layout.picSize;
    NSArray *pics = _layout.status.pics;
    int picsCount = (int)pics.count;
    
    for (int i = 0; i < 10; i++) {
        UIView *imageView = _picViews[i];
        if (i >= picsCount) {
            [imageView.layer cancelCurrentImageRequest];
            imageView.hidden = YES;
        } else {
            CGPoint origin = {0};
            switch (picsCount) {
                case 1: {
                    origin.x = kWBCellPadding;
                    origin.y = imageTop;
                } break;
                case 4: {
                    origin.x = kWBCellPadding + (i % 2) * (picSize.width + kWBCellPaddingPic);
                    origin.y = imageTop + (int)(i / 2) * (picSize.height + kWBCellPaddingPic);
                } break;
                default: {
                    origin.x = kWBCellPadding + (i % 3) * (picSize.width + kWBCellPaddingPic);
                    origin.y = imageTop + (int)(i / 3) * (picSize.height + kWBCellPaddingPic);
                } break;
            }
            imageView.frame = (CGRect){.origin = origin, .size = picSize};
            imageView.hidden = NO;
            [imageView.layer removeAnimationForKey:@"contents"];
            NSString *picLink = pics[i][@"thumb"];
            
            
            
            @weakify(imageView);
            [imageView.layer setImageWithURL:[NSURL URLWithString:picLink]
                                 placeholder:nil
                                     options:YYWebImageOptionAvoidSetImage
                                  completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint p = [touch locationInView:_retweetBackgroundView];
    BOOL insideRetweet = CGRectContainsPoint(_retweetBackgroundView.bounds, p);
    
    if (!_retweetBackgroundView.hidden && insideRetweet) {
        [(_retweetBackgroundView) performSelector:@selector(setBackgroundColor:) withObject:kWBCellHighlightColor afterDelay:0.15];
        _touchRetweetView = YES;
    } else {
        [(_contentView) performSelector:@selector(setBackgroundColor:) withObject:kWBCellHighlightColor afterDelay:0.15];
        _touchRetweetView = NO;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesRestoreBackgroundColor];
    if ([_cell.delegate respondsToSelector:@selector(cellDidClick:)]) {
        [_cell.delegate cellDidClick:_cell];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesRestoreBackgroundColor];
}

- (void)touchesRestoreBackgroundColor {
    [NSObject cancelPreviousPerformRequestsWithTarget:_retweetBackgroundView selector:@selector(setBackgroundColor:) object:kWBCellHighlightColor];
    [NSObject cancelPreviousPerformRequestsWithTarget:_contentView selector:@selector(setBackgroundColor:) object:kWBCellHighlightColor];
    
    _contentView.backgroundColor = [UIColor whiteColor];
    _retweetBackgroundView.backgroundColor = kWBCellInnerViewColor;
}

@end

@implementation RemarkTableViewMyRemarkCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    for (UIView *view in self.subviews) {
//        if([view isKindOfClass:[UIScrollView class]]) {
//            ((UIScrollView *)view).delaysContentTouches = NO; // Remove touch delay for iOS 7
//            break;
//        }
//    }
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.backgroundView.backgroundColor = [UIColor clearColor];
//    self.contentView.backgroundColor = [UIColor clearColor];
//    self.backgroundColor = [UIColor clearColor];
    
    _statusView = [PersonalRemarkCellStatusView new];
    _statusView.cell = self;
    _statusView.profileView.cell = self;
    [self.contentView addSubview:_statusView];
    return self;
}

- (void)setLayout:(PersonalRemarkLayout *)layout {
    self.height = layout.height;
    self.contentView.height = layout.height;
    _statusView.layout = layout;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
