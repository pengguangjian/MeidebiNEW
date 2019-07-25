//
//  JingXuanYuanChuangTableViewCell.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/7/2.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "JingXuanYuanChuangTableViewCell.h"

#import "MDB_UserDefault.h"

@interface JingXuanYuanChuangTableViewCell ()

@property(nonatomic , retain) UIView *viewback;

@property(nonatomic , retain) UIImageView *imgvhead;

@property(nonatomic , retain) UILabel *lbjinghua;
@property(nonatomic , retain) UILabel *lbshipin;


@property(nonatomic , retain) UILabel *lbcontent;

@property(nonatomic , retain) UILabel *lbother;

@property(nonatomic , retain) UIButton *btitem0;
@property(nonatomic , retain) UIButton *btitem1;
@property(nonatomic , retain) UIButton *btitem2;
@property(nonatomic , retain) NSMutableArray *arrbtitems;

@property(nonatomic , retain) UIButton *btzan;

@property(nonatomic , retain) UIButton *btpinglun;

@property(nonatomic , retain) UIView *viewbtline;

@property(nonatomic , retain) UIView *viewline;

@property(nonatomic , retain) UILabel *commentLable;
@property(nonatomic , retain) UILabel *creatLable;

@property(nonatomic , retain) UIImageView *commentImageView;
@property(nonatomic , retain) UIImageView *creatImageView;
@end

@implementation JingXuanYuanChuangTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _viewback = [[UIView alloc] initWithFrame:CGRectZero];
        [_viewback setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:_viewback];
        
        _imgvhead = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_imgvhead setContentMode:UIViewContentModeScaleAspectFill];
        [_imgvhead setClipsToBounds:YES];
        [_imgvhead.layer setMasksToBounds:YES];
        [_viewback addSubview:_imgvhead];
        
        _lbjinghua = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 63, 18)];
        [_lbjinghua setText:@"精华原创"];
        [_lbjinghua setTextColor:RadMenuColor];
        [_lbjinghua setTextAlignment:NSTextAlignmentCenter];
        [_lbjinghua setFont:[UIFont systemFontOfSize:11]];
        [_lbjinghua.layer setMasksToBounds:YES];
        [_lbjinghua.layer setCornerRadius:5];
        [_lbjinghua.layer setBorderColor:RadMenuColor.CGColor];
        [_lbjinghua.layer setBorderWidth:1];
//        [_lbjinghua setBackgroundColor:RGB(243,93,0)];
        [_lbjinghua setHidden:YES];
        [_imgvhead addSubview:_lbjinghua];
        
        
        _lbshipin = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 45, 18)];
        [_lbshipin setText:@"视频"];
        [_lbshipin setTextColor:RadMenuColor];
        [_lbshipin setTextAlignment:NSTextAlignmentCenter];
        [_lbshipin setFont:[UIFont systemFontOfSize:11]];
        [_lbshipin.layer setMasksToBounds:YES];
        [_lbshipin.layer setCornerRadius:5];
