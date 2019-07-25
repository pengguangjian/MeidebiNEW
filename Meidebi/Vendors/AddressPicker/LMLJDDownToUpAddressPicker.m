//
//  LMLJDDownToUpAddressPicker.m
//  LMLJDDwonToUpAddressPicker
//
//  Created by liaomaer on 16/7/18.
//  Copyright © 2016年 liaomaer. All rights reserved.
//

#import "LMLJDDownToUpAddressPicker.h"
#import "LMLJDDownToUpAdressPickerCell.h"

#import "HTTPManager.h"

#import "MDB_UserDefault.h"

#define Head_Line_Color [UIColor colorWithWhite:242.0 / 255.0 alpha:1.0]
#define Head_Vertical_Line_Color [UIColor colorWithWhite:242.0 / 255.0 alpha:1.0]
#define HeadLabel_Selected_Color [UIColor colorWithRed:30.0/255.0 green:170.0/255.0 blue:61.0/255.0 alpha:1.0]
#define Trailer_Line_Color [UIColor colorWithWhite:242.0 / 255.0 alpha:1.0]
#define Height_Of_Trailer 20

@interface LMLJDDownToUpAddressPicker () <UITableViewDelegate, UITableViewDataSource>
{
    // 全国地址字典
    NSDictionary *dic_of_china_address;
    NSArray *china_address;
    
    // 三个tab的数据源
    NSMutableArray *dataOfProvince;
    NSMutableArray *dataOfCity;
    NSMutableArray *dataOfCountry;
    
    NSString *selectProvinceID;
    NSString *selectCityID;
    NSString *selectCountryID;
    
    NSString *selectProvinceName;
    NSString *selectCityName;
    NSString *selectCountryName;
    
}
@property (nonatomic, strong) NSDictionary *addressDict;
@property (nonatomic, assign) CGRect allFrame;  // 自己空间的高度
@property (nonatomic, assign) float headHeight; // 默认
@property (nonatomic, assign) float rowHeight;  // 默认 44
@property (nonatomic, assign) int numberOfRow;  // 默认 6
@property (nonatomic, assign) BOOL needAniLine;  // 默认 6

/* 自己的部分 */
@property (nonatomic, strong) UIView *opacity_back;  // 这个是半透明度的黑色遮罩
@property (nonatomic, strong) UIView *headView;  // 头部
@property (nonatomic, strong) UIView *backOfTabAndTrailer; // table和尾部的back
@property (nonatomic, strong) UIButton *cancleButton; // 退出
@property (nonatomic, strong) UIButton *okButton;  // 确定按钮
@property (nonatomic, strong) UIScrollView *scrollView;    // 这个是省市县三个的back
@property (nonatomic, strong) UITableView *tab_province;  // 省份的tableView
@property (nonatomic, strong) UITableView *tab_city;      // 城市的tableView
@property (nonatomic, strong) UITableView *tab_country;   // 县的tableView

@end

@implementation LMLJDDownToUpAddressPicker

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.allFrame = frame;
        self.headHeight = 88;  // 默认88 上面44下面44
        self.rowHeight = 44;
        self.numberOfRow = 7;
        [self initData];
        [self initUI];
    }
    // 初始化界面
    self.frame = CGRectMake(0, _allFrame.size.height, _allFrame.size.width, 0.01);
    self.provinceLabel.text = @"请选择";
    self.cityLabel.userInteractionEnabled = NO;
    self.countryLabel.userInteractionEnabled = NO;
    self.opacity_back.alpha = 0.0;
    self.headView.frame = CGRectMake(0, _allFrame.size.height, self.headView.frame.size.width, 0.01);
    self.backOfTabAndTrailer.frame = CGRectMake(_backOfTabAndTrailer.frame.origin.x, _allFrame.size.height, _backOfTabAndTrailer.frame.size.width, 0.01);
    self.tab_province.frame = CGRectMake(self.tab_province.frame.origin.x, _allFrame.size.height, self.tab_province.frame.size.width, 0.01);
    self.tab_city.frame = CGRectMake(self.tab_city.frame.origin.x, _allFrame.size.height, self.tab_city.frame.size.width, 0.01);
    self.tab_country.frame = CGRectMake(self.tab_country.frame.origin.x, _allFrame.size.height, self.tab_country.frame.size.width, 0.01);
    
    
    return self;
}

