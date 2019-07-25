//
//  AddressListTableViewCell.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/8.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AddressListModel.h"


@protocol AddressListTableViewCellDelegate <NSObject>

@optional
- (void)editAddresscell:(AddressListModel *)model;
- (void)deleteAddresscell:(NSString *)addressID;
- (void)nomoAddresscell:(NSString *)addressID;
@end

@interface AddressListTableViewCell : UITableViewCell

@property (nonatomic , retain) AddressListModel *model;

@property (nonatomic , weak)id<AddressListTableViewCellDelegate>delegate;

@end
