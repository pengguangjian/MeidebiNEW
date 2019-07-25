//
//  SignInListModel.h
//  Meidebi
//
//  Created by fishmi on 2017/6/8.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignInListModel : NSObject
@property (nonatomic ,copy) NSString *activeprice;
@property (nonatomic ,copy) NSString *activeprice_change;
@property (nonatomic ,copy) NSString *agttype;
@property (nonatomic ,copy) NSString *classify;
@property (nonatomic ,copy) NSString *commentcount;
@property (nonatomic ,copy) NSString *commentyid;
@property (nonatomic ,copy) NSString *image;
@property (nonatomic ,copy) NSString *isabroad;
@property (nonatomic ,copy) NSString *linktype;
@property (nonatomic ,copy) NSString *linkurl;
@property (nonatomic ,copy) NSString *orginprice;
@property (nonatomic ,copy) NSString *orginprice_change;
@property (nonatomic ,copy) NSString *price;
@property (nonatomic ,copy) NSString *siteid;
@property (nonatomic ,copy) NSString *sitename;
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *votesp;

+ (void)listKeyReplace;
@end
