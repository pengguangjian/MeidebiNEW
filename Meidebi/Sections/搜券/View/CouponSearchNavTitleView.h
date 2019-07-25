//
//  CouponSearchNavTitleView.h
//  Meidebi
//
//  Created by mdb-admin on 2017/9/18.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CouponSearchNavTitleViewDelegate<NSObject>
@optional - (void)searchNavTitleViewDidRespondsSearch:(NSString *)searchKey;
@end

@interface CouponSearchNavTitleView : UIView
@property (nonatomic, weak) id<CouponSearchNavTitleViewDelegate> delegate;
@property (nonatomic, strong) NSString *textFieldPlaceholder;
- (void)textFieldResignFirstResponder;
@end
