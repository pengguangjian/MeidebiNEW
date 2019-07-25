//
//  FilterTypeHomeSubjectsView.h
//  Meidebi
//
//  Created by mdb-admin on 2016/11/21.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterTypeHomeSubjectsViewDelegate <NSObject>

@optional
- (void)resultFilterTypes:(NSArray *)types;

@end

@interface FilterTypeHomeSubjectsView : UIView

@property (nonatomic, weak) id<FilterTypeHomeSubjectsViewDelegate> delegate;
- (void)bindFilterTypeData:(NSArray *)model;

@end
