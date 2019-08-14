//
//  DaiGouXiaDanGoodsTableViewCell.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/9/30.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OrderGoodsInfoModel.h"

@protocol DaiGouXiaDanGoodsTableViewCellDelegate <NSObject>

-(void)DaiGouXiaDanGoodsNumChange;

@end

@interface DaiGouXiaDanGoodsTableViewCell : UITableViewCell

@property (nonatomic , weak) id<DaiGouXiaDanGoodsTableViewCellDelegate>delegate;

@property (nonatomic , retain)OrderGoodsInfoModel *model;

@property (nonatomic , assign) BOOL iseditnumber;

//////国外转运费和国外本土邮费折扣
@property (nonatomic , assign) float fcarriage_discount;

@end
