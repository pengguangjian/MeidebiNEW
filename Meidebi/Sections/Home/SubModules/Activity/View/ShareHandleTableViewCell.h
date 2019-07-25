//
//  ShareHandleTableViewCell.h
//  Meidebi
//
//  Created by mdb-admin on 2017/10/16.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ShareHandleType) {
    ShareHandleTypeSinaWeibo = 10000,
    ShareHandleTypeWeMoments,
    ShareHandleTypeQQSpace,
    ShareHandleTypeQQ,
    ShareHandleTypeWeChat
};
@protocol ShareHandleTableViewCellDelegate <NSObject>

@optional - (void)shareHandleTableViewCellDidClickedShareButtonAtType:(ShareHandleType)type;

@end

@interface ShareHandleTableViewCell : UITableViewCell
@property (nonatomic, weak) id<ShareHandleTableViewCellDelegate> delegate;
@end
