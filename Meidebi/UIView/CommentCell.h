//
//  CommentCell.h
//  Meidebi
//
//  Created by 杜非 on 15/2/5.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLEmojiLabel.h"
#import "OtherComV.h"
@interface CommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImv;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) MLEmojiLabel *contentLabels;
@property(weak,nonatomic)IBOutlet UILabel *contentLabel;

@property (strong, nonatomic)  UIView *lineView;

@property (strong,nonatomic)OtherComV  *otherCv;

@property (strong,nonatomic)UILabel *otherlabel;
@property (strong,nonatomic)UILabel *onamelabel;

@end
