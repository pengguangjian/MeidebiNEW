//
//  MenuView.h
//  Meidebi
//
//  Created by 杜非 on 15/1/6.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MenuView;
@protocol MenuDelegate<NSObject>
@optional

-(void)MenuSelect:(MenuView *)menu index:(NSInteger)selectIndex title:(NSString *)title;

@end
@interface MenuView : UIView

@property(nonatomic,weak)id<MenuDelegate>delegate;

@property(nonatomic,assign)NSInteger index;

-(id)initWithFrame:(CGRect)frame titles:(NSArray *)titles delegat:(id<MenuDelegate>)delegate;
-(void)setSelectOne;
-(void)setMenuIndex:(NSInteger)index;
@end
