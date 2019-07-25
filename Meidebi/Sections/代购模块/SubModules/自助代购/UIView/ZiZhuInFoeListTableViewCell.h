//
//  ZiZhuInFoeListTableViewCell.h
//  Meidebi
//
//  Created by mdb-losaic on 2019/5/22.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZiZhuInFoeListTableViewCellDelegate <NSObject>

-(void)buyItemAction:(id)value;

@end

@interface ZiZhuInFoeListTableViewCell : UITableViewCell

@property (nonatomic , weak)id<ZiZhuInFoeListTableViewCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