#pragma mark - init

- (void)initData {
    
    /* 创建省份数据 */
    // 注意，我们用的plist文件最好是后台吐给我们的这样可以统一
    //    NSString *areaPlistPath = [[NSBundle mainBundle] pathForResource:@"zz_3address" ofType:@"plist"]; //NSString *path = [NSBundle mainBundle];
    
    //    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"json"];
    //
    //
    //    NSData *data=[NSData dataWithContentsOfFile:jsonPath];
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"mdb_addresss"];
    
    ///上次存储的时间 单位s
    NSInteger ilasttime = [[[NSUserDefaults standardUserDefaults] objectForKey:@"mdb_addresss_time"] integerValue];
    
    ///当前时间
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];
    NSInteger inowtime = [timeString integerValue];
    
    
    
    
    if(data==nil || inowtime-ilasttime>=604800)
    {///重新获取数据
        
        [HTTPManager sendGETRequestUrlToService:mdb_Addresss withParametersDictionry:nil view:[UIApplication sharedApplication].keyWindow completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
            BOOL state = NO;
            NSString *describle = @"";
            if (responceObjct) {
                NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
                NSDictionary *dictResult=[str JSONValue];
                NSString* info = [NSString stringWithFormat:@"%@",[dictResult objectForKey:@"status"]];
                if ([info isEqualToString:@"1"]) {
                    state = YES;
                    if([[dictResult objectForKey:@"data"] isKindOfClass:[NSString class]])
                    {
                        
                        NSString *strtempdata = [dictResult objectForKey:@"data"];
                        if(strtempdata)
                        {
                            NSArray *arrtempdata = [NSJSONSerialization JSONObjectWithData:[strtempdata dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
                            NSData *datatemp = [NSJSONSerialization dataWithJSONObject:arrtempdata options:NSJSONWritingPrettyPrinted error:nil];
                            
                            [self dataJudge:datatemp];
                            [[NSUserDefaults standardUserDefaults] setObject:datatemp forKey:@"mdb_addresss"];
                            [[NSUserDefaults standardUserDefaults] setObject:timeString forKey:@"mdb_addresss_time"];
                        }
                        else
                        {
                            NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"json"];
                            
                            
                            NSData *data1=[NSData dataWithContentsOfFile:jsonPath];
                            [self dataJudge:data1];
                            
                            
                        }
                        
                        
                    }
                    else
                    {
                        if(data != nil)
                        {
                            [self dataJudge:data];
                        }
                        else
                        {
                            //                            [MDB_UserDefault showNotifyHUDwithtext:@"地址数据错误" inView:[UIApplication sharedApplication].keyWindow];
                            NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"json"];
                            
                            
                            NSData *data1=[NSData dataWithContentsOfFile:jsonPath];
                            [self dataJudge:data1];
                            
                            
                        }
                    }
                    
                    
                }else{
                    describle = dictResult[@"info"];
                    if(data != nil)
                    {
                        [self dataJudge:data];
                    }
                    else
                    {
                        //                        [MDB_UserDefault showNotifyHUDwithtext:describle inView:[UIApplication sharedApplication].keyWindow];
                        NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"json"];
                        
                        
                        NSData *data1=[NSData dataWithContentsOfFile:jsonPath];
                        [self dataJudge:data1];
                    }
                }
            }
            else
            {
                NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"json"];
                
                
                NSData *data1=[NSData dataWithContentsOfFile:jsonPath];
                [self dataJudge:data1];
            }
        }];
        
    }
    else
    {
        [self dataJudge:data];
    }
    
    
    //    // 字典的遍历
    //    [dic_of_china_address enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    //        NSLog(@"key = %@ and obj = %@", key, obj);
    //        [dataOfProvince addObject:key];
    //    }];
}

