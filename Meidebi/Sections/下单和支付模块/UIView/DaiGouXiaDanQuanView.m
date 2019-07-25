//
//  DaiGouXiaDanQuanView.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/12/25.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "DaiGouXiaDanQuanView.h"
#import "MDB_UserDefault.h"
#import "DaiGouXiaDanQuanTableViewCell.h"

@interface DaiGouXiaDanQuanView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    UIView *viewback;
    UITableView *tabview;
}

@end

@implementation DaiGouXiaDanQuanView

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
         
        UITapGestureRecognizer *tapview = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismisAction)];
        [tapview setDelegate:self];
        [self addGestureRecognizer:tapview];
        
        [self setBackgroundColor:RGBAlpha(0, 0, 0, 0.4)];
        
        
        float ftopheith =  kStatusBarHeight+44;
        float fother = 190;
        if(ftopheith<66)
        {
            fother = 160;
        }

        
        viewback = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height, self.size.width, fother)];
        [self addSubview:viewback];
        [viewback setBackgroundColor:RGB(245, 245, 245)];
        
        
        UILabel *lbname =[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 150, 20)];
        [lbname setTextAlignment:NSTextAlignmentLeft];
        [lbname setTextColor:RGB(153, 153, 153)];
        [lbname setText:@"商品券"];
        [lbname setFont:[UIFont systemFontOfSize:13]];
        [viewback addSubview:lbname];
        
        tabview = [[UITableView alloc] initWithFrame:CGRectMake(viewback.width/2.0-40, -(viewback.width/2.0-90), 100, viewback.width)];
        [tabview setDelegate:self];
        [tabview setDataSource:self];
        [viewback addSubview:tabview];
        tabview.transform=CGAffineTransformMakeRotation(-M_PI / 2);
        tabview.showsVerticalScrollIndicator=NO;
        [tabview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [tabview setBackgroundColor:RGB(245, 245, 245)];
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    
}

-(void)showQuan
{
    int i = 0;
    for(MyGoodsCouponModel *model in _arrdata)
    {
        if(i==_inomoselect)
        {
            model.isselect = YES;
        }
        else
        {
           model.isselect = NO;
        }
        
        i++;
    }
    
    float ftopheith =  kStatusBarHeight+44;
    float fother = 30;
    if(ftopheith<66)
    {
        fother = 0;
    }
    [UIView animateWithDuration:0.3 animations:^{
        [viewback setBottom:self.height+fother];
    }];
    [tabview reloadData];
}

-(void)dismisAction
{
    [UIView animateWithDuration:0.3 animations:^{
        [viewback setTop:self.height];
        
    } completion:^(BOOL finished) {
        [viewback removeFromSuperview];
        [self removeFromSuperview];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrdata.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *strcell = @"DaiGouXiaDanQuanTableViewCell";
    DaiGouXiaDanQuanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strcell];
    if(!cell)
    {
        cell = [[DaiGouXiaDanQuanTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strcell];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:RGB(245, 245, 245)];
    
    cell.model = _arrdata[indexPath.row];
    if(indexPath.row==0)
    {
        cell.ishigh = YES;
    }
    else
    {
        cell.ishigh = NO;
    }
    cell.strgoodsprice = _strgoodsprice;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.width*0.75<290)
    {
        return 290;
    }
    return self.width*0.75;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyGoodsCouponModel *model = _arrdata[indexPath.row];
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    if(model.usecondition.floatValue<=_strgoodsprice.floatValue && model.denomination.floatValue<= _strgoodsprice.floatValue && a<model.use_endtime.floatValue)
    {
        if(model.isselect)
        {
            model.isselect = NO;
            
            [self.delegate selectitem:nil andnum:-1];
        }
        else
        {
            model.isselect = YES;
            
            [self.delegate selectitem:model andnum:indexPath.row];
        }
        
        [tabview reloadData];
        [self dismisAction];
    }
    else
    {
        
    }
    
    
    
    
    
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    
    if(![touch.view isKindOfClass:[self class]])
    {
        return NO;
    }
 
    return YES;
}
@end
