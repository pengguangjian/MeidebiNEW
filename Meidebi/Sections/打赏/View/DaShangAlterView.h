//
//  DaShangAlterView.h
//  Meidebi
//
//  Created by mdb-losaic on 2019/8/8.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DaShangAlterViewDelegate <NSObject>
///打赏其他金额
-(void)DaShangAlterViewDaShangAction:(NSString *)value;

@end

@interface DaShangAlterView : UIView

@property (nonatomic , weak) id<DaShangAlterViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
