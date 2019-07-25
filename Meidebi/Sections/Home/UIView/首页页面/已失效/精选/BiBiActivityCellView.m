//
//  BiBiActivityCellView.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/22.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "BiBiActivityCellView.h"

#import "HomeViewModel.h"

#import "MDB_UserDefault.h"

@interface BiBiActivityCellView()

@property (nonatomic , strong) UIImageView *imgvpic;
@property (nonatomic , strong) UILabel *lbtitle;
@property (nonatomic , strong) UILabel *lbtime;
@property (nonatomic , strong) UILabel *lbnumberpeople;

@end

@implementation BiBiActivityCellView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupSubViews];
        
    }
    return self;
}


-(void)setupSubViews
{
    _imgvpic = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, self.width*0.44, self.height-30)];
    [self addSubview:_imgvpic];
    [_imgvpic.layer setMasksToBounds:YES];
    [_imgvpic.layer setCornerRadius:5];
    [_imgvpic setBackgroundColor:[UIColor grayColor]];
    
    
    _lbtitle = [[UILabel alloc] initWithFrame:CGRectMake(_imgvpic.right+10, _imgvpic.top, self.width-_imgvpic.right-20, 30)];
    [self addSubview:_lbtitle];
    [_lbtitle setTextColor:RGB(102,102,102)];
    [_lbtitle setNumberOfLines:2];
    [_lbtitle setTextAlignment:NSTextAlignmentLeft];
    [_lbtitle setFont:[UIFont systemFontOfSize:12]];
    
    _lbtime = [[UILabel alloc] initWithFrame:CGRectMake(_lbtitle.left, _lbtitle.bottom, _lbtitle.width, 1)];
//    [self addSubview:_lbtime];
    [_lbtime setTextColor:RGB(60, 60, 60)];
    [_lbtime setTextAlignment:NSTextAlignmentLeft];
    [_lbtime setFont:[UIFont systemFontOfSize:12]];
    
    
    
    
    _lbnumberpeople = [[UILabel alloc]initWithFrame:CGRectMake(_lbtitle.left, _lbtime.bottom+15, _lbtitle.width, 14)];
    [self addSubview:_lbnumberpeople];
    [_lbnumberpeople setTextColor:RGB(153,153,153)];
    [_lbnumberpeople setTextAlignment:NSTextAlignmentRight];
    [_lbnumberpeople setFont:[UIFont systemFontOfSize:10]];
    
    
    
    
}

-(void)loadData:(id)model
{
    HomeActivitieViewModel *modeltemp = model;
    [[MDB_UserDefault defaultInstance] setViewWithImage:_imgvpic url:modeltemp.imageLink];
    [_lbtitle setText:modeltemp.title];
    [_lbtime setText:@"2018.03.22-2018.3.30"];
    [_lbnumberpeople setText:[NSString stringWithFormat:@"%@人正在参与",modeltemp.totaluser]];
    [_lbnumberpeople setAttributedText:[self arrstring:_lbnumberpeople.text andstart:0 andend:modeltemp.totaluser.length+1 andfont:10 andcolor:RGB(242,70,58)]];
    for(int i = 0 ; i < modeltemp.users.count;i++)
    {
        UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(_lbnumberpeople.left+(_lbnumberpeople.height+6)*i, _lbnumberpeople.top-2, _lbnumberpeople.height+4, _lbnumberpeople.height+4)];
        [imgv.layer setMasksToBounds:YES];
        [imgv.layer setCornerRadius:imgv.height/2.0];
        [imgv setBackgroundColor:[UIColor grayColor]];
        [self addSubview:imgv];
        HomeUserViewModel *userModel = modeltemp.users[i];
        [[MDB_UserDefault defaultInstance] setViewWithImage:imgv url:userModel.avatar];
        
    }
    
    
    [self bringSubviewToFront:_lbnumberpeople];
    
}

///设置一行显示不同字体 颜色
-(NSMutableAttributedString *)arrstring:(NSString *)str andstart:(int)istart andend:(int)length andfont:(float)ff andcolor:(UIColor *)color
{
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc]initWithString:str];
    @try {
        [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:ff] range:NSMakeRange(istart, length)];
        
        [noteStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(istart, length)];
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    
    return noteStr;
}


@end
