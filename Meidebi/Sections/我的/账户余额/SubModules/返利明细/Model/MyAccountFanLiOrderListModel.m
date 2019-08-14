//
//  MyAccountFanLiOrderListModel.m
//  Meidebi
//
//  Created by mdb-losaic on 2019/8/13.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import "MyAccountFanLiOrderListModel.h"


@implementation MyAccountFanLiOrderListModel

-(void)modelValue:(NSDictionary *)dicvalue
{
   
    NSMutableArray *arrtemp = [NSMutableArray new];
    
    @try {
        for(NSDictionary *dictemp in [dicvalue objectForKey:@"goods"])
        {
            MyAccountFanLiOrderModel *model  = [[MyAccountFanLiOrderModel alloc] init];
            [model modelValue:dictemp];
            [arrtemp addObject:model];
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    self.carriage_amount = [NSString nullToString:[dicvalue objectForKey:@"carriage_amount"]];
    self.estimated_revenue = [NSString nullToString:[dicvalue objectForKey:@"estimated_revenue"]];
    self.create_time = [NSString nullToString:[dicvalue objectForKey:@"create_time"]];
    
    self.arrmodel = arrtemp;
}

@end

@implementation MyAccountFanLiOrderModel

-(void)modelValue:(NSDictionary *)dicvalue
{
    self.title = [NSString nullToString:[dicvalue objectForKey:@"title"]];
    self.pic_url = [NSString nullToString:[dicvalue objectForKey:@"pic_url"]];
    self.status_text = [NSString nullToString:[dicvalue objectForKey:@"status_text"]];
    self.is_take_effect = [NSString nullToString:[dicvalue objectForKey:@"is_take_effect"]];

}

@end
