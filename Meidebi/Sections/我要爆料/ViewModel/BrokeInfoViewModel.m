//
//  BrokeInfoViewModel.m
//  Meidebi
//
//  Created by mdb-admin on 16/7/28.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "BrokeInfoViewModel.h"
#import "NSString+extend.h"
@interface BrokeInfoViewModel ()

@property (nonatomic, strong) NSString *linkImgeLink;
@property (nonatomic, strong) NSString *proprice;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *session;
@property (nonatomic, strong) NSString *linkurl;

@end

@implementation BrokeInfoViewModel

+ (BrokeInfoViewModel *)viewModelWithSubjects:(NSDictionary *)dict{
    BrokeInfoViewModel *viewModel  = [[BrokeInfoViewModel alloc] init];
    [viewModel viewModelWithSubjects:dict];
    return viewModel;
}
- (void)viewModelWithSubjects:(NSDictionary *)subjects{
    _linkImgeLink = [NSString nullToString:subjects[@"linkinfo"][@"linkimge"]];
    _proprice = [NSString nullToString:subjects[@"linkinfo"][@"proprice"]];
    _linkurl = [NSString nullToString:subjects[@"linkinfo"][@"linkurl"]];
    _title = [NSString nullToString:subjects[@"linkinfo"][@"title"]];
    _token = [NSString nullToString:subjects[@"token"][@"value"]];
    _session = [NSString nullToString:subjects[@"session"]];
    _tags = subjects[@"tags"];
    _coinsign = [NSString nullToString:subjects[@"site"][@"coinsign"]];
    _exchange = [NSString nullToString:subjects[@"site"][@"exchange"]];
//    if ([@"2" isEqualToString:[NSString nullToString:subjects[@"type"]]]) {
//        _type = BrokeTypeActivity;
//    }else{
//        _type = BrokeTypeSimply;
//    }
}

- (void)updateImageLinkWithNewLink:(NSString *)link{
    if (link == nil) return;
    _linkImgeLink = link;
}
@end
