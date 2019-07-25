//
//  AddressListSubjectView.m
//  Meidebi
//
//  Created by mdb-admin on 2016/11/3.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "AddressListSubjectView.h"

#import "AddressListTableViewCell.h"

@interface AddressListSubjectView ()<UITableViewDelegate,UITableViewDataSource,AddressListTableViewCellDelegate>

@property (nonatomic, strong) UIButton *addAddressBtn;
@property (nonatomic, strong) UIView *addressInfoView;
@property (nonatomic, strong) UILabel *majorInfoLabel;
@property (nonatomic, strong) UILabel *addressInfoLabel;
@property (nonatomic, strong) NSDictionary *dataDict;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic ,weak) UILabel *hintLabel;

@property (nonatomic , retain) UITableView *tabview;

@property (nonatomic , retain) NSMutableArray *arrdata;

@end

@implementation AddressListSubjectView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    
    _tabview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height-90*kScale) style:UITableViewStylePlain];
    [self addSubview:_tabview];
    [_tabview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tabview setBackgroundColor:RGB(249,249,249)];
    [_tabview setDelegate:self];
    [_tabview setDataSource:self];
    
    
    UILabel *hintLabel = [[UILabel alloc] init];
    [self addSubview:hintLabel];
    hintLabel.text = @"您还没有添加地址哦！";
    hintLabel.textAlignment = NSTextAlignmentCenter;
    hintLabel.font = [UIFont systemFontOfSize:14];
    hintLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    [hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(90 * kScale);
        make.width.offset(kMainScreenW * 0.5);
    }];
    _hintLabel = hintLabel;
    
    
    
    _addAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_addAddressBtn];
    [_addAddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(356 *kScale, 51 *kScale));
        make.bottom.equalTo(self.mas_bottom).offset(-40 *kScale);
    }];
    _addAddressBtn.layer.cornerRadius = 4;
    _addAddressBtn.clipsToBounds = YES;
    _addAddressBtn.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
    _addAddressBtn.layer.borderWidth = 0.6;
    _addAddressBtn.tag = 100;
    _addAddressBtn.backgroundColor = [UIColor colorWithHexString:@"#F35D00"];
    [_addAddressBtn setTitle:@"添增地址" forState:UIControlStateNormal];
    [_addAddressBtn.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
    [_addAddressBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"]
                         forState:UIControlStateNormal];
    [_addAddressBtn addTarget:self
                       action:@selector(respondsToBtnEvents:)
             forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
//    _addressInfoView = [UIView new];
//    [self addSubview:_addressInfoView];
//    [_addressInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(self);
//    }];
//    _addressInfoView.hidden = YES;
//
//    _majorInfoLabel = [UILabel new];
//    [_addressInfoView addSubview:_majorInfoLabel];
//    [_majorInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_addressInfoView.mas_top).offset(22);
//        make.left.equalTo(_addressInfoView.mas_left).offset(20);
//        make.right.equalTo(_addressInfoView.mas_right).offset(-10);
//    }];
//    _majorInfoLabel.textColor = [UIColor colorWithHexString:@"#666666"];
//    _majorInfoLabel.font = [UIFont systemFontOfSize:14.f];
//
//    _addressInfoLabel = [UILabel new];
//    [_addressInfoView addSubview:_addressInfoLabel];
//    [_addressInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(_majorInfoLabel);
//        make.top.equalTo(_majorInfoLabel.mas_bottom).offset(8);
//    }];
//    _addressInfoLabel.font = _majorInfoLabel.font;
//    _addressInfoLabel.textColor = _majorInfoLabel.textColor;
//
//
//
//
//    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_addressInfoView addSubview:deleteBtn];
//    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(_addressInfoView.mas_right).offset(-20);
//        make.top.equalTo(_addressInfoLabel.mas_bottom).offset(16);
//        make.size.mas_equalTo(CGSizeMake(56, 26));
//
//    }];
//    deleteBtn.tag = 120;
//    deleteBtn.layer.masksToBounds = YES;
//    deleteBtn.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
//    deleteBtn.layer.borderWidth = 0.6;
//    deleteBtn.layer.cornerRadius = 4.f;
//    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
//    [deleteBtn setTitleColor:_addressInfoLabel.textColor forState:UIControlStateNormal];
//    [deleteBtn.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
//    [deleteBtn addTarget:self
//                       action:@selector(respondsToBtnEvents:)
//             forControlEvents:UIControlEventTouchUpInside];
//
//
//
//    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_addressInfoView addSubview:editBtn];
//    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(deleteBtn.mas_left).offset(-10);
//        make.top.equalTo(deleteBtn.mas_top);
//        make.size.equalTo(deleteBtn);
//    }];
//    editBtn.tag = 110;
//    editBtn.layer.masksToBounds = YES;
//    editBtn.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
//    editBtn.layer.borderWidth = 0.6;
//    editBtn.layer.cornerRadius = 4.f;
//    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
//    [editBtn setTitleColor:_addressInfoLabel.textColor forState:UIControlStateNormal];
//    [editBtn.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
//    [editBtn addTarget:self
//                action:@selector(respondsToBtnEvents:)
//      forControlEvents:UIControlEventTouchUpInside];
//
//    [_addressInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(editBtn.mas_bottom).offset(15);
//    }];
//
//    UIView *lineView = [UIView new];
//    [_addressInfoView addSubview:lineView];
//    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.bottom.right.equalTo(_addressInfoView);
//        make.height.offset(1);
//    }];
//    lineView.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
    
}

- (void)respondsToBtnEvents:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 100) {
        if ([self.delegate respondsToSelector:@selector(increaseAddress)]) {
            [self.delegate increaseAddress];
        }
    }
