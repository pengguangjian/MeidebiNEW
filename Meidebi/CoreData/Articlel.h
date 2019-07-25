//
//  Articlel.h
//  Meidebi
//
//  Created by mdb-admin on 16/5/4.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Articlel : NSObject

@property(nonatomic,strong)NSString *categoryname;
@property(nonatomic,strong)NSString *nickname;
@property(nonatomic,strong)NSString *postage;
@property(nonatomic,strong)NSString *price;
@property(nonatomic,strong)NSString *proprice;
@property(nonatomic,strong)NSString *sitename;
@property(nonatomic,strong)NSString *commentcount;
@property(nonatomic,strong)NSString *category;
@property(nonatomic,strong)NSString *createtime;
@property(nonatomic,strong)NSString *dealer;
@property(nonatomic,strong)NSString *descrip;
@property(nonatomic,strong)NSString *fcategory;
@property(nonatomic,strong)NSString *artid;
@property(nonatomic,strong)NSString *isabroad;
@property(nonatomic,strong)NSString *linktype;
@property(nonatomic,strong)NSString *remoteimage;
@property(nonatomic,strong)NSString *siteid;
@property(nonatomic,strong)NSString *timeout;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *url;
@property(nonatomic,strong)NSString *userid;
@property(nonatomic,strong)NSString *weight;
@property(nonatomic,strong)NSString *votesp;
@property(nonatomic,strong) NSString *prodescription;
@property(nonatomic,assign)BOOL isSelected;
@property(nonatomic,strong) NSString *tljurl;

-(void)setwithDic:(NSDictionary *)dic;
@end
