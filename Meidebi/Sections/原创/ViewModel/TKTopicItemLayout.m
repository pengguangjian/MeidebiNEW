//
//  TKTopicItemLayout.m
//  TaokeSecretary
//
//  Created by mdb-losaic on 2018/1/15.
//  Copyright © 2018年 leecool. All rights reserved.
//

#import "TKTopicItemLayout.h"
/*
 将每行的 baseline 位置固定下来，不受不同字体的 ascent/descent 影响。
 
 注意，Heiti SC 中，    ascent + descent = font size，
 但是在 PingFang SC 中，ascent + descent > font size。
 所以这里统一用 Heiti SC (0.86 ascent, 0.14 descent) 作为顶部和底部标准，保证不同系统下的显示一致性。
 间距仍然用字体默认
 */
@implementation TKTextLinePositionModifier

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
    TKTextLinePositionModifier *one = [self.class new];
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


@implementation TKTopicItemLayout
- (instancetype)initWithTopics:(TKTopicListViewModel *)topic{
    if (!topic) return nil;
    _topic = topic;
    [self layout];
    return self;
}

- (void)layout{
    [self _layout];
}

- (void)_layout{
    _marginTop = kTopicCellTopMargin;
    _profileHeight = 0;
    _textHeight = 0;
    _handleHeight = 0;
    _picHeight = 0;
    _handleHeight = kTopicCellToolbarBottomHeight;
    _marginBottom = kTopicCellToolbarBottomMargin;
    [self _layoutProfile];
    [self _layoutTitle];
    [self _layoutPics];
    [self _layoutText];

    // 计算高度
    _height = _marginTop;
    _height += _marginTop;
    _height += _profileHeight;
    if (_titleTextHeight > 0) {
        _height += _titleTextHeight;
        _height += kTopicCellTopMargin;
    }
    if (_topic.images.count > 0) {
        _height += kTopicCellPadding;
        _height += _picHeight;
    }
    if (_topic.images.count != 1) {
        _height += _textHeight;
    }
    if (_topic.images.count == 1) {
        _height -= kTopicCellToolbarBottomMargin;
    }
    
//    if (_topic.images.count > 1&&_topic.is_video.intValue>0) {
//        _height += _textHeight;
//    }
    
    
    
    _height += kTopicCellPadding;
    _height += _handleHeight;
    _height += _marginBottom;

}

- (void)_layoutProfile {
    [self _layoutName];
    [self _layoutSource];
    _profileHeight = 56;
}

/// 名字
- (void)_layoutName {
    NSString *nameStr = _topic.nickname;
    if (nameStr.length == 0) {
        _nameTextLayout = nil;
        return;
    }
    
    NSMutableAttributedString *nameText = [[NSMutableAttributedString alloc] initWithString:nameStr];
    
    nameText.font = [UIFont systemFontOfSize:12];
    nameText.color = [UIColor colorWithHexString:@"#000000"];
    nameText.lineBreakMode = NSLineBreakByCharWrapping;
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kTopicCellNameWidth, 9999)];
    container.maximumNumberOfRows = 1;
    _nameTextLayout = [YYTextLayout layoutWithContainer:container text:nameText];
}

/// 时间和来源
- (void)_layoutSource {
    NSMutableAttributedString *sourceText = [NSMutableAttributedString new];
    NSMutableAttributedString *createTimeText = [NSMutableAttributedString new];
    NSString * sourece = _topic.classify;
    NSString * createTime = [RemarkStatusHelper stringWithTimelineDate:[NSDate dateWithTimeIntervalSince1970:_topic.time.integerValue]];
    
    // 时间
    if (createTime.length) {
        NSMutableAttributedString *timeText = [[NSMutableAttributedString alloc] initWithString:createTime];
        [timeText appendString:@"  "];
        timeText.font = [UIFont systemFontOfSize:12];
        timeText.color = kTopicCellTimeNormalColor;
        [createTimeText appendAttributedString:timeText];
    }
    if (createTimeText.length == 0) {
        _timeTextLayout = nil;
    } else {
        YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kTopicCellNameWidth, 9999)];
        container.maximumNumberOfRows = 1;
        _timeTextLayout = [YYTextLayout layoutWithContainer:container text:createTimeText];
    }
    
    // 来源
    if (sourece.length) {
        NSMutableAttributedString *source1Text = [[NSMutableAttributedString alloc] initWithString:sourece];
        [source1Text appendString:@"  "];
        source1Text.font = [UIFont systemFontOfSize:12];
        source1Text.color = kTopicCellTimeNormalColor;
        [sourceText appendAttributedString:source1Text];
    }
    if (sourceText.length == 0) {
        _sourceTextLayout = nil;
    } else {
        YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kTopicCellNameWidth, 9999)];
        container.maximumNumberOfRows = 1;
        _sourceTextLayout = [YYTextLayout layoutWithContainer:container text:sourceText];
    }
}

- (void)_layoutTitle{
    NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString:_topic.title];
    titleText.color = RadMenuColor;
    titleText.font = [UIFont fontWithName:@"Heiti SC" size:16];
    if (titleText.length == 0) {
        _titleTextLayout = nil;
        _titleTextHeight = 0;
    } else {
        TKTextLinePositionModifier *modifier = [TKTextLinePositionModifier new];
        modifier.font = [UIFont fontWithName:@"Heiti SC" size:16];
        
        YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kTopicCellContentWidth, 9999)];
        container.maximumNumberOfRows = 2;
        container.truncationType = YYTextTruncationTypeEnd;
        container.linePositionModifier = modifier;
        _titleTextLayout = [YYTextLayout layoutWithContainer:container text:titleText];
        _titleTextHeight = [modifier heightForLineCount:_titleTextLayout.rowCount];
    }
}

