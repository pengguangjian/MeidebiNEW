//
//  ShareHongBaoView.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/12/21.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ShareHongBaoViewDelegate <NSObject>

-(void)shareAction;

@end

@interface ShareHongBaoView : UIView

-(id)initWithFrame:(CGRect)frame andtitle:(NSString *)strtitle andcontent:(NSString *)strcontent;

@property (nonatomic,weak)id<ShareHongBaoViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
