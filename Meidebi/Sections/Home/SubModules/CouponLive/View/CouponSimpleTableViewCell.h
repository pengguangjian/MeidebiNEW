//
//  CouponSimpleTableViewCell.h
//  Meidebi
//
//  Created by mdb-admin on 2017/6/29.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Commodity.h"

@interface CouponSimpleTableViewCell : UITableViewCell
- (void)fetchCommodityData:(Commodity *)aCommodity;

@end
