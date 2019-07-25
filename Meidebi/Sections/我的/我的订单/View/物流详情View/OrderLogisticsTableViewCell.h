//
//  OrderLogisticsTableViewCell.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/9.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OrderLogisticsModel.h"

@interface OrderLogisticsTableViewCell : UITableViewCell

@property (nonatomic , retain) OrderLogisticsModel *model;

@property (nonatomic , assign) NSInteger iline;

@property (nonatomic , assign) BOOL islast;

@end
