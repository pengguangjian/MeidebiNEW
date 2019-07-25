//
//  ReMenZhuanTiView.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/22.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReMenZhuanTiViewDelegate <NSObject>

///热门专题
- (void)sepcialProtalTableViewDidSelectSpecial:(NSString *)specialID andtype:(int)type;
///更多
- (void)homeSepcialProtalViewDidClickMoreBtn;
@end

@interface ReMenZhuanTiView : UIView

@property (nonatomic , weak) id<ReMenZhuanTiViewDelegate>delegate;

- (float)bindDataWithModel:(NSArray *)models;

@end
