//
//  CommentViewController.h
//  Meidebi
//
//  Created by 杜非 on 15/2/5.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewController : UIViewController


@property(nonatomic,assign) NSInteger  type;//1、为链接（包含单品，活动，优惠卷） 2 晒单 3 券交易
@property(nonatomic,assign)NSInteger  linkid;//linkid：（必须，即单品、活动、优惠卷的ID）

@end

@interface Comment :NSObject

@property(nonatomic,assign)NSInteger comentid;
@property(nonatomic,assign)NSInteger fromid;
@property(nonatomic,assign)NSInteger createtime;
@property(nonatomic,assign)NSInteger referto;
@property(nonatomic,assign)NSInteger userid;
@property(nonatomic,assign)NSInteger touserid;
@property(nonatomic,assign)NSInteger status;


//@property(nonatomic,strong)NSString *comment;
@property(nonatomic,strong)NSString *tonickname;
@property(nonatomic,strong)NSString *refernickname;
@property(nonatomic,strong)NSString *refercontent;
@property(nonatomic,strong)NSString *nickname;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *photo;

@end