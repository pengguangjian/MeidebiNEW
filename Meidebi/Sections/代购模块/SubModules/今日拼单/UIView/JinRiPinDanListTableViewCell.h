//
//  JinRiPinDanListTableViewCell.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/29.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JinRiPinDanListMainModel.h"

@protocol JinRiPinDanListTableViewCellDelegate <NSObject>

-(void)JinRiPinDanListTableViewCellAddByCar:(JinRiPinDanListMainModel *)model;

@end

@interface JinRiPinDanListTableViewCell : UITableViewCell

@property (nonatomic , weak) id<JinRiPinDanListTableViewCellDelegate>delegate;

@property (nonatomic , retain) JinRiPinDanListMainModel *model;

@end
