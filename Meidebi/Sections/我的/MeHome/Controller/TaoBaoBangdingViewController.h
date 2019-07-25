//
//  TaoBaoBangdingViewController.h
//  Meidebi
//淘宝绑定
//  Created by mdb-losaic on 2019/3/6.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TaoBaoBangdingViewControllerDelegate <NSObject>

- (void)taobaobangdingBackUrl:(NSString *)strurl;

@end

@interface TaoBaoBangdingViewController : RootViewController
@property (nonatomic , weak)id<TaoBaoBangdingViewControllerDelegate>deletate;
@end


NS_ASSUME_NONNULL_END
