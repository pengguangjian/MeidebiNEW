//
//  WoGuanZhuPeopleTableViewCell.h
//  Meidebi
//
//  Created by mdb-losaic on 2019/3/26.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WoGuanZhuPeopleModel.h"
#import "WoGuanZhuDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@interface WoGuanZhuPeopleTableViewCell : UITableViewCell
@property (nonatomic ,retain) WoGuanZhuPeopleModel *model;
@property (nonatomic,weak)id<WoGuanZhuDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
