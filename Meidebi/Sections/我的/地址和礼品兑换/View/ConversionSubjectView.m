//
//  ConversionSubjectView.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/22.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "ConversionSubjectView.h"
#import "NJScrollTableView.h"
#import "ConVersionItemViewController.h"
#import "ConversionAlertView.h"
#import "MDB_UserDefault.h"

#import "AddressListModel.h"
@interface ConversionSubjectView ()
<
ConversionAlertViewDelegate,
ScrollTabViewDataSource,
ConVersionItemViewControllerDelegate
>
{
    NSInteger duihuantype;
    
    AddressListModel *addressmodel;
    
}
@property (nonatomic, strong) UILabel *currentCoinNumLabel;
@property (nonatomic, strong) UILabel *currentCoinNumLabel1;

@property (nonatomic, strong) NSArray *allVCs;
@property (nonatomic, strong) NSDictionary *currentConversionGiftDict;
@property (nonatomic, strong) ConversionAlertView *conversionAlertView;
@end

@implementation ConversionSubjectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        duihuantype= 1;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    self.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    UIView *coinContainerView = [UIView new];
    [self addSubview:coinContainerView];
    [coinContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.offset(63);
    }];
    coinContainerView.backgroundColor = [UIColor whiteColor];
    if (![MDB_UserDefault getIsLogin]){
        [coinContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
        coinContainerView.hidden = YES;
    }
    
    
    
    UILabel *nameLabel = [UILabel new];
    [coinContainerView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.centerY.equalTo(coinContainerView);
    }];
    nameLabel.font = [UIFont systemFontOfSize:13.f];
    nameLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    nameLabel.text = @"铜币总额";
    
    
//    UIImageView *iconImageView = [UIImageView new];
//    [coinContainerView addSubview:iconImageView];
//    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(nameLabel.mas_left).offset(-8);
//        make.centerY.equalTo(nameLabel.mas_centerY);
//        make.size.mas_equalTo(CGSizeMake(23, 23));
//    }];
//    iconImageView.contentMode = UIViewContentModeScaleAspectFit;
//    iconImageView.image = [UIImage imageNamed:@"current_cion"];
    
    
    
    
    _currentCoinNumLabel = [UILabel new];
    [coinContainerView addSubview:_currentCoinNumLabel];
    [_currentCoinNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameLabel.mas_centerY);
        make.left.equalTo(nameLabel.mas_right).offset(6);
    }];
    _currentCoinNumLabel.font = [UIFont systemFontOfSize:14.f];
    _currentCoinNumLabel.textColor = [UIColor colorWithHexString:@"#F35D00"];
    _currentCoinNumLabel.text = @"0";
    
    
    
    UILabel *nameLabel1 = [UILabel new];
    [coinContainerView addSubview:nameLabel1];
    [nameLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(coinContainerView).multipliedBy(1.45);
        make.left.equalTo(coinContainerView.mas_centerX).offset(10);
        make.centerY.equalTo(coinContainerView);
    }];
    nameLabel1.font = [UIFont systemFontOfSize:13.f];
    nameLabel1.textColor = [UIColor colorWithHexString:@"#666666"];
    nameLabel1.text = @"贡献值总额";
    
    
    _currentCoinNumLabel1 = [UILabel new];
    [coinContainerView addSubview:_currentCoinNumLabel1];
    [_currentCoinNumLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameLabel1.mas_centerY);
        make.left.equalTo(nameLabel1.mas_right).offset(6);
    }];
    _currentCoinNumLabel1.font = [UIFont systemFontOfSize:14.f];
    _currentCoinNumLabel1.textColor = [UIColor colorWithHexString:@"#F35D00"];
    _currentCoinNumLabel1.text = @"0";
    
    
    ConVersionItemViewController *allItemVc = [[ConVersionItemViewController alloc] initWithConVersionType:ConVersionTypeAll];
    allItemVc.title = @"全部";
    allItemVc.delegate = self;
    ConVersionItemViewController *entityItemVc = [[ConVersionItemViewController alloc] initWithConVersionType:ConVersionTypeEntity];
    entityItemVc.title = @"实物礼品";
    entityItemVc.delegate = self;
    ConVersionItemViewController *ticketItemVc = [[ConVersionItemViewController alloc] initWithConVersionType:ConVersionTypeTicket];
    ticketItemVc.title = @"优惠券";
    ticketItemVc.delegate = self;
    ConVersionItemViewController *otherItemVc = [[ConVersionItemViewController alloc] initWithConVersionType:ConVersionTypeOther];
    otherItemVc.title = @"其他";
    otherItemVc.delegate = self;
    self.allVCs = @[allItemVc,entityItemVc,ticketItemVc,otherItemVc];
    [self layoutIfNeeded];
    NJScrollTableView *scrollTableView = [[NJScrollTableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(coinContainerView.frame)+8, kMainScreenW, kMainScreenH - (CGRectGetMaxY(coinContainerView.frame)+8) - 64/*nav height*/)];
    [self addSubview:scrollTableView];
    scrollTableView.backgroundColor = [UIColor whiteColor];
    scrollTableView.tabButtonTitleColorForNormal = [UIColor colorWithHexString:@"#666666"];
    scrollTableView.selectedLineWidth = 50;
    scrollTableView.dataSource = self;
    [scrollTableView buildUI];
    [scrollTableView selectTabWithIndex:0 animate:NO];
}

