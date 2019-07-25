//
//  AddressListViewController.m
//  Meidebi
//
//  Created by mdb-admin on 2016/11/3.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "AddressListViewController.h"
#import "AddressListSubjectView.h"
#import "AddressEditViewController.h"
#import "MDB_UserDefault.h"
#import "AddressEditDataController.h"



@interface AddressListViewController ()
<
AddressListSubjectViewDelegate,
AddressListSelectSubjectViewDelegate
>
@property (nonatomic, strong) AddressListSubjectView *subjectView;
@property (nonatomic, strong) AddressEditDataController *datacontroller;
@end

@implementation AddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"收货地址";
    [self setNavigation];
    self.automaticallyAdjustsScrollViewInsets=NO;//scrollview预留空位
    
    _subjectView = [[AddressListSubjectView alloc] initWithFrame:CGRectMake(0, kTopHeight, BOUNDS_WIDTH, BOUNDS_HEIGHT-kTopHeight)];
    [self.view addSubview:_subjectView];
    _subjectView.delegate = self;
    if(self.delegateitem!=nil)
    {
        _subjectView.delegatelist = self;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self fetchAddressData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setNavigation{
    UIButton* btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];    btnLeft.frame = CGRectMake(0,0,44,44);
    [btnLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_click.png"] forState:UIControlStateHighlighted];
    [btnLeft addTarget:self action:@selector(doClickLeftAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnLeft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

-(void)doClickLeftAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
    if ([self.delegate respondsToSelector:@selector(afreshConversionAlertView)]) {
        [self.delegate afreshConversionAlertView];
    }
    if(self.delegateitem!=nil)
    {
        if(self.strnomoid.length<1)
        {///如果添加了地址，需要自动返回一个
            
            NSMutableArray *arrtemp = [_subjectView getAddressList];
            if(arrtemp.count>0)
            {
                for(AddressListModel *model in arrtemp)
                {
                    if([model.strisnomo intValue] == 1)
                    {
                        [self.delegateitem addressSelectItem:model];
                        break;
                    }
                }
                
            }
            
        }
        
    }
}

- (void)skipAddressEditVC:(AddressListModel*)model{
    AddressEditViewController *editVc = [[AddressEditViewController alloc] init];
    editVc.model = model;
    [self.navigationController pushViewController:editVc animated:YES];
}

- (void)fetchAddressData{
    
    
    [self.datacontroller requestAcquireAddressInView1:_subjectView callback:^(NSError *error, BOOL state, NSString *describle) {
//        if (state) {
//            [_subjectView bindAddressDataWithModel:self.datacontroller.arrlist];
//        }
        [_subjectView bindAddressDataWithModel:self.datacontroller.arrlist];
    }];
    
}
#pragma mark - AddressListSubjectViewDelegate
- (void)increaseAddress{
    [self skipAddressEditVC:nil];
}

- (void)editAddress:(AddressListModel *)model{
    [self skipAddressEditVC:model];
}

- (void)deleteAddress:(NSString *)addressID{
    [self.datacontroller requestDeleteAddressInView:_subjectView addressID:addressID callback:^(NSError *error, BOOL state, NSString *describle) {
        if (state) {
            [self fetchAddressData];
            if(_strnomoid!=nil)
            {
                if([addressID isEqualToString:_strnomoid])
                {
                    [self.delegateitem addressDelItem:addressID];
                }
            }
            
            
        }else{
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:_subjectView];
        }
    }];
}

- (void)nomoAddress:(NSString *)addressID
{
    [self.datacontroller requestNomoAddressWithParameters:addressID inView:_subjectView callback:^(NSError *error, BOOL state, NSString *describle) {
        if(state)
        {
            [self fetchAddressData];
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:_subjectView];
        }
    }];
    ///数据请求
    
    
}

#pragma mark - setters and getters
- (AddressEditDataController *)datacontroller{
    if (!_datacontroller) {
        _datacontroller = [[AddressEditDataController alloc] init];
    }
    return _datacontroller;
}

-(void)addressSelectItem:(id)value
{
    [self.delegateitem addressSelectItem:value];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
