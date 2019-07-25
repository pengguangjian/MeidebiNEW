//
//  SearchViewController.m
//  Meidebi
//
//  Created by 杜非 on 15/1/19.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import "SearchViewController.h"
#import "MDB_UserDefault.h"
#import "HTTPManager.h"
#import "SearchEndViewController.h"
#import "SearchMainViewController.h"
#import "HistoryHotView.h"
#import "SMPagerTabView.h"
#import "NJCollectionViewController.h"
NSString *const kDataSourceSectionKey     = @"Items";


@interface SearchViewController ()
<
UITextFieldDelegate,
UITableViewDataSource,
UITableViewDelegate,
SMPagerTabViewDelegate,
HistoryHotViewDelegate,
NJCollectionViewDelegate
>
@property(nonatomic,strong) NSMutableArray *contArr;
@property(nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *allVC;
@property (nonatomic, strong) NSMutableArray *dataHotSource;
@property (nonatomic, strong) SMPagerTabView *segmentView;
@property (nonatomic, strong) HistoryHotView *historyHotView;
@property (nonatomic, strong) UIScrollView *scroView;
@property (nonatomic, strong) UIView *contairView;

@end

@implementation SearchViewController{

    UITextField *_textfield;
    UIButton    *_leftBut;
    UITableView *_tableView;
    NSMutableArray *_Arrtable;
    UIView      *_backView;
}
@synthesize contArr=_contArr;
@synthesize searchBar=_searchBar;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _dataHotSource = [NSMutableArray array];
    NSDictionary *dics=@{@"ismain":@"1"};
    [HTTPManager sendRequestUrlToService:URL_getcatgorys withParametersDictionry:dics view:self.view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct==nil) {
            _contArr=[NSMutableArray arrayWithArray:[MDB_UserDefault getCats]];
            [self setScroViewS];
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[dicAll objectForKey:@"info"]isEqualToString:@"GET_DATA_SUCCESS"]) {
                _contArr=[[NSMutableArray alloc]init];
                NSArray *arr=[dicAll objectForKey:@"data"];
                for (NSDictionary *dicar in arr) {
                    NSDictionary *dicss=@{@"name":[dicar objectForKey:@"name"],
                                          @"imageUrl":[dicar objectForKey:@"iosicon"],
                                          @"id":[dicar objectForKey:@"id"]};
                    [_contArr addObject:dicss];
                }
                [MDB_UserDefault setCats:_contArr];
                [self setScroViewS];
            }else{
            
                _contArr=[NSMutableArray arrayWithArray:[MDB_UserDefault getCats]];
                [self setScroViewS];
            }
        }
    }];
    [self setTextFiel];

     _leftBut=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
    [_leftBut setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [_leftBut addTarget:self action:@selector(leftBack:) forControlEvents:UIControlEventTouchUpInside];
    [_leftBut setImage:[UIImage imageNamed:@"back_click.png"] forState:UIControlStateHighlighted];
    [_leftBut setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:_leftBut]];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateSearHistoryView];
}

- (void)loadHotMallData{
    if (_dataHotSource.count>0) return;
    
    [HTTPManager sendRequestUrlToService:URL_Share_getmall withParametersDictionry:nil view:self.view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct==nil) {
            _dataHotSource=[NSMutableArray arrayWithArray:[MDB_UserDefault getCats]];
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[dicAll objectForKey:@"info"]isEqualToString:@"GET_DATA_SUCCESS"]) {
                NSDictionary *dict=[dicAll objectForKey:@"data"];
                _dataHotSource=[NSMutableArray arrayWithObjects:dict[@"haitao"],dict[@"guonei"], nil];
                [(NJCollectionViewController *)[self.allVC lastObject] setDataSource:_dataHotSource];
            }else{
                _dataHotSource=[NSMutableArray arrayWithArray:[MDB_UserDefault getCats]];
            }
        }
    }];
}
-(void)setTextFiel{
    _textfield=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 30.0)];
    _Arrtable=[NSMutableArray arrayWithArray:[MDB_UserDefault getProcducs]];
    _textfield.borderStyle=UITextBorderStyleNone;
    [_textfield.layer setMasksToBounds:YES];
    [_textfield.layer setBorderWidth:1.0];
    [_textfield.layer setBorderColor:RadLineColor.CGColor];
    _textfield.delegate=self;
    _textfield.backgroundColor=[UIColor whiteColor];
    _textfield.placeholder=@"  搜索更多优惠...";
    _textfield.font=[UIFont systemFontOfSize:14.0];
    //输入框中是否有个叉号，在什么时候显示，用于一次性删除输入框中的内容
    _textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textfield.returnKeyType=UIReturnKeyGoogle;
    self.navigationItem.titleView=_textfield;
}

