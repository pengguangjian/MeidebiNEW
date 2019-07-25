//
//  CheapFeaturedViewCell.h
//  Meidebi
//
//  Created by mdb-admin on 2017/8/22.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewModel.h"
@interface CheapFeaturedViewCell : UICollectionViewCell

- (void)bindDataWithModel:(HomeCheapViewModel *)model;

@end
