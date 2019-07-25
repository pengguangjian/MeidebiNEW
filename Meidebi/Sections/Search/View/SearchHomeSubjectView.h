//
//  SearchHomeSubjectView.h
//  Meidebi
//
//  Created by mdb-admin on 2016/11/28.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchHomeSubjectView;
@protocol SearchHomeSubjectViewDelegate <NSObject>

@optional
- (void)searchHomeSubjectView:(SearchHomeSubjectView *)subjectView
    didSelectSearchHistoryStr:(NSString *)historyStr;
- (void)searchHomeSubjectViewDidSlide;
@end

@interface SearchHomeSubjectView : UIView
@property (nonatomic, weak) id<SearchHomeSubjectViewDelegate> delegate;
- (void)updateSearchCache;

///热门搜索词
-(void)updateHotKeyValue:(NSMutableArray *)arrvalue;

@end
