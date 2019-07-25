//
//  CategoryCollectionViewCell.h
//  Meidebi
//
//  Created by mdb-admin on 16/4/7.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CollectionCellType) {
    CollectionCellTypeCategory,
    CollectionCellTypeHot
};

@interface CategoryCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSString *iconImageLink;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) CollectionCellType cellType;

@end
