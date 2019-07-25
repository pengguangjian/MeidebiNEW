//
//  OtherComV.h
//  Meidebi
//
//  Created by 杜非 on 15/3/13.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Comment;
@interface OtherComV : UIView{
    UILabel *labelyin;
    UILabel *labelname;
    UILabel *labelyuan;
    UILabel *labelcont;

}




-(id)initWithFrame:(CGRect)frame;
-(void)setWithDic:(Comment *)dic;




@end
