//
//  PersonalInfoView.m
//  Meidebi
//  个人信息页面
//  Created by fishmi on 2017/6/22.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "PersonalInfoView.h"
#import "PersonalInfoTableViewCell.h"
#import "MDB_UserDefault.h"
#import <UIImageView+WebCache.h>
#import "PersonalAlertView.h"
#import "PersonalTextAlertView.h"
#import "PersonalBirthAlertView.h"
#import "AddressListViewController.h"


@interface PersonalInfoView ()<UITableViewDataSource,UITableViewDelegate,PersonalAlertViewDelegate,PersonalTextAlertViewDelegate,UIAlertViewDelegate,PersonalBirthAlertViewDelegate>
@property (nonatomic ,strong) NSArray *tableArray;
@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (nonatomic ,weak) UITableView *tableV;
@property (nonatomic ,weak) UIImageView *imageV;
@end

static NSString  *const cellID = @"PersonalInfoViewCell";
@implementation PersonalInfoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        NSArray *array = @[@"头像",@"昵称",@"性别",@"生日",@"收货地址",@"我的支付宝"];
        _tableArray = array;
        
        [self setUpSubView];
    }
    return self;
}

-(void)setUpSubView{
    UIView *bottomV = [[UIView alloc] init];
    [self addSubview:bottomV];
    [bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.offset(66 *kScale);
    }];
    bottomV.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
    
    UILabel *bottomL = [[UILabel alloc] init];
    bottomL.text = @"注意：修改支付宝账号请联系客服";
    bottomL.textAlignment = NSTextAlignmentLeft;
    bottomL.textColor = [UIColor colorWithHexString:@"#666666"];
    bottomL.font = [UIFont systemFontOfSize:12];
    [bottomV addSubview:bottomL];
    [bottomL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomV).offset(21 *kScale);
        make.right.equalTo(bottomV).offset(-21 *kScale);
        make.centerY.equalTo(bottomV.mas_centerY);
    }];
    
    
    
    UITableView *tableV = [[UITableView alloc] init];
    [self addSubview: tableV];
    [tableV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(bottomV.mas_top);
    }];
    tableV.bounces = NO;
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableV registerClass:[PersonalInfoTableViewCell class] forCellReuseIdentifier:cellID];
    _tableV = tableV;
    
    UIView *footerV = [[UIView alloc] init];
    tableV.tableFooterView = footerV;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = _tableArray[indexPath.row];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        UIImageView *imageV = [[UIImageView alloc] init];
        [cell addSubview:imageV];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell).offset(-43 *kScale);
            make.centerY.equalTo(cell.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(46 *kScale, 46 *kScale));
        }];
//        imageV.backgroundColor = [UIColor redColor];
        imageV.layer.cornerRadius = 23 *kScale;
        imageV.clipsToBounds = YES;
        _imageV = imageV;
        if (_dataArray) {
            [imageV sd_setImageWithURL:[NSURL URLWithString:_dataArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"noavatar.png"]];
        }
        

        UIView *lineV = [[UIView alloc] init];
        [cell addSubview:lineV];
        lineV.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
        [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(cell);
            make.height.offset(1);
        }];
        
        return cell;
        
    }else{
        
        PersonalInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        cell.text_Label.text = _tableArray[indexPath.row];
        if (_dataArray) {
            if (indexPath.row == 6) {
                
            }else{
                cell.subLabel.text = _dataArray[indexPath.row];
            }
        }
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66 *kScale;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:nil                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        [alertView setTag:20];
        [alertView show];
    }else if (indexPath.row == 1){
        
        PersonalTextAlertView *alertV = [[PersonalTextAlertView alloc] init];
        alertV.tag = 10;
        alertV.delegate = self;
        [alertV setTitle:@"昵称" placeholder:@"请输入昵称" text:_dataArray[indexPath.row] image:[UIImage imageNamed:@"nickname"]];
        [alertV show];
    }else if (indexPath.row == 2){
        PersonalAlertView *alertV = [[PersonalAlertView alloc] init];
        alertV.tag = 11;
        alertV.delegate = self;
        [alertV show];

    }else if (indexPath.row == 3){
        PersonalBirthAlertView *alerView = [[PersonalBirthAlertView alloc] init];
        alerView.tag = 12;
        alerView.delegate = self;
        [alerView show];
        
    }else if (indexPath.row == 4){
        AddressListViewController *addressVc = [[AddressListViewController alloc] init];
        if ([self.delegate respondsToSelector:@selector(clickToViewController:)]) {
            [self.delegate clickToViewController:addressVc];
        }
    }else if (indexPath.row == 5){
        PersonalInfoTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.subLabel.text.length <= 0) {
            PersonalTextAlertView *alertV = [[PersonalTextAlertView alloc] init];
            alertV.tag = 13;
            alertV.delegate = self;
            [alertV setTitle:@"支付宝" placeholder:@"请输入支付宝账号" text:nil image:[UIImage imageNamed:@"alipay"]];
            [alertV show];
        }
        
    }
}



- (void)loadPersonalInfoData: (NSDictionary *)dictionary{
    _dataArray = [NSMutableArray array];
    NSArray *keyArray = @[@"avatar",@"nickname",@"sex",@"birth_day",@"address",@"alipay"];
    NSMutableArray *dataArray = [NSMutableArray array];
    for (int i = 0; i < keyArray.count; i++) {
        NSString *str = [dictionary objectForKey:keyArray[i]];
        [dataArray addObject:str];
        
    }
    if ([dataArray[2] isEqualToString:@"1"]) {
        [dataArray setObject:@"女" atIndexedSubscript:2];
    }else{
        [dataArray setObject:@"男" atIndexedSubscript:2];
    }
    
    _dataArray = dataArray;
    
    [_tableV reloadData];
}

#pragma mark - PersonalAlertViewDelegate

- (void)finishBtnClicked:(NSString *)text view:(UIView *)view{
   
    if ([self.delegate respondsToSelector:@selector(finishBtnClicked:view:)]) {
        [self.delegate finishBtnClicked:text view:view];
    }

}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if ([self.delegate respondsToSelector:@selector(takePhotos)]) {
            [self.delegate takePhotos];
        }
    }else if(buttonIndex == 2){
        if ([self.delegate respondsToSelector:@selector(selectePicture)]) {
            [self.delegate selectePicture];
        }
    }

}

- (void)setUpImageV:(UIImage *)image{
    _imageV.image = image;
}

@end
