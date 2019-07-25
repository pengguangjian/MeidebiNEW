//
//  HistoryCollectionFooterReusableView.h
//  Meidebi
//
//  Created by mdb-admin on 16/4/22.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HistoryCollectionFooterReusableViewDelegate <NSObject>

- (void)deleteHistory;

@end

@interface HistoryCollectionFooterReusableView : UICollectionReusableView

@property (nonatomic, weak) id<HistoryCollectionFooterReusableViewDelegate> delegate;

@end
