//
//  PersonalRemarkLayout.m
//  Meidebi
//
//  Created by mdb-admin on 2017/2/13.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "PersonalRemarkLayout.h"

#import "RemarkStatusHelper.h"
/*
 将每行的 baseline 位置固定下来，不受不同字体的 ascent/descent 影响。
 
 注意，Heiti SC 中，    ascent + descent = font size，
 但是在 PingFang SC 中，ascent + descent > font size。
 所以这里统一用 Heiti SC (0.86 ascent, 0.14 descent) 作为顶部和底部标准，保证不同系统下的显示一致性。
 间距仍然用字体默认
 */
@implementation PersonalRemarkTextLinePositionModifier

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
    PersonalRemarkTextLinePositionModifier *one = [self.class new];
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



@implementation PersonalRemarkLayout

- (instancetype)initWithStatus:(PersonalRemark *)status style:(PersonalRemarkMenuType)style;
{
    if (!status) return nil;
    self = [super init];
    _status = status;
    _style = style;
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
    _marginTop = 0;
    _profileHeight = 0;
    _textHeight = 0;
    _retweetHeight = 0;
    _retweetTextHeight = 0;
    _retweetPicHeight = 0;
    _textRemarkHeight = 0;
    _picHeight = 0;
    _marginBottom = kWBCellToolbarBottomMargin;
    
    // 文本排版，计算布局
    [self _layoutProfile];
    if ([_status.pose isEqualToString:@"quote"]) {
        [self _layoutRetweet];
    }
    if (_retweetHeight == 0) {
        [self _layoutPics];
    }
    [self _layoutText];
    
    // 计算高度
    _height = _marginTop;
    _height += _marginTop;
    _height += _profileHeight;
    _height += _textHeight;
    _height += _textRemarkHeight;
    if (_retweetHeight > 0) {
        _height += _retweetHeight;
    } else if (_picHeight > 0) {
        _height += _picHeight;
    }
    if (_picHeight > 0) {
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
    NSString *nameStr = _status.ousername;
    if (nameStr.length == 0) {
        _nameTextLayout = nil;
        return;
    }
    
    NSMutableAttributedString *nameText = [[NSMutableAttributedString alloc] initWithString:nameStr];
    
    nameText.font = [UIFont systemFontOfSize:kWBCellSourceFontSize];
    nameText.color = kWBCellTimeNormalColor ;
    nameText.lineBreakMode = NSLineBreakByCharWrapping;
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kWBCellNameWidth, 9999)];
    container.maximumNumberOfRows = 1;
    _nameTextLayout = [YYTextLayout layoutWithContainer:container text:nameText];
    
    _nameTextSize = [nameStr boundingRectWithSize:CGSizeMake(kWBCellNameWidth, 9999)
                                            options:NSStringDrawingTruncatesLastVisibleLine
                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kWBCellSourceFontSize]}
                                            context:nil].size;;

}

