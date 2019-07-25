//
//  AddressListModel.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/8.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressListModel : NSObject

@property (nonatomic , retain) NSString *strid;

@property (nonatomic , retain) NSString *strname;

@property (nonatomic , retain) NSString *strphone;
///地址信息
@property (nonatomic , retain) NSString *straddress;

@property (nonatomic , retain) NSString *strprovince;
@property (nonatomic , retain) NSString *strcity;
@property (nonatomic , retain) NSString *strarea;

@property (nonatomic , retain) NSString *strprovinceid;
@property (nonatomic , retain) NSString *strcityid;
@property (nonatomic , retain) NSString *strareaid;

@property (nonatomic , retain) NSString *straddressdetal;

@property (nonatomic , retain) NSString *strcode;

@property (nonatomic , retain) NSString *strisnomo;

+(AddressListModel *)dicChangeToModel:(NSDictionary *)dic;

@end
