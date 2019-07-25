//
//  ZLMenuItem.h
//  FilterWares
//
//  Created by mdb-admin on 2016/11/15.
//  Copyright © 2016年 losaic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLMenuItem : NSObject

@property (nonatomic, strong) NSString *menuItemName;
@property (nonatomic, strong) NSString *menuItemImageUrl;
@property (nonatomic, strong) NSString *menuItemID;
@property (nonatomic, strong) NSArray *menuSubItems;
@end


@interface ZLMenuSubItem : NSObject
@property (nonatomic, strong) NSString *itemName;
@property (nonatomic, strong) NSString *itemImageUrl;
@property (nonatomic, strong) NSString *itemID;
@property (nonatomic, strong) NSString *itemType;

@end

