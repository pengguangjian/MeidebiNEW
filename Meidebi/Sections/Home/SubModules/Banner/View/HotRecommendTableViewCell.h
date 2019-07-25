//
//  HotRecommendTableViewCell.h
//  Meidebi
//
//  Created by mdb-admin on 2017/5/16.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HotRecommendTableViewCellDelegate <NSObject>

@optional - (void)tableViewCellDidClickOpenUrlBtn:(NSString *)openUrl;

@end

@interface HotRecommendTableViewCell : UITableViewCell
@property (nonatomic, weak) id<HotRecommendTableViewCellDelegate> delegate;

- (void)bindHotRecommendData:(NSDictionary *)modelDict;

@end
