//
//  MyGiftViewController.m
//  Meidebi
//
//  Created by mdb-admin on 2016/11/7.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "MyGiftViewController.h"
#import "AddressListViewController.h"
#import "ExchangeRecordViewController.h"
@interface MyGiftViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) NSArray *rowContents;
@end

@implementation MyGiftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigation];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的礼品";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setNavigation{
    UIButton* btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame = CGRectMake(0,0,44,44);
    [btnLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_click.png"] forState:UIControlStateHighlighted];
    [btnLeft addTarget:self action:@selector(doClickLeftAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnLeft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

-(void)doClickLeftAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setupSubViews{
    UITableView *tableView = [[UITableView alloc] init];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }
    }];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    UIView *footerView = [UIView new];
    footerView.backgroundColor = [UIColor whiteColor];
    [tableView setTableFooterView:footerView];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.rowContents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        cell.textLabel.font = [UIFont systemFontOfSize:16.f];
    }
    cell.textLabel.text = self.rowContents[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        ExchangeRecordViewController *recordVc = [[ExchangeRecordViewController alloc] init];
        [self.navigationController pushViewController:recordVc animated:YES];
    }else if (indexPath.row == 1){
        AddressListViewController *listVc = [[AddressListViewController alloc] init];
        [self.navigationController pushViewController:listVc animated:YES];
    }
}

#pragma mark - setters and getters
- (NSArray *)rowContents{
    if (!_rowContents) {
        _rowContents = @[@"兑换记录",
                         @"收货地址"];
    }
    return _rowContents;
}

@end
