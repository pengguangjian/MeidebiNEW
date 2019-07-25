//
//  ZLJCollectionViewFlowLayout.h
//  Meidebi
//
//  Created by mdb-admin on 2017/6/27.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 扩展section的背景色和标题
@protocol ZLJCollectionViewFlowLayout <UICollectionViewDelegateFlowLayout>

- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout colorForSectionAtIndex:(NSInteger)section;


@optional - (NSString *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout titleForSectionAtIndex:(NSInteger)section;

@optional - (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout titleColorForSectionAtIndex:(NSInteger)section;
@end


@interface ZLJCollectionViewFlowLayout : UICollectionViewFlowLayout

@end
