//
//  WelfareStrategyViewCell.h
//  Meidebi
//
//  Created by mdb-admin on 2017/6/27.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kWelfareStrategyName = @"name";
static NSString * const kWelfareStrategyDescribe = @"describe";
static NSString * const kWelfareStrategySectionTitle = @"sectiontitle";
static NSString * const kWelfareStrategyType = @"type";
static NSString * const kWelfareStrategyStatus = @"status";

@interface WelfareStrategyViewCell : UICollectionViewCell

- (void)bindDataWithModel:(NSDictionary *)dict;

@end
