//
//  GoodsCarTableViewCell.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/8/29.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GoodsGarModel.h"

@protocol GoodsCarTableViewCellDelegate <NSObject>
///选中了某一个
-(void)selectActionItem:(GoodsGarModel *)model;
///数量发生了改变
-(void)itemNumChange;

////修改某一个规格
-(void)changeGuiGeItem:(GoodsGarModel *)model;

@end

@interface GoodsCarTableViewCell : UITableViewCell

@property (nonatomic , retain)GoodsGarModel *model;

@property (nonatomic , weak) id<GoodsCarTableViewCellDelegate>delegate;

@end
