//
//  DaiGouHomeTableViewCell.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/28.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DaiGouHomeListModel.h"

@protocol DaiGouHomeTableViewCellDelegate <NSObject>

-(void)DaiGouHomeTableViewCellAddGouWuChe:(DaiGouHomeListModel *)model;

@end

@interface DaiGouHomeTableViewCell : UITableViewCell

@property (nonatomic , weak) id<DaiGouHomeTableViewCellDelegate>delegate;

@property (nonatomic , retain) DaiGouHomeListModel *model;

@property (nonatomic , assign) BOOL ishidden;
///是否是现货
@property (nonatomic , assign) BOOL isxianhuo;

@end
