//
//  TKExploreViewModel.m
//  TaokeSecretary
//
//  Created by mdb-losaic on 2018/1/15.
//  Copyright © 2018年 leecool. All rights reserved.
//

#import "TKExploreViewModel.h"
@implementation TKExploreViewModel

@end


@implementation TKTopicListViewModel
+ (instancetype)viewModelWithSubject:(NSDictionary *)subject{
    if ([subject isKindOfClass:[NSNull class]]) return nil;
    TKTopicListViewModel *viewModel = [[TKTopicListViewModel alloc] init];
    [viewModel viewModelWithSubjects:subject];
    return viewModel;
}
- (void)viewModelWithSubjects:(NSDictionary *)subject{
    _topicID = [NSString nullToString:subject[@"id"]];
    _title = [NSString nullToString:subject[@"title"]];
    _content = [self removeSpaceAndNewline:[NSString nullToString:subject[@"content"]]];
    
    _thumbnails = [NSMutableArray new];
    if([subject[@"thumbnail"] isKindOfClass:[NSArray class]])
    {
        [_thumbnails addObjectsFromArray:subject[@"thumbnail"]];
    }
    
//    _thumb = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"thumb"]]];
//    _commentCount = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"comment_count"] preset:@"0"]];
    
    _thumb = [self numberChangeStringValue:[NSNumber numberWithInt:[NSString nullToString:subject[@"thumb"]].intValue]];
    _commentCount = [self numberChangeStringValue:[NSNumber numberWithInt:[NSString nullToString:subject[@"comment_count"]].intValue]];
    
    _is_video = [NSString nullToString:subject[@"video_type"]];
    _images = [NSMutableArray new];
    if([subject[@"images"] isKindOfClass:[NSArray class]])
    {
        [_images addObjectsFromArray:subject[@"images"]];
    }
    if([subject[@"video"] isKindOfClass:[NSArray class]])
    {
        NSArray *arrtempvideo = subject[@"video"];
        NSMutableArray *arrvideourl = [NSMutableArray new];
        for(int i = 0 ; i < arrtempvideo.count; i++)
        {
            if([arrtempvideo[i] isKindOfClass:[NSDictionary class]])
            {
                [_images insertObject:[NSString nullToString:[arrtempvideo[i] objectForKey:@"video_img"]] atIndex:i];
                [arrvideourl addObject:[NSString nullToString:[arrtempvideo[i] objectForKey:@"video_url"]]];
                
                [_thumbnails insertObject:[NSString nullToString:[arrtempvideo[i] objectForKey:@"video_img"]] atIndex:i];
                
            }
        }
        _video = arrvideourl;
    }
    
    
    
    _time = [NSString nullToString:subject[@"createtime"]];
    _userID = [NSString nullToString:subject[@"user"][@"userid"]];
    _avatar = [NSString nullToString:subject[@"user"][@"avatar"]];
    _nickname = [NSString nullToString:subject[@"user"][@"nickname"]];
    NSString *sticky = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"is_top"]]];
    if ([sticky isEqualToString:@"1"]) {
        _hasSticky = YES;
    }else {
        _hasSticky = NO;
    }
    NSString *highlight = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"isperfect"]]];
    if ([@"1" isEqualToString:highlight]) {
        _hasHighlight = YES;
    }else{
        _hasHighlight = NO;
    }
    NSString *classify = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"classify"]]];
//    if ([@"1" isEqualToString:classify]) {
//        classify = @"晒单广场";
//        _topicType = TKTopicTypeShaiDan;
//    }else if ([@"2" isEqualToString:classify]) {
//        classify = @"生活经验";
//        _topicType = TKTopicTypeEnable;
//    }else if ([@"3" isEqualToString:classify]) {
//        classify = @"必买清单";
//        _topicType = TKTopicTypeShoppingList;
//    }else if ([@"4" isEqualToString:classify]) {
//        classify = @"匿名吐槽";
//        _topicType = TKTopicTypeSpitslot;
//    }else if ([@"5" isEqualToString:classify]) {
//        classify = @"日常话题";
//        _topicType = TKTopicTypeDaily;
//    }else if ([@"6" isEqualToString:classify]) {
//        classify = @"穿搭导购";
//        _topicType = TKTopicTypeLooks;
//    }else if ([@"7" isEqualToString:classify]) {
//        classify = @"评测试用";
//        _topicType = TKTopicTypeEvaluation;
//    }else{
//        classify = @"未知";
//        _topicType = TKTopicTypeUnknown;
//    }
    classify = [self backTypeString:classify.integerValue];
    _topicType = classify.integerValue;
    _classify = [NSString stringWithFormat:@"来自：%@",classify];
}

