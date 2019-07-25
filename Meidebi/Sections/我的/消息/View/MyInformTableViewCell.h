//
//  MyInformTableViewCell.h
//  Meidebi
//
//  Created by 杜非 on 15/2/11.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyInformMainModel.h"

@protocol MyInformTableViewCellDelegate <NSObject>
- (void)touchWithId: (NSInteger)Id;

@end

@interface MyInformTableViewCell : UITableViewCell

//@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//@property (strong, nonatomic)  UILabel *contentLabel;
//@property (strong, nonatomic)  UIView *lineView;

@property (nonatomic ,weak) id <MyInformTableViewCellDelegate> delegate;
@property (nonatomic ,weak) UILabel *nameL;
@property (nonatomic ,weak) UILabel *timeL;
@property (nonatomic ,weak) UILabel *textL;
@property (nonatomic ,strong) UIImageView *imageedit;
@property (nonatomic ,strong) UIImageView *imageV;

@property (nonatomic ,strong) MyInformMainModel *model;
@property (nonatomic ,assign) BOOL isedit;

@end
