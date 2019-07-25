//
//  ProductInfoSubjectsViewModel.m
//  Meidebi
//
//  Created by mdb-admin on 16/4/28.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "ProductInfoSubjectsViewModel.h"
#import "Commodity.h"
#import "MDB_UserDefault.h"
#import <MJExtension/MJExtension.h>
@interface ProductInfoSubjectsViewModel ()

@property (nonatomic, strong) NSString *commodityName;
@property (nonatomic, strong) NSAttributedString *commodityPirce;
@property (nonatomic, strong) NSString *commodityPrimeCost;
@property (nonatomic, strong) NSString *commoditySupply;
@property (nonatomic, strong) NSString *commodityTransfer;
@property (nonatomic, strong) NSString *commoditySourceArea;
@property (nonatomic, strong) NSString *commodityPostage; // 本土运费、货物运费
@property (nonatomic, strong) NSString *commodityTax;
@property (nonatomic, strong) NSString *commodityZan;
@property (nonatomic, strong) NSString *commodityShou;
@property (nonatomic, strong) NSString *commodityCom;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *createtime;
@property (nonatomic, strong) NSString *commodityImageLink;
@property (nonatomic, strong) NSString *iconImageLink;
@property (nonatomic, strong) NSString *navTitle;
@property (nonatomic, strong) NSString *webDescription;
@property (nonatomic, strong) NSString *outurl;
@property (nonatomic, strong) NSString *redirectUrl;
@property (nonatomic, strong) NSString *linkType;
@property (nonatomic, strong) NSString *otherprice;
@property (nonatomic, strong) NSString *totalmoney_dec;
@property (nonatomic, strong) NSString *courselink;
@property (nonatomic, strong) NSString *tmallid;
@property (nonatomic, strong) NSString *waresid;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *activeImageLink;
@property (nonatomic, strong) NSString *activeLink;
@property (nonatomic, strong) NSString *tmalltWoinOneUrlLink;
@property (nonatomic, strong) NSString *appactiveopen;
@property (nonatomic, assign) BOOL isEnshrine;
@property (nonatomic, assign) BOOL isDirect;
@property (nonatomic, assign) BOOL isTianMao;
@property (nonatomic, assign) BOOL isOpenActive;
@property (nonatomic, assign) DetailViewType viewType;
@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, strong) NSArray *relateShares;
@property (nonatomic, strong) NSArray *flags;
@property (nonatomic, strong) NSString *commentSum;
@property (nonatomic, strong) NSString *userShareSum;
@property (nonatomic, assign) BOOL isFollow;
@property (nonatomic, strong) NSString *privilegeType;
@property (nonatomic, strong) NSString *prodescription;
@property (nonatomic, strong) NSString *wantbuy;
@property (nonatomic, strong) NSString *alreadybuy;
@property (nonatomic, strong) NSString *share_num;
@property (nonatomic, strong) NSString *showdan_num;
@property (nonatomic, strong) NSString *user_level;
@property (nonatomic, strong) NSString *rewardCount;
@property (nonatomic, strong) NSArray *rewardUsers;
@property (nonatomic, strong) NSArray *hotshowdans;

@end

@implementation ProductInfoSubjectsViewModel


+ (ProductInfoSubjectsViewModel *)viewModelWithSubject:(NSDictionary *)subject{
    ProductInfoSubjectsViewModel *viewModel = [[ProductInfoSubjectsViewModel alloc] init];
    [viewModel viewModelWithSubjects:subject];
    return viewModel;
}

+ (ProductInfoSubjectsViewModel *)viewModelInitializeWithSubject:(id)subject{
    ProductInfoSubjectsViewModel *viewModel = [[ProductInfoSubjectsViewModel alloc] init];
    NSDictionary *objectDict = [subject mj_keyValues];
    [viewModel viewModelWithSubjects:objectDict];
    return viewModel;
}

