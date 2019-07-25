//
//  ConVersionItemViewController.h
//  Meidebi
//
//  Created by mdb-admin on 2017/6/22.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ConVersionType) {
    ConVersionTypeAll = 0,
    ConVersionTypeTicket,
    ConVersionTypeOther,
    ConVersionTypeEntity
};

@protocol ConVersionItemViewControllerDelegate <NSObject>

@optional - (void)tableViewConfirmConversionItem:(NSDictionary *)itemDict type:(NSInteger)type;
@optional - (void)conversionTableViewDidSelectCellWithItem:(NSDictionary *)item;

@end

@interface ConVersionItemViewController : UITableViewController

@property (nonatomic, weak) id<ConVersionItemViewControllerDelegate> delegate;
- (instancetype)initWithConVersionType:(ConVersionType)type;

@end
