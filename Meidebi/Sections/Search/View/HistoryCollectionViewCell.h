//
//  HistoryCollectionViewCell.h
//  Meidebi
//
//  Created by mdb-admin on 16/4/7.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJIndexPathButton.h"

@interface HistoryCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NJIndexPathButton     *button;
@property (nonatomic, assign) NSUInteger            section;
@property (nonatomic, assign) NSUInteger            row;
@property (nonatomic, assign) BOOL                  shouldShow;

@end
