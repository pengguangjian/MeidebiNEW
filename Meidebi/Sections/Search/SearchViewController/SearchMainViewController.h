//
//  SearchMainViewController.h
//  Meidebi
//
//  Created by 杜非 on 15/2/3.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SearchMainVcType){
    SearchMainVcTypeCategory = 0,
    SearchMainVcTypeHot
};
@interface SearchMainViewController : UIViewController

@property (nonatomic, strong) NSArray *searchContents;
@property(nonatomic, assign)    int   cats;
@property(nonatomic, strong)    NSString *catName;
@property(nonatomic, assign)    SearchMainVcType vcType;



@end
