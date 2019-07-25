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

@end
