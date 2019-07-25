//
//  MyShareTableViewCell.h
//  Meidebi
//
//  Created by 杜非 on 15/2/10.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyShareTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImv;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *marketLabel;
@property (weak, nonatomic) IBOutlet UILabel *laiyuan;
@property (weak, nonatomic) IBOutlet UILabel *zhuangtai;

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (strong,nonatomic) UIView *viewl;


@end
