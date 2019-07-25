//
//  RemarkAtUserView.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/5/23.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "RemarkAtUserView.h"

@interface RemarkAtUserView ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tabview;
    
    NSMutableArray *arrdata;
}

@end

@implementation RemarkAtUserView

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
        [tabview.layer setBorderColor:RGB(245, 245, 245).CGColor];
        [tabview.layer setBorderWidth:1];
        [self addSubview:tabview];
        
    }
    return self;
}

-(void)AtUserValueLoad:(NSMutableArray *)arr
{
    arrdata = arr;
    
    if(arrdata.count>5)
    {
        [self setHeight:175];
        
    }
    else
    {
        [self setHeight:35*arrdata.count];
    }
    [tabview setHeight:self.height];
    [tabview reloadData];
//    tabview.layer.shadowColor = [UIColor blackColor].CGColor;
//    tabview.layer.shadowOpacity = 0.8f;
//    tabview.layer.shadowRadius = 4.f;
//    [tabview.layer setCornerRadius:4];
//    tabview.layer.shadowOffset = CGSizeMake(0,1);
    
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrdata.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strcell = @"AtuserCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strcell];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:strcell];
    }
    NSDictionary *dic = arrdata[indexPath.row];
    [cell.textLabel setText:[dic objectForKey:@"name"]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:12]];
    [cell.textLabel setTextColor:RGB(80, 80, 80)];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self setHeight:0];
    [tabview setHeight:0];
    
    NSLog(@"%@",arrdata[indexPath.row]);
    if(self.delegate!=nil)
    {
        [self.delegate selectItemValue:arrdata[indexPath.row]];
    }
    
}
@end
