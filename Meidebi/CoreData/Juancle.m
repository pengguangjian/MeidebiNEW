//
//  Juancle.m
//  Meidebi
//
//  Created by 杜非 on 15/1/26.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import "Juancle.h"


@implementation Juancle

-(instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.juanid=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"id"]] integerValue]];
        self.man=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"man"]] integerValue]];
        self.jian=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"jian"]] integerValue]];
        self.ishot=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"ishot"]] integerValue]];
        self.copper=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"copper"]] integerValue]];
        self.status=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"status"]] integerValue]];
        self.saledcount=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"saledcount"]] integerValue]];
        self.usestart=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"usestart"]] integerValue]];
        self.useend=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"useend"]] integerValue]];
        self.createtime=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"createtime"]] integerValue]];
        
        self.title=[self setisElequltoString:[dic objectForKey:@"title"]];
        self.imgurl=[self setisElequltoString:[dic objectForKey:@"imgUrl"]];
    }
    return self;
}

-(void)setWithMyHouseDic:(NSDictionary *)dic{
    self.juanid=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"id"]] integerValue]];
    self.ishot=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"type"]] integerValue]];
    self.status=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"state"]] integerValue]];
    self.title=[self setisElequltoString:[dic objectForKey:@"strDown"]];
    self.imgurl=[self setisElequltoString:[dic objectForKey:@"strImgUrl"]];
    //self.tagstr=[self setisElequltoString:[dic objectForKey:@"strUp"]];
}


-(NSString *)setisElequltoString:(id)str{
    if (![str isKindOfClass:[NSString class]]) {
        return [NSString stringWithFormat:@"%@",str];
    }
    if ((NSNull *)str ==[NSNull null]) {
        return nil;
    }else{
        return  [str isEqualToString:@"<null>"]||[str isEqualToString:@"<NULL>"]||[str isEqualToString:@""]||[str isEqualToString:@"null"]||[str isEqualToString:@"NSNULL"] ? nil : str;
    }
    
}

@end
