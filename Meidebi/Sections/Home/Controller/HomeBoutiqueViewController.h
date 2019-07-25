//
//  HomeBoutiqueViewController.h
//  Meidebi
//
//  Created by mdb-admin on 2017/9/28.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "RootTableViewController.h"


@protocol HomeBoutiqueViewControllerDelgate <NSObject>

@optional - (void)homeBoutiqueViewControllerDidSelectItem:(NSString *)itemID;

@end

@interface HomeBoutiqueViewController : UITableViewController
@property (nonatomic, weak) id<HomeBoutiqueViewControllerDelgate> delegate;
- (instancetype)initWithModels:(NSArray *)models;
@end
