//
//  ProductInfoJBAalterView.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/8/13.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductInfoJBAalterViewDelegate <NSObject>

///举报原因
- (void)ProductInfoJBAalterViewDelegateDidPressEnsureBtnWithAlertViewItem:(NSInteger)item;

@end

@interface ProductInfoJBAalterView : UIView

@property (nonatomic , weak)id<ProductInfoJBAalterViewDelegate>delegate;

- (void)showAlert;

- (void)hiddenAlert;

@end