-(void)dataJudge:(NSData *)data
{
    NSError *error;
    china_address=[NSJSONSerialization JSONObjectWithData:data
                                                  options:NSJSONReadingAllowFragments
                                                    error:&error];
    
    //    dic_of_china_address = [[NSDictionary alloc] initWithContentsOfFile:areaPlistPath];
    
    
    dataOfProvince = [NSMutableArray arrayWithCapacity:0];
    dataOfCity = [NSMutableArray arrayWithCapacity:0];
    dataOfCountry = [NSMutableArray arrayWithCapacity:0];
    
    [china_address enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *tempDict = (NSDictionary *)obj;
        NSDictionary *dict = @{@"id":tempDict[@"id"],
                               @"name":tempDict[@"name"]};
        [dataOfProvince addObject:dict];
        
        [self setnomoValue];
        
        if(self.superview!=nil)
        {
            [self show];
            [self.tab_province reloadData];
        }
        
        
    }];
    
    
    
    
}

-(void)setnomoValue
{
    [self setDefaultAddressWithProvinceid:selectProvinceID cityid:selectCityID districtid:selectCountryID provicename:selectProvinceName cityname:selectCityName districtname:selectCountryName];
    
}

- (void)initUI {
    
    if(self.opacity_back!=nil)
    {
        return;
    }
    /* 1.opacity_back */
    
    self.opacity_back = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _allFrame.size.width, _allFrame.size.height)];
    self.opacity_back.backgroundColor = [UIColor clearColor];
    //    self.opacity_back.alpha = 0.2;
    UITapGestureRecognizer *tapOpcityBack = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToOpacityBack:)];
    [self.opacity_back addGestureRecognizer:tapOpcityBack];
    
    [self addSubview:self.opacity_back];
    
    /* 2.header */
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, _allFrame.size.height - _headHeight - _numberOfRow * _rowHeight, _allFrame.size.width, self.headHeight)];
    self.headView.backgroundColor = [UIColor whiteColor];
    // a.head线
    UIView *head_line = [[UIView alloc] initWithFrame:CGRectMake(0, _headHeight - 1, _allFrame.size.width, 1)];
    head_line.backgroundColor = Head_Line_Color;
    
    // b.cancelButton
    self.cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancleButton setImage:[UIImage imageNamed:@"cancelButton.png"] forState:UIControlStateNormal];
    self.cancleButton.frame = CGRectMake(0, 0, 60, 44);
    [self.cancleButton addTarget:self action:@selector(respondsToCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:self.cancleButton];
    
    // c.确定按钮
    self.okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.okButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.okButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    //[self.okButton.titleLabel setTextColor:[UIColor colorWithRed:30.0/255.0 green:170.0/255.0 blue:60.0/255.0 alpha:1.0]];
    [self.okButton setTitleColor:[UIColor colorWithRed:30.0/255.0 green:170.0/255.0 blue:60.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    self.okButton.frame = CGRectMake(_allFrame.size.width - 60, 0, 60, 44);
    [self.okButton addTarget:self action:@selector(respondsToOKButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:self.okButton];
    
    // d.三个地址label
    self.provinceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.provinceLabel.textAlignment = NSTextAlignmentCenter;
    //self.provinceLabel.center = CGPointMake(_allFrame.size.width / 6.0, self.headHeight / 2);
    UITapGestureRecognizer *tap_province = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTapProvince:)];
    [self.provinceLabel addGestureRecognizer:tap_province];
    self.provinceLabel.userInteractionEnabled = YES;
    self.provinceLabel.textColor = HeadLabel_Selected_Color;
    self.provinceLabel.font = [UIFont systemFontOfSize:15];
    
    self.cityLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.cityLabel.textAlignment = NSTextAlignmentCenter;
    //self.cityLabel.center = CGPointMake(_allFrame.size.width / 2.0, self.headHeight / 2);
    UITapGestureRecognizer *tap_city = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTapCity:)];
    [self.cityLabel addGestureRecognizer:tap_city];
    self.cityLabel.userInteractionEnabled = YES;
    self.cityLabel.textColor = HeadLabel_Selected_Color;
    self.cityLabel.font = [UIFont systemFontOfSize:15];
    
    self.countryLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.countryLabel.textAlignment = NSTextAlignmentCenter;
    //self.countryLabel.center = CGPointMake(_allFrame.size.width * 5 / 6.0, self.headHeight / 2);
    UITapGestureRecognizer *tap_country = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTapCountry:)];
    [self.countryLabel addGestureRecognizer:tap_country];
    self.countryLabel.userInteractionEnabled = YES;
    self.countryLabel.textColor = HeadLabel_Selected_Color;
    self.countryLabel.font = [UIFont systemFontOfSize:15];
    
    [self.headView addSubview:self.provinceLabel];
    [self.headView addSubview:self.cityLabel];
    [self.headView addSubview:self.countryLabel];
    
    [self.provinceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView.mas_left).offset(5);
        make.top.equalTo(self.headView.mas_top).offset(44);
    }];
    
    [self.cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.provinceLabel.mas_right).offset(20);
        make.top.equalTo(self.headView.mas_top).offset(44);
    }];
    
    [self.countryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cityLabel.mas_right).offset(20);
        make.top.equalTo(self.headView.mas_top).offset(44);
    }];
    
    
    [self.headView addSubview:head_line];
    
    // 请选择地址
    UILabel *please_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    please_label.center = CGPointMake(_allFrame.size.width / 2.0, 22);
    please_label.text = @"请选择地址";
    [self.headView addSubview:please_label];
    
    
    /* 3. backOfTab scroll与tabs */
    self.backOfTabAndTrailer = [[UIView alloc] initWithFrame:CGRectMake(0, _allFrame.size.height - _numberOfRow * _rowHeight, _allFrame.size.width, _numberOfRow * _rowHeight)];
    self.backOfTabAndTrailer.backgroundColor = [UIColor whiteColor];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _allFrame.size.width, _rowHeight * _numberOfRow )];  // 高度为多少个cell乘以每一个cell的高度
    
    self.tab_province = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _allFrame.size.width, _rowHeight * _numberOfRow)];
    self.tab_province.dataSource = self;
    self.tab_province.delegate = self;
    self.tab_province.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tab_city = [[UITableView alloc] initWithFrame:CGRectMake(_allFrame.size.width, 0, _allFrame.size.width, _rowHeight * _numberOfRow)];
    self.tab_city.dataSource = self;
    self.tab_city.delegate = self;
    self.tab_city.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tab_country = [[UITableView alloc] initWithFrame:CGRectMake(_allFrame.size.width * 2, 0, _allFrame.size.width, _rowHeight * _numberOfRow)];
    self.tab_country.dataSource = self;
    self.tab_country.delegate = self;
    self.tab_country.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.scrollView addSubview:self.tab_province];
    [self.scrollView addSubview:self.tab_city];
    [self.scrollView addSubview:self.tab_country];
    
    self.scrollView.contentSize = CGSizeMake(_allFrame.size.width * 3, _rowHeight * _numberOfRow);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    [self.backOfTabAndTrailer addSubview:self.scrollView];
    
    [self addSubview:self.headView];
    [self addSubview:self.backOfTabAndTrailer];
    
}

