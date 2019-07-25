//
//  CLocationHelper.h
//  Meidebi
//
//  Created by mdb-admin on 16/5/17.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface CLocationHelper : NSObject<CLLocationManagerDelegate>

+ (CLocationHelper *)sharedLocation;

- (void)startUpdatingLocation:(void (^)(CGFloat longitude, CGFloat latitude, NSString *currentCity))completeLoaction;
@end