-(void)rightBut{
    _textfield.text=@"";
    [UIView beginAnimations:@"textfis" context:nil];
    [UIView setAnimationDuration:0.5];
    [_leftBut setFrame:CGRectMake(0, 0, 30, 30)];
    
    [_textfield setFrame:CGRectMake(0, 10, CGRectGetWidth(self.view.frame)-60.0, 30.0)];
    self.navigationItem.rightBarButtonItem=nil;
    if (_tableView) {
        [_tableView setHidden:YES];
        [_backView setHidden:YES];
    }
    [UIView commitAnimations];
    [_textfield resignFirstResponder];
    [self updateSearHistoryView];
}

-(void)leftBack:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setScroViewS{

    [self.view addSubview:self.scroView];
    [self.scroView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    _contairView = ({
        UIView *view = [UIView new];
        [self.scroView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.scroView);
            make.width.equalTo(self.scroView);
        }];
        view.backgroundColor = [UIColor clearColor];
        view;
    });
    
     _historyHotView = [HistoryHotView new];
    [_contairView addSubview:_historyHotView];
    _historyHotView.dataHistorySource = _Arrtable;
    [_historyHotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_contairView);
        make.height.offset(_historyHotView.viewHeight);
    }];
    _historyHotView.delegate = self;
    
    NJCollectionViewController *colletionCategoryVc = [[NJCollectionViewController alloc] init];
    colletionCategoryVc.collectionType = CollectionVcTypeCategory;
    colletionCategoryVc.dataSource = _contArr;
    colletionCategoryVc.delegate = self;
    colletionCategoryVc.title = @"商品分类";
    [self.allVC addObject:colletionCategoryVc];
    
    NJCollectionViewController *colletionHotVc = [[NJCollectionViewController alloc] init];
    colletionHotVc.collectionType = CollectionVcTypeHot;
    colletionHotVc.delegate = self;
    colletionHotVc.title = @"热门商城";
    [self.allVC addObject:colletionHotVc];
    
    [self.view layoutIfNeeded];
    self.segmentView = [[SMPagerTabView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_historyHotView.frame), CGRectGetWidth(self.view.frame), colletionCategoryVc.allHeight)];
    [_contairView addSubview:self.segmentView];
     self.segmentView.delegate = self;
    [self.segmentView setTabFrameHeight:78];
    [self.segmentView buildUI];
    [self.segmentView selectTabWithIndex:0 animate:NO];
    
    UIView *bottomLineView = [UIView new];
    [_contairView addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentView.mas_bottom);
        make.left.right.equalTo(_contairView);
        make.height.offset(1);
    }];
    bottomLineView.backgroundColor = [UIColor colorWithRed:0.8706 green:0.8745 blue:0.8706 alpha:1.0];
    [_contairView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomLineView.mas_bottom);
    }];
    
}

- (void)updateSearHistoryView{
    
    CGFloat historyHeight = 0.00;
    if (_Arrtable.count>0) {
        _historyHotView.dataHistorySource = _Arrtable;
        historyHeight = _historyHotView.viewHeight;
    }
    [_historyHotView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_contairView);
        make.height.offset(historyHeight);
    }];
    [self.view layoutIfNeeded];
    CGRect frame = self.segmentView.frame;
    frame.origin.y = CGRectGetMaxY(_historyHotView.frame);
    self.segmentView.frame = frame;
}

//com.mdb.SearchMainView.ViewController
- (void)buttsender:(UIButton *)sender{
    NSInteger index=sender.tag-88;
    NSDictionary *dicc=_contArr[index];
    
    UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchMainViewController *searchM=[story instantiateViewControllerWithIdentifier:@"com.mdb.SearchMainView.ViewController"];
    searchM.catName=[dicc objectForKey:@"name"];
    searchM.cats=[[dicc objectForKey:@"id"] intValue];
    
    [self.navigationController pushViewController:searchM animated:YES];
}

-(void)butx{
    [MDB_UserDefault removeAllProducs];
     _Arrtable=nil;
    [_tableView reloadData];
}