#pragma mark - tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _tab_province) {
        
        return dataOfProvince.count;
    }else if (tableView == _tab_city) {
        
        return dataOfCity.count;
    }else {
        
        return dataOfCountry.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cell_id = @"LMLJDDownToUpAdressPickerCell";
    
    LMLJDDownToUpAdressPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"LMLJDDownToUpAdressPickerCell" owner:self options:nil].lastObject;
        
    }
    
    /* 配置cell */
    if (tableView == _tab_province) {
        cell.addressName.text = dataOfProvince[indexPath.row][@"name"];
    }else if (tableView == _tab_city) {
        cell.addressName.text = dataOfCity[indexPath.row][@"name"];
    }else {
        cell.addressName.text = dataOfCountry[indexPath.row][@"name"];
    }
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == _tab_province) {
        
        // 找到cell
        LMLJDDownToUpAdressPickerCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        self.provinceLabel.text = cell.addressName.text;
        
        if ([cell.addressName.text isEqualToString:@"全国"]) {
            
            self.cityLabel.text = @"";
            self.cityLabel.userInteractionEnabled = NO;
            self.countryLabel.text = @"";
            self.countryLabel.userInteractionEnabled = NO;
            self.scrollView.contentSize = CGSizeMake(_allFrame.size.width, self.scrollView.bounds.size.height);
            [self dismiss];
            
        }else{
            
            /* 给第二级添加数据 */
            selectProvinceID = dataOfProvince[indexPath.row][@"id"];
            [self parseDataToCities];
            self.scrollView.contentSize = CGSizeMake(_allFrame.size.width * 2, self.scrollView.bounds.size.height);
            self.cityLabel.userInteractionEnabled = YES;
            self.cityLabel.text = @"请选择";
            self.countryLabel.text = @"";
            self.countryLabel.userInteractionEnabled = NO;
            [self.scrollView setContentOffset:CGPointMake(_allFrame.size.width, 0) animated:YES];
            
        }
        
    }else if (tableView == _tab_city) {
        
        // 找到cell
        LMLJDDownToUpAdressPickerCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        self.cityLabel.text = cell.addressName.text;
        
        if ([cell.addressName.text isEqualToString:@"不限"]) {
            self.countryLabel.text = @"";
            self.countryLabel.userInteractionEnabled = NO;
            self.scrollView.contentSize = CGSizeMake(_allFrame.size.width * 2, self.scrollView.bounds.size.height);
            [self dismiss];
            
        }else{
            
            /* 给第二级添加数据 */
            selectCityID = dataOfCity[indexPath.row][@"id"];
            [self parseDataToCountries];
            
            self.scrollView.contentSize = CGSizeMake(_allFrame.size.width * 3, self.scrollView.bounds.size.height);
            self.countryLabel.userInteractionEnabled = YES;
            
            if(dataOfCountry.count<=0)
            {
                self.countryLabel.text = @"";
                selectCountryID = @"0";
            }
            else
            {
                self.countryLabel.text = @"请选择";
                [self.scrollView setContentOffset:CGPointMake(_allFrame.size.width * 2, 0) animated:YES];
            }
        }
        
        
    }else {
        
        // 找到cell
        LMLJDDownToUpAdressPickerCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        self.countryLabel.text = cell.addressName.text;
        selectCountryID = dataOfCountry[indexPath.row][@"id"];
        //[self dismiss];
    }
    
    /* 自己的地址是多少 */
    if ([_cityLabel.text isEqualToString:@"不限"] || [_cityLabel.text isEqualToString:@"请选择"]) {
        
        _address = _provinceLabel.text;
    }
    else if ([_countryLabel.text isEqualToString:@"不限"] || [_countryLabel.text isEqualToString:@"请选择"]) {
        
        _address = [NSString stringWithFormat:@"%@%@", _provinceLabel.text, _cityLabel.text];
    }else {
        
        _address = [NSString stringWithFormat:@"%@%@%@", _provinceLabel.text, _cityLabel.text, _countryLabel.text];
    }
    
    
    
}





