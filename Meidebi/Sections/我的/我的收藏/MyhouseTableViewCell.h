//
//  MyhouseTableViewCell.h
//  Meidebi
//
//  Created by 杜非 on 15/2/10.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyhouseTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImv;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIImageView *pastDateImageView;
@property (weak, nonatomic) IBOutlet UILabel *youhuipriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *titlejuzhongLabel;

@end
