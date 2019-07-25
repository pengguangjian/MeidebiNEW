//
//  MyOrderTableViewCell.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/4.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyOrderMainModel.h"

@protocol MyOrderTableViewCellDelegate <NSObject>
-(void)cellRefAction:(NSString *)strtype andorderid:(NSString *)strid;
@end

@interface MyOrderTableViewCell : UITableViewCell

@property (nonatomic , retain) MyOrderGoodsModel *model;

@property (nonatomic , weak) id<MyOrderTableViewCellDelegate>degelate;

@property (nonatomic , assign) BOOL islast;

@end
