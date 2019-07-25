//
//  AddressListModel.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/4/8.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "AddressListModel.h"

@implementation AddressListModel

+(AddressListModel *)dicChangeToModel:(NSDictionary *)dic
{
    AddressListModel *model = [[AddressListModel alloc] init];
    
    NSString *addressInfoStr = [NSString stringWithFormat:@"%@%@%@%@",[NSString nullToString:dic[@"prov_name"]],[NSString nullToString:dic[@"city_name"]],[NSString nullToString:dic[@"county_name"]],[NSString nullToString:dic[@"address"]]];
    model.strid = [NSString stringWithFormat:@"%@",dic[@"address_id"]];
    model.strname = [NSString stringWithFormat:@"%@",dic[@"truename"]];
    model.strphone = [NSString stringWithFormat:@"%@",dic[@"mobile"]];
    model.strisnomo = [NSString stringWithFormat:@"%@",dic[@"isdefault"]];
    model.straddress = addressInfoStr;
    model.strprovince = [NSString nullToString:dic[@"prov_name"]];
    model.strcity = [NSString nullToString:dic[@"city_name"]];
    model.strarea = [NSString nullToString:dic[@"county_name"]];
    model.straddressdetal = [NSString nullToString:dic[@"address"]];
    model.strcode = [NSString nullToString:dic[@"postcode"]];
    model.strprovinceid = [NSString nullToString:dic[@"province"]];
    model.strcityid = [NSString nullToString:dic[@"city"]];
    model.strareaid = [NSString nullToString:dic[@"county"]];
    
    

    
    return model;
}

@end
