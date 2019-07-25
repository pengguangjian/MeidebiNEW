//
//  SearchHotKeyDaiGouView.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/2/15.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import "SearchHotKeyDaiGouView.h"
#import "HistoryHotView.h"
#import "MDB_UserDefault.h"


@interface NJHotScrollView : UIScrollView

@end

@implementation NJHotScrollView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    @try
    {
        [self.nextResponder touchesBegan:touches withEvent:event];
    }
    @finally
    {
        
    }
}

@end


@interface SearchHotKeyDaiGouView ()
<HistoryHotViewDelegate,UIScrollViewDelegate>
///热门搜索
@property (nonatomic, strong) HistoryHotView *hotView;

@property (nonatomic, strong) UIView *contairView;

@end

@implementation SearchHotKeyDaiGouView

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
        [self setupSubViews];
        
    }
    return self;
}
- (void)setupSubViews{
    
    self.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    
    NJHotScrollView *scrollView = [NJHotScrollView new];
    [self addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    scrollView.delegate = self;
    
    UIView *contairView = [UIView new];
    [scrollView addSubview:contairView];
    [contairView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    contairView.backgroundColor = [UIColor clearColor];
    _contairView = contairView;
    
    _hotView = [[HistoryHotView alloc] init];
    [contairView addSubview:_hotView];
    _hotView.dataHistorySource = [NSArray new];
    [_hotView setTag:10];
    _hotView.delegate = self;
    _hotView.isbottom = NO;
    _hotView.strtitle = @"热门搜索";
//    [_hotView setHidden:YES];
    __weak typeof(self) viewh = self;
    _hotView.callback = ^(CGFloat height){
        [viewh.hotView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(contairView);
            make.height.offset(height);
        }];
    };
    
    [contairView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_hotView.mas_bottom);
    }];
    
}
-(void)updateHotKeyValue:(NSMutableArray *)arrvalue
{
    if(arrvalue.count>0)
    {
        _hotView.dataHistorySource = arrvalue;
//        [_hotView setHidden:NO];
        __weak typeof(self) viewh = self;
        _hotView.callback = ^(CGFloat height){
            [viewh.hotView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(viewh);
                make.height.offset(height);
            }];
        };
    }
}

#pragma mark - HistoryHotViewDelegate
- (void)historyHotViewDidPressDeleateBtn{
}

- (void)historyHotView:(HistoryHotView *)hotView didPressSimpleHistoryStr:(NSString *)contentStr{
    if ([self.delegate respondsToSelector:@selector(searchHotKeyDaiGouViewSubjectView:didSelectSearchHistoryStr:)]) {
        [self.delegate searchHotKeyDaiGouViewSubjectView:self didSelectSearchHistoryStr:contentStr];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    @try
    {
        [self.nextResponder touchesBegan:touches withEvent:event];
    }
    @finally
    {
        [self.delegate keyboarddismisss];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.delegate keyboarddismisss];
    
}
@end
