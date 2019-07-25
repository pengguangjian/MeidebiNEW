//
//  DaiGouXiaDanMainView.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/30.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DaiGouXiaDanMainView : UIView

///是否是参与拼团
@property (nonatomic , assign) BOOL iscanyupintuan;

-(void)bindData:(NSDictionary *)dicvalue andstrpindan_id:(NSString *)strpindan_id;

-(void)bindUrl:(NSString *)strid andstrpindan_id:(NSString *)strpindan_id;


@property (nonatomic , assign) BOOL iseditnumber;

@property (nonatomic , retain) NSTimer *toptimeer;

@end
