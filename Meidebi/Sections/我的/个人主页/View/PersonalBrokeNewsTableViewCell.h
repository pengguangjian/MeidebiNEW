//
//  PersonalBrokeNewsTableViewCell.h
//  Meidebi
//
//  Created by mdb-admin on 2017/6/20.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalBrokeNewsViewModel.h"
@interface PersonalBrokeNewsTableViewCell : UITableViewCell

- (void)bindDataWithModel:(PersonalBrokeNewsViewModel *)model;

@end
