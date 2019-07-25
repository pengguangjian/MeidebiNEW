//
//  Articlel.m
//  Meidebi
//
//  Created by mdb-admin on 16/5/4.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "Articlel.h"

@implementation Articlel

-(void)setwithDic:(NSDictionary *)dic{
    self.category=[NSString stringWithFormat:@"%@",[dic objectForKey:@"category"]];
    self.createtime=[NSString stringWithFormat:@"%@",[dic objectForKey:@"createtime"]];
    self.dealer=[NSString stringWithFormat:@"%@",[dic objectForKey:@"dealer"]];
    self.descrip=[NSString stringWithFormat:@"%@",[dic objectForKey:@"description"]];
    self.fcategory=[NSString stringWithFormat:@"%@",[dic objectForKey:@"fcategory"]];
    self.artid=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    self.isabroad=[NSString stringWithFormat:@"%@",[dic objectForKey:@"isabroad"]];
    self.linktype=[NSString stringWithFormat:@"%@",[dic objectForKey:@"linktype"]];
    self.remoteimage=[NSString stringWithFormat:@"%@",[dic objectForKey:@"remoteimage"]];
    self.siteid=[NSString stringWithFormat:@"%@",[dic objectForKey:@"siteid"]];
    self.timeout=[NSString stringWithFormat:@"%@",[dic objectForKey:@"timeout"]];
    self.title=[NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
    self.url=[NSString stringWithFormat:@"%@",[dic objectForKey:@"url"]];
    self.userid=[NSString stringWithFormat:@"%@",[dic objectForKey:@"userid"]];
    self.weight=[NSString stringWithFormat:@"%@",[dic objectForKey:@"weight"]];
    self.prodescription = [NSString stringWithFormat:@"%@",[dic objectForKey:@"prodescription"]];
    self.categoryname=[NSString stringWithFormat:@"%@",[dic objectForKey:@"categoryname"]];
    self.nickname=[NSString stringWithFormat:@"%@",[dic objectForKey:@"nickname"]];
    self.postage=[NSString stringWithFormat:@"%@",[dic objectForKey:@"postage"]];
    self.price=[NSString stringWithFormat:@"%@",[dic objectForKey:@"price"]];
    self.proprice=[NSString stringWithFormat:@"%@",[dic objectForKey:@"proprice"]];
    self.sitename=[NSString stringWithFormat:@"%@",[dic objectForKey:@"sitename"]];
    self.commentcount=[NSString stringWithFormat:@"%@",[dic objectForKey:@"commentcount"]];
    self.votesp=[NSString stringWithFormat:@"%@",[dic objectForKey:@"votesp"]];
    self.tljurl = [NSString nullToString:[dic objectForKey:@"tljurl"]];
    
}

@end
