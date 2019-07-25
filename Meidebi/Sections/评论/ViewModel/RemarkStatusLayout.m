//
//  RemarkStatusLayout.m
//  Meidebi
//
//  Created by mdb-admin on 2017/2/6.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "RemarkStatusLayout.h"
#import "RemarkStatusHelper.h"
/*
 将每行的 baseline 位置固定下来，不受不同字体的 ascent/descent 影响。
 
 注意，Heiti SC 中，    ascent + descent = font size，
 但是在 PingFang SC 中，ascent + descent > font size。
 所以这里统一用 Heiti SC (0.86 ascent, 0.14 descent) 作为顶部和底部标准，保证不同系统下的显示一致性。
 间距仍然用字体默认
 */
@implementation TextLinePositionModifier

- (instancetype)init {
    self = [super init];
    
    if (kiOS9Later) {
        _lineHeightMultiple = 1.34;   // for PingFang SC
    } else {
        _lineHeightMultiple = 1.3125; // for Heiti SC
    }
    
    return self;
}

- (void)modifyLines:(NSArray *)lines fromText:(NSAttributedString *)text inContainer:(YYTextContainer *)container {
    //CGFloat ascent = _font.ascender;
    CGFloat ascent = _font.pointSize * 0.86;
    
    CGFloat lineHeight = _font.pointSize * _lineHeightMultiple;
    for (YYTextLine *line in lines) {
        CGPoint position = line.position;
        position.y = _paddingTop + ascent + line.row  * lineHeight;
        line.position = position;
    }
}

- (id)copyWithZone:(NSZone *)zone {
    TextLinePositionModifier *one = [self.class new];
    one->_font = _font;
    one->_paddingTop = _paddingTop;
    one->_paddingBottom = _paddingBottom;
    one->_lineHeightMultiple = _lineHeightMultiple;
    return one;
}

- (CGFloat)heightForLineCount:(NSUInteger)lineCount {
    if (lineCount == 0) return 0;
    //    CGFloat ascent = _font.ascender;
    //    CGFloat descent = -_font.descender;
    CGFloat ascent = _font.pointSize * 0.86;
    CGFloat descent = _font.pointSize * 0.14;
    CGFloat lineHeight = _font.pointSize * _lineHeightMultiple;
    return _paddingTop + _paddingBottom + ascent + descent + (lineCount - 1) * lineHeight;
}

@end



@implementation RemarkStatusLayout

- (instancetype)initWithStatus:(Remark *)status{
    if (!status) return nil;
    self = [super init];
    _status = status;
    [self layout];
    return self;
}

- (void)layout{
    [self _layout];
}

- (void)updateDate{
    [self _layoutSource];
}

- (void)_layout{
    _marginTop = kWBCellTopMargin;
    _profileHeight = 0;
    _textHeight = 0;
    _retweetHeight = 0;
    _retweetTextHeight = 0;
    _retweetPicHeight = 0;
    _picHeight = 0;
    _marginBottom = kWBCellToolbarBottomMargin;
    
    // 文本排版，计算布局
    [self _layoutProfile];
    if (_status.referto.intValue>0) {
        [self _layoutRetweet];
    }
    if (_retweetHeight == 0) {
        [self _layoutPics];
    }
    [self _layoutText];
    [self _layoutDrawGiftText];
    
    // 计算高度
    _height = _marginTop;
    _height += _marginTop;
    _height += _profileHeight;
    _height += _textHeight;
    if (_retweetHeight > 0) {
        _height += _retweetHeight;
    } else if (_picHeight > 0) {
        _height += _picHeight;
    }
    if (_picHeight > 0) {
        _height += kWBCellPadding;
    }
    if (_drawGiftDescribeTextHeight > 0) {
        _height += _drawGiftHeight;
        _height += kWBCellPadding;
    }
    _height += _marginBottom;

}

- (void)_layoutProfile {
    [self _layoutName];
    [self _layoutSource];
    _profileHeight = kWBCellProfileHeight;
}

/// 名字
- (void)_layoutName {
    NSString *nameStr = _status.nickname;
    if (nameStr.length == 0) {
        _nameTextLayout = nil;
        return;
    }
    
    NSMutableAttributedString *nameText = [[NSMutableAttributedString alloc] initWithString:nameStr];
    
    nameText.font = [UIFont systemFontOfSize:kWBCellNameFontSize];
    nameText.color = kWBCellNameNormalColor ;
    nameText.lineBreakMode = NSLineBreakByCharWrapping;
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kWBCellNameWidth, 9999)];
    container.maximumNumberOfRows = 1;
    _nameTextLayout = [YYTextLayout layoutWithContainer:container text:nameText];
}

