//
//  oneView.h
//  Meidebi
//
//  Created by 杜非 on 15/1/26.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol oneViewDelegate <NSObject>

@optional

-(void)butSelect:(NSInteger)index;

@end

@interface oneView : UIView<oneViewDelegate>

@property(nonatomic,weak)id<oneViewDelegate>delegate;
@property(nonatomic,strong)UIView *yuanviewl;
@property (nonatomic, strong) UIView *commentWarningView;
-(id)initWithFrame:(CGRect)frame imageArr:(NSArray *)imageArr strArr:(NSArray *)strArr;


@end
