//
//  SearchHotKeyDaiGouView.h
//  Meidebi
//
//  Created by mdb-losaic on 2019/2/15.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SearchHotKeyDaiGouView;
@protocol SearchHotKeyDaiGouViewDelegate <NSObject>

- (void)searchHotKeyDaiGouViewSubjectView:(SearchHotKeyDaiGouView *)subjectView
    didSelectSearchHistoryStr:(NSString *)historyStr;


-(void)keyboarddismisss;

@end

@interface SearchHotKeyDaiGouView : UIView

-(void)updateHotKeyValue:(NSMutableArray *)arrvalue;

@property (nonatomic, weak)id<SearchHotKeyDaiGouViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
