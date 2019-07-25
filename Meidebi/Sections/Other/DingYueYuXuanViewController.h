//
//  DingYueYuXuanViewController.h
//  Meidebi
//  订阅预选
//  Created by mdb-losaic on 2018/12/20.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DingYueYuXuanViewControllerDelegate <NSObject>

-(void)dimisview;

@end

@interface DingYueYuXuanViewController : UIViewController

@property (nonatomic , retain) NSArray *arrallkey;

@property (nonatomic , weak) id<DingYueYuXuanViewControllerDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
