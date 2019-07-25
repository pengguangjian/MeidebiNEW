//
//  PersonalInfoTableViewCell.h
//  Meidebi
//
//  Created by fishmi on 2017/6/22.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PersonalInfoModel;

@interface PersonalInfoTableViewCell : UITableViewCell
@property (nonatomic ,weak) UILabel *text_Label;
@property (nonatomic ,weak) UILabel *subLabel;

@end
