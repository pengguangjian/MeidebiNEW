//
//  AddressListViewController.h
//  Meidebi
//
//  Created by mdb-admin on 2016/11/3.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddressListViewControllerDelegate <NSObject>

@optional - (void)afreshConversionAlertView;

@end

@protocol AddressListSelectViewControllerDelegate <NSObject>

-(void)addressSelectItem:(id)value;
///删除item
-(void)addressDelItem:(id)value;

@end

@interface AddressListViewController : UIViewController

@property (nonatomic, weak) id<AddressListViewControllerDelegate> delegate;

@property (nonatomic , weak) id<AddressListSelectViewControllerDelegate> delegateitem;

///订单页面在使用
@property (nonatomic , retain) NSString *strnomoid;

@end