//        [_lbshipin setBackgroundColor:RGBAlpha(0, 0, 0, 0.85)];
        [_lbjinghua.layer setBorderColor:RadMenuColor.CGColor];
        [_lbjinghua.layer setBorderWidth:1];
        [_lbshipin setHidden:YES];
        [_imgvhead addSubview:_lbshipin];
        
        
        _lbcontent = [[UILabel alloc] initWithFrame:CGRectZero];
        [_lbcontent setTextColor:RGB(51,51,51)];
        [_lbcontent setNumberOfLines:2];
        [_lbcontent setTextAlignment:NSTextAlignmentLeft];
        [_lbcontent setFont:[UIFont systemFontOfSize:16]];
        [_viewback addSubview:_lbcontent];
        
        
        _lbother = [[UILabel alloc] initWithFrame:CGRectZero];
        [_lbother setTextColor:RadMenuColor];
        [_lbother setTextAlignment:NSTextAlignmentLeft];
        [_lbother setFont:[UIFont systemFontOfSize:14]];
        [_viewback addSubview:_lbother];
        
        _btitem0 = [[UIButton alloc] initWithFrame:CGRectZero];
        [_btitem0 setTitleColor:RGB(102,102,102) forState:UIControlStateNormal];
        [_btitem0.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [_btitem0.layer setBorderColor:RGB(170,170,170).CGColor];
        [_btitem0.layer setBorderWidth:1];
        [_btitem0 setHidden:YES];
        [_viewback addSubview:_btitem0];
        
        _btitem1 = [[UIButton alloc] initWithFrame:CGRectZero];
        [_btitem1 setTitleColor:RGB(102,102,102) forState:UIControlStateNormal];
        [_btitem1.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [_btitem1.layer setBorderColor:RGB(170,170,170).CGColor];
        [_btitem1.layer setBorderWidth:1];
        [_btitem1 setHidden:YES];
        [_viewback addSubview:_btitem1];
        
        _btitem2 = [[UIButton alloc] initWithFrame:CGRectZero];
        [_btitem2 setTitleColor:RGB(102,102,102) forState:UIControlStateNormal];
        [_btitem2.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [_btitem2.layer setBorderColor:RGB(170,170,170).CGColor];
        [_btitem2.layer setBorderWidth:1];
        [_btitem2 setHidden:YES];
        [_viewback addSubview:_btitem2];
        
        _arrbtitems = [NSMutableArray new];
        [_arrbtitems addObject:_btitem0];
        [_arrbtitems addObject:_btitem1];
        [_arrbtitems addObject:_btitem2];
        
        
//        _btzan = [[UIButton alloc] initWithFrame:CGRectZero];
//        [_btzan setTitleColor:RGB(153,153,153) forState:UIControlStateNormal];
//        [_btzan.titleLabel setFont:[UIFont systemFontOfSize:10]];
//        [_viewback addSubview:_btzan];
//
//        _btpinglun = [[UIButton alloc] initWithFrame:CGRectZero];
//        [_btpinglun setTitleColor:RGB(153,153,153) forState:UIControlStateNormal];
//        [_btpinglun.titleLabel setFont:[UIFont systemFontOfSize:10]];
//        [_viewback addSubview:_btpinglun];
        
        _commentLable = [UILabel new];
        [_viewback addSubview:_commentLable];
        _commentLable.textColor = [UIColor colorWithHexString:@"#999999"];
        _commentLable.font = [UIFont systemFontOfSize:11.f];
        [_commentLable setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        
        
        _commentImageView = [UIImageView new];
        [_viewback addSubview:_commentImageView];
        _commentImageView.image = [UIImage imageNamed:@"pinglun"];
        
        _creatLable = [UILabel new];
        [_viewback addSubview:_creatLable];
        _creatLable.textColor = [UIColor colorWithHexString:@"#999999"];
        _creatLable.font = [UIFont systemFontOfSize:11.f];
        [_creatLable setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        
        _creatImageView = [UIImageView new];
        [_viewback addSubview:_creatImageView];
        _creatImageView.image = [UIImage imageNamed:@"zhan"];
        
        
        _viewbtline = [[UIView alloc] initWithFrame:CGRectZero];
        [_viewbtline setBackgroundColor:RGB(153,153,153)];
        [_viewback addSubview:_viewbtline];
        
        
        _viewline = [[UIView alloc] initWithFrame:CGRectZero];
        [_viewline setBackgroundColor:RGB(236,236,236)];
        [_viewback addSubview:_viewline];
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    
    [_viewback setFrame:CGRectMake(0, 0, self.width, self.height)];
    
    [_imgvhead setFrame:CGRectMake(10, 15, _viewback.height-30, _viewback.height-30)];
    [_imgvhead.layer setCornerRadius:5];
    
    [[MDB_UserDefault defaultInstance] setViewWithImage:_imgvhead url:_model.pic];
    
    
    
    [_lbcontent setFrame:CGRectMake(_imgvhead.right+10, _imgvhead.top, _viewback.width-_imgvhead.right-20, 40)];
    [_lbcontent setText:_model.title];
    
    [_lbother setFrame:CGRectMake(_lbcontent.left, _lbcontent.bottom, _lbcontent.width, _imgvhead.height-_lbcontent.height-20)];
    [_lbother setText:@"精华原创"];
    if(_model.video_type.intValue>0)
    {
        [_lbother setText:@"精华原创/视频"];
    }
    
    float fleft = _imgvhead.right+10;
    for(UIButton *bt in _arrbtitems)
    {
        [bt setHidden:YES];
    }
    for(int i = 0 ; i < _model.arrtagstr.count; i++)
    {
        if(i>=_arrbtitems.count-1)break;
        NSString *strtemp = [NSString nullToString:_model.arrtagstr[i]];
        CGSize size = [MDB_UserDefault getStrWightFont:[UIFont systemFontOfSize:11] str:strtemp hight:20];
        UIButton *bt = _arrbtitems[i];
        [bt setFrame:CGRectMake(fleft, _imgvhead.bottom-20, size.width+28, 20)];
        [bt setTitle:strtemp forState:UIControlStateNormal];
        if(bt.width>80*kScale)
        {
            [bt setWidth:80*kScale];
        }
        [bt.layer setMasksToBounds:YES];
        [bt.layer setCornerRadius:bt.height/2.0];
        bt.titleLabel.lineBreakMode =  NSLineBreakByTruncatingTail;
        [bt setHidden:NO];
        fleft = bt.right+5;
        if(fleft>_viewback.width*0.8)
        {
            [bt setHidden:YES];
        }
    }
    
    
    
//    [_btpinglun setFrame:CGRectMake(0, _imgvhead.bottom-20, 40, 20)];
//    [_btpinglun setRight:_viewback.right-10];
//    NSString *strcommentc = [NSString stringWithFormat:@"%@", _model.commentcount];
//    if(strcommentc.intValue>99)
//    {
//        strcommentc = @"99+";
//    }
//    [_btpinglun setTitle:strcommentc forState:UIControlStateNormal];
//    [_btpinglun setImage:[UIImage imageNamed:@"pinglun"] forState:UIControlStateNormal];
//    [_btpinglun setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    NSString *strcommentc = [NSString stringWithFormat:@"%@", _model.commentcount];
    if(strcommentc.intValue>99)
    {
        strcommentc = @"99+";
    }

    [_commentLable setText:strcommentc];
    float fcomw = [MDB_UserDefault countTextSize:CGSizeMake(50, 15) andtextfont:_commentLable.font andtext:strcommentc].width;
    
    [_commentLable setFrame:CGRectMake(_viewback.width-fcomw-8, _imgvhead.bottom-20, fcomw+3, 20)];
    [_commentImageView setFrame:CGRectMake(_commentLable.left-_commentLable.height, _commentLable.top, _commentLable.height, _commentLable.height)];
    
    
//    [_viewbtline setFrame:CGRectMake(_btpinglun.left-1, _btpinglun.top+3, 1, _btpinglun.height-6)];
    
//    [_btzan setFrame:CGRectMake(0, _btpinglun.top, _btpinglun.width, _btpinglun.height)];
//    [_btzan setRight:_btpinglun.left];
//    NSString *strvotesp = [NSString stringWithFormat:@"%@",_model.votesp];
//    if(strvotesp.intValue>99)
//    {
//        strvotesp = @"99+";
//    }
//    [_btzan setTitle:strvotesp forState:UIControlStateNormal];
//    [_btzan setImage:[UIImage imageNamed:@"zhan"] forState:UIControlStateNormal];
//    [_btzan setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    
    NSString *strvotesp = [NSString stringWithFormat:@"%@",_model.votesp];
    if(strvotesp.intValue>99)
    {
        strvotesp = @"99+";
    }

    [_creatLable setText:strvotesp];
    float fcrew = [MDB_UserDefault countTextSize:CGSizeMake(50, 15) andtextfont:_commentLable.font andtext:strvotesp].width;
    [_creatLable setFrame:CGRectMake(_commentImageView.left-fcrew-3, _commentLable.top, fcrew+3, _commentLable.height)];
    [_creatImageView setFrame:CGRectMake(_creatLable.left-_creatLable.height, _creatLable.top, _creatLable.height, _creatLable.height)];
    
    
    
    [_viewline setFrame:CGRectMake(0, _viewback.height-1, _viewback.width, 1)];
    
}


@end
