//
//  SearchYuanChuangTableViewCell.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/12.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "SearchYuanChuangTableViewCell.h"
#import "MDB_UserDefault.h"

@interface SearchYuanChuangTableViewCell ()

@property (nonatomic , retain) UIView *viewback;
///图标
@property (nonatomic , retain) UIImageView *imgvpic;

///标题
@property (nonatomic , retain) UILabel *lbtitle;
///价格
@property (nonatomic , retain) UILabel *lbcontent;

@property (nonatomic , retain) UIView *viewline;

@end;

@implementation SearchYuanChuangTableViewCell
@synthesize model;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
        _viewback = [[UIView alloc]initWithFrame:CGRectZero];
        [_viewback setBackgroundColor:[UIColor whiteColor]];
        
        _imgvpic = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_imgvpic.layer setMasksToBounds:YES];
        
        
        
        _lbtitle = [[UILabel alloc]initWithFrame:CGRectZero];
        [_lbtitle setTextColor:RGB(30, 30, 30)];
        [_lbtitle setTextAlignment:NSTextAlignmentLeft];
        [_lbtitle setFont:[UIFont systemFontOfSize:16]];
        [_lbtitle setNumberOfLines:2];
        
        _lbcontent = [[UILabel alloc]initWithFrame:CGRectZero];
        [_lbcontent setTextColor:RGB(130, 130, 130)];
        [_lbcontent setTextAlignment:NSTextAlignmentLeft];
        [_lbcontent setFont:[UIFont systemFontOfSize:14]];
        [_lbcontent setNumberOfLines:2];
        
        
        
        _viewline = [[UIView alloc]initWithFrame:CGRectZero];
        [_viewline setBackgroundColor:RGB(239, 239, 239)];
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [_viewback setFrame:CGRectMake(0, 0, self.width, self.height)];
    [self.contentView addSubview:_viewback];
    
    [_imgvpic setFrame:CGRectMake(15, 15, _viewback.height-30, _viewback.height-30)];
    [_imgvpic.layer setCornerRadius:4];
    [_viewback addSubview:_imgvpic];
    
    [[MDB_UserDefault defaultInstance]setViewWithImage:_imgvpic url:model.strpicurl options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            _imgvpic.image=image;
        }else{
            _imgvpic.image=[UIImage imageNamed:@"punot.png"];
        }
    }];
    
    
    [_lbtitle setFrame:CGRectMake(_imgvpic.right+10, _imgvpic.top, _viewback.width-_imgvpic.right-20, 40)];
    [_lbtitle setText:model.strtitle];
    [_viewback addSubview:_lbtitle];
    if(model.isSelect)
    {
        [_lbtitle setTextColor:RGB(150, 150, 150)];
        
    }
    else
    {
        [_lbtitle setTextColor:RGB(30, 30, 30)];
    }
    
    [_lbcontent setFrame:CGRectMake(_lbtitle.left, _lbtitle.bottom, _lbtitle.width, 40)];
    [_lbcontent setText:model.strcontent];
    [_viewback addSubview:_lbcontent];
    
    
    [_viewline setFrame:CGRectMake(15, _viewback.height-1, _viewback.width-25, 1)];
    [_viewback addSubview:_viewline];
    
    
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
