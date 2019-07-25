//
//  TaoBaoWebViewViewController.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/8/3.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "RootViewController.h"
@protocol TaoBaoWebViewViewControllerDelegate <NSObject>

- (void)taobaoLoginBackUrl:(NSString *)strurl;

@end
@interface TaoBaoWebViewViewController : RootViewController

@property (nonatomic , weak)id<TaoBaoWebViewViewControllerDelegate>deletate;

@end
