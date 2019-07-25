//
//  myBorkeNews.m
//  Meidebi
//
//  Created by 杜非 on 15/5/18.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import "myBorkeNews.h"

@implementation myBorkeNews

-(void)objectWithDictionary:(NSDictionary *)dic{
    self.artid=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"id"]] integerValue]];
    
    self.abroadhot=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"abroadhot"]] integerValue]];
    
    self.apilink_id=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"apilink_id"]] integerValue]];
    
    self.category=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"category"]]integerValue]];
    
    self.categoryname=[self setisElequltoString:[dic objectForKey:@"categoryname"]];
    
    self.changetime=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"changetime"]] integerValue]];
    
    self.changeuser=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"changeuser"]] integerValue]];
    
    self.commentcount=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"commentcount"]] integerValue]];
    
    self.contrysitename=[self setisElequltoString:[dic objectForKey:@"contrysitename"]];
    
    self.cpsurl=[self setisElequltoString:[dic objectForKey:@"cpsurl"]];
    
    self.createtime=[NSDate dateWithTimeIntervalSince1970:[[self setisElequltoString:[dic objectForKey:@"createtime"]] integerValue]];
    
    self.descriptions=[self setisElequltoString:[dic objectForKey:@"description"]];
    
    self.directtariff=[self setisElequltoString:[dic objectForKey:@"directtariff"]];
    
    self.editforbiden=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"editforbiden"]] integerValue]];
    
    self.fcategory=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"fcategory"]] integerValue]];
    
    self.freight=[self setisElequltoString:[dic objectForKey:@"freight"]];
    
    self.guoneihot=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"guoneihot"]] integerValue]];
    
    self.hit=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"hit"]] integerValue]];
    
    self.image=[self setisElequltoString:[dic objectForKey:@"image"]];
    
    self.isabroad=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"isabroad"]] integerValue]];
    
    self.isamazonz=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"isamazonz"]] integerValue]];
    
    self.isdirectmail=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"isdirectmail"]] integerValue]];
    
    self.ishot=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"ishot"]] integerValue]];
    self.isagthot=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"isagthot"]] integerValue]];
    self.isorder=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"isorder"]] integerValue]];
    
    self.issendemail=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"issendemail"]] integerValue]];
    
    self.jibaoguoqi=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"jibaoguoqi"]] integerValue]];
    
    self.linktype=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"linktype"]] integerValue]];
    
    self.nickname=[self setisElequltoString:[dic objectForKey:@"nickname"]];
    
    self.notchecked=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"notchecked"]] integerValue]];
    
    self.orginurl=[self setisElequltoString:[dic objectForKey:@"orginurl"]];
    
    self.perfect=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"perfect"]] integerValue]];
    
    self.postage=[NSNumber numberWithFloat:[[self setisElequltoString:[dic objectForKey:@"postage"]] floatValue]];
    
    self.price=[NSNumber numberWithFloat:[[self setisElequltoString:[dic objectForKey:@"price"]] floatValue]];
    
    self.procurenum=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"procurenum"]] integerValue]];
    
    self.redirecturl=[self setisElequltoString:[dic objectForKey:@"redirecturl"]];
    
    self.remoteimage=[self setisElequltoString:[dic objectForKey:@"remoteimage"]];
    self.prodescription=[self setisElequltoString:[dic objectForKey:@"prodescription"]];
    
    
    self.setahottime=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"setahottime"]] integerValue]];
    
    self.setghottime=[NSDate dateWithTimeIntervalSince1970:[[self setisElequltoString:[dic objectForKey:@"setghottime"]] integerValue]];
    
    self.sethottime=[NSDate dateWithTimeIntervalSince1970:[[self setisElequltoString:[dic objectForKey:@"sethottime"]] integerValue]];
    
    self.setthottime=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"setthottime"]] integerValue]];
    
    self.showcount=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"showcount"]] integerValue]];
    
    self.siteid=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"siteid"]] integerValue]];
    
    self.sitename=[self setisElequltoString:[dic objectForKey:@"sitename"]];
    
    self.statustext=[self setisElequltoString:[dic objectForKey:@"statustext"]];
    
    self.subsiteorwh=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"subsiteorwh"]] integerValue]];
    
    self.tagstr=[self setisElequltoString:[dic objectForKey:@"tagstr"]];
    
    self.timeout=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"timeout"]] integerValue]];
    
    self.title=[self setisElequltoString:[dic objectForKey:@"title"]];
    
    self.tmallhot=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"tmallhot"]] integerValue]];
    
    self.votesp=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"votesp"]] integerValue]];
    
    self.userid=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"userid"]] integerValue]];
    
    self.votesm=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"votesm"]] integerValue]];
    
    self.proprice=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"proprice"]] floatValue]];
    
    
}
-(void)setWithMyHouseDic:(NSDictionary *)dic{
    self.artid=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"id"]] integerValue]];
    self.ishot=[NSNumber numberWithInteger:[[self setisElequltoString:[dic objectForKey:@"iZanNum"]] integerValue]];
    self.statustext=[self setisElequltoString:[dic objectForKey:@"statustext"]];
    self.sitename=[self setisElequltoString:[dic objectForKey:@"strDown"]];
    self.image=[self setisElequltoString:[dic objectForKey:@"strImgUrl"]];
    self.tagstr=[self setisElequltoString:[dic objectForKey:@"strUp"]];
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
