//
//  AppraiseVIew.m
//  Meidebi
//
//  Created by 杜非 on 15/4/28.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import "AppraiseVIew.h"

@implementation AppraiseVIew{
    
}
-(void)setIntloadWight:(float)wight{
    float imalWight=self.frame.size.width/5.0;
    _sumWidth = 0;
    for (int x=0; x<5; x++) {
        UIImageView *imal=[[UIImageView alloc]initWithFrame:CGRectMake(imalWight*x+(imalWight-wight)/2.0,(self.frame.size.height-wight)/2.0 ,wight , wight)];
        imal.image= x==0?[UIImage imageNamed:@"appraise.png"]:[UIImage imageNamed:@"appraisegray.png"];
        imal.tag=400+x;
        [self addSubview:imal];
        if (x==4) {
            _sumWidth=CGRectGetMaxX(imal.frame);
        }
    }

}
-(void)setSelectImageIndex:(NSInteger)count{
    for (UIImageView *imal in [self subviews]) {
        if ((imal.tag-400)<count) {
            imal.image=[UIImage imageNamed:@"appraise.png"];
        }else{
            imal.image=[UIImage imageNamed:@"appraisegray.png"];
        }
    }

}

@end
