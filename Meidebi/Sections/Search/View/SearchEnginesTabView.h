//
//  SearchEnginesTabView.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/9.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchEnginesTabViewDelegate <NSObject>

@optional
-(void)SearchEnginesTabViewDelegateSelectValue:(id)value;

-(void)scrollDrag;

@end

@interface SearchEnginesTabView : UIView
////搜索的关键词
@property (nonatomic , weak) NSString *strkeywords;

@property (nonatomic , weak) id<SearchEnginesTabViewDelegate>degelate;
           

-(void)loaddata:(NSString *)strkey;

@end
