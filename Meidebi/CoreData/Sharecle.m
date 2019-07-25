//
//  Sharecle.m
//  Meidebi
//
//  Created by 杜非 on 15/1/25.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import "Sharecle.h"

@implementation Sharecle

-(instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.shareid=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"id"]]integerValue]];
        self.album=[self setisElequltoString:[dic objectForKey:@"album"]] ;
        self.average=[self setisElequltoString:[dic objectForKey:@"average"]];
        self.chechtime=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"checktime"]]integerValue]];
        self.coinsnum=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"coinsnum"]] integerValue]];
        self.content=[self removeContent:[self setisElequltoString:[dic objectForKey:@"content"]]];
        self.commentcount=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"commentcount"]] integerValue]];
        self.coppernum=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"coppernum"]] integerValue]];
        self.cover=[self setisElequltoString:[dic objectForKey:@"cover"]];
        self.createtime=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"createtime"]] integerValue]];
        self.custom=[self setisElequltoString:[dic objectForKey:@"custom"]];
        self.dbquality=[self setisElequltoString:[dic objectForKey:@"dbquality"]];
        self.dispatch=[self setisElequltoString:[dic objectForKey:@"dispatch"]];
        self.headphoto=[self setisElequltoString:[dic objectForKey:@"headphoto"]];
        self.impression=[self setisElequltoString:[dic objectForKey:@"impression"]];
        self.ip=[self setisElequltoString:[dic objectForKey:@"ip"]];
        self.orgimages=[self setisElequltoString:[dic objectForKey:@"orgimages"]];
        self.isabroad=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"isabroad"]] integerValue]];
        self.isperfect=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"isperfect"]] integerValue]];
        self.name=[self setisElequltoString:[dic objectForKey:@"name"]];
        self.pic=[self setisElequltoString:[dic objectForKey:@"pic"]];
        self.pics=[self setisElequltoString:[dic objectForKey:@"pics"]];
        self.reason=[self setisElequltoString:[dic objectForKey:@"reason"]];
        self.remark=[self setisElequltoString:[dic objectForKey:@"remark"]];
        self.remotelink=[self setisElequltoString:[dic objectForKey:@"remotelink"]];
        self.userLevel=[self setisElequltoString:dic[@"user_level"]];
        self.setpftime=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"setpftime"]] integerValue]];
        self.showcount=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"showcount"]] integerValue]];
        self.siteid=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"siteid"]] integerValue]];
        self.star=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"star"]] integerValue]] ;
        self.status=[NSNumber numberWithInteger: [[self setisElequltoString:[dic objectForKey:@"status"]] integerValue]];
        self.tagstr=[self setisElequltoString:[dic objectForKey:@"tagstr"]];
        self.title=[self setisElequltoString:[dic objectForKey:@"title"]];
        self.transitcopany=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"transitcopany"]]integerValue]];
        self.unchecked=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"unchecked"]]integerValue]];
        self.votesp=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"votesp"]] integerValue]];
        self.userid=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"userid"]] integerValue]];
        self.votesm=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"votesm"]] integerValue]];
        self.devicetype=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"devicetype"]] integerValue]];
        self.width=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"width"]] integerValue]];
        self.height=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"height"]] integerValue]];
        if ([[self setisElequltoString:[dic objectForKey:@"is_follow"]] integerValue] == 1) {
            self.isFllow = YES;
        }else{
            self.isFllow = NO;
        }
        self.tags = dic[@"tags"];
        self.cellHeight = [self caculateHeight];
        _identifier = [self uniqueIdentifier];

    }
    return self;
}
-(void)setWithMyHouseDic:(NSDictionary *)dic{
    self.shareid=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"id"]] integerValue]];
    self.coppernum=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"iZanNum"]] integerValue]];
    self.status=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"state"]] integerValue]];
    self.name=[self setisElequltoString:[dic objectForKey:@"strDown"]];
    self.headphoto=[self setisElequltoString:[dic objectForKey:@"strImgUrl"]];
    self.tagstr=[self setisElequltoString:[dic objectForKey:@"strUp"]];
}


- (NSString *)uniqueIdentifier
{
    static NSInteger counter = 0;
    return [NSString stringWithFormat:@"unique-id-%@", @(counter++)];
}


-(NSString *)removeContent:(NSString *)content{
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

-(NSString *)setisElequltoString:(id)str{
    if (![str isKindOfClass:[NSString class]]) {
        return [NSString stringWithFormat:@"%@",str];
    }
    if ((NSNull *)str ==[NSNull null]) {
        return nil;
    }else{
        return  [str isEqualToString:@"<null>"]||[str isEqualToString:@"<NULL>"]||[str isEqualToString:@""]||[str isEqualToString:@"null"]||[str isEqualToString:@"NSNULL"] ? nil : str;
        
    }
    
}

- (CGFloat)caculateHeight{
    CGFloat totalHeight = 0.0;
    CGFloat contentTopMargin = 10;
    CGFloat contentBottomMargin = 20;
    
    totalHeight += contentTopMargin;
    totalHeight += contentBottomMargin;
    totalHeight += 30;
    totalHeight += 10;
    totalHeight += (kMainScreenW-30)*0.463;
    totalHeight += 16;
    totalHeight += [self calculateTextHeightWithText:self.title fontSize:14.f].size.height;
    if (self.tagstr.length>0) {
        totalHeight += 5;
        totalHeight += 50;
    }
    totalHeight += [self heightForLineCount:3];
    totalHeight += 14;
    totalHeight += 15;
    totalHeight += 20;
    return totalHeight;
}

- (CGRect)calculateTextHeightWithText:(NSString *)text
                             fontSize:(CGFloat)size{
    CGSize maxSize = CGSizeMake(kMainScreenW-25, MAXFLOAT);
    CGRect contentRect = [text boundingRectWithSize:maxSize
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]}
                                            context:nil];
    return contentRect;
}

- (CGFloat)heightForLineCount:(NSUInteger)lineCount {
    if (lineCount == 0) return 0;
    CGFloat _lineHeightMultiple;
    if (IOS_VERSION_9_OR_ABOVE) {
        _lineHeightMultiple = 1.34;   // for PingFang SC
    } else {
        _lineHeightMultiple = 1.3125; // for Heiti SC
    }
    CGFloat ascent = [UIFont systemFontOfSize:13].pointSize * 0.86;
    CGFloat descent = [UIFont systemFontOfSize:13].pointSize * 0.14;
    CGFloat lineHeight = [UIFont systemFontOfSize:13].pointSize * _lineHeightMultiple;
    CGFloat paddingTop = 0;
    CGFloat paddingBottom = 0;

    return paddingTop + paddingBottom + ascent + descent + (lineCount - 1) * lineHeight;
}
@end
