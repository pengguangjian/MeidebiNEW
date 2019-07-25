//
//  JuanCell.h
//  Meidebi
//
//  Created by 杜非 on 15/1/26.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JuanCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImv;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *manLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end