#pragma mark - responds event

- (void)respondsToOpacityBack:(UITapGestureRecognizer *)tap {
    
    [self dismiss];
}

- (void)respondsToCancelButton:(UIButton *)sender {
    
    [self dismiss];
}

- (void)respondsToOKButton:(UIButton *)sender {
    
    
    /* 选择后的地址str */
    NSString *addressStr; //
    
    if ([self.cityLabel.text isEqualToString:@"不限"]) {
        addressStr = self.provinceLabel.text;
    }else if ([self.countryLabel.text isEqualToString:@"不限"]) {
        addressStr = [NSString stringWithFormat:@"%@%@", self.provinceLabel.text, self.cityLabel.text];
    }else if ([self.provinceLabel.text isEqualToString:@"全国"]){
        addressStr = @"all";  // 所有
    }else if (![self.provinceLabel.text isEqualToString:@"请选择"] && (![self.cityLabel.text isEqualToString:@"请选择"] || ![[NSString nullToString:self.countryLabel.text] isEqualToString:@""])){
        if ([self.countryLabel.text isEqualToString:@"请选择"]) {
            self.countryLabel.text = nil;
            addressStr = [NSString stringWithFormat:@"%@%@", self.provinceLabel.text, self.cityLabel.text];
        }else{
            addressStr = [NSString stringWithFormat:@"%@%@%@", self.provinceLabel.text, self.cityLabel.text, [NSString nullToString:self.countryLabel.text]];
        }
    }
    
    [self dismiss];
    
    if (_addressBlock) {
        NSDictionary *dict = nil;
        if (addressStr) {
            dict = @{@"provincename":[NSString nullToString:self.provinceLabel.text],
                     @"provinceid":[NSString nullToString:selectProvinceID],
                     @"cityname":[NSString nullToString:self.cityLabel.text],
                     @"cityid":[NSString nullToString:selectCityID],
                     @"districtname":[NSString nullToString:self.countryLabel.text],
                     @"districtid":[NSString nullToString:selectCountryID]};
            _addressDict = dict;
        }
        _addressBlock(addressStr,dict);
    }
}