- (void)_layoutPics {
    [self _layoutPicsWithTopics:_topic];
}

- (void)_layoutPicsWithTopics:(TKTopicListViewModel *)topic{
    _picSize = CGSizeZero;
    _picHeight = 0;
    if (topic.images.count == 0) return;
    
    CGSize picSize = CGSizeZero;
    CGFloat picHeight = 0;
    
    CGFloat len1_3 = (kTopicCellContentWidth) / 3 - kTopicCellPaddingPic;
    if(topic.is_video.intValue >0)
    {
//        len1_3 = CGFloatPixelRound(len1_3);
//        picSize = CGSizeMake(len1_3*1.5, len1_3*1.5);
//        picHeight = len1_3*1.5;
        
        len1_3 = CGFloatPixelRound(len1_3);
        picSize = CGSizeMake(len1_3, len1_3);
        picHeight = len1_3;
    }
    else
    {
        len1_3 = CGFloatPixelRound(len1_3);
        picSize = CGSizeMake(len1_3, len1_3);
        picHeight = len1_3;
    }
    
    
//    switch (topic.images.count) {
//        case 1: case 2: case 3: {
//            picSize = CGSizeMake(len1_3, len1_3);
//            picHeight = len1_3;
//        } break;
//        case 4: case 5: case 6: {
//            picSize = CGSizeMake(len1_3, len1_3);
//            picHeight = len1_3 * 2 + kTopicCellPaddingPic;
//        } break;
//        case 7: case 8: case 9: { // 7, 8, 9
//            picSize = CGSizeMake(len1_3, len1_3);
//            picHeight = len1_3 * 3 + kTopicCellPaddingPic * 2;
//        } break;
//        default:{ // 10, 11, 12
//            picSize = CGSizeMake(len1_3, len1_3);
//            picHeight = len1_3 * 4 + kTopicCellPaddingPic * 2;
//        }break;
//    }
    _picSize = picSize;
    _picHeight = picHeight;
}

/// 文本
- (void)_layoutText {
    _textHeight = 0;
    _textLayout = nil;
    
    
    NSMutableArray *arrycdj = [[NSUserDefaults standardUserDefaults] objectForKey:@"yuanchuangyidianji"];
    BOOL isbool = [arrycdj containsObject: _topic.topicID];
    
    UIColor *color = [UIColor colorWithHexString:@"#666666"];
    if(_topic.isselectded==YES || isbool==YES)
    {
        color = RGB(150, 150, 150);
    }
    
    NSMutableAttributedString *text = [self _textWithTopics:_topic
                                                   fontSize:kTpoicCellTextFontSize
                                                  textColor:color];
    
    if (text.length == 0) return;
    
    TKTextLinePositionModifier *modifier = [TKTextLinePositionModifier new];
//    modifier.font = [UIFont fontWithName:@"Heiti SC" size:kTpoicCellTextFontSize];
    modifier.font = [UIFont systemFontOfSize:kTpoicCellTextFontSize];
    modifier.paddingTop = kTopicCellPaddingText;
    modifier.paddingBottom = kTopicCellPaddingText;
    
    YYTextContainer *container = [YYTextContainer new];
    if (_topic.images.count == 1) {
        container.size = CGSizeMake(kTopicCellContentWidth-_picSize.width-kTopicCellPaddingText, HUGE);
        container.maximumNumberOfRows = 4;
    }else{
        container.size = CGSizeMake(kTopicCellContentWidth, HUGE);
        container.maximumNumberOfRows = 3;
    }
//    container.truncationType = YYTextTruncationTypeEnd;
    container.linePositionModifier = modifier;
    
    _textLayout = [YYTextLayout layoutWithContainer:container text:text];
    if (!_textLayout) return;
    
    _textHeight = [modifier heightForLineCount:_textLayout.rowCount];
}

- (NSMutableAttributedString *)_textWithTopics:(TKTopicListViewModel *)topics
                                      fontSize:(CGFloat)fontSize
                                     textColor:(UIColor *)textColor {
    if (!topics) return nil;
    NSMutableString *string = nil;
    NSString *str111 = [topics.content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *string22 = [str111 stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    string = (NSMutableString *)string22;
    if (string.length == 0) {
        string = topics.title.mutableCopy;
    }
    if (string.length == 0) return nil;
    // 字体
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    // 高亮状态的背景
    YYTextBorder *highlightBorder = [YYTextBorder new];
    highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
    highlightBorder.cornerRadius = 3;
    highlightBorder.fillColor = kTopicCellTextHighlightBackgroundColor;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
    text.font = font;
    text.color = textColor;
//    text.lineBreakMode = NSLineBreakByCharWrapping;
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
                replace.color = kTopicCellTextHighlightColor;
                
                // 高亮状态
                YYTextHighlight *highlight = [YYTextHighlight new];
                [highlight setBackgroundBorder:highlightBorder];
                // 数据信息，用于稍后用户点击
                highlight.userInfo = @{kTopicLinkURLName : urls[i]};
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
