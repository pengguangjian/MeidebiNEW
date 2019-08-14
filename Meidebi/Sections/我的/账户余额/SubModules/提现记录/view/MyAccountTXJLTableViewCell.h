//
//  MyAccountTXJLTableViewCell.h
//  Meidebi
//
//  Created by mdb-losaic on 2019/7/11.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAccountTXJLListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyAccountTXJLTableViewCell : UITableViewCell

@property (nonatomic, retain) MyAccountTXJLModel *model;

@property (nonatomic , assign) BOOL ishidenline;

@end

NS_ASSUME_NONNULL_END
