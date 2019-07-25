//
//  DaiGouXiaDanQuanTableViewCell.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/12/25.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyGoodsCouponModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DaiGouXiaDanQuanTableViewCell : UITableViewCell
@property (nonatomic,retain) MyGoodsCouponModel *model;
///商品价格
@property (nonatomic , retain) NSString *strgoodsprice;
@property (nonatomic,assign)BOOL ishigh;

@end

NS_ASSUME_NONNULL_END
