//
//  CLocationHelper.m
//  Meidebi
//
//  Created by mdb-admin on 16/5/17.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "CLocationHelper.h"

typedef void(^loactionInfo)(CGFloat longitude, CGFloat latitude, NSString *currentCity);

@interface CLocationHelper ()

@property (nonatomic, strong) CLLocationManager  *locationManager;
@property (nonatomic, copy) loactionInfo locationBlock;

@end

@implementation CLocationHelper

+ (CLocationHelper *)sharedLocation{
    static CLocationHelper *sharedLocationHelper = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
         sharedLocationHelper = [[CLocationHelper alloc] init];
        [sharedLocationHelper initializeLocationService];
    });
    return sharedLocationHelper;
}

- (void)initializeLocationService {
    // 初始化定位管理器
    _locationManager = [[CLLocationManager alloc] init];
    // 设置代理
    _locationManager.delegate = self;
    // 设置定位精确度到米
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 设置过滤器为无
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    if (IOS_VERSION_8_OR_ABOVE) {
//        [_locationManager requestAlwaysAuthorization];
        [_locationManager requestWhenInUseAuthorization];
    }
   
}

- (void)startUpdatingLocation:(void (^)(CGFloat, CGFloat, NSString *))completeLoaction{
    // 开始定位
    [_locationManager startUpdatingLocation];
     _locationBlock = completeLoaction;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
    
    //经度
    CGFloat longitude = newLocation.coordinate.longitude;
    //纬度
    CGFloat latitude = newLocation.coordinate.latitude;
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    __block NSString *city = @"";
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            //获取城市
            city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            _locationBlock(longitude,latitude,city);
        }
        else if (error == nil && [array count] == 0)
        {
            NSLog(@"No results were returned.");
             _locationBlock(longitude,latitude,city);
        }
        else if (error != nil)
        {
            NSLog(@"An error occurred = %@", error);
             _locationBlock(longitude,latitude,city);
        }
    }];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied)
    {
        UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"需要开启定位服务,请到设置->隐私,打开定位服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alvertView show];
        _locationBlock(10,0,@"");
    }
    if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
        _locationBlock(0,0,@"");
    }
}

@end
