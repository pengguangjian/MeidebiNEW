//
//  OriginalFlagView.h
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/9/21.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OriginalFlagViewDelegate <NSObject>

@optional - (void)flageCollectionViewDidSelectRow:(NSString *)flagID;

@end

@interface OriginalFlagView : UIView
@property (nonatomic, weak) id<OriginalFlagViewDelegate> delegate;
@end
