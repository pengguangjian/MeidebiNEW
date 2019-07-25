//
//  ContentCell.h
//  mdb
//
//  Created by 杜非 on 14/12/30.
//  Copyright (c) 2014年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"
#import "Articlel.h"
#import "Commodity.h"
@interface ContentCell : UITableViewCell

- (void)fetchCellData:(Article *)article;

- (void)fetchSearchCellData:(Articlel *)articlel isOption:(BOOL)isOption;

- (void)fetchCommodityData:(Commodity *)aCommodity;
@end
