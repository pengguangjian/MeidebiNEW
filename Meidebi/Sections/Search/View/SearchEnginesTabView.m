//
//  SearchEnginesTabView.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/9.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "SearchEnginesTabView.h"
#import "HTTPManager.h"

#import "SearchEnginesTableViewCell.h"


@interface SearchEnginesTabView ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tabview;
    NSMutableArray *arrdata;
}


@end

@implementation SearchEnginesTabView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    tabview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [tabview setDelegate:self];
    [tabview setDataSource:self];
    [tabview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addSubview:tabview];
}

-(void)loaddata:(NSString *)strkey
{
    if(strkey.length<1)
    {
        [self setHidden:YES];
        arrdata = [NSMutableArray new];
        [tabview reloadData];
        return;
    }
    _strkeywords = strkey;
    NSDictionary *dicpush = @{@"pre":strkey};
    [HTTPManager sendGETRequestUrlToService:SearchfullWordUrl withParametersDictionry:dicpush view:nil completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"网络错误！";
        arrdata = [NSMutableArray new];
        if (responceObjct){
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[dicAll objectForKey:@"status"]intValue] == 1) {
                NSArray *dict=[dicAll objectForKey:@"data"];
                if ([[dicAll objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                    arrdata =(NSMutableArray *) dict;
                    state = YES;
                }
            }else{
                describle = dicAll[@"info"];
            }
        }
        [tabview reloadData];
        if(arrdata.count>0)
        {
            [self setHidden:NO];
        }
        else
        {
            [self setHidden:YES];
        }
    }];
}

#pragma mark - UITableView
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.degelate scrollDrag];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrdata.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strcell = @"SearchEnginesTableViewCell";
    SearchEnginesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strcell];
    if(!cell)
    {
        cell = [[SearchEnginesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strcell];
    }
    if(arrdata.count>indexPath.row)
    {
        cell.strValue = arrdata[indexPath.row];
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.degelate SearchEnginesTabViewDelegateSelectValue:arrdata[indexPath.row]];
}

@end
