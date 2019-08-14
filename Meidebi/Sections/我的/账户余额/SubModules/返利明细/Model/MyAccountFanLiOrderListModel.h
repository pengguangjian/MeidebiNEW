//
//  MyAccountFanLiOrderListModel.h
//  Meidebi
//
//  Created by mdb-losaic on 2019/8/13.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyAccountFanLiOrderListModel : NSObject

@property (nonatomic , retain ) NSMutableArray *arrmodel;
///购买时间
@property (nonatomic , retain ) NSString *create_time;
///国际运费金额
@property (nonatomic , retain ) NSString *carriage_amount;
///预估返利
@property (nonatomic , retain ) NSString *estimated_revenue;


-(void)modelValue:(NSDictionary *)dicvalue;

@end

@interface MyAccountFanLiOrderModel : NSObject

@property (nonatomic , retain ) NSString *title;

@property (nonatomic , retain ) NSString *pic_url;

@property (nonatomic , retain ) NSString *status_text;

@property (nonatomic , retain ) NSString *is_take_effect;

-(void)modelValue:(NSDictionary *)dicvalue;

@end


NS_ASSUME_NONNULL_END
