//
//  DaiGouXiaDanGoodsView.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/9/30.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "DaiGouXiaDanGoodsView.h"

#import "DaiGouXiaDanGoodsTableViewCell.h"


@interface DaiGouXiaDanGoodsView ()<UITableViewDelegate,UITableViewDataSource,DaiGouXiaDanGoodsTableViewCellDelegate>
{
    
    UITableView *tabview;
    
    
}
@end

@implementation DaiGouXiaDanGoodsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        tabview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        [tabview setDelegate:self];
        [tabview setDataSource:self];
        [tabview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [tabview setScrollEnabled:NO];
        [self addSubview:tabview];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    
    if(_igoodsnomonum>1)
    {
        for(OrderShopInfoModel *model in _arrgoods)
        {
            for(OrderGoodsInfoModel *model1 in model.arrgoods)
            {
                model1.iselectnumber = _igoodsnomonum;
               
            }
            
        }
    }
//    else
//    {
//        for(OrderShopInfoModel *model in _arrgoods)
//        {
//            //            share_id
//            OrderGoodsInfoModel *modeltemp;
//            for(OrderGoodsInfoModel *model1 in model.arrgoods)
//            {
//                if(modeltemp==nil)
//                {
//                    modeltemp = model1;
//                }
//                else
//                {
//                    if([modeltemp.share_id isEqualToString:model1.share_id])
//                    {
//                        modeltemp.onelimit = @"0";
//                        
//                    }
//                    modeltemp = model1;
//                }
//            }
//            
//        }
//        
//    }
    [tabview reloadData];
}


#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _arrgoods.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    OrderShopInfoModel *model = _arrgoods[section];
    return model.arrgoods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strcell = @"DaiGouXiaDanGoodsTableViewCell";
    DaiGouXiaDanGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strcell];
    if(!cell)
    {
        cell = [[DaiGouXiaDanGoodsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strcell];
        
    }
    [cell setDelegate:self];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.iseditnumber = _iseditnumber;
    OrderShopInfoModel *model = _arrgoods[indexPath.section];
    
    cell.model = model.arrgoods[indexPath.row];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderShopInfoModel *model = _arrgoods[indexPath.section];
    OrderGoodsInfoModel *model1 = model.arrgoods[indexPath.row];
    if(model1.onelimit.integerValue>0)
    {
        return 178;
    }
    else
    {
        return 145;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 50)];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    float fleft = 10;
    OrderShopInfoModel *model = _arrgoods[section];
    UILabel *lbzhiyou = [[UILabel alloc] initWithFrame:CGRectMake(10, 17, 45, 17)];
    [lbzhiyou setText:@"直邮"];
    [lbzhiyou setTextColor:RGB(230,56,47)];
    [lbzhiyou setTextAlignment:NSTextAlignmentCenter];
    [lbzhiyou setFont:[UIFont systemFontOfSize:13]];
    [lbzhiyou.layer setMasksToBounds:YES];
    [lbzhiyou.layer setCornerRadius:2];
    [lbzhiyou.layer setBorderColor:RGB(230,56,47).CGColor];
    [lbzhiyou.layer setBorderWidth:1];
    [lbzhiyou sizeToFit];
    [lbzhiyou setHeight:17];
    [lbzhiyou setWidth:lbzhiyou.width+6];
    [view addSubview:lbzhiyou];
    //    if([model.transfertype intValue] == 2)
    //    {
    //        fleft = lbzhiyou.right+10;
    //        [lbzhiyou setHidden:NO];
    //    }
    //    else
    //    {
    //        fleft = 10;
    //        [lbzhiyou setHidden:YES];
    //    }
    
    fleft = 10;
    [lbzhiyou setHidden:YES];
    
    UILabel *lbshop = [[UILabel alloc] initWithFrame:CGRectMake(fleft, lbzhiyou.top, view.width-fleft-10, lbzhiyou.height)];
    [lbshop setText:model.name];
    [lbshop setTextColor:RadMenuColor];
    [lbshop setTextAlignment:NSTextAlignmentLeft];
    [lbshop setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:lbshop];
    
    UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(0, lbshop.bottom+17, view.width, 1)];
    [viewline setBackgroundColor:RGB(231,231,231)];
    [view addSubview:viewline];
    
    
    return view;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 10)];
    [view setBackgroundColor:RGB(241, 241, 241)];
    
    return view;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}


-(void)DaiGouXiaDanGoodsNumChange
{
    [self.delegate DaiGouXiaDanGoodsNumChange];
}


@end
