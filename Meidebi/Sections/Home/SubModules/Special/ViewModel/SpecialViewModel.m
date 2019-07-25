//
//  SpecialViewModel.m
//  Meidebi
//
//  Created by mdb-admin on 2017/9/29.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "SpecialViewModel.h"

@implementation SpecialViewModel

+ (instancetype)viewModelWithSubject:(NSDictionary *)subject{
    SpecialViewModel *viewModel = [[SpecialViewModel alloc] init];
    [viewModel viewModelWithSubjects:subject];
    return viewModel;
}

- (void)viewModelWithSubjects:(NSDictionary *)subject{
    _specialID = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"id"]]];
    _title = [NSString nullToString:subject[@"title"]];
    _imageLink = [NSString nullToString:subject[@"image"]];
    _tbContent = [NSString nullToString:subject[@"content"]];
    _commentcount = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"commentcount"]]];
    _browsecount = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"browsecount"]]];
    _praisecount = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"praisecount"]]];
    _hasreward = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"hasreward"]]];
    NSString *type = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"type"]]];
    if ([@"4" isEqualToString:type]) {
        _style = SpecialSourceStyleTaobao;
    }else{
        _style = SpecialSourceStyleInner;
    }

}

@end
