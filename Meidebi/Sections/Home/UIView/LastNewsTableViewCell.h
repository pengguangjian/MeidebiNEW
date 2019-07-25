//
//  LastNewsTableViewCell.h
//  Meidebi
//
//  Created by leecool on 2017/9/27.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LastNewsModel.h"
@interface LastNewsTableViewCell : UITableViewCell
- (void)bindDataWithModel:(LastNewsModel *)model;
@end