/*  */
- (void)respondsToTapProvince:(UITapGestureRecognizer *)tap_province {
    
    if (_isOpenState == NO) {
        
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }else {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    [self show];
}

- (void)respondsToTapCity:(UITapGestureRecognizer *)tap_city {
    
    if (_isOpenState == NO) {
        
        [self.scrollView setContentOffset:CGPointMake(_allFrame.size.width, 0) animated:NO];
    }else {
        [self.scrollView setContentOffset:CGPointMake(_allFrame.size.width, 0) animated:YES];
    }
    [self show];
}

- (void)respondsToTapCountry:(UITapGestureRecognizer *)tap_country {
    
    if (_isOpenState == NO) {
        [self.scrollView setContentOffset:CGPointMake(_allFrame.size.width * 2, 0) animated:NO];
    }else {
        [self.scrollView setContentOffset:CGPointMake(_allFrame.size.width * 2, 0) animated:YES];
    }
    
    [self show];
}


#pragma mark - 解析数据

- (void)parseDataToCities {
    
    [dataOfCity removeAllObjects];
    
    NSMutableArray *mut_arr = [NSMutableArray arrayWithCapacity:0];
    [china_address enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *tempDict = (NSDictionary *)obj;
        if ([selectProvinceID isEqualToString:tempDict[@"id"]]) {
            NSArray *citys = tempDict[@"city"];
            [citys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *tempDict = (NSDictionary *)obj;
                NSDictionary *dict = @{@"id":tempDict[@"id"],
                                       @"name":tempDict[@"name"]};
                [mut_arr addObject:dict];
            }];
        }
    }];
    
    dataOfCity = mut_arr;
    
    [self.tab_city reloadData];
    
}


- (void)parseDataToCountries {
    
    [dataOfCountry removeAllObjects];
    __block NSMutableArray *mut_arr = [NSMutableArray arrayWithCapacity:0];
    [china_address enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *tempDict = (NSDictionary *)obj;
        if ([selectProvinceID isEqualToString:tempDict[@"id"]]) {
            NSArray *citys = tempDict[@"city"];
            [citys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *tempCityDict = (NSDictionary *)obj;
                if ([selectCityID isEqualToString:tempCityDict[@"id"]]) {
                    if([tempCityDict[@"district"] isKindOfClass:[NSArray class]])
                    {
                        mut_arr = [tempCityDict[@"district"] mutableCopy];
                    }
                    else
                    {
                        [mut_arr addObject:tempCityDict];
                    }
                }
            }];
        }
    }];
    
    dataOfCountry = mut_arr;
    [self.tab_country reloadData];
}

#pragma mark - private methods

