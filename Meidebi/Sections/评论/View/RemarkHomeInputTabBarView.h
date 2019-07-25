//
//  RemarkHomeInputTabBarView.h
//  Meidebi
//
//  Created by mdb-admin on 2017/2/10.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RemarkHomeInputTabBarViewDelegate <NSObject>

@optional - (void)textViewShouldReturn:(NSString *)text;

@end

@interface RemarkHomeInputTabBarView : UIView

@property (nonatomic, weak) id<RemarkHomeInputTabBarViewDelegate> delegate;
@property (nonatomic, strong) NSString *placeholderStr;
- (void)textViewBecomeFirstResponder;
- (void)textViewDismissFirstResponder;

@end
