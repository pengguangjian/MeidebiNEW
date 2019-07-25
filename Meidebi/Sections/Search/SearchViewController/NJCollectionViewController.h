//
//  NJCollectionViewController.h
//  Meidebi
//
//  Created by mdb-admin on 16/4/11.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NJCollectionViewController;
typedef NS_ENUM(NSInteger, CollectionVcType){
    CollectionVcTypeCategory = 0,
    CollectionVcTypeHot
};

@protocol NJCollectionViewDelegate <NSObject>

@optional
- (void)NJCollectionViewController:(NJCollectionViewController *)collectionViewController
     categoryDidPressCellOfContent:(NSDictionary *)content;

@end


@interface NJCollectionViewController : UIViewController

@property (nonatomic, assign) CollectionVcType collectionType;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, weak) id<NJCollectionViewDelegate> delegate;
@property (nonatomic, readonly, assign) CGFloat allHeight;


@end
