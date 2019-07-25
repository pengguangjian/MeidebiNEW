//
//  PushSubscibeHotKeysView.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/7/17.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "PushSubscibeHotKeysView.h"

#import "MDB_UserDefault.h"

@implementation PushSubscibeHotKeysView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self drawUI];
    }
    return self;
}


-(void)drawUI
{
    UILabel *lbtitle = [[UILabel alloc] init];
    [self addSubview:lbtitle];
    [lbtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(0);
    }];
//    [lbtitle setText:@"热门推荐"];
    [lbtitle setTextColor:RGB(90, 90, 90)];
    
    
}


-(void)bindkeys:(NSArray *)arrkeys
{
    __block float fleft = 15.0;
    __block float ftop = 30.0;
    for(NSString *strtemp in arrkeys)
    {
        if(![strtemp isKindOfClass:[NSString class]])
        {
            return;
        }
        float fwsize = [MDB_UserDefault getStrWightFont:[UIFont systemFontOfSize:15] str:strtemp hight:20].width+20;
        if(fleft+fwsize>self.width)
        {
            fleft = 15.0;
            ftop=ftop+33+13;
        }
        
        UIButton *bt = [[UIButton alloc] init];
        [self addSubview:bt];
        [bt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(fleft);
            make.top.offset(ftop);
            make.width.offset(fwsize);
            make.height.offset(33);
            
            fleft = fleft+fwsize+13;
        }];
        [bt.layer setBorderColor:RGB(237, 236, 238).CGColor];
        [bt.layer setBorderWidth:1];
        [bt.layer setCornerRadius:33/2.0];
        [bt setBackgroundColor:[UIColor whiteColor]];
        [bt setTitle:strtemp forState:UIControlStateNormal];
        [bt setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        [bt.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [bt addTarget:self action:@selector(btAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(ftop+30+13);
    }];
    
}

-(void)btAction:(UIButton *)sender
{
    NSString *strtemp = sender.titleLabel.text;
    
    [self.delegate PushSubscibeHotKeysViewItemAction:strtemp];
//    NSLog(@"%@",strtemp);
    
}


@end
