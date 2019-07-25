//
//  DaiGouHomeListModel.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/17.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DaiGouHomeListModel : NSObject
@property (nonatomic, strong) NSString *dgID;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *addtime;
@property (nonatomic, strong) NSString *istop;
@property (nonatomic, strong) NSString *ishot;
@property (nonatomic, strong) NSString *share_id;
///运输方式 1转运 2直邮
@property (nonatomic, strong) NSString *transfertype;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *isend;
@property (nonatomic, strong) NSString *isspiderorder;
@property (nonatomic, strong) NSString *purchased_nums;

/////现货
@property (nonatomic, strong) NSString *isspotgoods;

+ (instancetype)viewModelWithSubject:(NSDictionary *)subject;
@end
