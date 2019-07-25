//
//  ZLJunioMenuCollectionViewCell.h
//  FilterWares
//
//  Created by mdb-admin on 2016/11/21.
//  Copyright © 2016年 losaic. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZLMenuSubItem;

@interface ZLJuniorMenuCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, strong) ZLMenuSubItem *juniorItem;
@end
