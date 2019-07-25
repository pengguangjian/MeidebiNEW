//
//  DaiGouPaiHangBangTableViewCell.h
//  Meidebi
//
//  Created by mdb-losaic on 2019/4/16.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DaiGouHomeListModel.h"

#import "DaiGouHomeTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface DaiGouPaiHangBangTableViewCell : UITableViewCell

@property (nonatomic , weak) id<DaiGouHomeTableViewCellDelegate>delegate;

@property (nonatomic , retain) DaiGouHomeListModel *model;

@property (nonatomic , assign) BOOL ishidden;
@end

NS_ASSUME_NONNULL_END
