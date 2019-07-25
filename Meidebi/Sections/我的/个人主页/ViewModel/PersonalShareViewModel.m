//
//  PersonalShareViewModel.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/21.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "PersonalShareViewModel.h"

@implementation PersonalShareViewModel

+ (instancetype)viewModelWithSubject:(NSDictionary *)subject{
    PersonalShareViewModel *viewModel = [[PersonalShareViewModel alloc] init];
    [viewModel viewModelWithSubject:subject];
    return viewModel;
}

- (void)viewModelWithSubject:(NSDictionary *)subject{
    _userID = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"userid"]]];
    _artid = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"id"]]];
    _content = [NSString stringWithFormat:@"%@",[self removeSpaceAndNewline:[NSString nullToString:subject[@"content"]]]];
    _collectcount = [NSString stringWithFormat:@"%@",[self removeSpaceAndNewline:[NSString nullToString:subject[@"favcount"]]]];
    _showcount = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"showcount"]]];
    _commentcount = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"commentcount"]]];
    _artTitle = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"title"]]];
    _image = [NSString stringWithFormat:@"%@",[NSString nullToString:subject[@"cover"]]];
}

- (NSString *)removeSpaceAndNewline:(NSString *)str
{
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}
@end
