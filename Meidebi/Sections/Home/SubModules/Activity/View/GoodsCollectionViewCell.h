//
//  GoodsCollectionViewCell.h
//  Meidebi
//
//  Created by fishmi on 2017/5/11.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendListViewModel.h"

@interface GoodsCollectionViewCell : UICollectionViewCell

@property (nonatomic ,strong) RecommendListViewModel *model;
@end