/// 时间和来源
- (void)_layoutSource {
    NSMutableAttributedString *sourceText = [NSMutableAttributedString new];
    NSString *createTime = _status.createtime;
    
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
    
    NSMutableAttributedString *text = [self _textWithStatus:[self obtainStatusText]
                                                  isRetweet:NO
                                                   fontSize:kWBCellTextFontSize
                                                  textColor:kWBCellTextNormalColor];
    if (text.length == 0) return;
    
    PersonalRemarkTextLinePositionModifier *modifier = [PersonalRemarkTextLinePositionModifier new];
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

- (NSMutableAttributedString *)obtainStatusText{
    NSMutableAttributedString *text = nil;
    NSMutableString *string = nil;
    NSString *fromTitle = [NSString nullToString:_status.fromtitle];
    if ([_status.pose isEqualToString:@"quote"]) {
        if (_style == PersonalRemarkMenuTypeReply) {
            NSString *tempFromTitle = [NSString stringWithFormat:@"在%@中引用我的评论：",fromTitle];
            
            tempFromTitle = fromTitle;
            
            text = [[NSMutableAttributedString alloc] initWithString:tempFromTitle];
            [text addAttribute:NSForegroundColorAttributeName
                         value:[UIColor colorWithHexString:@"#999999"]
                         range:NSMakeRange(0, tempFromTitle.length)];
            [text addAttribute:NSFontAttributeName
                         value:[UIFont systemFontOfSize:13]
                         range:NSMakeRange(0, text.string.length)];
        }else{
            NSString *nameStr = [NSString stringWithFormat:@"@%@",[NSString nullToString:_status.ousername]];
            NSString *tempFromTitle = [NSString stringWithFormat:@"在%@中引用",fromTitle];
            NSString *temStr = @"的评论：";
            NSString *contentStr = [NSString stringWithFormat:@"%@ %@",tempFromTitle,nameStr];
            string = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",contentStr,temStr]];
            
            nameStr = @"";
            tempFromTitle = @"";
            temStr = @"";
            contentStr = @"";
            string = [NSMutableString stringWithFormat:@"%@",@""];
            
            text = [[NSMutableAttributedString alloc] initWithString:string];
            [text addAttribute:NSForegroundColorAttributeName
                         value:[UIColor colorWithHexString:@"#999999"]
                         range:NSMakeRange(0, tempFromTitle.length)];
            [text addAttribute:NSForegroundColorAttributeName
                         value:[UIColor colorWithHexString:@"#999999"]
                         range:NSMakeRange(contentStr.length, temStr.length)];
            [text addAttribute:NSForegroundColorAttributeName
                         value:[UIColor colorWithHexString:@"#999999"]
                         range:NSMakeRange(tempFromTitle.length, nameStr.length)];
            [text addAttribute:NSFontAttributeName
                         value:[UIFont systemFontOfSize:13]
                         range:NSMakeRange(0, string.length)];
        }
        [self _layoutRemarkText];
        
    }else if ([_status.pose isEqualToString:@"reply"]) {
        BOOL isRead=[[NSString nullToString:_status.isread] boolValue];
        NSString *commentStr = [NSString nullToString:_status.comment];
        NSString *nameStr = [NSString stringWithFormat:@"@%@",[NSString nullToString:_status.ousername]];
        NSString *tempFromTitle = [NSString stringWithFormat:@"在%@中回复",fromTitle];
        NSString *contentStr = [NSString stringWithFormat:@"%@%@： ",tempFromTitle,nameStr];
        
        
        tempFromTitle = @"";
        nameStr = @"";
        contentStr = @"";
        
        
        
        text = [[NSMutableAttributedString alloc] initWithString:[contentStr stringByAppendingString:commentStr]];
        [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(tempFromTitle.length, nameStr.length)];
        [text addAttribute:NSForegroundColorAttributeName
                                    value:[UIColor colorWithHexString:@"#999999"]
                                    range:NSMakeRange(tempFromTitle.length, nameStr.length)];
        [text addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:NSMakeRange(contentStr.length, commentStr.length)];
        
        [text addAttribute:NSForegroundColorAttributeName
                                    value:[UIColor colorWithHexString:@"#999999"]
                                    range:NSMakeRange(0, tempFromTitle.length)];
        
        
        if (!isRead && _style==PersonalRemarkMenuTypeReply) {
            [text addAttribute:NSForegroundColorAttributeName
                                        value:RGB(0, 90, 160)
                                        range:NSMakeRange(contentStr.length, commentStr.length)];
        }else{
            [text addAttribute:NSForegroundColorAttributeName
                                        value:[UIColor colorWithHexString:@"#555555"]
                                        range:NSMakeRange(contentStr.length, commentStr.length)];
        }

    }else{
        NSString *commentStr  = [NSString nullToString:_status.comment];
//        if (_style == PersonalRemarkMenuTypeReply) {
//            string = [NSMutableString stringWithFormat:@"在%@中回复我评论：",fromTitle];
//        }else{
//            string = [NSMutableString stringWithFormat:@"在%@中评论：",fromTitle];
//        }
//        text = [[NSMutableAttributedString alloc] initWithString:[string stringByAppendingString:commentStr]];
//        [text addAttribute:NSFontAttributeName
//                     value:[UIFont systemFontOfSize:13]
//                     range:NSMakeRange(0, string.length)];
//        [text addAttribute:NSForegroundColorAttributeName
//                     value:[UIColor colorWithHexString:@"#999999"]
//                     range:NSMakeRange(0, string.length)];
//
//        [text addAttribute:NSFontAttributeName
//                     value:[UIFont boldSystemFontOfSize:15]
//                     range:NSMakeRange(string.length, commentStr.length)];
        
        string = [NSMutableString stringWithFormat:@"%@",@""];
        text = [[NSMutableAttributedString alloc] initWithString:commentStr];
        [text addAttribute:NSFontAttributeName
                     value:[UIFont boldSystemFontOfSize:15]
                     range:NSMakeRange(string.length, commentStr.length)];
        
        BOOL isRead=[[NSString nullToString:_status.isread] boolValue];
        if (!isRead && _style==PersonalRemarkMenuTypeReply) {
            [text addAttribute:NSForegroundColorAttributeName
                         value:RGB(0, 90, 160)
                         range:NSMakeRange(string.length, commentStr.length)];
        }else{
            [text addAttribute:NSForegroundColorAttributeName
                         value:[UIColor colorWithHexString:@"#555555"]
                         range:NSMakeRange(string.length, commentStr.length)];
        }

    }
    
    return text;
}


- (void)_layoutRetweetedText {
    _retweetHeight = 0;
    _retweetTextLayout = nil;
    
    NSString *string = [NSString stringWithFormat:@"%@",[NSString nullToString:_status.qcontent]];
    NSMutableAttributedString *texts = [[NSMutableAttributedString alloc] initWithString:string];
    texts.font = [UIFont systemFontOfSize:kWBCellTextFontRetweetSize];
    texts.color = kWBCellTextSubTitleColor;
    
    NSMutableAttributedString *text = [self _textWithStatus:texts
                                                  isRetweet:YES
                                                   fontSize:kWBCellTextFontRetweetSize
                                                  textColor:kWBCellTextSubTitleColor];
    if (text.length == 0) return;
    
    PersonalRemarkTextLinePositionModifier *modifier = [PersonalRemarkTextLinePositionModifier new];
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
- (void)_layoutRemarkText{
    _textRemarkHeight = 0;
    _textRemarkLayout = nil;

    NSString *string = [NSString stringWithFormat:@"%@",[NSString nullToString:_status.comment]];
    NSMutableAttributedString *texts = [[NSMutableAttributedString alloc] initWithString:string];
    [texts addAttribute:NSFontAttributeName
                 value:[UIFont boldSystemFontOfSize:15]
                 range:NSMakeRange(0, string.length)];
    BOOL isRead=[[NSString nullToString:_status.isread] boolValue];
    if (isRead) {
        [texts addAttribute:NSForegroundColorAttributeName
                     value:RGB(0, 90, 160)
                     range:NSMakeRange(0, string.length)];
    }else{
        [texts addAttribute:NSForegroundColorAttributeName
                     value:[UIColor colorWithHexString:@"#555555"]
                     range:NSMakeRange(0, texts.string.length)];
    }
    
    NSMutableAttributedString *text = [self _textWithStatus:texts
                                                  isRetweet:YES
                                                   fontSize:kWBCellTextFontRetweetSize
                                                  textColor:kWBCellTextSubTitleColor];
    
    if (text.length == 0) return;
    
    PersonalRemarkTextLinePositionModifier *modifier = [PersonalRemarkTextLinePositionModifier new];
    modifier.font = [UIFont fontWithName:@"Heiti SC" size:kWBCellTextFontRetweetSize];
    modifier.paddingTop = kWBCellPaddingText;
    modifier.paddingBottom = kWBCellPaddingText;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(kWBCellContentWidth, HUGE);
    container.linePositionModifier = modifier;
    
    _textRemarkLayout = [YYTextLayout layoutWithContainer:container text:text];
    if (!_textRemarkLayout) return;
    
    _textRemarkHeight = [modifier heightForLineCount:_textRemarkLayout.lines.count];
}

- (void)_layoutPics {
    [self _layoutPicsWithStatus:_status isRetweet:NO];
}

- (void)_layoutRetweetPics {
    [self _layoutPicsWithStatus:_status isRetweet:YES];
}

- (void)_layoutPicsWithStatus:(PersonalRemark *)status isRetweet:(BOOL)isRetweet {
    if (isRetweet && [_status.pose isEqualToString:@"quote"]) {
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
    
    if (isRetweet && [_status.pose isEqualToString:@"quote"]) {
        _retweetPicSize = picSize;
        _retweetPicHeight = picHeight;
    } else {
        _picSize = picSize;
        _picHeight = picHeight;
    }
}

- (NSMutableAttributedString *)_textWithStatus:(NSMutableAttributedString *)statuText
                                     isRetweet:(BOOL)isRetweet
                                      fontSize:(CGFloat)fontSize
                                     textColor:(UIColor *)textColor {
    if (!statuText) return nil;
    
    // 字体
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    NSMutableAttributedString *text = statuText;
   
    // 高亮状态的背景
    YYTextBorder *highlightBorder = [YYTextBorder new];
    highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
    highlightBorder.cornerRadius = 3;
    highlightBorder.fillColor = kWBCellTextHighlightBackgroundColor;
    
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
