//
//  VolumeContentViewController.h
//  Meidebi
//
//  Created by 杜非 on 15/2/2.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Juancle.h"

typedef NS_ENUM(NSInteger, waresType) {
    waresTypeCoupon,
    waresTypeMaterial
};

@interface VolumeContentViewController : UIViewController

@property(nonatomic,strong)Juancle * juancle;
@property(nonatomic,assign)NSInteger juancleid;
@property (nonatomic, assign) waresType type;
@property (nonatomic, strong) NSString *haveto;

@property (nonatomic, assign) int present_type;

@end
