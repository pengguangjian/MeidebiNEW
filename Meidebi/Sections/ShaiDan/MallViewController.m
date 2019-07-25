//
//  MallViewController.m
//  Meidebi
//
//  Created by 杜非 on 15/4/27.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import "MallViewController.h"
#import "MallView.h"
#import "pinyin.h"
#import "POAPinyin.h"
#import "MenuView.h"
@interface MallObjct ()
@end

@implementation MallObjct
-(id)initWithName:(NSString *)namel lid:(NSInteger )lid{
    if (self) {
        self=[super init];
    }
    
    self.name=namel;
    self.mallid=lid;
    return self;
}

@end
@interface MallViewController ()<UISearchBarDelegate,MenuDelegate,MallViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    MallView *_mallView;
    MallView   *_mallTwoView;
    
    UISearchBar *searchBar;
    MenuView   *_menu;
    
    UITableView *_tableView;
    
    NSMutableArray *allMallobj;
    
    NSMutableArray *filterArr;
}
    
@end

@implementation MallViewController
@synthesize delegate=_delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    allMallobj=[[NSMutableArray alloc]init];
    sectionDic= [[NSMutableDictionary alloc] init];
    filterArr=[[NSMutableArray alloc]init];
    
    
    _mallTwoView=[[MallView alloc]initWithFrame:CGRectMake(0, 111.0, self.view.frame.size.width, self.view.frame.size.height-111.0) isbroad:@"1" delegate:self];
    [self.view addSubview:_mallTwoView];
    
    _mallView=[[MallView alloc]initWithFrame:CGRectMake(0, 111.0, self.view.frame.size.width, self.view.frame.size.height-111.0) isbroad:@"0" delegate:self ];
    [self.view addSubview:_mallView];
    [self setNavigationSearch];
    _menu=[[MenuView alloc]initWithFrame:CGRectMake(0, kTopHeight,self.view.frame.size.width, 47) titles:@[@"国内电商",@"国外电商"] delegat:self];
    
    [self.view addSubview:_menu];
}
#pragma mark mallViewSelegate
-(void)mallviewData:(NSArray *)arrl{
    [allMallobj addObjectsFromArray:arrl];
    [self loadDate];
}
-(void)mallViewSelegate:(MallObjct *)mallObj{
    [searchBar resignFirstResponder];
    if (_delegate) {
        [_delegate appRriceSelect:mallObj];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)mallViewScrp{
    [searchBar resignFirstResponder];
}
#pragma mark MenuDelegate
-(void)MenuSelect:(MenuView *)menu index:(NSInteger)selectIndex title:(NSString *)title{
    switch (selectIndex) {
        case 0:
            _mallView.hidden=NO;
            _mallTwoView.hidden=YES;
            break;
        case 1:
            _mallView.hidden=YES;
            _mallTwoView.hidden=NO;
            
            break;
        default:
            break;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setNavigationSearch{
    UIButton* btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame = CGRectMake(0,0,44,44);
    [btnLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_click.png"] forState:UIControlStateHighlighted];
    [btnLeft addTarget:self action:@selector(doClickLeftAction) forControlEvents:UIControlEventTouchUpInside];
    [btnLeft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [negativeSpacer setWidth:-20];

    self.navigationItem.leftBarButtonItems = @[leftBarButtonItem,negativeSpacer];
    searchBar=[[UISearchBar alloc] initWithFrame:self.navigationController.navigationBar.bounds];
    searchBar.delegate=self;
    searchBar.placeholder = @"商城";
    self.navigationItem.titleView=searchBar;
}
-(void)doClickLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self performSelectorOnMainThread:@selector(searchWithString:) withObject:searchText waitUntilDone:YES];
}
-(void)loadDate{
    [sectionDic removeAllObjects];
    for (int i = 0; i < 26; i++) [sectionDic setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%c",'A'+i]];
    [sectionDic setObject:[NSMutableArray array] forKey:@"#"];
    for (int k=0; k<allMallobj.count; k++) {
        MallObjct *mallobj=[allMallobj objectAtIndex:k];
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
    
   
    
}
-(void)searchWithString:(NSString *)searchString
{
    [filterArr removeAllObjects];
    // NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([searchString length]!=0) {
        
        //搜索对应分类下的数组
        NSString *sectionName = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([searchString characterAtIndex:0])] uppercaseString];
        NSArray *array=[sectionDic objectForKey:sectionName];
        for (int j=0;j<[array count];j++) {
            MallObjct *mallobj=[array objectAtIndex:j];
            //NSString *name=(NSString *)ABRecordCopyCompositeName(person);
            if ([self searchResult:mallobj.name searchText:searchString]) { //先按输入的内容搜索
                [filterArr addObject:mallobj];
            }
            else { //按拼音搜索
                NSString *string = @"";
                NSString *firststring=@"";
                for (int i = 0; i < [mallobj.name length]; i++)
                {
                    if([string length] < 1)
                        string = [NSString stringWithFormat:@"%@",
                                  [POAPinyin quickConvert:[mallobj.name substringWithRange:NSMakeRange(i,1)]]];
                    else
                        string = [NSString stringWithFormat:@"%@%@",string,
                                  [POAPinyin quickConvert:[mallobj.name substringWithRange:NSMakeRange(i,1)]]];
                    if([firststring length] < 1)
                        firststring = [NSString stringWithFormat:@"%c",
                                       pinyinFirstLetter([mallobj.name characterAtIndex:i])];
                    else
                    {
                        if ([mallobj.name characterAtIndex:i]!=' ') {
                            firststring = [NSString stringWithFormat:@"%@%c",firststring,
                                           pinyinFirstLetter([mallobj.name characterAtIndex:i])];
                        }
                        
                    }
                }
                if ([self searchResult:string searchText:searchString]
                    ||[self searchResult:firststring searchText:searchString])
                {
                    
                    [filterArr addObject:mallobj];
                    
                }
            }
        }
        NSMutableArray *mutArr=[[NSMutableArray alloc]init];
        for (NSString *sectionName in [sectionDic allKeys]) {
            [mutArr addObjectsFromArray:[sectionDic objectForKey:sectionName]];
        }
        
        for (int j=0;j<[mutArr count];j++) {
            MallObjct *mallobj=[mutArr objectAtIndex:j];
            if ([mallobj.name rangeOfString:searchString].length>0) {
                BOOL  mallBool=YES;
                for (MallObjct *mallobjt in filterArr) {
                    if (mallobjt.mallid ==mallobj.mallid){
                        mallBool=NO;
                    }
                }
                if (mallBool) {
                    [filterArr addObject:mallobj];
                }
                
            }
        
        }
        
        
        
        if (_tableView) {
            
            _tableView.hidden=NO;
            [_tableView reloadData];
        }else{
            _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0.0, kTopHeight, self.view.frame.size.width, self.view.frame.size.height-kTopHeight)];
            _tableView.delegate=self;
            _tableView.dataSource=self;
            [self.view addSubview:_tableView];
            
        }
        
        
    }else{
        if (_tableView) {
            _tableView.hidden=YES;
            [_tableView reloadData];
        }
    
    }
    
}
-(BOOL)searchResult:(NSString *)contactName searchText:(NSString *)searchT{
    if (contactName.length<searchT.length || contactName == nil || searchT == nil) return NO;
    NSComparisonResult result = [contactName compare:searchT options:NSCaseInsensitiveSearch
                                               range:NSMakeRange(0, searchT.length)];
    if (result == NSOrderedSame)
        return YES;
    else
        return NO;
}

#pragma mark delegate

//指定有多少个分区(Section)，默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//指定每个分区中有多少行，默认为1
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return filterArr.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    MallObjct *mallobj=[filterArr objectAtIndex:indexPath.row];
    if (![mallobj.name isKindOfClass:[NSNull class]]) {
    cell.textLabel.text=mallobj.name;
    }
    
    return cell;
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==_tableView) {
        [searchBar resignFirstResponder];
    }
    

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
[self mallViewSelegate:[filterArr objectAtIndex:indexPath.row]];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
