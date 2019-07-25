//
//  OriginalFlagCollectionViewCell.h
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/21.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString * const kFlageName = @"name";
static NSString * const kFlageImage = @"image";
@interface OriginalFlagCollectionViewCell : UICollectionViewCell
- (void)bindDataWithModel:(NSDictionary *)model;
@end