- (void)beginSearchContentOfHistoryStr:(NSString *)str{
    UIStoryboard *mainStroy=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchEndViewController *ductViewC=[mainStroy instantiateViewControllerWithIdentifier:@"com.mdb.SearchEndView.ViewController"];
    ductViewC.searchStr=str;
    [self.navigationController pushViewController:ductViewC animated:YES];
    [_leftBut setFrame:CGRectMake(0, 0, 30, 30)];
    [_textfield setFrame:CGRectMake(0, 10, CGRectGetWidth(self.view.frame)-60.0, 30.0)];
    self.navigationItem.rightBarButtonItem=nil;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *str=textField.text;
    [MDB_UserDefault setProcducs:str];
    [_tableView setHidden:YES];
    [_backView setHidden:YES];
    if (_Arrtable) {
        [_Arrtable insertObject:str atIndex:0];
    }else{
        _Arrtable=[[NSMutableArray alloc]initWithObjects:str, nil];
    }
    [_textfield resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    
    UIStoryboard *mainStroy=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchEndViewController *ductViewC=[mainStroy instantiateViewControllerWithIdentifier:@"com.mdb.SearchEndView.ViewController"];
    ductViewC.searchStr=str;
    [self.navigationController pushViewController:ductViewC animated:YES];
    [_leftBut setFrame:CGRectMake(0, 0, 30, 30)];
    [_textfield setFrame:CGRectMake(0, 10, CGRectGetWidth(self.view.frame)-60.0, 30.0)];
    self.navigationItem.rightBarButtonItem=nil;
    _textfield.text=@"";
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [_leftBut setFrame:CGRectMake(0, 0, 0, 0)];
    [_textfield setFrame:CGRectMake(44 , 10,CGRectGetWidth(self.view.frame)-104.0, 30.0)];
    [UIView beginAnimations:@"textfide" context:nil];
    
    if (_tableView) {
        [_tableView setHidden:NO];
        [_backView setHidden:NO];
        [_tableView reloadData];
    }else{
        _backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [_backView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:_backView];
        
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-240.0)];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.showsVerticalScrollIndicator=NO;
        //设定cell分行线的样式，默认为UITableViewCellSeparatorStyleSingleLine
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.view addSubview:_tableView];
    }
    [UIView setAnimationDuration:0.5];
    [_textfield setFrame:CGRectMake(0 , 10,CGRectGetWidth(self.view.frame)-60.0, 30.0)];
    [UIView commitAnimations];
    UIButton *butright=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [butright setTitle:@"取消" forState:UIControlStateNormal];
    [butright setTitleColor:RGB(68.0, 68.0, 68.0) forState:UIControlStateNormal];
    [butright addTarget:self action:@selector(rightBut) forControlEvents:UIControlEventTouchUpInside];
    [butright setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
    UIBarButtonItem *barBut=[[UIBarButtonItem alloc]initWithCustomView:butright];
    self.navigationItem.rightBarButtonItem=barBut;
    [_textfield becomeFirstResponder];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""])
    {
        return YES;
    }
    //string就是此时输入的那个字符 textField就是此时正在输入的那个输入框 返回YES就是可以改变输入框的值 NO相反
    //按会车可以改变
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    //判断是否时我们想要限定的那个输入框
    if (_textfield == textField)
    {
        if ([toBeString length] > 20) { //如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:20];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"超过最大字数不能输入了" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] ;
            [alert show];
            return NO;
        }
    }
    return YES;
}