-(NSString *)backTypeString:(NSInteger)type
{
    NSString *typeStr = @"";
    switch (type) {
        case TKTopicTypeEnable:
            typeStr = @"#生活经验#";
            break;
        case TKTopicTypeLooks:
            typeStr = @"#服饰鞋包#";
            break;
        case TKTopicTypeBeauty:
            typeStr = @"#美妆护肤#";
            break;
        case TKTopicType3C:
            typeStr = @"#数码家电#";
            break;
        case TKTopicTypeDeliciousfood:
            typeStr = @"美食旅游#";
            break;
        case TKTopicTypeEvaluation:
            typeStr = @"#评测试用#";
            break;
        case TKTopicTypeOther:
            typeStr = @"#其他#";
            break;
        case TKTopicTypeShaiDan:
            typeStr = @"#晒单广场#";
            break;
        case TKTopicTypeSpitslot:
            typeStr = @"#匿名吐槽#";
            break;
        case TKTopicTypeDaily:
            typeStr = @"#日常话题#";
            break;
        case TKTopicTypeShoppingList:
            typeStr = @"#必买清单#";
            break;
        default:
            typeStr = @"#未知#";
            break;
    }
    
    return typeStr;
    
}

- (NSString *)removeSpaceAndNewline:(NSString *)str
{
    //    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    //    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    //    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //    return temp;
    NSString *content = str;
    NSMutableString *mutContentStr;
    if (content&&![content isEqualToString:@""]) {
        mutContentStr=[NSMutableString stringWithString:content];
    }else{
        return nil;
    }
    if (IOS_VERSION_8_OR_ABOVE) {
        while ([mutContentStr containsString:@"\n"]) {
            NSRange range=[mutContentStr rangeOfString:@"\n"];
            [mutContentStr deleteCharactersInRange:range];
        }
        while ([mutContentStr containsString:@"\t"]) {
            NSRange range=[mutContentStr rangeOfString:@"\t"];
            [mutContentStr deleteCharactersInRange:range];
        }
        while ([mutContentStr containsString:@"&nbsp;"]) {
            NSRange range=[mutContentStr rangeOfString:@"&nbsp;"];
            [mutContentStr deleteCharactersInRange:range];
        }
        while ([mutContentStr containsString:@"  "]) {
            NSRange range=[mutContentStr rangeOfString:@"  "];
            [mutContentStr deleteCharactersInRange:range];
        }
        while ([mutContentStr containsString:@"\r"]) {
            NSRange range=[mutContentStr rangeOfString:@"\r"];
            [mutContentStr deleteCharactersInRange:range];
        }
        
        return [NSString stringWithString:mutContentStr];
    }else{
        while ([mutContentStr rangeOfString:@"\n"].length>0) {
            NSRange range=[mutContentStr rangeOfString:@"\n"];
            [mutContentStr deleteCharactersInRange:range];
        }
        while ([mutContentStr rangeOfString:@"\t"].length>0) {
            NSRange range=[mutContentStr rangeOfString:@"\t"];
            [mutContentStr deleteCharactersInRange:range];
        }
        while ([mutContentStr rangeOfString:@"&nbsp;"].length>0) {
            NSRange range=[mutContentStr rangeOfString:@"&nbsp;"];
            [mutContentStr deleteCharactersInRange:range];
        }
        while ([mutContentStr rangeOfString:@"  "].length>0) {
            NSRange range=[mutContentStr rangeOfString:@"  "];
            [mutContentStr deleteCharactersInRange:range];
        }
        while ([mutContentStr rangeOfString:@"\r"].length>0) {
            NSRange range=[mutContentStr rangeOfString:@"\r"];
            [mutContentStr deleteCharactersInRange:range];
        }
        return [NSString stringWithString:mutContentStr];
    }
}

-(NSString *)numberChangeStringValue:(NSNumber *)value
{
    NSString *strtemp = @"";
    if(value.integerValue>=1000&&value.integerValue<10000)
    {
        strtemp = [NSString stringWithFormat:@"%dk+",value.intValue/1000];
    }
    else if (value.integerValue>=10000)
    {
        strtemp = [NSString stringWithFormat:@"%dw+",value.intValue/10000];
    }
    else
    {
        strtemp = [NSString stringWithFormat:@"%d",value.intValue];
    }
    return strtemp;
}


@end