/// 时间和来源
- (void)_layoutSource {
    NSMutableAttributedString *sourceText = [NSMutableAttributedString new];
    NSString *createTime;
    if (_status.createtime.integerValue==0) {
        createTime = _status.createtime;
    }else{
        createTime = [RemarkStatusHelper stringWithTimelineDate:[NSDate dateWithTimeIntervalSince1970:_status.createtime.integerValue]];
    }
    
    // 时间
    if (createTime.length) {
        NSMutableAttributedString *timeText = [[NSMutableAttributedString alloc] initWithString:createTime];
        [timeText appendString:@"  "];
        timeText.font = [UIFont systemFontOfSize:kWBCellSourceFontSize];
        timeText.color = kWBCellTimeNormalColor;
        [sourceText appendAttributedString:timeText];
    }

    if (sourceText.length == 0) {
        _sourceTextLayout = nil;
    } else {
        YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kWBCellNameWidth, 9999)];
        container.maximumNumberOfRows = 1;
        _sourceTextLayout = [YYTextLayout layoutWithContainer:container text:sourceText];
    }
}

- (void)_layoutRetweet {
    _retweetHeight = 0;
    [self _layoutRetweetedText];
    [self _layoutRetweetPics];
    
    _retweetHeight = _retweetTextHeight;
    if (_retweetPicHeight > 0) {
        _retweetHeight += _retweetPicHeight;
        _retweetHeight += kWBCellPadding;
    }
}

/// 文本
- (void)_layoutText {
    _textHeight = 0;
    _textLayout = nil;
    
    NSMutableAttributedString *text = [self _textWithStatus:_status
                                                  isRetweet:NO
                                                   fontSize:kWBCellTextFontSize
                                                  textColor:kWBCellTextNormalColor];
    if (text.length == 0) return;
    
    TextLinePositionModifier *modifier = [TextLinePositionModifier new];
    modifier.font = [UIFont fontWithName:@"Heiti SC" size:kWBCellTextFontSize];
    modifier.paddingTop = kWBCellPaddingText;
    modifier.paddingBottom = kWBCellPaddingText;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(kWBCellContentWidth, HUGE);
    container.linePositionModifier = modifier;
    
    _textLayout = [YYTextLayout layoutWithContainer:container text:text];
    if (!_textLayout) return;
    
    _textHeight = [modifier heightForLineCount:_textLayout.rowCount];
}

/// 随机掉宝
- (void)_layoutDrawGiftText {
    _drawGiftHeight = 0;
    _drawGiftDescribeTextHeight = 0;
    _drawGiftDescribeTextLayout = nil;
    
    // 字体
    UIFont *font = [UIFont systemFontOfSize:12.f];
    // 高亮状态的背景
    YYTextBorder *highlightBorder = [YYTextBorder new];
    highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
    highlightBorder.cornerRadius = 3;
    highlightBorder.fillColor = kWBCellTextHighlightBackgroundColor;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString nullToString:_status.lottery_prize]];
    text.font = font;
    text.color = [UIColor colorWithHexString:@"#F66A0A"];
    
    if (text.length == 0) return;
    
    TextLinePositionModifier *modifier = [TextLinePositionModifier new];
    modifier.font = [UIFont fontWithName:@"Heiti SC" size:kWBCellTextFontSize];
    modifier.paddingTop = 4;
    modifier.paddingBottom = 6;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(kWBCellContentWidth-15-6, HUGE);
    container.linePositionModifier = modifier;
    
    _drawGiftDescribeTextLayout = [YYTextLayout layoutWithContainer:container text:text];
    if (!_drawGiftDescribeTextLayout) return;
    
    _drawGiftDescribeTextHeight = [modifier heightForLineCount:_drawGiftDescribeTextLayout.rowCount];
    _drawGiftHeight = _drawGiftDescribeTextHeight;
}


