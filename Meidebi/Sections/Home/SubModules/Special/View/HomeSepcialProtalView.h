//
//  HomeSepcialProtalView.h
//  Meidebi
//
//  Created by ZlJ_losaic on 2017/8/22.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeSepcialProtalViewDelegate <NSObject>

@optional - (void)sepcialProtalTableViewDidSelectSpecial:(NSString *)specialID;
@optional - (void)sepcialProtalTableViewDidSelectTBSpecial:(NSString *)content;
@optional - (void)homeSepcialProtalViewDidClickMoreBtn;

@end

@interface HomeSepcialProtalView : UIView

@property (nonatomic, weak) id<HomeSepcialProtalViewDelegate> delegate;
- (void)bindDataWithModel:(NSArray *)models;

@end
