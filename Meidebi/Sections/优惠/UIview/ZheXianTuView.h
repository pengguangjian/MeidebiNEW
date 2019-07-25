//
//  ZheXianTuView.h
//  ZheXianTu
//
//  Created by mdb-losaic on 2019/2/26.
//  Copyright © 2019年 mcxzfa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,LineType) {
    
    LineType_Straight = 0,
    LineType_Curve
    
};

@interface ZheXianTuView : UIView
/*
/////画折线图
 *targetValues 所有的值 createtime：price：
 
 */
-(void)drawLineChartViewWithValues:(NSMutableArray *)targetValues;

@end

NS_ASSUME_NONNULL_END
