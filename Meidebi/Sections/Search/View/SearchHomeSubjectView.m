//
//  SearchHomeSubjectView.m
//  Meidebi
//
//  Created by mdb-admin on 2016/11/28.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "SearchHomeSubjectView.h"
#import "HistoryHotView.h"
#import "MDB_UserDefault.h"

@interface NJHistoryScrollView : UIScrollView

@end

@implementation NJHistoryScrollView

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

@interface SearchHomeSubjectView ()
<
HistoryHotViewDelegate,
UIScrollViewDelegate
>
///历史搜索记录
@property (nonatomic, strong) HistoryHotView *historyView;
///热门搜索
@property (nonatomic, strong) HistoryHotView *hotView;

@property (nonatomic, strong) UIView *contairView;




@end

@implementation SearchHomeSubjectView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    
    self.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    NSArray *histCaches = [MDB_UserDefault getProcducs];
    
    NJHistoryScrollView *scrollView = [NJHistoryScrollView new];
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
    _hotView.strtitle = @"Ta们都在搜";
    [_hotView setHidden:YES];
    __weak typeof(self) viewh = self;
    _hotView.callback = ^(CGFloat height){
        [viewh.hotView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(contairView);
            make.height.offset(height);
        }];
    };
    
    _historyView = [HistoryHotView new];
    [contairView addSubview:_historyView];
    _historyView.dataHistorySource = histCaches;
    _historyView.delegate = self;
    _historyView.isbottom = YES;
    _historyView.strtitle = @"历史搜索";
    __weak typeof(self) view = self;
    __weak typeof(_hotView) viewht = _hotView;
    _historyView.callback = ^(CGFloat height){
        [view.historyView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(viewht.mas_bottom);
            make.left.right.equalTo(contairView);
            if(height<1)
            {
                make.height.offset(1);
            }
            else
            {
                make.height.offset(height);
            }
        }];
    };
    
    
    
    if(histCaches.count==0)
    {
        [contairView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_hotView.mas_bottom);
        }];
    }
    else
    {
        [contairView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_historyView.mas_bottom);
        }];
    }
}

- (void)updateSearchCache{
     NSArray *histCaches = [MDB_UserDefault getProcducs];
    _historyView.dataHistorySource = histCaches;
    __weak typeof(self) view = self;
    __weak typeof(_hotView) viewht = _hotView;
    _historyView.callback = ^(CGFloat height){
        [view.historyView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(viewht.mas_bottom);
            make.left.right.equalTo(view.contairView);
            if(height<1)
            {
                make.height.offset(1);
            }
            else
            {
                make.height.offset(height);
            }
            
        }];
    };
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    @try
    {
        [self.nextResponder touchesBegan:touches withEvent:event];
    }
    @finally
    {
        
    }
}

///热门搜索词
-(void)updateHotKeyValue:(NSMutableArray *)arrvalue
{
    if(arrvalue.count>0)
    {
        _hotView.dataHistorySource = arrvalue;
        [_hotView setHidden:NO];
        __weak typeof(self) viewh = self;
        _hotView.callback = ^(CGFloat height){
            [viewh.hotView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(viewh.contairView);
                make.height.offset(height);
            }];
        };
    }
    
}

#pragma mark - HistoryHotViewDelegate
- (void)historyHotViewDidPressDeleateBtn{
    [MDB_UserDefault removeAllProducs];
//    _historyView.dataHistorySource = nil;
    [_historyView setHidden:YES];
//    [_historyView mas_remakeConstraints:^(MASConstraintMaker *make) {
////        make.top.left.right.equalTo(self);
//        make.height.offset(1);
//    }];
    
}

- (void)historyHotView:(HistoryHotView *)hotView didPressSimpleHistoryStr:(NSString *)contentStr{
    if ([self.delegate respondsToSelector:@selector(searchHomeSubjectView:didSelectSearchHistoryStr:)]) {
        [self.delegate searchHomeSubjectView:self didSelectSearchHistoryStr:contentStr];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(searchHomeSubjectViewDidSlide)]) {
        [self.delegate searchHomeSubjectViewDidSlide];
    }
}
@end
