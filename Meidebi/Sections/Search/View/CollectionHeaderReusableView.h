//
//  CollectionHeaderReusableView.h
//  Meidebi
//
//  Created by mdb-admin on 16/4/7.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CollectionHeaderReusableView;
@protocol CollectionHeaderReusableViewDelegate <NSObject>

@optional
- (void)headerResuableViewDidPressDeleateBtn;
- (void)headerReusableView:(CollectionHeaderReusableView *)headerView
           didPressBtnType:(NSString *)type;


@end

@interface CollectionHeaderReusableView : UICollectionReusableView

@property (nonatomic, assign) BOOL isShowTopLineView;
@property (nonatomic, strong) NSString *categoryStr;
@property (nonatomic, strong) NSArray  *dataHistorySource;
@property (nonatomic, weak) id<CollectionHeaderReusableViewDelegate> headerDelegate;
@end