- (void)bindDataWithModel:(NSDictionary *)dict{
    _currentCoinNumLabel.text = [NSString nullToString:dict[@"copper"]];
    _currentCoinNumLabel1.text = [NSString nullToString:dict[@"contribution"]];
}

- (BOOL)verificationLogin{
    if (![MDB_UserDefault getIsLogin]){
        if ([self.delegate respondsToSelector:@selector(jumpLoginVc)]) {
            [self.delegate jumpLoginVc];
        }
        return NO;
    }
    return YES;
}

- (void)showLastAlertView{
    [self tableViewConfirmConversionItem:_currentConversionGiftDict type:duihuantype];
}

///显示获取到的地址
-(void)showLastAlertViewAddress:(id)value
{
    addressmodel = value;
//    NSString *haveto = [NSString nullToString:_currentConversionGiftDict[@"haveto"]];
    if ([[NSString nullToString:_currentConversionGiftDict[@"type"]] isEqualToString:@"present"]) {
        NSString *title = [NSString stringWithFormat:@"你正在兑换“%@”",[NSString nullToString:_currentConversionGiftDict[@"title"]]];
        ConversionAlertType alertType = ConversionAlertSubTitle;
        self.conversionAlertView.alertType = alertType;
        self.conversionAlertView.waresName = title;
        self.conversionAlertView.faultRemindStr = addressmodel.straddress;
        [self.conversionAlertView show];
    }
    
}

#pragma mark - ScrollTabViewDataSource
- (NSUInteger)numberOfPagers:(NJScrollTableView *)view{
    return self.allVCs.count;
}

- (UITableViewController *)scrollTableViewOfPagers:(NJScrollTableView *)view
                                     indexOfPagers:(NSUInteger)index{
    return self.allVCs[index];
}

#pragma mark - ConVersionItemViewControllerDelegate
- (void)tableViewConfirmConversionItem:(NSDictionary *)itemDict type:(NSInteger)type {
    if (![self verificationLogin]) return;
    duihuantype = type;
    _currentConversionGiftDict = itemDict;
    if ([[NSString nullToString:_currentConversionGiftDict[@"type"]] isEqualToString:@"present"]) {
        NSString *title = [NSString stringWithFormat:@"你正在兑换“%@”",[NSString nullToString:_currentConversionGiftDict[@"title"]]];
        ConversionAlertType alertType;
        NSString *haveto = [NSString nullToString:_currentConversionGiftDict[@"haveto"]];
        NSString *alertPlaceholderStr = nil;
        if ([haveto isEqualToString:@"qq"]) {
            alertType = ConversionAlertVirtual;
            alertPlaceholderStr = @"请输入领取QQ号码";
        }else if ([haveto isEqualToString:@"phone"]){
            alertType = ConversionAlertVirtual;
            alertPlaceholderStr = @"请输入领取手机号";
        }else if ([haveto isEqualToString:@"address"]){
            alertType = ConversionAlertMaterial;
        }else{
            alertType = ConversionAlertNormal;
        }
        self.conversionAlertView.alertType = alertType;
        self.conversionAlertView.waresName = title;
        self.conversionAlertView.placeholderStr = alertPlaceholderStr;
        [self.conversionAlertView show];
    }else if ([[NSString nullToString:_currentConversionGiftDict[@"type"]] isEqualToString:@"coupon"]){
        
        NSDictionary *waresInfoDict = @{@"type":[NSString nullToString:_currentConversionGiftDict[@"type"]],
                                        @"id":[NSString nullToString:_currentConversionGiftDict[@"id"]],
                                        @"present_type":[NSNumber numberWithInteger:duihuantype]
                                        };
        
        
        if ([self.delegate respondsToSelector:@selector(conversionMaterialWaresWithInfo:success:failure:)]) {
            [self.delegate conversionMaterialWaresWithInfo:waresInfoDict success:^(NSString *describle){
                self.conversionAlertView.alertState = ConversionAlertStateSuccess;
                self.conversionAlertView.alertDescribleStr = describle;
                [self.conversionAlertView show];
            } failure:^(NSString *describle){
                if ([describle isEqualToString:@"铜币不足"]) {
                    self.conversionAlertView.alertState = ConversionAlertStateCopperFailure;
                }else{
                    self.conversionAlertView.faultRemindStr = describle;
                    self.conversionAlertView.alertState = ConversionAlertStateFailure;
                }
                [self.conversionAlertView show];
            }];
        }
    }

}

