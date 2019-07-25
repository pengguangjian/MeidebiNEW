//
//  MyCouponsTableViewCell.h
//  Meidebi
//
//  Created by 杜非 on 15/2/11.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCouponsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImv;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestarLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeendLabel;
@property (weak, nonatomic) IBOutlet UIView *userView;
@property (weak, nonatomic) IBOutlet UILabel *isuseLabel;
@property (weak, nonatomic) IBOutlet UILabel *passLabel;



@end
