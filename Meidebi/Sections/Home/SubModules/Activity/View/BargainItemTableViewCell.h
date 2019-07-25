//
//  BargainItemTableViewCell.h
//  Meidebi
//
//  Created by mdb-admin on 2017/10/16.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BargainParticipationViewModel.h"
@class BargainItemViewModel;

@interface BargainItemTableViewCell : UITableViewCell

- (void)bindDataWithModel:(BargainItemViewModel *)model;
- (void)bindParticiptationDataWithModel:(BargainParticipationViewModel *)model;
@end
