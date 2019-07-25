//
//  LastNewsModel.m
//  Meidebi
//
//  Created by leecool on 2017/9/27.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "LastNewsModel.h"

@implementation LastNewsModel
+ (instancetype)viewModelWithSubject:(NSDictionary *)subject{
    if ([subject isKindOfClass:[NSNull class]]) return nil;
    LastNewsModel *viewModel = [[LastNewsModel alloc] init];
    [viewModel viewModelWithSubjects:subject];
    return viewModel;
}
- (void)viewModelWithSubjects:(NSDictionary *)subject{
    _newsID = [NSString nullToString:subject[@"id"]];
    _title = [NSString nullToString:subject[@"title"]];
    _imageLink = [NSString nullToString:subject[@"image"]];
    _site = [NSString nullToString:subject[@"site"]];
    _time = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"createtime"]]];
    _userName = [NSString nullToString:subject[@"username"]];
    _avaterImageLink = [NSString nullToString:subject[@"photo"]];
    _price = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"price"]]];
    _likeCount = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"votesp"]]];
    _remarkCount = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"commentcount"]]];
    NSString *type = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"type"]]];
    if ([type isEqualToString:@"1"]) {
        _style = NewsTypeDiscount;
        _rowHeight = 148;
        _sourceStr = [NSString stringWithFormat:@"爆料来自：%@",_userName];
    }else if ([type isEqualToString:@"2"]){
        _style = NewsTypeOriginal;
        _rowHeight = IS_IPHONE_WIDE_SCREEN ? (kMainScreenW*.68) : (kMainScreenW*.67);
        _sourceStr = [NSString stringWithFormat:@"原创来自：%@",_userName];
    }else if ([type isEqualToString:@"3"]){
        _style = NewsTypeSpecial;
        _rowHeight = IS_IPHONE_WIDE_SCREEN ? (kMainScreenW*.68) : (kMainScreenW*.67);
        _sourceStr = [NSString stringWithFormat:@"专题来自：%@",_userName];
    }
    
    
}

@end
