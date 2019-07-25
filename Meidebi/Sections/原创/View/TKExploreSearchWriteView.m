//
//  TKExploreSearchWriteView.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/5/22.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "TKExploreSearchWriteView.h"

#import "YuanChuanSearchTableViewController.h"

@implementation TKExploreSearchWriteView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configurUI];
    }
    return self;
}

- (void)configurUI{
    
    [self setBackgroundColor:RGB(245, 245, 245)];
    
    UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(13*kScale, 5*kScale, self.width-26*kScale, self.height-10*kScale)];
    [viewline setBackgroundColor:[UIColor whiteColor]];
    [viewline.layer setMasksToBounds:YES];
    [viewline.layer setCornerRadius:viewline.height/2.0];
    [viewline.layer setBorderColor:RGB(211,211,211).CGColor];
    [viewline.layer setBorderWidth:1];
    [self addSubview:viewline];
    
    _searchField = [[UITextField alloc] initWithFrame:CGRectMake(25, 0, viewline.width-25-viewline.height-10, viewline.height)];
    [_searchField setPlaceholder:@"想看什么内容？搜索试试看"];
    [_searchField setTextColor:RGB(80, 80, 80)];
    [_searchField setTextAlignment:NSTextAlignmentLeft];
    [_searchField setFont:[UIFont systemFontOfSize:14]];
    [_searchField setReturnKeyType:UIReturnKeySearch];
    [_searchField setDelegate:self];
    [viewline addSubview:_searchField];
    
    UIButton *btsearch = [[UIButton alloc] initWithFrame:CGRectMake(_searchField.right, 0, viewline.height, viewline.height)];
    [viewline addSubview:btsearch];
    UIImageView *images = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, btsearch.width*0.7, btsearch.width*0.7)];
    [images setImage:[UIImage imageNamed:@"yuanchuang_seach_icon"]];
    [images setCenter:CGPointMake(btsearch.width/2.0, btsearch.height/2.0)];
    [btsearch addSubview:images];
    [btsearch addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void)searchAction
{
    [_searchField resignFirstResponder];
    
    NSLog(@"开始搜索");
    NSString *strtemp = [_searchField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(strtemp.length < 1)return;
    
    YuanChuanSearchTableViewController *yvc = [[YuanChuanSearchTableViewController alloc] init];
    yvc.strkeywords = _searchField.text;
    [self.nvc pushViewController:yvc animated:YES];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@"\n"])
    {
        [self searchAction];
        return NO;
    }
    
    return YES;
}

@end
