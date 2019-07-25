//
//  MyTrackDataController.h
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/8.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyTrackDataController : NSObject

@property (nonatomic ,strong, readonly) NSDictionary *resultDict;
@property (nonatomic, strong, readonly) NSArray *results;

- (void)requestMyTrackBannerCallback:(completeCallback)callback;
- (void)requestMyTrackListCallback:(completeCallback)callback;
- (void)lastNewPageDataWithCallback:(completeCallback)callback;
- (void)nextPageDataWithCallback:(completeCallback)callback;
@end