//    else if (btn.tag == 110){
//        if ([self.delegate respondsToSelector:@selector(editAddress)]) {
//            [self.delegate editAddress];
//        }
//    }else if (btn.tag == 120){
//        if ([self.delegate respondsToSelector:@selector(deleteAddress:)]) {
//            [self.delegate deleteAddress:[NSString nullToString:_dataDict[@"address_id"]]];
//        }
//    }
}

- (void)bindAddressDataWithModel:(NSArray *)model{
    if (model) {
//        _addAddressBtn.hidden = YES;
        _hintLabel.hidden = YES;
        _addressInfoView.hidden = NO;
        [self updateAddressViewWithInfoData:model];
    }else{
//        _addAddressBtn.hidden = NO;
        _hintLabel.hidden = NO;
        _addressInfoView.hidden = YES;
        _arrdata = [NSMutableArray new];
    }
    [_tabview reloadData];
}

- (void)updateAddressViewWithInfoData:(NSArray *)dataDict{
//    _dataDict = dataDict;
//    NSString *majorInfoStr = [NSString stringWithFormat:@"%@      %@",dataDict[@"name"],dataDict[@"phone"]];
//    _majorInfoLabel.text = majorInfoStr;
//
//    NSString *addressInfoStr = [NSString stringWithFormat:@"%@%@%@%@",[NSString nullToString:dataDict[@"provincename"]],[NSString nullToString:dataDict[@"cityname"]],[NSString nullToString:dataDict[@"districtname"]],[NSString nullToString:dataDict[@"address"]]];
//    _addressInfoLabel.text = addressInfoStr;
    
    _arrdata = [NSMutableArray new];
    for(NSDictionary *dic in dataDict)
    {
        [_arrdata addObject:[AddressListModel dicChangeToModel:dic]];
    }
    
    
    [_tabview reloadData];
}


#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrdata.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strcell = @"AddressListTableViewCell";
    AddressListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strcell];
    if(!cell)
    {
        cell = [[AddressListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strcell];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.model = _arrdata[indexPath.row];
    [cell setDelegate:self];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 156;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.delegatelist!=nil)
    {
        [self.delegatelist addressSelectItem:_arrdata[indexPath.row]];
    }
}

#pragma mark -
- (void)editAddresscell:(AddressListModel *)model
{
    if ([self.delegate respondsToSelector:@selector(editAddress:)]) {
        [self.delegate editAddress:model];
    }
}
- (void)deleteAddresscell:(NSString *)addressID
{
    if ([self.delegate respondsToSelector:@selector(deleteAddress:)]) {
        [self.delegate deleteAddress:addressID];
    }
}
- (void)nomoAddresscell:(NSString *)addressID
{
    if ([self.delegate respondsToSelector:@selector(nomoAddress:)]) {
        [self.delegate nomoAddress:addressID];
    }
}

-(NSMutableArray *)getAddressList
{
    return _arrdata;
}

@end
