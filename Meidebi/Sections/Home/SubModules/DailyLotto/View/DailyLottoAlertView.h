//
//  DailyLottoAlertView.h
//  Meidebi
//
//  Created by mdb-admin on 2017/9/19.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DailyLottoAlertView : UIView

- (void)showAlertWithAward:(NSString *)award
                      type:(NSString *)type;

- (void)dismiss;
@end