- (void)viewModelWithSubjects:(NSDictionary *)subject{
    NSDictionary *dicsupers = subject;
    _comments = subject[@"comments"];
    
    if([[subject objectForKey:@"historyPrice"] isKindOfClass:[NSArray class]])
    {
        _historyPrice = [subject objectForKey:@"historyPrice"];
    }
    
    _relateShares = subject[@"relateShare"];
    NSDictionary *dicreward = [subject objectForKey:@"reward"];
    if ([[dicreward objectForKey:@"users"] isKindOfClass:[NSArray class]]) {
        _rewardUsers = subject[@"reward"][@"users"];
    }
    _rewardCount = [NSString nullToString:[dicreward objectForKey:@"count"]];
    _hotshowdans = subject[@"hotshowdan"];
    NSDictionary *shareDict = subject[@"share"];
    if (shareDict) {
        subject = shareDict;
    }
    NSMutableArray *tags = [NSMutableArray array];
    for (NSString *tag in subject[@"tags"]) {
        if (![[NSString nullToString:tag] isEqualToString:@""]) {
            [tags addObject:@{@"name":[NSString nullToString:tag],
                              @"type":@"1"}];
        }
    }
    if (![[NSString nullToString:subject[@"sitename"]] isEqualToString:@""]) {
        [tags addObject:@{@"name":[NSString stringWithFormat:@"商城：%@",[NSString nullToString:subject[@"sitename"]]],
                          @"id":[NSString nullToString:subject[@"siteid"]],
                          @"type":@"2"}];
    }
    if (![[NSString nullToString:subject[@"categoryname"]] isEqualToString:@""]) {
        [tags addObject:@{@"name":[NSString stringWithFormat:@"分类：%@",[NSString nullToString:subject[@"categoryname"]]],
                          @"id":[NSString nullToString:subject[@"category"]],
                          @"type":@"3"}];
    }
    _flags = tags.mutableCopy;
    _commentSum = [NSString stringWithFormat:@"%@",subject[@"commentcount"]];
    NSString *privilege = [NSString nullToString:subject[@"type"]];
    if ([privilege isEqualToString:@"1"]) {
        _privilegeType = @"购买直降";
    }else if ([privilege isEqualToString:@"2"]){
        _privilegeType = @"满额优惠";
    }else if ([privilege isEqualToString:@"3"]){
        _privilegeType = @"领券用码";
    }else if ([privilege isEqualToString:@"4"]){
        _privilegeType = @"联合促销";
    }else{
        _privilegeType = @"";
    }
    _prodescription = [NSString nullToString:subject[@"prodescription"]];
    NSString *pricesStr = [NSString nullToString:subject[@"price"]];
    if ([[NSString stringWithFormat:@"%@",subject[@"price"]] rangeOfString:@"￥"].location == NSNotFound) {
        pricesStr = [NSString stringWithFormat:@"%.2f",[pricesStr floatValue]];
        pricesStr = [NSString stringWithFormat:@"￥%@",pricesStr];
    }
    
    if ([MDB_UserDefault getIsLogin]) {
        if (subject[@"isfav"] && subject[@"isfav"]==[NSNumber numberWithInt:1]) {
            _isEnshrine = YES;
        }
    }
    NSMutableAttributedString *outsideAttributeStr = [[NSMutableAttributedString alloc] initWithString:pricesStr];
    [outsideAttributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:21] range:NSMakeRange(0, pricesStr.length)];
    _commodityPirce = [outsideAttributeStr mutableCopy];
    _commodityPrimeCost = [NSString nullToString:subject[@"orginprice"]];
    _nickname = [NSString nullToString:subject[@"nickname"]];
    
    if ([[NSString stringWithFormat:@"%@",subject[@"createtime"]] rangeOfString:@":"].location == NSNotFound) {
        _createtime =[MDB_UserDefault strTimefromDatas:[NSDate dateWithTimeIntervalSince1970:[subject[@"createtime"] integerValue]] dataFormat:@"yyyy-MM-dd"];
    } else {
        _createtime = [NSString nullToString:subject[@"createtime"]];
    }
    
    _userShareSum = [NSString nullToString:[NSString stringWithFormat:@"最近发布爆料%@篇",[[NSString nullToString:subject[@"share_num"]] isEqualToString:@""]? @"0":[NSString nullToString:subject[@"share_num"]]]];
    if ([[NSString nullToString:[NSString stringWithFormat:@"%@",subject[@"is_follow"]]] isEqualToString:@"1"]) {
        _isFollow = YES;
    }else{
        _isFollow = NO;
    }
    _waresid = [NSString nullToString:[NSString stringWithFormat:@"%@",subject[@"id"]]];
    _userID = [NSString nullToString:[NSString stringWithFormat:@"%@",subject[@"userid"]]];
    _courselink = [NSString nullToString:subject[@"haitaoarticle"]];
    _totalmoney_dec = [NSString nullToString:subject[@"totalmoney_dec"]];
    _otherprice = [NSString nullToString:subject[@"otherprice"]];
    _commodityCom = [NSString nullToString:[NSString stringWithFormat:@"%@",subject[@"commentcount"]]];
    _commodityZan = [NSString nullToString:[NSString stringWithFormat:@"%@",subject[@"votesp"]]];
    _commodityShou = [[NSString nullToString:subject[@"favnum"]] isEqualToString:@""]?@"0":[NSString nullToString:subject[@"favnum"]];
    _commodityImageLink = [NSString nullToString:subject[@"image"]];
    _commoditySupply = [NSString nullToString:subject[@"sitename"]];
    _commoditySupplyid = [NSString nullToString:subject[@"siteid"]];
    _commodityName = [NSString  nullToString:subject[@"title"]];
    _iconImageLink = [NSString nullToString:subject[@"photo"]];
    _webDescription = [NSString nullToString:subject[@"description"]];
