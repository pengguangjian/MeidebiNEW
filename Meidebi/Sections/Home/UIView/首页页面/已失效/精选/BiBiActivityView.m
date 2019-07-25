//
//  BiBiActivityView.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/22.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "BiBiActivityView.h"

#import "BiBiActivityCellView.h"

@interface BiBiActivityView()

@property (nonatomic , strong) UIScrollView *scrollView;

@end

@implementation BiBiActivityView

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
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    [self addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:14.f];
    titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    titleLabel.text = @"比比活动";
    [titleLabel sizeToFit];
    [titleLabel setCenter:CGPointMake(self.width/2.0, 0)];
    [titleLabel setTop:10];
    [titleLabel setHeight:20];
    
    UIView *leftLineView = [[UIView alloc] initWithFrame:CGRectMake(titleLabel.left-16, titleLabel.center.y, 16, 1)];
    [self addSubview:leftLineView];
    leftLineView.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    
    UIView *rightLineView = [[UIView alloc] initWithFrame:CGRectMake(titleLabel.right, titleLabel.center.y, 16, 1)];
    [self addSubview:rightLineView];
    rightLineView.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 30, self.width, self.height-30)];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [self addSubview:_scrollView];
    [_scrollView setPagingEnabled:YES];
    
    
}

-(void)loadBiBiData:(NSArray *)arrbb
{
    if(arrbb.count<1)return;
    for(UIView *view in _scrollView.subviews)
    {
        [view removeFromSuperview];
    }
    for(int i = 0 ; i< arrbb.count;i++)
    {
        BiBiActivityCellView *cell = [[BiBiActivityCellView alloc] initWithFrame:CGRectMake(_scrollView.width*i, 0, _scrollView.width, _scrollView.height)];
        [_scrollView addSubview:cell];
        [cell loadData:arrbb[i]];
        [cell setUserInteractionEnabled:YES];
        [cell setTag:i];
        UITapGestureRecognizer *tapcell = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellAction:)];
        [cell addGestureRecognizer:tapcell];
    }
    [_scrollView setContentSize:CGSizeMake(_scrollView.width*arrbb.count, 0)];
    if(arrbb.count>1)
    {
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(scrollTimeAction) userInfo:nil repeats:NO];
    }
}

-(void)scrollTimeAction
{
    [_scrollView setContentOffset:CGPointMake(_scrollView.width, 0) animated:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(scrollTimeAction1) userInfo:nil repeats:NO];
}

-(void)scrollTimeAction1
{
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(void)cellAction:(UIGestureRecognizer *)gesture
{
    [self.delegate BiBiActivityViewAction:gesture.view.tag];
    
}

@end