#pragma mark Uitableview Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_Arrtable.count>0) {
         return _Arrtable.count+1;
    }else{
        return 0;
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==_Arrtable.count) {
        return 80.0;
    }else{
        return 30.0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==_Arrtable.count) {
        static NSString *SimpleTableIden = @"SimpleTableIdent";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 SimpleTableIden];
        
        UIImageView *imageV;
        UILabel *labelss;
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier: SimpleTableIden];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            imageV=[UIImageView new];
            [cell addSubview:imageV];
            [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(cell).centerOffset(CGPointMake(-40, 0));
                make.size.mas_equalTo(CGSizeMake(30, 30));
            }];
            imageV.image=[UIImage imageNamed:@"shousuosqingkong.png"];

            labelss =[UILabel new];
            [cell addSubview:labelss];
            [labelss mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(imageV.mas_right);
                make.centerY.equalTo(cell.mas_centerY);
            }];
            labelss.font=[UIFont systemFontOfSize:13.0];
            labelss.textColor=RadshuziColor;
            labelss.text=@"清空搜索历史";
            UIButton *butx=[UIButton buttonWithType:UIButtonTypeCustom];
            [cell addSubview:butx];
            [butx mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(cell);
            }];
            [butx setBackgroundColor:[UIColor clearColor]];
            [butx addTarget:self action:@selector(butx) forControlEvents:UIControlEventTouchUpInside];
             
        }
        return cell;
    }else{
        static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 SimpleTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:SimpleTableIdentifier];
            UILabel *labels =[[UILabel alloc]initWithFrame:CGRectMake(16.0, 5.0, self.view.frame.size.width-32.0, 18.0)];
            labels.textColor=RadDaoBiaoColor;
            labels.font=[UIFont systemFontOfSize:14.0];
            UIView *viewline=[[UIView alloc]initWithFrame:CGRectMake(0.0, 29.0, CGRectGetWidth(self.view.frame),1.0)];
            [viewline setBackgroundColor:RadLineColor];
            [cell addSubview:viewline];
            [cell addSubview:labels];
            if (![_Arrtable[indexPath.row] isKindOfClass:[NSNull class]]&&_Arrtable.count>indexPath.row) {
                labels.text=[NSString stringWithFormat:@"%@",_Arrtable[indexPath.row]];
            }
        }else{
        
            for (UIView *vies in [cell subviews]) {
                if ([vies isKindOfClass:[UILabel class]]) {
                    UILabel *lasbel=(UILabel *)vies;
                    if (![_Arrtable[indexPath.row] isKindOfClass:[NSNull class]]&&_Arrtable.count>indexPath.row) {
                        lasbel.text=[NSString stringWithFormat:@"%@",_Arrtable[indexPath.row]];
                    }
                }
            }
        }
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<_Arrtable.count) {
        
        NSString *str=_Arrtable[indexPath.row];
        [MDB_UserDefault setProcducs:str];
        [_tableView setHidden:YES];
        [_backView setHidden:YES];
        if (_Arrtable) {
            [_Arrtable insertObject:str atIndex:0];
        }else{
            _Arrtable=[[NSMutableArray alloc]initWithObjects:str, nil];
        }
        [_tableView reloadData];
        
        [_textfield resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
        
        [self beginSearchContentOfHistoryStr:str];
        _textfield.text=@"";
        
    }
    
}

#pragma mark - DBPagerTabView Delegate
- (NSUInteger)numberOfPagers:(SMPagerTabView *)view {
    return [self.allVC count];
}

- (UIViewController *)pagerViewOfPagers:(SMPagerTabView *)view indexOfPagers:(NSUInteger)number {
    return self.allVC[number];
}

- (void)whenSelectOnPager:(NSUInteger)number {
    CGRect frame = self.segmentView.frame;
    frame.size.height = [(NJCollectionViewController *)self.allVC[number] allHeight];
    [self.segmentView setFrame:frame];
    
    if (number==0) {
        [(NJCollectionViewController *)[self.allVC firstObject] setDataSource:_contArr];
    }else if (number==1){
        [self loadHotMallData];
    }
}

#pragma mark - HistoryHotViewDelegate
- (void)historyHotViewDidPressDeleateBtn{
    [MDB_UserDefault removeAllProducs];
    [_Arrtable removeAllObjects];
    CGRect frame = self.segmentView.frame;
    frame.origin.y = 0;
    [self.segmentView setFrame:frame];
    [_historyHotView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_contairView);
        make.height.offset(0);
    }];
}

- (void)historyHotView:(HistoryHotView *)hotView didPressSimpleHistoryStr:(NSString *)contentStr{
    [self beginSearchContentOfHistoryStr:contentStr];
}

#pragma mark - NJCollectionViewDelegate
- (void)NJCollectionViewController:(NJCollectionViewController *)collectionViewController
  categoryDidPressCellOfContent:(NSDictionary *)content{
    UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchMainViewController *searchM=[story instantiateViewControllerWithIdentifier:@"com.mdb.SearchMainView.ViewController"];
    searchM.catName=[content objectForKey:@"name"];
    searchM.cats=[[content objectForKey:@"id"] intValue];
    if (collectionViewController.collectionType == CollectionVcTypeCategory) {
        searchM.vcType = SearchMainVcTypeCategory;
    }else{
        searchM.vcType = SearchMainVcTypeHot;
    }
    [self.navigationController pushViewController:searchM animated:YES];
}

#pragma mark - getters and setters

- (NSMutableArray *)allVC{
    if (!_allVC) {
        self.allVC = [NSMutableArray array];
    }
    return _allVC;
}

- (UIScrollView *)scroView{
    if (!_scroView) {
        _scroView = [UIScrollView new];
        _scroView.backgroundColor = [UIColor clearColor];
    }
    return _scroView;
}
@end
