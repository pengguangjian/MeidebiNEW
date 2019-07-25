//
//  FansTableViewCell.h
//  Meidebi
//
//  Created by mdb-admin on 2017/6/19.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactViewModel.h"
@class ContactTableViewCell;
typedef NS_ENUM(NSInteger, ContactType) {
    ContactTypeFans,
    ContactTypeFollow
};

@protocol ContactTableViewCellDelegate <NSObject>

@optional - (void)contactTableViewDidClickFollowBtnWithCell:(ContactTableViewCell *)cell;
@optional - (void)avatarImageViewClickedWithCell:(ContactTableViewCell *)cell;

@end

@interface ContactTableViewCell : UITableViewCell
@property (nonatomic, weak) id<ContactTableViewCellDelegate> delegate;
@property (nonatomic, assign) ContactType type;
@property (nonatomic ,strong) ContactViewModel *model;
- (void)bindDataWithModel:(ContactViewModel *)model;
@end
