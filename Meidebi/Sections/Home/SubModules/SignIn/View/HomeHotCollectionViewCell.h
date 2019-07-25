//
//  HomeHotCollectionViewCell.h
//  Meidebi
//
//  Created by mdb-admin on 2017/5/27.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Commodity.h"
@interface HomeHotCollectionViewCell : UICollectionViewCell

- (void)bindDataWithModel:(Commodity *)model;

@end
