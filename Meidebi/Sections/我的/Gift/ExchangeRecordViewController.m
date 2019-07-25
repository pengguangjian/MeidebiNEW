//
//  ExchangeRecordViewController.m
//  Meidebi
//
//  Created by mdb-admin on 2016/11/7.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "ExchangeRecordViewController.h"
#import "ExchangeSubjectView.h"
#import "ExchangeRcordDataController.h"

@interface ExchangeRecordViewController ()
<
ExchangeSubjectViewDelegate
>
@property (nonatomic, strong) ExchangeRcordDataController *datacontroller;
@property (nonatomic, strong) ExchangeSubjectView*subjectView;
@end

@implementation ExchangeRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigation];
    self.navigationItem.title = @"兑换记录";
    self.view.backgroundColor = [UIColor whiteColor];
    _subjectView = [ExchangeSubjectView new];
    [self.view addSubview:_subjectView];
    [_subjectView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view);
        }
    }];
    _subjectView.delegate = self;
    [self fetchRecodData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

- (void)fetchRecodData{
    [self.datacontroller requestSubjectDataWithInView:_subjectView callback:^(NSError *error, BOOL state, NSString *describle) {
        [_subjectView bindDataWithModel:self.datacontroller.requestResults];
    }];
}

#pragma mark - ExchangeSubjectViewDelegate
- (void)subjectsViewWithPullupTableview{
    [self.datacontroller nextPageDataWithCallback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            [_subjectView bindDataWithModel:self.datacontroller.requestResults];
        }
    }];
}

- (void)subjectsViewWithPullDownTableview{
    [self.datacontroller lastNewPageDataWithCallback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            [_subjectView bindDataWithModel:self.datacontroller.requestResults];
        }
    }];
}

#pragma mark - setters and getters
- (ExchangeRcordDataController *)datacontroller{
    if (!_datacontroller) {
        _datacontroller = [[ExchangeRcordDataController alloc] init];
    }
    return _datacontroller;
}

@end