//    _webDescription = [NSString stringWithFormat:@"%@",[_webDescription stringByReplacingOccurrencesOfString:@"inkdesc" withString:@"inkdesc_v2"]];
    _outurl = [NSString nullToString:subject[@"outurl"]];
    _redirectUrl = [NSString nullToString:subject[@"redirecturl"]];
    _tmallid = [NSString nullToString:subject[@"tmallid"]];
    _activeLink = [NSString nullToString:subject[@"appactivelink"]];
    _activeImageLink = [NSString nullToString:subject[@"appactiveimage"]];
    _tmalltWoinOneUrlLink = [NSString nullToString:subject[@"tmalltwoinoneurl"]];
    _appactiveopen = [NSString nullToString:subject[@"appactiveopen"]];
    _share_num = [NSString nullToString:subject[@"share_num"]];
    _showdan_num = [NSString nullToString:subject[@"showdan_num"]];
    _user_level = [NSString nullToString:subject[@"user_level"]];
    _free_freight_url = [NSString nullToString:subject[@"free_freight_url"]];
    _outopen = [NSString nullToString:subject[@"outopen"]];
    _site_can_order = [NSString nullToString:subject[@"site_can_order"]];
    _wishBtn = [NSString nullToString:subject[@"wishBtn"]];
    
    _is_attention =  [NSString nullToString:subject[@"is_attention"]];;
    
    _tljurl = [NSString nullToString:subject[@"tljurl"]];
    
    if ([@"" isEqualToString:[NSString nullToString:subject[@"wantbuy"]]]) {
        _wantbuy = @"0";
    }else{
        _wantbuy = [NSString nullToString:subject[@"wantbuy"]];
    }
    if ([@"" isEqualToString:[NSString nullToString:subject[@"alreadybuy"]]]) {
        _alreadybuy = @"0";
    }else{
        _alreadybuy = [NSString nullToString:subject[@"alreadybuy"]];
    }
    if (![_activeImageLink isEqualToString:@""] && ![_activeLink isEqualToString:@""]) {
        _isOpenActive = YES;
    }else{
        _isOpenActive = NO;
    }
    if ([[NSString nullToString:subject[@"freight"]] isEqualToString:@"$0.00"]) {
        _isDirect = NO;
    }else{
        _isDirect = YES;
    }
    _linkType=[NSString nullToString:subject[@"linktype"]];//1、单品；2、活动；3、优惠卷活动
    NSString *isabroad=[NSString nullToString:subject[@"isabroad"]];
    BOOL isChinaSingle=[_linkType isEqualToString:@"1"]&&[isabroad isEqualToString:@"0"];//国内单品
    BOOL isAbroadSingle=[_linkType isEqualToString:@"1"]&&[isabroad isEqualToString:@"1"];//海淘单品
    BOOL isActivity=[_linkType isEqualToString:@"2"];    //活动
    
    if (([_linkType isEqualToString:@"1"] && [[NSString nullToString:subject[@"siteid"]] isEqualToString:@"64"]) && ![_tmallid isEqualToString:@""]) {
        _isTianMao = YES;
    }else{
        _isTianMao = NO;
    }
    _redirecturl = [NSString nullToString:subject[@"redirecturl"]];
    if ([[NSString nullToString:subject[@"siteid"]] isEqualToString:@"2"] && _redirecturl.length>6) {
        _isJD = YES;
    }else{
        _isJD = NO;
    }
    
    
    
    if ([_linkType isEqualToString:@"1"]) {
        if (isChinaSingle) {
            _navTitle=@"国内单品";
            _viewType = DetailViewTypeInland;
            //有货地区:
            if ([subject[@"whorsubsites"] isKindOfClass:[NSArray class]]) {
                NSArray *stationAry=[[NSArray alloc] initWithArray:subject[@"whorsubsites"]];
                __block NSString *str_station=@"";
                [stationAry enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    str_station= [str_station stringByAppendingString:[NSString stringWithFormat:@"，%@",obj]];
                }];
                if ([str_station length]>1) {
                    str_station=[str_station substringFromIndex:1];
                }else{
                    str_station=@"全国";
                }
                _commoditySourceArea=[NSString stringWithFormat:@"有货地区：%@",str_station];
            }else{
                _commoditySourceArea=@"有货地区：全国";
            }
            NSMutableString *tempStr = [[NSString nullToString:subject[@"postage"]] mutableCopy];
            if (tempStr.length ==1) {
                tempStr = [[tempStr stringByAppendingString:@" 0"] mutableCopy];
            }
            _commodityPostage = [NSString stringWithFormat:@"运货费用：%@",tempStr];
        }else if(isAbroadSingle){
            _navTitle=@"海淘单品";
            _viewType = DetailViewTypeOverseas;
            //转运公司
            if (![[NSString nullToString:subject[@"isdirectmail"]] isEqualToString:@"1"] && [subject[@"transitcompany"] isKindOfClass:[NSDictionary class]]) {
                //                _commodityTransfer = [NSString nullToString:subject[@"transitcompany"][@"name"]];
                _commodityTransfer = @"";
            }
            //人民币
            NSString *priceal=[NSString nullToString:subject[@"price"]];
            if ([[NSString stringWithFormat:@"%@",priceal] rangeOfString:@"￥"].location == NSNotFound) {
                priceal = [NSString stringWithFormat:@"%.2f",[priceal floatValue]];
                priceal = [NSString stringWithFormat:@"￥%@",priceal];
            }
            //$
            NSString *priceal2=[NSString stringWithFormat:@"（%@）",[NSString nullToString:[subject[@"aprice"] floatValue]<[subject[@"aproprice"] floatValue]?subject[@"aprice"]:subject[@"aproprice"]]];
            if ([priceal2 isEqualToString:@"（）"]) {
                priceal2 = @"";
            }
            NSString *priceStr = [NSString stringWithFormat:@"%@%@",priceal,priceal2];
            
            
            NSMutableAttributedString *outsideAttributeStr = [[NSMutableAttributedString alloc] initWithString:priceStr];
            [outsideAttributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:21] range:NSMakeRange(0, priceal.length)];
            [outsideAttributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(priceal.length, priceal2.length)];
            _commodityPirce = [outsideAttributeStr mutableCopy];
            
            
            if ([subject[@"aorginprice"] isKindOfClass:[NSString class]]) {
                if (![subject[@"aorginprice"] isEqualToString:@""]) {
                    _commodityPrimeCost = [NSString nullToString:subject[@"aorginprice"]];
                }
            }
        }
    }else if (isActivity){
        _navTitle=@"活动";
        _viewType = DetailViewTypeActivity;
        NSString *strStar= [MDB_UserDefault strTimefromData:[subject[@"starttime"] integerValue] dataFormat:nil];
        NSString *strEnd=[MDB_UserDefault strTimefromData:[subject[@"endtime"] integerValue] dataFormat:nil];
        _activityDate = [NSString stringWithFormat:@"活动时间：%@至%@",strStar,strEnd];
        NSString *prodescriptionStr = [NSString nullToString:subject[@"prodescription"]];
        NSMutableAttributedString *outsideAttributeStr = [[NSMutableAttributedString alloc] initWithString:prodescriptionStr];
        [outsideAttributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:21] range:NSMakeRange(0, prodescriptionStr.length)];
        _commodityPirce = [outsideAttributeStr mutableCopy];
    }else if([_linkType isEqualToString:@"3"]){
        _navTitle=@"优惠券活动";
        _viewType = DetailViewTypeDiscount;
    }
    
    ////代购数据
    if([[subject objectForKey:@"daigou"] isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *daigou = [subject objectForKey:@"daigou"];
        _daigouModel = [ProductInfoSubjectsDaiGouViewModel viewModelWithSubject:daigou];
        
    }
    
    ///关联阅读数据
    if([[dicsupers objectForKey:@"articles"] isKindOfClass:[NSArray class]])
    {
        NSMutableArray *arrarticles = [NSMutableArray new];
        NSArray *arr = [dicsupers objectForKey:@"articles"];
        for(NSDictionary *dic in arr)
        {
            [arrarticles addObject:[ProductInfoSubjectsGuanLianYueDuViewModel viewModelWithSubject:dic]];
        }
        _articles = arrarticles;
        
    }
    
}
@end

