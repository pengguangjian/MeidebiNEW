//
//  NJCustomPushView.h
//  Meidebi
//
//  Created by mdb-admin on 16/4/1.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NJCustomPushView;
@protocol NJCustomPushViewDelegate <NSObject>

@optional
- (void)pushCategoryViewDidPressNoPush;
- (void)pushCategoryView:(NJCustomPushView *)customPushView
    ensureOfCates:(NSArray *)categorys
             orgs:(NSArray *)orgs;

@end

@interface NJCustomPushView : UIView

@property (nonatomic, weak) id<NJCustomPushViewDelegate>delegate;
@property (nonatomic, strong) NSString *headerTitle;
@property (nonatomic, strong) NSArray *contentArr;

- (void)show;
@end
