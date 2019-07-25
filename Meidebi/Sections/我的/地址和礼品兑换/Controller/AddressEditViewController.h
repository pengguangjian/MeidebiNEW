//
//  AddressEditViewController.h
//  Meidebi
//
//  Created by mdb-admin on 2016/11/3.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AddressListModel.h"
@interface AddressEditViewController : UIViewController

///已取消
@property (nonatomic, strong) NSDictionary *lastAddressDict;
///

@property (nonatomic, strong) AddressListModel *model;

@end
