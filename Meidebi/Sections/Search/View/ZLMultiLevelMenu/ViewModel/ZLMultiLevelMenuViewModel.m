//
//  ZLMultiLevelMenuViewModel.m
//  FilterWares
//
//  Created by mdb-admin on 2016/11/15.
//  Copyright © 2016年 losaic. All rights reserved.
//

#import "ZLMultiLevelMenuViewModel.h"

@interface ZLMultiLevelMenuViewModel ()

@property (nonatomic, assign) NSInteger tableRowHeight;
@property (nonatomic, assign) NSInteger tableSections;
@property (nonatomic, strong) NSMutableArray *rusltContents;

@end

@implementation ZLMultiLevelMenuViewModel


+ (instancetype)multiLevelMenuViewModel:(NSArray *)model{
    ZLMultiLevelMenuViewModel *viewModel = [[ZLMultiLevelMenuViewModel alloc] init];
    [viewModel calculationModel:model];
    return viewModel;
}

- (void)calculationModel:(NSArray *)models{
    _rusltContents = [NSMutableArray array];
    _tableSections = models.count;
    for (NSArray * array in models) {
        NSMutableArray *topMenus = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *contentDict = (NSDictionary *)obj;
            ZLMenuItem *item = [[ZLMenuItem alloc] init];
            item.menuItemImageUrl = contentDict[@"icon"];
            item.menuItemName = contentDict[@"name"];
            item.menuItemID = contentDict[@"id"];
            NSArray *categorys = contentDict[@"category"];
            NSMutableArray *handles = [NSMutableArray array];
            [categorys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ZLMenuSubItem *subItem = [[ZLMenuSubItem alloc] init];
                subItem.itemType = contentDict[@"type"];
                if ([subItem.itemType isEqualToString:@"1"] || [subItem.itemType isEqualToString:@"2"]) {
                    subItem.itemImageUrl = obj[@"iosicon"];
                }else{
                    subItem.itemImageUrl = obj[@"icon"];
                }
                subItem.itemName = obj[@"name"];
                subItem.itemID = obj[@"id"];
                [handles addObject:subItem];
            }];
            item.menuSubItems = handles.mutableCopy;
            [topMenus addObject:item];
        }];
        [_rusltContents addObject:topMenus.mutableCopy];
    }
}

#pragma mark - setters and getters
- (NSArray *)tableContents{
    return _rusltContents.count==0?@[]:_rusltContents;
}

@end