@implementation TKTopicDetailViewModel
+ (instancetype)viewModelWithSubject:(NSDictionary *)subject{
    if ([subject isKindOfClass:[NSNull class]]) return nil;
    TKTopicDetailViewModel *viewModel = [[TKTopicDetailViewModel alloc] init];
    [viewModel viewModelWithSubjects:subject];
    return viewModel;
}
- (void)viewModelWithSubjects:(NSDictionary *)subject{
    _topicID = [NSString nullToString:subject[@"id"]];
    _title = [NSString nullToString:subject[@"title"]];
    _content_url = [NSString stringWithFormat:@"%@%@",URL_HR,[NSString nullToString:subject[@"content_url"]]];
    _images = subject[@"images"];
    _comment = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"comment"]]];
    _collect = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"marks"]]];
    _thumb = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"thumb"]]];
    
    _thumb = [self numberChangeStringValue:[NSNumber numberWithInt:[NSString nullToString:subject[@"thumb"]].intValue]];
    _comment = [self numberChangeStringValue:[NSNumber numberWithInt:[NSString nullToString:subject[@"comment"]].intValue]];
    _collect = [self numberChangeStringValue:[NSNumber numberWithInt:[NSString nullToString:subject[@"marks"]].intValue]];
    
    
    _time = [self tk_stringWithTimelineDate:[NSDate dateWithTimeIntervalSince1970:[[NSString nullToString:subject[@"time"]] integerValue]]];
    _userID = [NSString nullToString:subject[@"user"][@"author_id"]];
    _avatar = [NSString nullToString:subject[@"user"][@"author_avatar"]];
    _nickname = [NSString nullToString:subject[@"user"][@"author"]];
    _comments = subject[@"comments"];
    
    NSString *classify = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"classify"]]];
    if ([@"1" isEqualToString:classify]) {
        classify = @"晒单广场";
        _topicType = TKTopicTypeShaiDan;
    }else if ([@"2" isEqualToString:classify]) {
        classify = @"生活经验";
        _topicType = TKTopicTypeEnable;
    }else if ([@"3" isEqualToString:classify]) {
        classify = @"必买清单";
        _topicType = TKTopicTypeShoppingList;
    }else if ([@"4" isEqualToString:classify]) {
        classify = @"匿名吐槽";
        _topicType = TKTopicTypeSpitslot;
    }else if ([@"5" isEqualToString:classify]) {
        classify = @"日常话题";
        _topicType = TKTopicTypeDaily;
    }else if ([@"6" isEqualToString:classify]) {
        classify = @"穿搭导购";
        _topicType = TKTopicTypeLooks;
    }else if ([@"7" isEqualToString:classify]) {
        classify = @"评测试用";
        _topicType = TKTopicTypeEvaluation;
    }else{
        classify = @"未知";
        _topicType = TKTopicTypeUnknown;
    }
    _classify = [NSString stringWithFormat:@"来自：%@",classify];
    
    NSString *is_fav = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"is_fav"]]];
    if ([is_fav isEqualToString:@"1"]) {
        _has_fav = YES;
    }else {
        _has_fav = NO;
    }
    NSString *is_thumb = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"is_thumb"]]];
    if ([@"1" isEqualToString:is_thumb]) {
        _has_thumb = YES;
    }else{
        _has_thumb = NO;
    }
}

- (NSString *)tk_stringWithTimelineDate:(NSDate *)date{
    if (!date) return @"";
    static NSDateFormatter *formatterYesterday;
    static NSDateFormatter *formatterSameYear;
    static NSDateFormatter *formatterFullDate;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatterYesterday = [[NSDateFormatter alloc] init];
        [formatterYesterday setDateFormat:@"昨天 HH:mm"];
        [formatterYesterday setLocale:[NSLocale currentLocale]];
        
        formatterSameYear = [[NSDateFormatter alloc] init];
        [formatterSameYear setDateFormat:@"M-d"];
        [formatterSameYear setLocale:[NSLocale currentLocale]];
        
        formatterFullDate = [[NSDateFormatter alloc] init];
        [formatterFullDate setDateFormat:@"YYYY.MM.dd HH:mm"];
        [formatterFullDate setLocale:[NSLocale currentLocale]];
    });
    return [formatterFullDate stringFromDate:date];
}

-(NSString *)numberChangeStringValue:(NSNumber *)value
{
    NSString *strtemp = @"";
    if(value.integerValue>=1000&&value.integerValue<10000)
    {
        strtemp = [NSString stringWithFormat:@"%dk+",value.intValue/1000];
    }
    else if (value.integerValue>=10000)
    {
        strtemp = [NSString stringWithFormat:@"%dw+",value.intValue/10000];
    }
    else
    {
        strtemp = [NSString stringWithFormat:@"%d",value.intValue];
    }
    return strtemp;
}

@end