- (void)_layoutRetweetedText {
    _retweetHeight = 0;
    _retweetTextLayout = nil;
    NSMutableAttributedString *text = [self _textWithStatus:_status
                                                  isRetweet:YES
                                                   fontSize:kWBCellTextFontRetweetSize
                                                  textColor:kWBCellTextSubTitleColor];
    if (text.length == 0) return;
    
    TextLinePositionModifier *modifier = [TextLinePositionModifier new];
    modifier.font = [UIFont fontWithName:@"Heiti SC" size:kWBCellTextFontRetweetSize];
    modifier.paddingTop = kWBCellPaddingText;
    modifier.paddingBottom = kWBCellPaddingText;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(kWBCellContentWidth, HUGE);
    container.linePositionModifier = modifier;
    
    _retweetTextLayout = [YYTextLayout layoutWithContainer:container text:text];
    if (!_retweetTextLayout) return;
    
    _retweetTextHeight = [modifier heightForLineCount:_retweetTextLayout.lines.count];
}

- (void)_layoutPics {
    [self _layoutPicsWithStatus:_status isRetweet:NO];
}

- (void)_layoutRetweetPics {
    [self _layoutPicsWithStatus:_status isRetweet:YES];
}

- (void)_layoutPicsWithStatus:(Remark *)status isRetweet:(BOOL)isRetweet {
    if (isRetweet && status.referto.intValue>0) {
        _retweetPicSize = CGSizeZero;
        _retweetPicHeight = 0;
    } else {
        _picSize = CGSizeZero;
        _picHeight = 0;
    }
    if (status.pics.count == 0) return;
    
    CGSize picSize = CGSizeZero;
    CGFloat picHeight = 0;
    
    CGFloat len1_3 = (kWBCellContentWidth + kWBCellPaddingPic) / 3 - kWBCellPaddingPic;
    len1_3 = CGFloatPixelRound(len1_3);
    switch (status.pics.count) {
        case 1: case 2: case 3: {
            picSize = CGSizeMake(len1_3, len1_3);
            picHeight = len1_3;
        } break;
        case 4: case 5: case 6: {
            picSize = CGSizeMake(len1_3, len1_3);
            picHeight = len1_3 * 2 + kWBCellPaddingPic;
        } break;
        case 7: case 8: case 9: { // 7, 8, 9
            picSize = CGSizeMake(len1_3, len1_3);
            picHeight = len1_3 * 3 + kWBCellPaddingPic * 2;
        } break;
        default:{ // 10, 11, 12
            picSize = CGSizeMake(len1_3, len1_3);
            picHeight = len1_3 * 4 + kWBCellPaddingPic * 2;
        }break;
    }
    
    if (isRetweet && status.referto.intValue>0) {
        _retweetPicSize = picSize;
        _retweetPicHeight = picHeight;
    } else {
        _picSize = picSize;
        _picHeight = picHeight;
    }
}