// 设置默认的位置  （经验交流 默认是市：四川省->成都市）
- (void)setDefaultAddressWithProvinceid:(NSString *)provinceid
                                 cityid:(NSString *)cityid
                             districtid:(NSString *)districtid
                            provicename:(NSString *)provincename
                           cityname:(NSString *)cityname
                           districtname:(NSString *)districtname{
    if(provinceid==nil)return;
    selectProvinceID = provinceid;
    selectCityID = cityid;
    selectCountryID = districtid;
    
    selectProvinceName = provincename;
    selectCityName = cityname;
    selectCountryName = districtname;
    
    if(dataOfProvince.count<3)
    {
        
        return;
    }
    
    if(self.tab_province !=nil)
    {
        [self.tab_province reloadData];
        [self.tab_city reloadData];
        [self.tab_country reloadData];
    }
    
    [dataOfProvince enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dict = (NSDictionary *)obj;
        if(selectProvinceName.length>0)
        {
            if ([dict[@"name"] isEqualToString:selectProvinceName]) {
                self.provinceLabel.text = dict[@"name"];
                selectProvinceID = [NSString nullToString:dict[@"id"]];
            }
        }
        else
        {
            if ([dict[@"id"] isEqualToString:selectProvinceID]) {
                self.provinceLabel.text = dict[@"name"];
            }
        }
        
        
        
    }];
    
    // 省-市
    if (([districtid isEqualToString:@""] || [districtid isEqualToString:@"0"]) && ((![provinceid isEqualToString:@""] || ![provinceid isEqualToString:@"0"]) && (![cityid isEqualToString:@""] || ![cityid isEqualToString:@"0"]))) {
        
        /* 给第二级添加数据 */
        [self parseDataToCities];
        [dataOfCity enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dict = (NSDictionary *)obj;
            
            if(selectCityName.length>0)
            {
                if ([dict[@"name"] isEqualToString:selectCityName]) {
                    self.cityLabel.text = dict[@"name"];
                    selectCityID = [NSString nullToString:dict[@"id"]];
                }
            }
            else
            {
                if ([dict[@"id"] isEqualToString:selectCityID]) {
                    self.cityLabel.text = dict[@"name"];
                }
            }
            
            
        }];
        
        self.cityLabel.userInteractionEnabled = YES;
        self.countryLabel.userInteractionEnabled = YES;
        
        /* 给第三级添加数据 */
        [self parseDataToCountries];
        
        /* 跳转到市 */
        self.scrollView.contentOffset = CGPointMake(_allFrame.size.width , 0);
        
    }
    // 省市县
    else if ((![districtid isEqualToString:@""] || ![districtid isEqualToString:@"0"]) && ((![provinceid isEqualToString:@""] || ![provinceid isEqualToString:@"0"]) && (![cityid isEqualToString:@""] || ![cityid isEqualToString:@"0"]))) {
        
        /* 给第二级添加数据 */
        [self parseDataToCities];
        [dataOfCity enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dict = (NSDictionary *)obj;
            
            if(selectCityName.length>0)
            {
                if ([dict[@"name"] isEqualToString:selectCityName]) {
                    self.cityLabel.text = dict[@"name"];
                    selectCityID = [NSString nullToString:dict[@"id"]];
                }
            }
            else
            {
                if ([dict[@"id"] isEqualToString:selectCityID]) {
                    self.cityLabel.text = dict[@"name"];
                }
            }
            
            
        }];
        
        /* 给第三级添加数据 */
        [self parseDataToCountries];
        [dataOfCountry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dict = (NSDictionary *)obj;
            
            if(selectCountryName.length>0)
            {
                if ([dict[@"name"] isEqualToString:selectCountryName]) {
                    self.countryLabel.text = dict[@"name"];
                    selectCityID = [NSString nullToString:dict[@"id"]];
                }
            }
            else
            {
                if ([dict[@"id"] isEqualToString:selectCountryID]) {
                    self.countryLabel.text = dict[@"name"];
                }
            }
            
            
        }];
        
        self.cityLabel.userInteractionEnabled = YES;
        self.countryLabel.userInteractionEnabled = YES;
        
        
        /* 跳转到县 */
        
        self.scrollView.contentOffset = CGPointMake(_allFrame.size.width * 2, 0);
    }
    // 省
    else {
        
        self.cityLabel.userInteractionEnabled = YES;
        
        /* 给第二级添加数据 */
        [self parseDataToCities];
    }
    
    _addressDict = @{@"provincename":[NSString nullToString:self.provinceLabel.text],
                     @"provinceid":[NSString nullToString:selectProvinceID],
                     @"cityname":[NSString nullToString:self.cityLabel.text],
                     @"cityid":[NSString nullToString:selectCityID],
                     @"districtname":[NSString nullToString:self.countryLabel.text],
                     @"districtid":[NSString nullToString:selectCountryID]};
}


