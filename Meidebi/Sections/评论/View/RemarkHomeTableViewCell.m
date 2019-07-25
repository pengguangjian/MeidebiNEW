//
//  RemarkTableViewCell.m
//  Meidebi
//
//  Created by mdb-admin on 2017/2/8.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "RemarkHomeTableViewCell.h"
#import "YYControl.h"
#import "RemarkStatusHelper.h"

#import "MDB_UserDefault.h"

@implementation RemarkStatusProfileView {
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
    
    _avatarView = [UIImageView new];
    _avatarView.size = CGSizeMake(40, 40);
    _avatarView.origin = CGPointMake(kWBCellPadding, kWBCellPadding-3);
    _avatarView.contentMode = UIViewContentModeScaleAspectFill;
    [_avatarView.layer setMasksToBounds:YES];
    [_avatarView.layer setCornerRadius:_avatarView.height/2.0];
    [self addSubview:_avatarView];
    
    CALayer *avatarBorder = [CALayer layer];
    avatarBorder.frame = _avatarView.bounds;
    avatarBorder.borderWidth = CGFloatFromPixel(1);
    avatarBorder.borderColor = [UIColor colorWithWhite:0.000 alpha:0.090].CGColor;
    avatarBorder.cornerRadius = _avatarView.height / 2;
    avatarBorder.shouldRasterize = YES;
    avatarBorder.rasterizationScale = kScreenScale;
    [_avatarView.layer addSublayer:avatarBorder];
    
    _avatarBadgeView = [UIImageView new];
    _avatarBadgeView.size = CGSizeMake(14, 14);
    _avatarBadgeView.center = CGPointMake(_avatarView.right - 6, _avatarView.bottom - 6);
    _avatarBadgeView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_avatarBadgeView];
    
    _nameLabel = [YYLabel new];
    _nameLabel.size = CGSizeMake(kWBCellNameWidth, 24);
    _nameLabel.left = _avatarView.right + kWBCellNamePaddingLeft;
    _nameLabel.centerY = 27;
    _nameLabel.displaysAsynchronously = YES;
    _nameLabel.ignoreCommonProperties = YES;
    _nameLabel.fadeOnAsynchronouslyDisplay = NO;
    _nameLabel.fadeOnHighlight = NO;
    _nameLabel.lineBreakMode = NSLineBreakByClipping;
    _nameLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    [self addSubview:_nameLabel];
    
    _sourceLabel = [YYLabel new];
    _sourceLabel.frame = _nameLabel.frame;
    _sourceLabel.centerY = 47;
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
    
    _againBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _againBtn.left = _nameLabel.left+80;
    _againBtn.size = CGSizeMake(40, _nameLabel.height);
    _againBtn.centerY = 47;
    [_againBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_againBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_againBtn setTitle:@"重传" forState:UIControlStateNormal];
    [_againBtn.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
    [_againBtn addTarget:self action:@selector(respondsToAgainEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_againBtn];
    
    _abandonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _abandonBtn.left = _againBtn.right+5;
    _abandonBtn.top = _againBtn.top;
    _abandonBtn.size = CGSizeMake(40, _againBtn.height);
    [_abandonBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_abandonBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [_abandonBtn setTitle:@"放弃" forState:UIControlStateNormal];
    [_abandonBtn.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
    [_abandonBtn addTarget:self action:@selector(respondsToAbandonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_abandonBtn];
    
    _btzan = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 25)];
    [_btzan.layer setMasksToBounds:YES];
    [_btzan.layer setCornerRadius:_btzan.height/2.0];
    [_btzan.layer setBorderColor:RGB(224, 224, 224).CGColor];
    [_btzan.layer setBorderWidth:1];
    [_btzan setImage:[UIImage imageNamed:@"discount_like_normal"] forState:UIControlStateNormal];
    [_btzan setTitle:@"0" forState:UIControlStateNormal];
    [_btzan setTitleColor:RGB(182, 182, 182) forState:UIControlStateNormal];
    [_btzan.titleLabel setFont:[UIFont systemFontOfSize:12]];
    _btzan.centerY = 27;
    [_btzan setRight:kScreenWidth-10];
    [_btzan setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    [_btzan addTarget:self action:@selector(zanAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btzan];
    
    return self;
}

///赞按钮
-(void)zanAction
{
    
    if(_btzan.isSelected == NO)
    {
        if ([_cell.delegate respondsToSelector:@selector(cell:disClickZan:)])
        {
            [self.cell.delegate cell:_cell disClickZan:_cell.statusView.layout.status];
            [_btzan setSelected:YES];
            if ([MDB_UserDefault defaultInstance].usertoken){
                int veot = [NSString nullToString:self.cell.statusView.layout.status.votesp].intValue+1;
                NSString *strveot = [NSString stringWithFormat:@"%d",veot];
                if(veot > 99)
                {
                    strveot = [NSString stringWithFormat:@"99+"];
                }
                [_btzan setTitle:strveot forState:UIControlStateNormal];
                [_btzan setImage:[UIImage imageNamed:@"discount_like_select"] forState:UIControlStateNormal];
            }
        }
    }
    
    
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
            [_cell.delegate cell:_cell didClickUser:_cell.statusView.layout.status.userid];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!_trackingTouch) {
        [super touchesCancelled:touches withEvent:event];
    }
}

- (void)respondsToAgainEvent:(id)sender{
    if ([self.cell.delegate respondsToSelector:@selector(cell:didClickInAgainBtn:)]) {
        [self.cell.delegate cell:self.cell didClickInAgainBtn:sender];
    }
}

- (void)respondsToAbandonEvent:(id)sender{
    if ([self.cell.delegate respondsToSelector:@selector(cell:didClickInAbandonBtn:)]) {
        [self.cell.delegate cell:self.cell didClickInAbandonBtn:sender];
    }
}

@end

@implementation RemarkGiftProfileView
- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kWBCellContentWidth;
        frame.size.height = 1;
    }
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor colorWithHexString:@"#FBF4EF"];
    self.left = kWBCellPadding;
    self.exclusiveTouch = YES;
    
    _giftImageView = [UIImageView new];
    _giftImageView.size = CGSizeMake(15, 15);
    _giftImageView.left = kWBCellPaddingText;
    _giftImageView.top = 5;
    _giftImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_giftImageView];
    
    _giftDescribeLabel = [YYLabel new];
    _giftDescribeLabel.left = _giftImageView.right + 6;
    _giftDescribeLabel.width = kWBCellContentWidth-_giftImageView.width-_giftImageView.left*2;
    _giftDescribeLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    _giftDescribeLabel.displaysAsynchronously = YES;
    _giftDescribeLabel.ignoreCommonProperties = YES;
    _giftDescribeLabel.fadeOnAsynchronouslyDisplay = NO;
    _giftDescribeLabel.fadeOnHighlight = NO;
    [self addSubview:_giftDescribeLabel];

    return self;
}