- (NSMutableAttributedString *)_textWithStatus:(Remark *)status
                                     isRetweet:(BOOL)isRetweet
                                      fontSize:(CGFloat)fontSize
                                     textColor:(UIColor *)textColor {
    if (!status) return nil;
    
    NSMutableString *string = nil;
    if (status.status.intValue == 2) {
        string = [NSMutableString stringWithFormat:@"该评论被屏蔽"];
    }else if (isRetweet && status.referto.intValue>0){
        string = status.refercontent.mutableCopy;
    }else{
        string = status.content.mutableCopy;
    }
    if (string.length == 0) return nil;
    if (status.reward == NO){
        if (isRetweet && status.referto.intValue>0) {
            NSString *name = status.refernickname;
            if (name) {
                NSString *insert = [NSString stringWithFormat:@"引用 @%@ 发表的原文:\n",name];
                [string insertString:insert atIndex:0];
            }
        }
        if (status.touserid.intValue>0) {
            NSString *name = status.tonickname;
            if (name) {
                NSString *insert = [NSString stringWithFormat:@"回复 %@:\n",name];
                [string insertString:insert atIndex:0];
            }
        }
    }
    // 字体
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    // 高亮状态的背景
    YYTextBorder *highlightBorder = [YYTextBorder new];
    highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
    highlightBorder.cornerRadius = 3;
    highlightBorder.fillColor = kWBCellTextHighlightBackgroundColor;
    
    NSMutableAttributedString *text;
    // 打赏
    if (status.reward) {
        UIImage *image = [UIImage imageWithCGImage:[UIImage imageNamed:@"remark_reward"].CGImage scale:2 orientation:UIImageOrientationUp];
        text = [NSMutableAttributedString attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:CGSizeMake(18, 15) alignToFont:font alignment:YYTextVerticalAlignmentCenter];
        NSAttributedString *attachText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",string]];
        [text appendAttributedString:attachText];
    }else{
        text = [[NSMutableAttributedString alloc] initWithString:string];
    }
    text.font = font;
    text.color = textColor;
    
    // 匹配 [URL]
    NSArray<NSTextCheckingResult *> *results = [[RemarkStatusHelper regexUrl] matchesInString:text.string options:kNilOptions range:text.rangeOfAll];
    NSString *urlTitle = @"网页链接";
    NSMutableArray *urls = [NSMutableArray array];
    for (NSTextCheckingResult *result in results) {
      NSString * url = [text.string substringWithRange:NSMakeRange(result.range.location, result.range.length)];
        if (url) {
            [urls addObject:url];
        }
    }
    for (NSInteger i=0; i<urls.count; i++) {
        
        NSRange searchRange = NSMakeRange(0, text.string.length);
        do {
            NSRange range = [text.string rangeOfString:urls[i] options:kNilOptions range:searchRange];
            if (range.location == NSNotFound) break;
            
            if ([text attribute:YYTextHighlightAttributeName atIndex:range.location] == nil) {
                
                // 替换的内容
                NSMutableAttributedString *replace = [[NSMutableAttributedString alloc] initWithString:urlTitle];
                replace.font = font;
                replace.color = kWBCellTextHighlightColor;
                
                // 高亮状态
                YYTextHighlight *highlight = [YYTextHighlight new];
                [highlight setBackgroundBorder:highlightBorder];
                // 数据信息，用于稍后用户点击
                highlight.userInfo = @{kWBLinkURLName : urls[i]};
                [replace setTextHighlight:highlight range:NSMakeRange(0, replace.length)];
                
                // 添加被替换的原始字符串，用于复制
                YYTextBackedString *backed = [YYTextBackedString stringWithString:[text.string substringWithRange:range]];
                [replace setTextBackedString:backed range:NSMakeRange(0, replace.length)];
                
                // 替换
                [text replaceCharactersInRange:range withAttributedString:replace];
                
                searchRange.location = searchRange.location + (replace.length ? replace.length : 1);
                if (searchRange.location + 1 >= text.length) break;
                searchRange.length = text.length - searchRange.location;
            } else {
                searchRange.location = searchRange.location + (searchRange.length ? searchRange.length : 1);
                if (searchRange.location + 1>= text.length) break;
                searchRange.length = text.length - searchRange.location;
            }
        } while (1);
    }
    
    
    // 匹配 @用户名
    NSArray *atResults = [[RemarkStatusHelper regexAt] matchesInString:text.string options:kNilOptions range:text.rangeOfAll];
    for (NSTextCheckingResult *at in atResults) {
        if (at.range.location == NSNotFound && at.range.length <= 1) continue;
        if ([text attribute:YYTextHighlightAttributeName atIndex:at.range.location] == nil) {
            [text setColor:kWBCellTextHighlightColor range:at.range];
            
            // 高亮状态
            YYTextHighlight *highlight = [YYTextHighlight new];
            [highlight setBackgroundBorder:highlightBorder];
            // 数据信息，用于稍后用户点击
            highlight.userInfo = @{kWBLinkAtName : [text.string substringWithRange:NSMakeRange(at.range.location + 1, at.range.length - 1)]};
            [text setTextHighlight:highlight range:at.range];
        }
    }
    
    // 匹配 [表情]
    NSArray<NSTextCheckingResult *> *emoticonResults = [[RemarkStatusHelper regexEmoticon] matchesInString:text.string options:kNilOptions range:text.rangeOfAll];
    NSUInteger emoClipLength = 0;
    for (NSTextCheckingResult *emo in emoticonResults) {
        if (emo.range.location == NSNotFound && emo.range.length <= 1) continue;
        NSRange range = emo.range;
        range.location -= emoClipLength;
        if ([text attribute:YYTextHighlightAttributeName atIndex:range.location]) continue;
        if ([text attribute:YYTextAttachmentAttributeName atIndex:range.location]) continue;
        NSString *emoString = [text.string substringWithRange:range];
        NSString *imagePath = [RemarkStatusHelper emoticonDic][emoString];
        UIImage *image = [UIImage imageNamed:imagePath];
        if (!image) continue;
        
        NSAttributedString *emoText = [NSAttributedString attachmentStringWithEmojiImage:image fontSize:fontSize];
        [text replaceCharactersInRange:range withAttributedString:emoText];
        emoClipLength += range.length - 1;
    }
    
    return text;
}

@end
