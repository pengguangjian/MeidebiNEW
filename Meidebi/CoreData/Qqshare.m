//
//  Qqshare.m
//  Meidebi
//
//  Created by 杜非 on 15/3/25.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import "Qqshare.h"

@implementation Qqshare


-(id)initWithdic:(NSDictionary *)dic{
    if (self) {
        self=[super init];
    }
    self.image=[NSString nullToString:[dic objectForKey:@"image"]];
    self.qqsharecontent=[NSString nullToString:[dic objectForKey:@"qqsharecontent"]];
    self.qqsharetitle=[NSString nullToString:[dic objectForKey:@"qqsharetitle"]];
    self.qqshareuserdefaultword=[NSString nullToString:[dic objectForKey:@"qqshareuserdefaultword"]];
    self.qqweibocontent=[NSString nullToString:[dic objectForKey:@"qqweibocontent"]];
    self.sinaweibocontent=[NSString nullToString:[dic objectForKey:@"sinaweibocontent"]];
    self.url=[NSString nullToString:[dic objectForKey:@"url"]];
    self.image = [self getCompleteWebsite:self.image];
    self.applet_url = [NSString nullToString:[dic objectForKey:@"applet_url"]];
    
    
    return self;
}


- (NSString *)getCompleteWebsite:(NSString *)urlStr{
    NSString *returnUrlStr = nil;
    NSString *scheme = nil;
    
    assert(urlStr != nil);
    
    urlStr = [urlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ( (urlStr != nil) && (urlStr.length != 0) ) {
        NSRange  urlRange = [urlStr rangeOfString:@"://"];
        if (urlRange.location == NSNotFound) {
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"//" withString:@""];
            returnUrlStr = [NSString stringWithFormat:@"https://%@", urlStr];
        } else {
            scheme = [urlStr substringWithRange:NSMakeRange(0, urlRange.location)];
            assert(scheme != nil);
            
            if ( ([scheme compare:@"http"  options:NSCaseInsensitiveSearch] == NSOrderedSame)
                || ([scheme compare:@"https" options:NSCaseInsensitiveSearch] == NSOrderedSame) ) {
                returnUrlStr = urlStr;
            } else {
                //不支持的URL方案
            }
        }
    }
    return returnUrlStr;
}

//判断此路径是否能够请求成功,直接进行HTTP请求
- (void)urliSAvailable:(NSString *)urlStr{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setHTTPMethod:@"HEAD"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"不可用");
        }else{
            NSLog(@"可用");
        }
    }];
    [task resume];
}


@end
