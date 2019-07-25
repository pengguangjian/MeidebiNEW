//
//  CheapOrOutsideSubjectsView.h
//  Meidebi
//
//  Created by mdb-admin on 16/5/5.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheapOrOutsideSubjectsViewModel.h"
#import "Commodity.h"
@class CheapOrOutsideSubjectsView;
@protocol CheapOrOutsideSubjectsViewDelgate <NSObject>

@optional
- (void)subjectsView:(CheapOrOutsideSubjectsView *)view didPressCellWithCommodity:(Commodity *)aCommodity;
- (void)subjectsViewWithPullupTableview;
- (void)subjectsViewWithPullDownTableview;

@end

@interface CheapOrOutsideSubjectsView : UIView

@property (nonatomic, weak) id<CheapOrOutsideSubjectsViewDelgate>delegate;


- (void)bindDataWithViewModel:(CheapOrOutsideSubjectsViewModel *)viewModel;

@end
