//
//  MallView.m
//  Meidebi
//
//  Created by 杜非 on 15/4/27.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import "MallView.h"
#import "pinyin.h"
#import "POAPinyin.h"
#import "HTTPManager.h"
#import "Constants.h"
#import "MallViewController.h"


@implementation MallView{
    NSMutableArray *arrl;

}
@synthesize delegate=_delegate;

-(id)initWithFrame:(CGRect)frame isbroad:(NSString *)isbroad delegate:(id)delegate{
    if (self) {
        self=[super initWithFrame:frame];
    }
    _delegate=delegate;
    arrl=[[NSMutableArray alloc]init];
    sectionDic= [[NSMutableDictionary alloc] init];
   // NSDictionary *dicl=@{@"isbroad":isbroad};
//    NSString *urls=[NSString stringWithFormat:@"%@-isabroad-%@-allsite-%@",URL_getmall,isbroad,@"1"];
    NSDictionary *parameters = @{@"isabroad":isbroad,
                                 @"allsite":@"1"};
    [HTTPManager  sendGETRequestUrlToService:URL_getmall withParametersDictionry:parameters view:self completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct){
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
    
            if ([[dicAll objectForKey:@"info"]isEqualToString:@"GET_DATA_SUCCESS"])
            {
                if ([[dicAll objectForKey:@"data"]isKindOfClass:[NSDictionary class]]) {
                    NSArray *arrkeys=[[dicAll objectForKey:@"data"] allKeys];
                    for (NSString *strkey in arrkeys) {
                        MallObjct *mallobj=[[MallObjct alloc]initWithName:[[dicAll objectForKey:@"data"] objectForKey:strkey] lid:[strkey integerValue]];
                        [arrl addObject:mallobj];
                    }
                    if ([_delegate respondsToSelector:@selector(mallviewData:)]) {
                        [_delegate mallviewData:arrl];
                    }
                    
                    [self loadDate];
                }
            }
            
        }}];
    

    return self;
}
-(void)loadDate{
    for (int i = 0; i < 26; i++) [sectionDic setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%c",'A'+i]];
    [sectionDic setObject:[NSMutableArray array] forKey:@"#"];
    for (int k=0; k<arrl.count; k++) {
        MallObjct *mallobj=[arrl objectAtIndex:k];
        
        NSString *personname=mallobj.name;
        char first=pinyinFirstLetter([personname characterAtIndex:0]);
        NSString *sectionName;
        if ((first>='a'&&first<='z')||(first>='A'&&first<='Z')) {
            if([self searchResult:personname searchText:@"曾"])
                sectionName = @"Z";
            else if([self searchResult:personname searchText:@"解"])
                sectionName = @"X";
            else if([self searchResult:personname searchText:@"仇"])
                sectionName = @"Q";
            else if([self searchResult:personname searchText:@"朴"])
                sectionName = @"P";
            else if([self searchResult:personname searchText:@"查"])
                sectionName = @"Z";
            else if([self searchResult:personname searchText:@"能"])
                sectionName = @"N";
            else if([self searchResult:personname searchText:@"乐"])
                sectionName = @"Y";
            else if([self searchResult:personname searchText:@"单"])
                sectionName = @"S";
            else
                sectionName = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([personname characterAtIndex:0])] uppercaseString];
        }
        else {
            sectionName=[[NSString stringWithFormat:@"%c",'#'] uppercaseString];
        }
        [[sectionDic objectForKey:sectionName] addObject:mallobj];
    }
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0.0, self.frame.size.width, self.frame.size.height)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self addSubview:_tableView];

}


-(BOOL)searchResult:(NSString *)contactName searchText:(NSString *)searchT{
    NSComparisonResult result = [contactName compare:searchT options:NSCaseInsensitiveSearch
                                               range:NSMakeRange(0, searchT.length)];
    if (result == NSOrderedSame)
        return YES;
    else
        return NO;
}
#pragma mark - Table View
//用以定制自定义的section头部视图－Header

 //右侧添加一个索引表
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
        NSMutableArray *indices = [NSMutableArray arrayWithObject:UITableViewIndexSearch];
        for (int i = 0; i < 27; i++)
            [indices addObject:[[ALPHA substringFromIndex:i] substringToIndex:1]];
    
        return indices;
  
}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
  
    return  [ALPHA rangeOfString:title].location;
}
//指定有多少个分区(Section)，默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        return 27;
}
//指定每个分区中有多少行，默认为1
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

        NSString *key=[NSString stringWithFormat:@"%c",[ALPHA characterAtIndex:section]];
    
        return  [[sectionDic objectForKey:key] count];
   
}
//每个section头部的标题－Header
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *key=[NSString stringWithFormat:@"%c",[ALPHA characterAtIndex:section]];
    if ([[sectionDic objectForKey:key] count]!=0) {
        return key;
    }
    return nil;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    NSString *key=[NSString stringWithFormat:@"%c",[ALPHA characterAtIndex:indexPath.section]];
    
        NSMutableArray *persons=[sectionDic objectForKey:key];
        MallObjct *mallobj=[persons objectAtIndex:indexPath.row];
    if (![mallobj.name isKindOfClass:[NSNull class]]) {
    cell.textLabel.text=mallobj.name;
    }

    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key=[NSString stringWithFormat:@"%c",[ALPHA characterAtIndex:indexPath.section]];
    NSMutableArray *persons=[sectionDic objectForKey:key];
    MallObjct *mallobj=[persons objectAtIndex:indexPath.row];
    if ([_delegate respondsToSelector:@selector(mallViewSelegate:)]) {
        [_delegate mallViewSelegate:mallobj];
    }
    

}
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([_delegate respondsToSelector:@selector(mallViewScrp)]) {
        [_delegate mallViewScrp];
    }
   
}

@end
