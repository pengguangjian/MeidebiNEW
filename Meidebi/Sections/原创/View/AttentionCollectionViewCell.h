//
//  AttentionCollectionViewCell.h
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/21.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString * const kUserFollowState = @"userFollowState";
@class AttentionCollectionViewCell;
@protocol AttentionCollectionViewCellDelegate <NSObject>

@optional - (void)collectionViewCellDidSelect:(AttentionCollectionViewCell *)cell;

@end

@interface AttentionCollectionViewCell : UICollectionViewCell
@property (nonatomic, weak) id<AttentionCollectionViewCellDelegate> delegate;
- (void)bindDataWithModel:(NSDictionary *)model;

@end
