//
//  SocialBoundTableViewCell.h
//  Meidebi
//
//  Created by mdb-admin on 2017/6/28.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kSocialPlatmentName = @"name";
static NSString * const kSocialPlatmentImage = @"image";
static NSString * const kSocialPlatmentType = @"type";
static NSString * const kSocialPlatmentStatus = @"status";

@interface SocialBoundTableViewCell : UITableViewCell
- (void)bindDataWithModel:(NSDictionary *)dict;
@end
