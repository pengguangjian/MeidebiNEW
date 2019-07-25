//
//  RecommendElementViewCell.h
//  Meidebi
//
//  Created by mdb-admin on 2017/5/12.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewModel.h"
@interface RecommendElementViewCell : UICollectionViewCell

- (void)bindRecommendElementData:(HomeActivitieViewModel *)model;

@end