///代购或拼单数据
@implementation ProductInfoSubjectsDaiGouViewModel
+ (ProductInfoSubjectsDaiGouViewModel *)viewModelWithSubject:(NSDictionary *)subject
{
    ProductInfoSubjectsDaiGouViewModel *viewModel = [[ProductInfoSubjectsDaiGouViewModel alloc] init];
    [viewModel viewModelWithSubjects:subject];
    return viewModel;
    
}
- (void)viewModelWithSubjects:(NSDictionary *)subject
{
    
    _daigoutype = [NSString nullToString:subject[@"daigoutype"]];
    _isspiderorder = [NSString nullToString:subject[@"isspiderorder"]];
    _daiendtime = [NSString nullToString:subject[@"endtime"]];
    _goods_id = [NSString nullToString:subject[@"goods_id"]];
    _pindannum = [NSString nullToString:subject[@"pindannum"]];
    _price = [NSString nullToString:subject[@"price"]];
    _purchased_nums = [NSString nullToString:subject[@"purchased_nums"]];
    _isend = [NSString nullToString:subject[@"isend"]];
    _status = [NSString nullToString:subject[@"status"]];
    
    _directmailmoney = [NSString nullToString:subject[@"directmailmoney"]];
    _hpostage = [NSString nullToString:subject[@"hpostage"]];
    _transfermoney = [NSString nullToString:subject[@"transfermoney"]];
    _tariff = [NSString nullToString:subject[@"tariff"]];
    
    _isspotgoods = [NSString nullToString:subject[@"isspotgoods"]];
    if([subject[@"zhixia"] isKindOfClass:[NSArray class]])
    {
        _zhixia = subject[@"zhixia"];
    }
    
    if([subject[@"pindan"] isKindOfClass:[NSArray class]])
    {
        NSArray *arr = subject[@"pindan"];
        NSMutableArray *arrpindan = [NSMutableArray new];
        for(NSDictionary *dic in arr)
        {
            [arrpindan addObject:[ProductInfoSubjectsDaiGouPinTuanViewModel viewModelWithSubject:dic]];
        }
        _pindan = arrpindan;
    }
    
    
}

