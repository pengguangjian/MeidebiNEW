//
//  PushKeywordCollectionViewCell.h
//  Meidebi
//
//  Created by mdb-admin on 16/9/21.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJIndexPathButton.h"

@interface PushKeywordCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIButton     *button;
@property (nonatomic, strong) NJIndexPathButton     *contentBtn;
@property (nonatomic, assign) NSUInteger            section;
@property (nonatomic, assign) NSUInteger            row;
@property (nonatomic, assign) BOOL                  shouldShow;

@end
