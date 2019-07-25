//
//  JingXuanYouHuiQuanTableViewCell.h
//  Meidebi
//
//  Created by mdb-losaic on 2019/2/18.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"

NS_ASSUME_NONNULL_BEGIN

@interface JingXuanYouHuiQuanTableViewCell : UITableViewCell

- (void)fetchCellData:(Article *)article;

@end

NS_ASSUME_NONNULL_END
