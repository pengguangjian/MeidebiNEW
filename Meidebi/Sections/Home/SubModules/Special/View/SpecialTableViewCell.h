//
//  SpecialTableViewCell.h
//  Meidebi
//
//  Created by mdb-admin on 2017/5/15.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpecialViewModel.h"

@interface SpecialTableViewCell : UITableViewCell

- (void)bindSpeicalWithModel:(SpecialViewModel *)model;

@end
