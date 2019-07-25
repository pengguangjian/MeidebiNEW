//
//  PushYuanChuangTextView.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/9/6.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "PushYuanChuangTextView.h"

@interface PushYuanChuangTextView ()
{
    
    UILabel *lbplach;
    
}

@end

@implementation PushYuanChuangTextView

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
        lbplach = [[UILabel alloc] initWithFrame:CGRectMake(5, 8, frame.size.width-16, 100)];
        [lbplach setTextColor:RGB(189, 189, 189)];
        [lbplach setTextAlignment:NSTextAlignmentLeft];
        [lbplach setNumberOfLines:0];
        [self addSubview:lbplach];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [lbplach setFont:self.font];
    lbplach.width = self.width-16;
    [lbplach setLeft:4];
    [lbplach sizeToFit];
    
    if(self.text.length>0)
    {
        [lbplach setHidden:YES];
    }
    else
    {
        [lbplach setHidden:NO];
    }
    
}

-(void)hiddenPlaceholder
{
    if(self.text.length>0)
    {
        [lbplach setHidden:YES];
    }
    else
    {
        [lbplach setHidden:NO];
    }
}

-(void)setPlaceholderText:(NSString *)PlaceholderText
{
    [lbplach setText:PlaceholderText];
    [lbplach sizeToFit];
}

-(void)textChange:(NSNotification *)notifi
{
    if(self.text.length>0)
    {
        [lbplach setHidden:YES];
    }
    else
    {
        [lbplach setHidden:NO];
    }
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
