//
//  TrackTableViewCell.h
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/8.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrackViewModel.h"
@interface TrackTableViewCell : UITableViewCell

- (void)bindDataWithModel:(TrackEventModel *)model;
- (void)bindTimeDataWithContent:(NSString *)time;
- (void)showSpanLineView:(BOOL)show;
@end