@end

@implementation RemarkCellStatusView {
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
    
    _profileView = [RemarkStatusProfileView new];
    [_contentView addSubview:_profileView];
    
    _giftProfileView = [RemarkGiftProfileView new];
    [_contentView addSubview:_giftProfileView];
    
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


- (void)setLayout:(RemarkStatusLayout *)layout {
    _layout = layout;
    
    self.height = layout.height;
    _contentView.top = layout.marginTop;
    _contentView.height = layout.height - layout.marginTop - layout.marginBottom;
    
    CGFloat top = 0;
    
//    /// 圆角头像
//    [_profileView.avatarView setImageWithURL:[NSURL URLWithString:layout.status.photo] //profileImageURL
//                                 placeholder:nil
//                                     options:kNilOptions
//                                     manager:[RemarkStatusHelper avatarImageManager] //< 圆角头像manager，内置圆角处理
//                                    progress:nil
//                                   transform:nil
//                                  completion:nil];
    [[MDB_UserDefault defaultInstance] setViewWithImage:_profileView.avatarView url:layout.status.photo];
    
    _profileView.nameLabel.textLayout = layout.nameTextLayout;
    _profileView.sourceLabel.textLayout = layout.sourceTextLayout;
    _profileView.againBtn.hidden = !layout.status.submitState;
    _profileView.abandonBtn.hidden = !layout.status.submitState;
    _profileView.height = layout.profileHeight;
    _profileView.top = top;
    int veot = [NSString nullToString:layout.status.votesp].intValue;
    NSString *strveot = [NSString stringWithFormat:@"%d",veot];
    if(veot > 99)
    {
        strveot = [NSString stringWithFormat:@"99+"];
    }
    [_profileView.btzan setTitle:strveot forState:UIControlStateNormal];
    top += layout.profileHeight+layout.marginTop;
    

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
    
    _textLabel.top = top;
    _textLabel.height = layout.textHeight;
    _textLabel.textLayout = layout.textLayout;
    top += layout.textHeight;
    
    if (layout.drawGiftDescribeTextHeight>0) {
        _giftProfileView.hidden = NO;
        _giftProfileView.giftDescribeLabel.textLayout = layout.drawGiftDescribeTextLayout;
        _giftProfileView.giftDescribeLabel.height = layout.drawGiftDescribeTextHeight;
        _giftProfileView.giftImageView.image = [UIImage imageNamed:@"remark_loot"];
        _giftProfileView.height = layout.drawGiftHeight;
        _giftProfileView.top = top;
        top += layout.drawGiftHeight+kWBCellPadding;
    }else{
        _giftProfileView.hidden = YES;
    }
    if (layout.picHeight > 0) {
        [self _setImageViewWithTop:top isRetweet:NO];
    }
    
    
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
            if ([pics[i] isKindOfClass:[UIImage class]]) {
                ((YYControl *)imageView).image = pics[i];
            }else{
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



@implementation RemarkHomeTableViewCell

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
    
    _statusView = [RemarkCellStatusView new];
    _statusView.cell = self;
    _statusView.profileView.cell = self;
    [self.contentView addSubview:_statusView];
    return self;
}

- (void)setLayout:(RemarkStatusLayout *)layout {
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

    // Configure the view for the selected state
}

@end