#pragma mark - show and dismiss

- (void)show{
    
    
    if (self.isOpenState == YES || china_address.count==0) {
        return;
    }
    
    // 隐藏scrollView 不然其下不能点击
    //self.scrollView.hidden = NO;
    self.frame = CGRectMake(_allFrame.origin.x , _allFrame.origin.y, self.frame.size.width, _allFrame.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.opacity_back.alpha = 0.2;
        
        self.headView.frame = CGRectMake(0, _allFrame.size.height - _headHeight - _numberOfRow * _rowHeight, _allFrame.size.width, self.headHeight);
        
        self.backOfTabAndTrailer.frame = CGRectMake(0, _allFrame.size.height - _numberOfRow * _rowHeight, _allFrame.size.width, _numberOfRow * _rowHeight);
        self.tab_province.frame = CGRectMake(0, 0, _allFrame.size.width, _rowHeight * _numberOfRow);
        self.tab_city.frame = CGRectMake(_allFrame.size.width, 0, _allFrame.size.width, _rowHeight * _numberOfRow);
        self.tab_country.frame = CGRectMake(_allFrame.size.width * 2, 0, _allFrame.size.width, _rowHeight * _numberOfRow);
        
    } completion:^(BOOL finished){
        
        self.isOpenState = YES;
        
        @try
        {
            [self.tab_province reloadData];
            [self.tab_city reloadData];
            [self.tab_country reloadData];
            [self setnomoValue];
            /* 让tabview滚到被选中的地方 */
            if (![self.provinceLabel.text isEqualToString:@""] && dataOfProvince.count != 0) {
                for (int i = 0; i < dataOfProvince.count; i ++) {
                    
                    if ([dataOfProvince[i][@"name"] isEqualToString:self.provinceLabel.text]) {
                        
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                        [_tab_province selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
                    }
                }
                
            }
            if (![self.cityLabel.text isEqualToString:@""] && dataOfCity.count != 0) {
                for (int i = 0; i < dataOfCity.count; i ++) {
                    
                    if ([dataOfCity[i][@"name"] isEqualToString:self.cityLabel.text]) {
                        
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                        [_tab_city selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
                    }
                }
                
            }
            if (![self.countryLabel.text isEqualToString:@""] && dataOfCountry.count != 0) {
                for (int i = 0; i < dataOfCountry.count; i ++) {
                    
                    if ([dataOfCountry[i][@"name"] isEqualToString:self.countryLabel.text]) {
                        
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                        [_tab_country selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
                    }
                }
                
            }
        }
        @catch(NSException *exc)
        {
            
        }
        @finally
        {
            
        }
        
    }];
    
    
    
}

// 弹起tab
- (void)dismiss {
    
    if (self.isOpenState == NO ) {
        return;
    }
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.frame = CGRectMake(0, _allFrame.size.height, _allFrame.size.width, 0.01);
        //CGRect frame = self.backOfTabAndTrailer.frame;
        self.opacity_back.alpha = 0.0;
        
        //frame.size.height=0.1;
        //[self.backOfTabAndTrailer setFrame:frame];
        self.headView.frame = CGRectMake(0, _allFrame.size.height, self.headView.frame.size.width, 0.01);
        self.backOfTabAndTrailer.frame = CGRectMake(_backOfTabAndTrailer.frame.origin.x, _allFrame.size.height, _backOfTabAndTrailer.frame.size.width, 0.01);
        self.tab_province.frame = CGRectMake(self.tab_province.frame.origin.x, _allFrame.size.height, self.tab_province.frame.size.width, 0.01);
        self.tab_city.frame = CGRectMake(self.tab_city.frame.origin.x, _allFrame.size.height, self.tab_city.frame.size.width, 0.01);
        self.tab_country.frame = CGRectMake(self.tab_country.frame.origin.x, _allFrame.size.height, self.tab_country.frame.size.width, 0.01);
        
    } completion:^(BOOL finished){
        
        self.isOpenState = NO;
        
        // 隐藏
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.headHeight);
    }];
    
}


@end
