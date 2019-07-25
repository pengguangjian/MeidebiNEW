//
//  AddressEditViewController.m
//  Meidebi
//
//  Created by mdb-admin on 2016/11/3.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "AddressEditViewController.h"
#import "AddressEditSubjectView.h"
#import "AddressEditDataController.h"
#import "MDB_UserDefault.h"
@interface AddressEditViewController ()
<
AddressEditSubjectViewDelegate
>
@property (nonatomic, strong) AddressEditSubjectView *editSubView;
@property (nonatomic, strong) AddressEditDataController *datacontroller;
@end

@implementation AddressEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"收货地址";
    [self setNavigation];
    
    _editSubView = [AddressEditSubjectView new];
    [self.view addSubview:_editSubView];
    [_editSubView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }
    }];
    _editSubView.delegate = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_editSubView bindAddressDataWithModel:_model];
    });
    

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

#pragma mark - AddressEditSubjectViewDelegate
- (void)addressEditSubjectView:(AddressEditSubjectView *)subjectView
            saveCurrentAddress:(NSDictionary *)addressDict{
    [self.datacontroller requestSaveAddressWithParameters:addressDict
                                                   inView:_editSubView
                                                 callback:^(NSError *error, BOOL state, NSString *describle) {
                                                     if (state) {
                                                        [MDB_UserDefault showNotifyHUDwithtext:@"操作成功" inView:subjectView];
                                                         [self doClickLeftAction:nil];
                                                     }else{
                                                        [MDB_UserDefault showNotifyHUDwithtext:describle inView:subjectView];
                                                     }
    }];
}

#pragma mark - getters and setters
- (AddressEditDataController *)datacontroller{
    if (!_datacontroller) {
        _datacontroller = [[AddressEditDataController alloc] init];
    }
    return _datacontroller;
}

@end
