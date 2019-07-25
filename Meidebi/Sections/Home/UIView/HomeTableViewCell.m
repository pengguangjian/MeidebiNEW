//
//  HomeTableViewCell.m
//  Meidebi
//
//  Created by mdb-admin on 2017/8/24.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "NJScrollTableView.h"
@interface HomeTableViewCell ()
<
ScrollTabViewDataSource
>
@property (nonatomic, strong) NSArray *views;
@property (nonatomic, strong) NJScrollTableView *scrollTableView;
@end

@implementation HomeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NJScrollTableView *scrollTableView = [[NJScrollTableView alloc] initWithFrame:CGRectMake(0,
                                                                                                 0,
                                                                                                 kMainScreenW,
                                                                                                 kMainScreenH-(kTopHeight+kTabBarHeight/*nav height + tabbar height*/))];
        scrollTableView.backgroundColor = [UIColor whiteColor];
        scrollTableView.selectedLineWidth = 100;
        scrollTableView.dataSource = self;
        [self.contentView addSubview:scrollTableView];
        _scrollTableView = scrollTableView;
    }
    return self;
}

- (void)showRemind:(BOOL)isShow{
    [_scrollTableView showRemindView:isShow];
}

- (void)setDelegate:(id<HomeTableViewCellDelegate>)delegate{
    _delegate = delegate;
    if (!_scrollTableView.isBuildUI) {
        [_scrollTableView buildUI];
        @try
        {
            [_scrollTableView selectTabWithIndex:0 animate:NO];
        }
        @catch (NSException *exc)
        {
            
        }
        @finally
        {
            
        }
        
    }
}
#pragma mark - ScrollTabViewDataSource
- (NSUInteger)numberOfPagers:(NJScrollTableView *)view{
    _views = [self.delegate numberOfCellPages];
    return _views.count;
}

- (UITableViewController *)scrollTableViewOfPagers:(NJScrollTableView *)view
                                     indexOfPagers:(NSUInteger)index{
    return _views[index];
}

- (void)whenSelectOnPager:(NSUInteger)number{
    if (number == _views.count-1) {
        if ([self.delegate respondsToSelector:@selector(didWipeToHotNew)]) {
            [self.delegate didWipeToHotNew];
        }
    }
}




@end