- (void)conversionTableViewDidSelectCellWithItem:(NSDictionary *)item{
    if([self.delegate respondsToSelector:@selector(welfareHomeSubjectView:didSelectWaresWithItemId:waresType:haveto:present_type:)]){
        if (item == nil) return;
        [self.delegate welfareHomeSubjectView:self
                     didSelectWaresWithItemId:[NSString nullToString:item[@"id"]]
                                    waresType:[NSString nullToString:item[@"type"]]
                                       haveto:[NSString nullToString:item[@"haveto"]]
                                 present_type:[NSString nullToString:item[@"changetype"]]];
    }
}

#pragma mark - ConversionAlertViewDelegate
- (void)conversionAlertView:(ConversionAlertView *)alertView handleConversionWithNumber:(NSString *)numberStr{
    if ([[NSString nullToString:_currentConversionGiftDict[@"type"]] isEqualToString:@"present"])
    {
        numberStr = addressmodel.strid;
        if(numberStr.length<1)
        {
            [MDB_UserDefault showNotifyHUDwithtext:@"兑换信息不能为空" inView:self];
            return;
        }
    }
    if (alertView.alertType != ConversionAlertMaterial) {
        if ([numberStr isEqualToString:@""]) {
            [MDB_UserDefault showNotifyHUDwithtext:@"兑换信息不能为空" inView:self];
            return;
        }
    }
    
    NSDictionary *waresInfoDict = @{@"type":[NSString nullToString:_currentConversionGiftDict[@"type"]],
                                    @"id":[NSString nullToString:_currentConversionGiftDict[@"id"]],
                                    @"info":[NSString nullToString:numberStr],
                                    @"present_type":[NSNumber numberWithInteger:duihuantype]
                                    };
    if ([self.delegate respondsToSelector:@selector(conversionMaterialWaresWithInfo:success:failure:)]) {
        [self.delegate conversionMaterialWaresWithInfo:waresInfoDict success:^(NSString *describle){
            self.conversionAlertView.alertState = ConversionAlertStateSuccess;
            self.conversionAlertView.alertDescribleStr = describle;
            [self.conversionAlertView show];
        } failure:^(NSString *describle){
            if ([describle isEqualToString:@"铜币不足"]) {
                self.conversionAlertView.alertState = ConversionAlertStateCopperFailure;
            }else{
                self.conversionAlertView.faultRemindStr = describle;
                self.conversionAlertView.alertState = ConversionAlertStateFailure;
            }
            [self.conversionAlertView show];
        }];
    }
}

-(void)conversionAlertView:(ConversionAlertView *)alertView handleExchangeGiftWithNumber:(NSString *)numberStr{
    if ([numberStr isEqualToString:@""]) {
        [MDB_UserDefault showNotifyHUDwithtext:@"兑换信息不能为空" inView:self];
        return;
    }
}

- (void)referCopperRule{
    if ([self.delegate respondsToSelector:@selector(welfareHomeSubjectViewReferCopperRule)]) {
        [self.delegate welfareHomeSubjectViewReferCopperRule];
    }
}

- (void)referLogisticsAddress{
    if ([self.delegate respondsToSelector:@selector(welfareHomeSubjectViewReferLogisticsAddress)]) {
        [self.delegate welfareHomeSubjectViewReferLogisticsAddress];
    }
}

#pragma mark - setters and getters
- (ConversionAlertView *)conversionAlertView{
    if (!_conversionAlertView) {
        _conversionAlertView = [[ConversionAlertView alloc] init];
        _conversionAlertView.delegate = self;
    }
    return _conversionAlertView;
}


@end
