//
//  SearchHomeViewController.m
//  Meidebi
//
//  Created by mdb-admin on 2016/11/18.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "SearchHomeViewController.h"
#import "SearchHomeSubjectView.h"
#import "MDB_UserDefault.h"
#import "SearchEndViewController.h"

#import "SearchEnginesTabView.h"
#import "SearchHomeViewDataController.h"

@interface LEESearchBar: UISearchBar
@end

@implementation LEESearchBar
- (void)layoutSubviews{
    [super layoutSubviews];
    for (UIView *subview in [[self.subviews firstObject] subviews]) {
        if([subview isKindOfClass:[UITextField class]]){
            CGRect frame = subview.frame;
            if (@available(iOS 11.0, *)) {
                frame.origin.y += 2;
            }else{
                frame.origin.y -= 2;
            }
            frame.size.height = 31;
            subview.frame = frame;
        }
    }
}
@end

@interface SearchHomeViewController ()
<
UISearchBarDelegate,
SearchHomeSubjectViewDelegate,
SearchEnginesTabViewDelegate
>
@property (nonatomic, strong) LEESearchBar *searchBar;
@property (nonatomic, strong) SearchHomeSubjectView *subjectView;

@property (nonatomic , retain) SearchEnginesTabView *searchTabview;

@property (nonatomic , assign) BOOL issearch;
@property (nonatomic , retain) SearchHomeViewDataController *dataControl;

@end

@implementation SearchHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self setupNavigationBarView];
    _subjectView = [[SearchHomeSubjectView alloc] init];
    [self.view addSubview:_subjectView];
    [_subjectView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }
    }];
    _subjectView.delegate = self;
    
    
    _dataControl = [[SearchHomeViewDataController alloc] init];
    NSDictionary *dicpush = @{@"key":@"home_search_hot"};
    [_dataControl requestSearchHomeViewDataWithView:nil pushValue:dicpush callback:^(NSError *error, BOOL state, NSString *describle) {
        if(state)
        {
            [_subjectView updateHotKeyValue:_dataControl.arrkeys];
        }
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_subjectView updateSearchCache];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_searchBar becomeFirstResponder];
    
    if(_issearch)
    {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    _searchBar.text = nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_searchBar resignFirstResponder];
    [_searchTabview removeFromSuperview];
    _searchTabview = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupNavigationBarView{
    CGRect frame = self.navigationController.navigationBar.bounds;
    _searchBar = [[LEESearchBar alloc] initWithFrame:frame];
    _searchBar.tintColor = [UIColor colorWithHexString:@"#BFBFBF"];
    _searchBar.placeholder = kDefaultHotSearchStr;
    _searchBar.showsCancelButton = YES;
    _searchBar.delegate = self;
    
    UITextField *searchField = [self.searchBar valueForKey:@"searchField"];
    // To change background color
    searchField.backgroundColor = [UIColor colorWithHexString:@"#ECECEC"];
    // To change text color
    UILabel *placeholderLabel = [searchField valueForKey:@"placeholderLabel"];
    searchField.textColor = placeholderLabel.textColor;
    searchField.font = [UIFont systemFontOfSize:14.f];
    searchField.layer.masksToBounds = YES;
    searchField.layer.cornerRadius = 31/2.f;
    // To change placeholder text color
//    searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Some Text"];
//    UILabel *placeholderLabel = [searchField valueForKey:@"placeholderLabel"];
//    placeholderLabel.textColor = [UIColor grayColor];
    //修改取消按钮字体颜色
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil]
     setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"]}
     forState:UIControlStateNormal];
    self.navigationItem.titleView = _searchBar;
    
    if (_hotSearchStr) {
        _searchBar.placeholder = _hotSearchStr;
        searchField.enablesReturnKeyAutomatically = NO;
    }
}

- (void)beginSearchContentOfHistoryStr:(NSString *)str{
    [_searchBar resignFirstResponder];
    _issearch = YES;
    UIStoryboard *mainStroy=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchEndViewController *ductViewC=[mainStroy instantiateViewControllerWithIdentifier:@"com.mdb.SearchEndView.ViewController"];
    ductViewC.searchStr=str;
    [self.navigationController pushViewController:ductViewC animated:YES];
}


#pragma mark - UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(_searchTabview == nil)
    {
        _searchTabview = [[SearchEnginesTabView alloc] initWithFrame:CGRectMake(0, _subjectView.top, self.view.width, self.view.height-_subjectView.top)];
        [_searchTabview setDegelate:self];
        [self.view addSubview:_searchTabview];
    }
    
    _searchTabview.strkeywords = searchText;
    [_searchTabview loaddata:searchText];
    
    NSLog(@"%@",searchText);
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *searchContentStr = @"";
    if (_hotSearchStr && [[NSString nullToString:searchBar.text] isEqualToString:@""]) {
        searchContentStr = _hotSearchStr;
    }else{
        searchContentStr = searchBar.text;
    }
    if ([[NSString nullToString:searchContentStr] isEqualToString:@""]) return;
    [MDB_UserDefault setProcducs:searchContentStr];
    [self beginSearchContentOfHistoryStr:searchContentStr];
}

#pragma mark - SearchHomeSubjectViewDelegate
- (void)searchHomeSubjectView:(SearchHomeSubjectView *)subjectView
    didSelectSearchHistoryStr:(NSString *)historyStr{
    
    [MDB_UserDefault setProcducs:historyStr];
    
    [self beginSearchContentOfHistoryStr:historyStr];
}

- (void)searchHomeSubjectViewDidSlide{
    [_searchBar resignFirstResponder];
}


#pragma mark - SearchEnginesTabViewDelegate
-(void)SearchEnginesTabViewDelegateSelectValue:(id)value
{
    [_searchBar setText:value];
    
    [MDB_UserDefault setProcducs:value];
    [self beginSearchContentOfHistoryStr:value];
    [_searchTabview removeFromSuperview];
    _searchTabview = nil;
}
-(void)scrollDrag
{
    [_searchBar resignFirstResponder];
}
@end