@end

///代购或拼单数据
@implementation ProductInfoSubjectsDaiGouPinTuanViewModel
+ (ProductInfoSubjectsDaiGouPinTuanViewModel *)viewModelWithSubject:(NSDictionary *)subject
{
    ProductInfoSubjectsDaiGouPinTuanViewModel *viewModel = [[ProductInfoSubjectsDaiGouPinTuanViewModel alloc] init];
    [viewModel viewModelWithSubjects:subject];
    return viewModel;
    
}
- (void)viewModelWithSubjects:(NSDictionary *)subject
{
    
    _did = [NSString nullToString:subject[@"id"]];
    _image = [NSString nullToString:subject[@"image"]];
    _nickname = [NSString nullToString:subject[@"nickname"]];
    _remain_pindannum = [NSString nullToString:subject[@"remain_pindannum"]];
    _userid = [NSString nullToString:subject[@"userid"]];
    
}


@end

///关联阅读数据
@implementation ProductInfoSubjectsGuanLianYueDuViewModel
+ (ProductInfoSubjectsGuanLianYueDuViewModel *)viewModelWithSubject:(NSDictionary *)subject
{
    ProductInfoSubjectsGuanLianYueDuViewModel *viewModel = [[ProductInfoSubjectsGuanLianYueDuViewModel alloc] init];
    [viewModel viewModelWithSubjects:subject];
    return viewModel;
    
}
- (void)viewModelWithSubjects:(NSDictionary *)subject
{
    _did = [NSString nullToString:subject[@"id"]];
    
    _title = [NSString nullToString:subject[@"title"]];
    
    _createtime = [NSString nullToString:subject[@"createtime"]];
    
    //    _content =  [NSString stringWithFormat:@"%@%@",URL_HR,[NSString nullToString:subject[@"content"]]];
    _content =  [NSString nullToString:subject[@"content"]];
}
@end
